//
//  HCAsset.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/5.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import Photos

class HCAssetManager {
    
    enum HCAssetType {
        case image
        case video
        case audio
        case all
    }
    
    enum HCImageMode {
        case thumb
        case orignal
    }

    /// 获取相册所有媒体
    static func getAllAsset(mediaType: HCAssetType = .image, complet:@escaping (([HCAsset])->())) {
        DispatchQueue.global().async {
            var arr:[HCAsset] = []
            let options = PHFetchOptions.init()
            // 所有智能相册集合(系统自动创建的相册)
            let smartAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: options)
            //遍历得到每一个相册
            for i in 0..<smartAlbums.count {
                // 是否按创建时间排序
                let options = PHFetchOptions.init()
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                            ascending: false)]//时间排序
                if let predicate = predicateForAsset(mediaType: mediaType) {
                    options.predicate = predicate
                }
                //得到一个相册,一个集合就是一个相册
                let collection:PHCollection  = smartAlbums[i];
                /**
                 相册标题英文：
                 Portrait、Long Exposure、Panoramas、Hidden、Recently Deleted、Live Photos、Videos、Animated、Recently Added、Slo-mo、Time-lapse、Bursts、Camera Roll、Screenshots、Favorites、Selfies
                 */
                PrintLog("相册标题---\(collection.localizedTitle as Any)");
                
                //遍历获取相册
                if let assetCollection = collection as? PHAssetCollection {
                    //collection中的资源都统一使用PHFetchResult 对象封装起来。
                    //得到PHFetchResult封装的图片资源集合
                    let fetchResult:PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: options)
                    if fetchResult.count>0{
                        //某个相册里面的所有PHAsset对象（PHAsset对象对应的是图片，需要通过方法请求到图片）
                        arr.append(contentsOf: getAllPHAssetFromOneAlbum(assetCollection: assetCollection))
                    }
                }
            }
            
            PrintLog(arr)
            DispatchQueue.main.async {
                complet(arr)
            }
        }
    }
    
    //获取一个相册里的所有图片的PHAsset对象
    private static func getAllPHAssetFromOneAlbum(assetCollection:PHAssetCollection, mediaType: HCAssetType = .image)->([HCAsset]){
        var arr:[HCAsset] = []
        // 是否按创建时间排序
        let options = PHFetchOptions.init()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                    ascending: false)]//时间排序
        
        if let predicate = predicateForAsset(mediaType: mediaType) {
            options.predicate = predicate
        }

        // 获取所有图片资源对象
        let results:PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: options)
        
        // 遍历，得到每一个图片资源asset，然后放到集合中
        results.enumerateObjects { (asset, index, stop) in
            PrintLog(asset)
            switch asset.mediaType {
            case .image:
                arr.append(HCPhotoAsset(asset: asset))
            case .video:
                arr.append(HCVideoAsset(asset: asset))
            case .audio:
                arr.append(HCAudioAsset(asset: asset))
            default:
                break
            }
        }
        
        return arr
    }
    
    private static func predicateForAsset(mediaType: HCAssetType) ->NSPredicate? {
        switch mediaType {
        case .all:
            return nil
        case .image:
            return NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)
        case .video:
            return NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.video.rawValue)
        case .audio:
            return NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.audio.rawValue)
        }
    }
}

extension HCAssetManager {
    
    /// 通过PHAsset加载图片
    public static func loadImage(imageMode: HCImageMode, asset: HCPhotoAsset, complet:@escaping ((UIImage?)->())) {
        DispatchQueue.global().async {
            let options = PHImageRequestOptions()
            options.isSynchronous = false
            options.deliveryMode = imageMode == .thumb ? .fastFormat : .highQualityFormat
            options.isNetworkAccessAllowed = true
            options.progressHandler = { (progress, error, stop, info) in
                PrintLog("图片获取进度：\(progress)")
            }
            
            if #available(iOS 13, *) {
                PHImageManager.default().requestImageDataAndOrientation(for: asset.asset, options: options) { (data, _, orientation, info) in
                    var image: UIImage? = nil
                    if let d = data {
                        image = UIImage(data: d)
                    }
                    
                    DispatchQueue.main.async {
                        complet(image)
                    }
                }
            } else {
                PHImageManager.default().requestImageData(for: asset.asset, options: options) { (data, _, orientation, info) in
                    var image: UIImage? = nil
                    if let d = data {
                        image = UIImage(data: d)
                    }
                    
                    DispatchQueue.main.async {
                        complet(image)
                    }
                }
            }
        }
    }
}

extension HCAssetManager {
    
    public static func checkPhotoLibrary(result:@escaping ((Bool)->())) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .restricted, .denied:
            result(false)
            return
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { res in
                DispatchQueue.main.async {
                    if #available(iOS 14, *) {
                        if res == .authorized || res == .limited {
                            result(true)
                        }else {
                            result(false)
                        }
                    } else {
                        if res == .authorized {
                            result(true)
                        }else {
                            result(false)
                        }
                    }
                }
            }
            return
        default:
            result(true)
        }
    }
    
    public static func checkCamera(result:@escaping ((Bool)->())) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { flag in
                result(flag)
            }
        case .denied, .restricted:
            result(false)
        default:
            result(true)
        }
    }

}

//MARK: 媒体模型转换
class HCAsset {
    public var asset: PHAsset = PHAsset()
    /// 加载图片后赋值
    public var image: UIImage?
    
    init() { }
    
    convenience init(asset: PHAsset) {
        self.init()
        self.asset = asset
    }
}

class HCPhotoAsset: HCAsset {
    
}

class HCVideoAsset: HCAsset {
    
}

class HCAudioAsset: HCAsset {
    
}

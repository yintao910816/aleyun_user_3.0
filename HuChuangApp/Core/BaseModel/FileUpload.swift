//
//  FileUpload.swift
//  HuChuangApp
//
//  Created by yintao on 2019/2/14.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class UpLoadIconModel: HJModel {
    var fileName: String = ""
    var filePath: String = ""
}

class HCFileUploadModel: HJModel {
    var fileName: String = ""
    var filePath: String = ""
    var subFilePath: String = ""
    
    var audioDuration: UInt = 0
}

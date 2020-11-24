//
//  CarouselView.swift
//  ComicsReader
//
//  Created by 尹涛 on 2018/5/22.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class CarouselView: UIView {
    
    enum IndicatorPosition {
        case bottomRight
        case bottomCenter
    }
    
    private var scroll: UIScrollView!
    public var pageContrl: UIPageControl!
    
    // 上一个
    private var lastImageView: UIImageView!
    // 此imageView始终为当前显示的
    private var currentImageView: UIImageView!
    // 下一个
    private var nextImageView: UIImageView!
    
    private var tapGesture: UITapGestureRecognizer!

    private let dataControl = CarouselDatasource.init()
    
    private var timer: Timer?
    
    public var tapCallBack: ((CarouselSource) ->Void)?
    public var pageIdxChangeCallBack: ((Int)->())?
    
    public var timeInterval: TimeInterval = 4.0 {
        didSet {
            timer?.invalidate()
            timer = nil
            
            timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
            timer?.fireDate = Date.init(timeIntervalSinceNow: timeInterval)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setData<T: CarouselSource>(source: [T]) {
        if source.count > 0 {
            tapGesture.isEnabled = true
            scroll.isUserInteractionEnabled = true

            dataControl.dataSource = source
            
            pageContrl.numberOfPages = source.count
            scroll.isScrollEnabled = !(source.count <= 1)
            
            setCarouselImage()
            
            if source.count > 1 {
                timer?.fireDate = Date.init(timeIntervalSinceNow: timeInterval)
                pageContrlIsHidden = false
            }else {
                timer?.fireDate = Date.distantFuture
                pageContrlIsHidden = true
            }
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public var pageContrlIsHidden: Bool = false {
        didSet {
            pageContrl.isHidden = pageContrlIsHidden
        }
    }
    
    public var indicatorPosition: IndicatorPosition = .bottomRight {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    private func setCarouselImage() {
        lastImageView.setImage(dataControl.itemModel(.last)?.url)
        currentImageView.setImage(dataControl.itemModel(.current)?.url)
        nextImageView.setImage(dataControl.itemModel(.next)?.url)
    
        scroll.setContentOffset(CGPoint.init(x: width, y: 0), animated: false)
    }
    
    private func setupView() {
        scroll = UIScrollView.init()
        scroll.isPagingEnabled = true
        scroll.isUserInteractionEnabled = false
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        
        lastImageView = UIImageView.init()
        lastImageView.contentMode = .scaleAspectFill
        lastImageView.clipsToBounds = true
        
        currentImageView = UIImageView.init()
        currentImageView.contentMode = .scaleAspectFill
        currentImageView.clipsToBounds = true

        nextImageView = UIImageView.init()
        nextImageView.contentMode = .scaleAspectFill
        nextImageView.clipsToBounds = true
        
        pageContrl = UIPageControl.init()
        pageContrl.currentPage = 0
        pageContrl.currentPageIndicatorTintColor = HC_MAIN_COLOR
        pageContrl.pageIndicatorTintColor = .white

        addSubview(scroll)
        scroll.addSubview(lastImageView)
        scroll.addSubview(currentImageView)
        scroll.addSubview(nextImageView)
        addSubview(pageContrl)
        bringSubviewToFront(pageContrl)
        
        scroll.setContentOffset(CGPoint.init(x: width, y: 0), animated: false)
        
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapCarousel(_:)))
        tapGesture.isEnabled = false
        addGestureRecognizer(tapGesture)
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timer?.fireDate = Date.distantFuture
    }
    
    @objc private func timerAction() {
        scroll.setContentOffset(CGPoint.init(x: width * 2, y: 0), animated: true)
    }
    
    @objc private func tapCarousel(_ tap: UITapGestureRecognizer) {
        tapCallBack?(dataControl.itemModel()!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        scroll.frame = bounds
        lastImageView.frame = .init(x: 0, y: 0, width: width, height: height)
        currentImageView.frame = .init(x: scroll.width, y: 0, width: width, height: height)
        nextImageView.frame = .init(x: 2 * width, y: 0, width: width, height: height)
                
        let size = pageContrl.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 20))
        switch indicatorPosition {
        case .bottomRight:
            pageContrl.frame = .init(x: width - 20 - size.width,
                                     y: height - size.height,
                                     width: size.width,
                                     height: size.height)
        case .bottomCenter:
            pageContrl.frame = .init(x: (width - size.width) / 2,
                                     y: height - size.height,
                                     width: size.width,
                                     height: size.height)
        }
        
        scroll.contentSize = .init(width: scroll.width * 3, height: scroll.height)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        
        PrintLog("计时器释放了 -- \(self)")
    }
}

extension CarouselView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.fireDate = Date.distantFuture
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        dataControl.scrollEnd(scroll: scrollView) { [unowned self] page in self.pageContrl.currentPage = page }
        
        setCarouselImage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
        
        timer?.fireDate = Date.init(timeIntervalSinceNow: timeInterval)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
    
}

//
//  URLProtocol.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/26.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

private let FilteredKey: String = "FilteredKey"

class HCWebURLProtocol: URLProtocol {

    private var responseData: NSMutableData!
    private var connect: NSURLConnection!
    
    // 决定这个 protocol 是否可以处理传入的 request 的如是返回 true 就代表可以处理,如果返回 false 那么就不处理这个 request
    override class func canInit(with request: URLRequest) -> Bool {
        let flag = URLProtocol.property(forKey: FilteredKey, in: request)
        if flag != nil {
            return false
        }
        return true
    }
    
    /**
     这个方法主要是用来返回格式化好的request，如果自己没有特殊需求的话，直接返回当前的request就好了。如果你想做些其他的，比如地址重定向，或者请求头的重新设置，你可以copy下这个request然后进行设置
     */
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /**
     这个方法主要是用来返回格式化好的request，如果自己没有特殊需求的话，直接返回当前的request就好了。如果你想做些其他的，比如地址重定向，或者请求头的重新设置，你可以copy下这个request然后进行设置
     */
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }
    
    override func startLoading() {
        PrintLog("拦截到的URL:\(request.url?.absoluteString)")
        let newRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(NSNumber.init(value: true), forKey: FilteredKey, in: newRequest)
        connect = NSURLConnection.init(request: newRequest as URLRequest, delegate: self)
    }
    
    override func stopLoading() {
        if connect != nil {
            connect.cancel()
            connect = nil
        }
    }
}

extension HCWebURLProtocol: NSURLConnectionDelegate {
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        client?.urlProtocol(self, didFailWithError: error)
    }
    
}

extension HCWebURLProtocol: NSURLConnectionDataDelegate {

    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        responseData = NSMutableData.init()
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        responseData.append(data)
        self.client?.urlProtocol(self, didLoad: data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        self.client?.urlProtocolDidFinishLoading(self)
    }
}

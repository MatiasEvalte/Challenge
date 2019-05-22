//
//  SMRequestManager.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol SMRequestManagerDelegate {
    @objc optional func smRequest(_ smRequestManager: SMRequestManager?, didReceiveData data: Data?)
    @objc optional func smRequestImage(_ smRequestManager: SMRequestManager?, didReceiveData image: UIImage?)
}

open class SMRequestManager: NSObject {
    
    open weak  var mutableRequest: NSMutableURLRequest!
    open weak var delegate: SMRequestManagerDelegate?
    
    private func rest(_ url: URLRequest) {
        let session = URLSession.shared
        session.dataTask(with: self.mutableRequest as URLRequest) { [weak self] data, response, err in
            if err == nil {
                self?.didReceive(data!)
            } else {
                self?.didReceiveError(err)
            }
            }.resume()
    }
    
    private func restPhoto(_ url: URLRequest) {
        let session = URLSession.shared
        session.dataTask(with: self.mutableRequest as URLRequest) { [weak self] data, response, err in
            if err == nil {
                self?.didReceiveImage(UIImage(data: data!))
            } else {
                self?.didReceiveError(err)
            }
            }.resume()
    }
    
    open func performGetRequest(_ url: NSURL) {
        let mutable = NSMutableURLRequest(url: url as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 400000.0)
        self.mutableRequest = mutable
        self.mutableRequest.httpMethod = "GET"
        
        self.rest(self.mutableRequest as URLRequest)
    }
    
    open func performGetPhotoRequest(_ url: NSURL) {
        let mutable = NSMutableURLRequest(url: url as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 400000.0)
        self.mutableRequest = mutable
        self.mutableRequest.httpMethod = "GET"
        
        self.restPhoto(self.mutableRequest as URLRequest)
    }
    
    open func didReceiveError(_ error: Error?) {
        assert(true, "SMRest -> Error: Called abstract method in AbstractRequest")
    }
    
    open func didReceive(_ data: Data?) {
        self.delegate?.smRequest?(self, didReceiveData: data)
    }
    
    open func didReceiveImage(_ image: UIImage?) {
        self.delegate?.smRequestImage?(self, didReceiveData: image)
    }
}

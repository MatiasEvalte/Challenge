//
//  Request.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import Foundation
import UIKit

public typealias RequestComplete = (AnyObject?, String?) -> Void 

open class Request: SMRequestManager {
     
    var completion: RequestComplete?
    
    open func performGetRequest(_ postData: String, forMethod method: String) {
        let urlRequest =  "https://api.themoviedb.org/3/"
        self.performGetRequest(URL(string: urlRequest + method + postData)! as NSURL)
    }
    
    open func performGetPhotoRequest(forMethod method: String) {
        let urlRequest =  "https://image.tmdb.org/t/p/w500"
        self.performGetPhotoRequest(URL(string: urlRequest + method)! as NSURL)
    }
    
    open override func didReceive(_ data: Data?) {
        if let parseData = data {
            let result = SMJSONSerialization.parseJSON(parseData, withJSONOptions: JSONSerialization.ReadingOptions.mutableContainers)
            guard result != nil else {
                print("ATSBase -> Error: the result dictionary parsed from JSON is nil --<<<", terminator: "")
                self.completion?(nil, "Error: the result dictionary parsed from JSON is nil")
                return
            }
            self.parseResult(result!)
        }
    }
    
    open override func didReceiveError(_ error: Error?) {
        self.completion?(nil, error?.localizedDescription ?? "Dont have connection internet")
    }
    
    open override func didReceiveImage(_ image: UIImage?) { 
        if image != nil {
            self.parseResultImg(image!)
        }
    }
    
    open func parseResult(_ dictionary: NSDictionary) {
        let restObject = SMJSONSerialization.parseRestObject(dictionary)
        self.parseResultObject(restObject)
    }
    
    open func parseResultImg(_ image: UIImage) {
        let restObject = SMJSONSerialization.parseRestImageObj(image)
        self.parseResultObject(restObject)
    }
    
    open func parseResultObject(_ restObject: SMRestObject) {} 
}

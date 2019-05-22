//
//  SMJSONSerialization.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import UIKit

open class SMJSONSerialization: NSObject {
    
    open class func serializeJSON(_ dictionary: NSDictionary) -> Data? {
        var data: Data? = nil
        do {
            data = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let error as NSError {
            print("SMRest ->  Error JSON Serialization: \(error) --<<<", terminator: "")
        }
        return data
    }
    
    open class func parseJSON(_ response: Data, withJSONOptions options: JSONSerialization.ReadingOptions) -> NSDictionary? {
        var dictionaryObject: NSDictionary? = nil
        do {
            dictionaryObject = try JSONSerialization.jsonObject(with: response, options: options) as? NSDictionary
        } catch let error as NSError {
            print("SMRest ->  Error Parse JSON: \(error) --<<<", terminator: "")
        }
        return dictionaryObject
    }
    
    open class func parseRestObject(_ result: NSDictionary) -> SMRestObject {
        let restObject = SMRestObject()
        restObject.page = result.object(forKey: "page") as? Int
        restObject.object = result.object(forKey: "results") as AnyObject? 
        return restObject
    }
    
    open class func parseRestImageObj(_ result: UIImage) -> SMRestObject {
        let restObject = SMRestObject()
        restObject.imageObj = result
        return restObject
    }
}

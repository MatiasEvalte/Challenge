//
//  SMRestObject.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import UIKit

open class SMRestObject: NSObject {
    
    open var page: Int?
    open var object: AnyObject?
    open var imageObj: UIImage?
    
    open func objectToJSONDictionary() -> NSDictionary {
        fatalError("SMRest -> Error: Called abstract method in SMRestObject")
    }
    
    open func objectOldToJSONDictionary() -> NSDictionary {
        fatalError("SMRest -> Error: Called abstract method in SMRestObject")
    }
    
    open func objectNoDateToJSONDictionary() -> NSDictionary {
        fatalError("SMRest -> Error: Called abstract method in SMRestObject")
    }
    
    open func jsonToObject() {
        fatalError("SMRest -> Error: Called abstract method in SMRestObject")
    } 
}

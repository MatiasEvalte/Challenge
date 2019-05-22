//
//  MDate.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import Foundation

open class MDate: NSObject {
    
    open class func formatDateToString(_ aDate: Date, withFormat aFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = aFormat
        return dateFormatter.string(from: aDate)
    }
    
    open class func formatStringToDate(_ aStringDate: String, withFormat aFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = aFormat
        return dateFormatter.date(from: aStringDate)
    }
    
    open class func formatDateToDate(_ aDate: Date, withFormat aFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = aFormat
        return dateFormatter.date(from: (dateFormatter.string(from: aDate)))
    }
}

public extension Date {
    func string(withFormat format: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

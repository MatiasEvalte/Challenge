//
//  Movies.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

open class Movies: Object {
    
    @objc open dynamic var id: Int = 0
    @objc open dynamic var vote_count: Int = 0
    @objc open dynamic var video: Bool = false
    @objc open dynamic var vote_average: Double = 0.0
    @objc open dynamic var title: String = ""
    @objc open dynamic var popularity: Double = 0.0
    @objc open dynamic var poster_path: String = ""
    @objc open dynamic var original_language: String = ""
    @objc open dynamic var original_title: String = ""
    @objc open dynamic var backdrop_path: String = ""
    @objc open dynamic var adult: Bool = false
    @objc open dynamic var overview: String = ""
    @objc open dynamic var release_date: Date?
    @objc open dynamic var hasImage: Bool = false
    open var arrayGenre = List<Int>()
    
    @objc private dynamic var imgBackDrop: String = ""
    open var imagePreview: UIImage? {
        get {
            return image(fromStringBase64: self.imgBackDrop)
        }
        set {
            self.imgBackDrop = newValue != nil ? stringBase64(fromImage: newValue!) ?? "" : ""
        }
    }
    
    @objc private dynamic var imgPoster: String = ""
    open var imagePreviewPoster: UIImage? {
        get {
            return image(fromStringBase64: self.imgPoster)
        }
        set {
            self.imgPoster = newValue != nil ? stringBase64(fromImage: newValue!) ?? "" : ""
        }
    }
    
    override open class func primaryKey() -> String? {
        return "id"
    }
    
    public required convenience init(fromJSONDictionary dictionary: NSDictionary) {
        self.init()
        self.id                 = dictionary.object(forKey: "id") as? Int ?? 0
        self.vote_count         = dictionary.object(forKey: "vote_count") as? Int ?? 0
        self.video              = dictionary.object(forKey: "video") as? Bool ?? false
        self.vote_average       = dictionary.object(forKey: "vote_average") as? Double ?? 0.0
        self.title              = dictionary.object(forKey: "title") as? String ?? ""
        self.popularity         = dictionary.object(forKey: "popularity") as? Double ?? 0.0
        self.poster_path        = dictionary.object(forKey: "poster_path") as? String ?? ""
        self.original_language  = dictionary.object(forKey: "original_language") as? String ?? ""
        self.original_title     = dictionary.object(forKey: "original_title") as? String ?? ""
        self.backdrop_path      = dictionary.object(forKey: "backdrop_path") as? String ?? ""
        self.video              = dictionary.object(forKey: "adult") as? Bool ?? false
        self.overview           = dictionary.object(forKey: "overview") as? String ?? ""
        
        if let dateString = dictionary.object(forKey: "release_date") as? String {
            self.release_date = MDate.formatStringToDate(dateString, withFormat: "yyyy-MM-dd")
        }
        
        //genre_ids
        if let object = dictionary.object(forKey: "genre_ids") as? NSArray {
            for number in object where ((number as? Int) != nil) {
                self.arrayGenre.append(number as! Int)
            }
        }
    }
    
    func image(fromStringBase64 stringBase64: String) -> UIImage? {
        guard let decodedData = Data(base64Encoded: stringBase64, options: NSData.Base64DecodingOptions(rawValue:0)) else { return nil }
        let decodedimage = UIImage(data: decodedData)
        return decodedimage
    }
    
    func stringBase64(fromImage image: UIImage) -> String? {
        guard let imageData = image.pngData() else { return nil }
        let base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
}


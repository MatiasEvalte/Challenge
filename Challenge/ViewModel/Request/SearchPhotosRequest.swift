//
//  SearchPhotosRequest.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import UIKit
import RealmSwift

class SearchPhotosRequest: Request {
    
    private var idMovie: Int?
    private var isPoster: Bool = false
    
    open func request(idMovie: Int, isPoster: Bool, photoString: String, completion: @escaping RequestComplete) {
        self.completion = completion
        self.idMovie    = idMovie
        self.isPoster   = isPoster 
        self.performGetPhotoRequest(forMethod: photoString)
    }  
    
    override open func parseResultObject(_ restObject: SMRestObject) {
        
        if restObject.imageObj != nil {
            var image: UIImage = UIImage()
            image = restObject.imageObj!
            
            let realm = try! Realm()
            let movie = realm.object(ofType: Movies.self, forPrimaryKey: self.idMovie)
            do {
                try realm.write() { [weak self] in
                    if self?.isPoster ?? false {
                        movie?.imagePreviewPoster = image
                    } else {
                        movie?.imagePreview       = image
                    }
                    movie?.hasImage           = true
                }
            } catch {
                print(error)
            }
            self.completion?(image, nil)
        } else {
            self.completion?(nil, "Falha ao obter os climas")
        }
    }
}

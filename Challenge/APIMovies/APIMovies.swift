//
//  APIMovies.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import Foundation 

open class APIMovies: NSObject {
    
    private let requestSearchMovies = SearchMoviesRequest()
    private let requestSearchPhotos = SearchPhotosRequest()
    
    // MARK: REQUEST MOVIES
    open func searchMoviesRequest(completion: @escaping RequestComplete) {
        
        guard currentReachabilityStatus != .notReachable else {
            Alert.alert(msg: "Dont have connection internet")
            return
        }
        
        requestSearchMovies.request(completion: completion)
    }
    
    // MARK: REQUEST PHOTOS
    open func searchPhotosRequest(idMovie: Int, isPoster: Bool, photoString: String, completion: @escaping RequestComplete) {
        
        guard currentReachabilityStatus != .notReachable else {
            Alert.alert(msg: "Dont have connection internet")
            return
        }
        
        requestSearchPhotos.request(idMovie: idMovie, isPoster: isPoster, photoString: photoString, completion: completion)
    }
    
    deinit {
        print("DEALLOC \(self)")
    }
}

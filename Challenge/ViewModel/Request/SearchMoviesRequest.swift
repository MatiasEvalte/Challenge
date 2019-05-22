//
//  SearchMoviesRequest.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import UIKit
import RealmSwift

class SearchMoviesRequest: Request {
    
    open func request(completion: @escaping RequestComplete) {
        self.completion = completion
        self.performGetRequest("?api_key=1f54bd990f1cdfb230adb312546d765d", forMethod: "discover/movie")
    }
    
    override open func parseResultObject(_ restObject: SMRestObject) {
        DispatchQueue.main.async {
            if restObject.object != nil && restObject.object is NSArray {
                var movies: [Movies] = []
                if let array = restObject.object as? NSArray {
                    for item in array {
                        guard let dictionary = item as? NSDictionary else { continue }
                        let movie = Movies(fromJSONDictionary: dictionary)
                        movies.append(movie)
                    }
                }
                
                do {
                    let realm = try! Realm()
                    try realm.write() {
                        realm.add(movies, update: true)
                    }
                    self.completion?(movies as AnyObject?, nil)
                } catch let error as NSError {
                    print("ATSBase: Erro ao salvar a lista de chat. Descrição: \(error)")
                    self.completion?(nil, error.description)
                }
            } else {
                self.completion?(nil, "Falha ao obter os climas")
            }
        }
    }
}

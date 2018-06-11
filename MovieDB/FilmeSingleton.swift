//
//  FilmeSingleton.swift
//  MovieDB
//
//  Created by Marllon Camargo on 22/05/16.
//  Copyright © 2016 PUCPR. All rights reserved.
//

import UIKit

class FilmeSingleton: NSObject {

    static let sharedInstance: FilmeSingleton = FilmeSingleton()
    
    var id: String
    
    private override init() {
        id = ""
    }
}

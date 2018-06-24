//
//  APIConfig.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 10/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit
import CryptoSwift

struct APIConfig {

    static let baseURL = "https://gateway.marvel.com:443"
    
    static private let privatekey = "e4692d483a8c3b431c49c06a00a50b5aeb675b5b"
    static private let publicKey = "7db840260e42cbb68c22e51a4c07047b"
    static private let ts = Date().timeIntervalSince1970.description
    static private let hash = "\(ts)\(privatekey)\(publicKey)".md5()
    
    static func apiParams() -> [String : String] {
        let params = ["apikey": APIConfig.publicKey,
                      "ts": APIConfig.ts,
                      "hash": APIConfig.hash]
        return params
    }
}

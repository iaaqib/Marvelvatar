//
//  APIManager.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 9/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class APIManager {
    
    static let sharedInstance = APIManager()
    
    
    func request<T: BaseMappable>(urlConvertible: URLRequestConvertible, success:@escaping (_ response: T)->(), failure:@escaping (_ error: Error)->()){
        
        Alamofire.request(urlConvertible).responseString { (response) in
            switch response.result {
            case .success(let value):
                guard let map = Mapper<T>().map(JSONString: value) else { return }
                success(map)
            case .failure(let error):
                failure(error)
            }
        }
        
        
    }
    
}

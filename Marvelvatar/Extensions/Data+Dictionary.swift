//
//  Data+Dictionary.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 10/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit

extension Data{
    
    func toDictionary() -> [String : Any]?{
        
        do {
           let serialized = try JSONSerialization.jsonObject(with: self, options: [])
            guard let serializedDictionary = serialized as? [String : Any] else{
               return nil
            }
            return serializedDictionary
        } catch let parseError as NSError {
            
            return ["ParseError" : parseError.localizedDescription]
        }
        
    }
    
    
}

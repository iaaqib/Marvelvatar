//
//  Comics.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 9/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import Foundation
import ObjectMapper

public class Comics: Mappable {
    
    
	public var available : Int?
	public var collectionURI : String?
	public var items : Array<Items>?
	public var returned : Int?


    public class func modelsFromDictionaryArray(array:NSArray) -> [Comics]{
        var models:[Comics] = []
        models = array.compactMap{
            Comics(dictionary: $0 as? Dictionary<String,Any>)
        }
        return models
    }

    required public init?(dictionary: Dictionary<String,Any>?) {

		available = dictionary?["available"] as? Int
		collectionURI = dictionary?["collectionURI"] as? String
		if let items = dictionary?["items"] as? NSArray { self.items = Items.modelsFromDictionaryArray(array: items) }
		returned = dictionary?["returned"] as? Int
	}

    public required init?(map: Map) {
        
        available <- map["available"]
        collectionURI <- map["collectionURI"]
        items <- map["items"]
        returned <- map["returned"]
    }
    
    public func mapping(map: Map) {
        
    }

}

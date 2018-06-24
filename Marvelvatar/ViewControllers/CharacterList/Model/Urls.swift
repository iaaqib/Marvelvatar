//
//  Urls.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 9/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//
import Foundation
import ObjectMapper


public class Urls: Mappable {
    
	public var type : String?
	public var url : String?

    public class func modelsFromDictionaryArray(array: NSArray) -> [Urls]{
        var models:[Urls] = []
        models = array.flatMap{
            Urls(dictionary: $0 as? Dictionary<String,Any>)
        }
        return models
    }


	required public init?(dictionary: Dictionary<String,Any>?) {

		type = dictionary?["type"] as? String
		url = dictionary?["url"] as? String
	}

    public required init?(map: Map) {
        type <- map["type"]
        url <- map["url"]
    }
    
    public func mapping(map: Map) {
        
    }
    
		


}

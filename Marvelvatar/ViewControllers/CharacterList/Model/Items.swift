//
//  Items.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 9/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//



import Foundation
import ObjectMapper

public class Items: Mappable {
    public  func mapping(map: Map) {
        
    }
    
	public var resourceURI : String?
	public var name : String?


    public class func modelsFromDictionaryArray(array: NSArray) -> [Items]{
        var models:[Items] = []
        models = array.flatMap{
            Items(dictionary: $0 as? Dictionary<String,Any>)
        }
        return models
    }


	required public init?(dictionary: Dictionary<String,Any>?) {

		resourceURI = dictionary?["resourceURI"] as? String
		name = dictionary?["name"] as? String
	}
    public required init?(map: Map) {
        resourceURI <- map["resourceURI"]
        name <- map["name"]
    }

    


}

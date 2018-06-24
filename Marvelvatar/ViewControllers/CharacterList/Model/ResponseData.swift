//
//  ResponseData.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 9/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//


import Foundation
import ObjectMapper


public class ResponseData: Mappable {
    
	public var offset: Int?
	public var limit: Int?
	public var total: Int?
	public var count: Int?
	public var results: Array<Results>?

    public class func modelsFromDictionaryArray(array: NSArray) -> [ResponseData]{
        var models:[ResponseData] = []
        models = array.flatMap{
            ResponseData(dictionary: $0 as? Dictionary<String,Any>)
        }
        return models
    }


	required public init?(dictionary: Dictionary<String,Any>?) {

		offset = dictionary?["offset"] as? Int
		limit = dictionary?["limit"] as? Int
		total = dictionary?["total"] as? Int
		count = dictionary?["count"] as? Int
        if let dict = dictionary?["results"] as? NSArray{
            results = Results.modelsFromDictionaryArray(array: dict) }
	}
    public required init?(map: Map) {
        offset <- map["offset"]
        limit <- map["limit"]
        total <- map["total"]
        count <- map["count"]
        results <- map["results"]
    }
    
    public func mapping(map: Map) {
        
    }
    

}

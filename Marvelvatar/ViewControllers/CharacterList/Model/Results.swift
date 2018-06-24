//
//  Results.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 9/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//




import Foundation
import ObjectMapper

public class Results: Mappable {
    
    
    
    
	public var id : Int?
	public var name : String?
	public var description : String?
	public var modified : String?
	public var thumbnail : Thumbnail?
	public var resourceURI : String?
	public var comics : Comics?
	public var series : Series?
	public var stories : Stories?
	public var events : Events?
	public var urls : Array<Urls>?
    public var isFavorite = false

    public class func modelsFromDictionaryArray(array:NSArray) -> [Results]{
        var models:[Results] = []
        models = array.flatMap{
            Results(dictionary: $0 as? Dictionary<String,Any>)
        }

        return models
    }

	required public init?(dictionary: Dictionary<String,Any>?) {

		id = dictionary?["id"] as? Int
		name = dictionary?["name"] as? String
		description = dictionary?["description"] as? String
		modified = dictionary?["modified"] as? String
		if let thumb = dictionary?["thumbnail"] as? Dictionary<String,Any>{
        thumbnail = Thumbnail(dictionary: thumb)}
		resourceURI = dictionary?["resourceURI"] as? String
		if let comics = dictionary?["comics"] as? Dictionary<String,Any> { self.comics = Comics(dictionary: comics) }
		if let series = dictionary?["series"] as? Dictionary<String,Any> { self.series = Series(dictionary: series) }
		if let story = dictionary?["stories"] as? Dictionary<String,Any>{ stories = Stories(dictionary: story) }
        if let event = dictionary?["events"] as? Dictionary<String,Any> { events = Events(dictionary: event ) }
        if let url = dictionary?["urls"] as? NSArray { urls = Urls.modelsFromDictionaryArray(array: url) }
        
	}

    public required init?(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        modified <- map["modified"]
        thumbnail <- map["thumbnail"]
        resourceURI <- map["resourceURI"]
        comics <- map["comics"]
        series <- map["series"]
        stories <- map["stories"]
        events <- map["events"]
        urls <- map["urls"]
    }
    
    public func mapping(map: Map) {
        
    }
}

//
//  Thumbnail.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 9/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//
import Foundation
import ObjectMapper


public class Thumbnail: Mappable {
   
    var path : String?
    var fileExtension : String?
    var imageUrl: URL?

    public class func modelsFromDictionaryArray(array: NSArray) -> [Thumbnail]{
        var models:[Thumbnail] = []
        models = array.flatMap{
            Thumbnail(dictionary: $0 as? Dictionary<String,Any>)
        }
        return models
    }


	required public init?(dictionary: Dictionary<String,Any>?) {

		path = dictionary?["path"] as? String
		fileExtension = dictionary?["extension"] as? String
        imageUrl = URL(string: "\(path ?? "").\(fileExtension ?? "")")
	}

    public required init?(map: Map) {
        path <- map["path"]
        fileExtension <- map["extension"]
        imageUrl = URL(string: "\(path ?? "").\(fileExtension ?? "")")
    }
    
    public func mapping(map: Map) {
        
    }


}

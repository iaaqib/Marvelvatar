//
//  CharacterModel.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 9/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import Foundation
import ObjectMapper


public class CharacterModel: Equatable, Mappable {
    
    
 
    
    public static func ==(lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        return lhs.data?.offset == rhs.data?.offset
    }
    
	public var code : Int?
	public var status : String?
	public var copyright : String?
	public var attributionText : String?
	public var attributionHTML : String?
	public var etag : String?
	public var data : ResponseData?


    public class func modelsFromDictionaryArray(array: NSArray) -> [CharacterModel]
    {
        var models:[CharacterModel] = []
        models = array.flatMap{
         CharacterModel(dictionary: $0 as? Dictionary<String,Any>)
        }
        return models
    }


	required public init?(dictionary: Dictionary<String,Any>?) {

		code = dictionary?["code"] as? Int
		status = dictionary?["status"] as? String
		copyright = dictionary?["copyright"] as? String
		attributionText = dictionary?["attributionText"] as? String
		attributionHTML = dictionary?["attributionHTML"] as? String
		etag = dictionary?["etag"] as? String
		if let data = dictionary?["data"] as? Dictionary<String,Any>{ self.data = ResponseData(dictionary: data) }
	}

    public required init?(map: Map) {
        code <- map["code"] 
        status <- map["status"]
        copyright <- map["copyright"]
        attributionText <- map["attributionText"]
        attributionHTML <- map["attributionHTML"]
        etag <- map["etag"]
        data <- map["data"]
        
    }
    
    public func mapping(map: Map) {
        
    }

}

//
//  ImageCache.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 10/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit

class ImageCache: NSObject {

    //Cache Memory can be adjusted from totalCostLimit
    static let sharedInstance: NSCache<NSString, UIImage> = {
        
        let cache = NSCache<NSString, UIImage>()
        cache.name = "ImageCache"
        cache.countLimit = 10
        cache.totalCostLimit = 10*1024*1024
        cache.evictsObjectsWithDiscardedContent = true
        return cache
        
        
    }()
    
     static func clearCache(){
        
        ImageCache.sharedInstance.removeAllObjects()
        
    }
}

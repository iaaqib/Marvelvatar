//
//  UIImageView+Download.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 10/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadImage(url: URL?, placeHolderImage: UIImage? = nil, completion: ((_ completedWithSuccess:Bool, _ error: Error?)->())? = nil){
        guard let url = url else {return}
        self.image = nil
        self.image = placeHolderImage
        if let image = containsImageInCache(key: url.absoluteString as NSString) {
            
            DispatchQueue.main.async{
                self.image = image
            }
            return
        }else {
            DispatchQueue.global(qos: .background).async{
            APIManager.sharedManager.download(url: url, success: {[weak self] (imageData) in
                let image = UIImage(data: imageData, scale: 0.5)
                ImageCache.sharedInstance.setObject(
                    image!,
                    forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async{
                    self?.image = image
                    guard let completion = completion else{return}
                    completion(true, nil)
                }
                
            }, failure: { (error) in
                guard let completion = completion else{return}
                completion(false, error)
            })
            }
        }

        
    }
    
    //Loads from Cache
    private func containsImageInCache(key: NSString) -> UIImage?{
        guard let image = ImageCache.sharedInstance.object(forKey: key) else{
            return nil
        }
        return image
        
    }
    
    
    
}

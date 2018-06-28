//
//  CharacterTableViewCell.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 10/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    static let identifier = "characterCell"
    
    var characterModel: (result: Results? , row: Int)?{
        didSet{
            guard let model = characterModel else {return}
            guard let result = model.result else {return}
        
            characterName.text = "\(model.row + 1): \(String(describing: result.name ?? ""))"
            characterImage.kf.setImage(with: result.thumbnail?.imageUrl, placeholder: #imageLiteral(resourceName: "marvel-place"))            
        }
    }
    
    
}

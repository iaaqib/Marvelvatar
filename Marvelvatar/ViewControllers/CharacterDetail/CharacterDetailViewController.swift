//
//  CharacterDetailViewController.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 11/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterDescription: UITextView!
    
    var characterModel: Results!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setData()

    }
    override func viewDidLayoutSubviews() {
        characterDescription.setContentOffset(.zero, animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set dat into views
    func setData(){
        
        characterName.text = characterModel.name ?? ""
        var description = characterModel.description ?? ""
        description = description == "" ? "NA" : description        
        
        let descriptionAttributed = NSMutableAttributedString()
        descriptionAttributed.bold("Description: ").normal("\(description)\n")
        if let comics = characterModel.comics?.items, comics.count>0 {
            
            descriptionAttributed.bold("\nComics:\n")
            comics.forEach({ (item) in
                descriptionAttributed.normal(" ● \(item.name ?? "")\n")
            })
        }
        if let events = characterModel.events?.items, events.count>0 {
            descriptionAttributed.bold("\nEvents:\n")
            events.forEach({ (item) in
                descriptionAttributed.normal(" ● \(item.name ?? "")\n")
            })
        }
        if let stories = characterModel.stories?.items, stories.count>0 {
            descriptionAttributed.bold("\nStories:\n")
            stories.forEach({ (item) in
                descriptionAttributed.normal(" ● \(item.name ?? "")\n")
            })
        }
        if let series = characterModel.series?.items, series.count>0 {
            descriptionAttributed.bold("\nSeries:\n")
            series.forEach({ (item) in
                descriptionAttributed.normal(" ● \(item.name ?? "")\n")
            })
        }
        characterDescription.attributedText = descriptionAttributed
        characterDescription.layoutIfNeeded()
        guard let image = characterModel.thumbnail?.imageUrl else {return}
        characterImage.kf.setImage(with: image, placeholder: #imageLiteral(resourceName: "marvel-place"))
    }

}


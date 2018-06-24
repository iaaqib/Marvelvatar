//
//  BottomActivityIndicatorView.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 10/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit

class BottomActivityIndicatorView: UIView {
    @IBOutlet weak var activitiIndictor: UIActivityIndicatorView!
    
    class func loadView()-> BottomActivityIndicatorView{
        let view = Bundle.main.loadNibNamed("BottomActivityIndicatorView", owner: self, options: nil)?.first as? BottomActivityIndicatorView
        
        return view!
    }
   
    
}

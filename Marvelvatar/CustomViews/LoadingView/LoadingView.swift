//
//  LoadingView.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 10/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet weak var activitiIndictor: UIActivityIndicatorView!
    private static var loadView: LoadingView = {
        let view = Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)?.first as? LoadingView
        return view!
    }()
    
    class func getLoadedrView() -> LoadingView {
        return loadView
    }
  
    
}


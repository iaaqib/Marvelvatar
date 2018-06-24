//
//  UIView+LoadingView.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 10/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit

extension UIView{
    //Show Custom Loader
    func showLoaderView() {
        let loaderView = LoadingView.getLoadedrView()
        loaderView.activitiIndictor.startAnimating()
        loaderView.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(loaderView)
      
    }
    
    //Hide Custom Loader
    func hideLoaderView() {
        LoadingView.getLoadedrView().activitiIndictor.stopAnimating()
        LoadingView.getLoadedrView().removeFromSuperview()
    }
    
    //Hide Keyboard on tap
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelEditing))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func cancelEditing() {
        self.endEditing(true)
    }
}

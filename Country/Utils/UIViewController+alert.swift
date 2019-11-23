//
//  UIViewController+alert.swift
//  Dermatologi
//
//  Created by Federico Piccirilli on 14/06/2018.
//  Copyright © 2018 Digital Mill. All rights reserved.
//

import UIKit

extension UIViewController {
    func showSimpleAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

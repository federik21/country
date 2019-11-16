//
//  ViewController.swift
//  Country
//
//  Created by Federico Piccirilli on 13/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import UIKit

class CountryListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    private var viewModel: CountryViewModel = CountryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupListComponents()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(chooseFilter))
    }
    
    @objc func chooseFilter(){
        self.performSegue(withIdentifier: "filter", sender: self)
    }
    
    func setupListComponents(){
        self.viewModel.countryListPresenter.delegate = self
        self.viewModel.countryListPresenter.viewModel = viewModel
        self.viewModel.countryListPresenter.bind(tableView: tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "filter":
            if let vc = segue.destination as? FilterVC {
                vc.viewModel = self.viewModel
                let backItem = UIBarButtonItem()
                backItem.title = "Apply"
                navigationItem.backBarButtonItem = backItem
            }
        default:
            break
        }
    }
    
}

extension CountryListVC: CountryListPresenterDelegate{
    
    func countryListPresenter(didSelectCountry country: Country) {
        //TODO: go to detail
    }
    
}

// Keyboard handling
extension CountryListVC {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize: CGSize = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size) else {return}
        let height = min(keyboardSize.height, keyboardSize.width)
        
        tableViewBottomConstraint.constant = height // you can add a value to the height to move it up/down.
        self.view.layoutIfNeeded() // this will auto animate the view motion with the keyboard

    }

    @objc func keyboardWillHide() {
        tableViewBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
}

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
    private var presenter: CountryListPresenter!

    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupListComponents()
        self.title = "Countries"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progress.startAnimating()
        progress.isHidden = false
        messageLabel.isHidden = true
        presenter.loadData()
    }
    
    @objc func chooseFilter(){
        self.performSegue(withIdentifier: "filter", sender: self)
    }
    
    func setupListComponents(){
        presenter = CountryListPresenter()
        presenter.bind(tableView: tableView)
        presenter.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.closeSearch()
        switch segue.identifier {
        case "filter":
            if let vc = segue.destination as? FilterVC {
                vc.presenter = self.presenter
                let backItem = UIBarButtonItem()
                backItem.title = "Apply"
                navigationItem.backBarButtonItem = backItem
            }
        case "detailCountry":
            if let vc = segue.destination as? CountryDetailVC {
                guard let country = sender as? Country else {return}
                vc.country = country
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem
            }
        default:
            break
        }
    }
    
    @objc func reloadData(){
        progress.startAnimating()
        progress.isHidden = false
        messageLabel.isHidden = true
        presenter.loadData()
    }

    
}

extension CountryListVC: CountryListPresenterDelegate{
    
    func countryListPresenter(didSelectCountry country: Country) {
        self.performSegue(withIdentifier: "detailCountry", sender: country)
    }
    
    func countryListPresenter(didFinishToLoad countries: [Country], with error: Error?) {
        DispatchQueue.main.async {
            [unowned self] in
                self.progress.stopAnimating()
                self.progress.isHidden = true
                if let error = error {
                    self.messageLabel.isHidden = false
                    self.messageLabel.text = "Something went wrong...\nTry to check your connection, and reload the data"
                    
                    self.showSimpleAlert(title: "Error", message: "\(error.localizedDescription)")
                    
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "reload"), style: .plain, target: self, action: #selector(self.reloadData))

                }
                else {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(self.chooseFilter))
                    if countries.count == 0 {
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = "No country found...\nTry a different filter"
                        
                    }
                }
            }
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

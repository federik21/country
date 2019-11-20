//
//  CountryDetailVC.swift
//  Country
//
//  Created by Federico Piccirilli on 19/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import UIKit

enum CountryDataType {
    case string(String?)
    case double(Double?)
    case currencies([Currencies]?)
    case languages([Languages]?)
    case regionalBlocs([RegionalBlocs]?)
}

class CountryDetailVC: UIViewController {
    
    fileprivate var infos: [(label:String, data:CountryDataType)] = []
    var viewModel :DetailViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(chooseFilter))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.infos = viewModel.parseInfo()
        self.tableView.reloadData()
    }
    
    @objc func chooseFilter(){
        self.performSegue(withIdentifier: "countryDetailSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "countryDetailSettings":
            if let vc = segue.destination as? CountrySettingsVC {
                vc.viewModel = self.viewModel
            }
        default:
            break
        }
    }
   
}

extension CountryDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryDataCell", for: indexPath) as! CountryDataTVC
        let info = infos[indexPath.row]
        cell.bind(name: info.label, data: info.data)
        return cell
    }
    
}

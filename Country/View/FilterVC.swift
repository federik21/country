//
//  LanguageListVC.swift
//  Country
//
//  Created by Federico Piccirilli on 16/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // Will be section 0 of the table view
    var regions = [String]()
    
    // Will be section 1 of the table view
    var languages = [String]()

    weak var viewModel: CountryViewModel? {
        didSet {
            regions = viewModel?.regionsFilterMap.keys.sorted() ?? []
            languages = viewModel?.languagesFilterMap.keys.sorted() ?? []
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func fetchFilterParams(from countries:[Country]){
        
    }

}

extension FilterVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return regions.count
            case 1:
                return languages.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "Regions"
            case 1:
                return "Languages"
            default:
                return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filtersCell", for: indexPath)
        switch indexPath.section {
            case 0:
                let data = regions[indexPath.row]
                cell.textLabel?.text = data
                cell.setSelected(viewModel?.regionsFilterMap[data] ?? false, animated: true)
            case 1:
                let data = languages[indexPath.row]
                cell.textLabel?.text = data
                cell.setSelected(viewModel?.languagesFilterMap[data] ?? false, animated: true)
            default:
                break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let code = cell?.textLabel?.text else {return}
        switch indexPath.section {
            case 0:
                viewModel?.regionsFilterMap.updateValue(true, forKey: code)
            case 1:
                viewModel?.languagesFilterMap.updateValue(true, forKey: code)
            default:break
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let code = cell?.textLabel?.text else {return}
        switch indexPath.section {
            case 0:
                viewModel?.regionsFilterMap.updateValue(false, forKey: code)
            case 1:
                viewModel?.languagesFilterMap.updateValue(false, forKey: code)
            default:break
        }
    }
}

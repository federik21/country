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
    
    @IBOutlet weak var labelStatus: UILabel!
    // Will be section 0 of the table view
    var regions = [String]()
    
    // Will be section 1 of the table view
    var languages = [Languages]()

    weak var viewModel: CountryViewModel? {
        didSet {
            regions = viewModel?.getRegions().sorted() ?? []
            languages = viewModel?.getLanguages().sorted(by: {$1.name ?? "" > $0.name ?? ""}) ?? []
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    fileprivate func updateFilteringStatus() {
        if viewModel?.isFiltering ?? false {
            labelStatus.text = "Filters are ACTIVE"
        }
        else {
            labelStatus.text = "Filters are OFF"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFilteringStatus()
    }
    
    @IBAction func resetFilter(_ sender: Any) {
        self.viewModel?.resetFilters()
        self.tableView.reloadData()
        updateFilteringStatus()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "filtersCell", for: indexPath) as! FilterTVC
        cell.delegate = self
        switch indexPath.section {
            case 0:
                let data = regions[indexPath.row]
                cell.type = .region
                cell.filterId = data
                cell.labelTitle?.text = data
                let on = viewModel?.regionFilterActive(key: data) ?? false
                cell.switchActive.isOn = on
                cell.switchActive.setOn(on, animated: false)
            case 1:
                let data = languages[indexPath.row]
                cell.type = .language
                cell.filterId = data.iso639_1
                cell.labelTitle?.text = data.name
                let on = viewModel?.languageFilterActive(key: data.iso639_1 ?? "") ?? false
                cell.switchActive.isOn = on
                cell.switchActive.setOn(on, animated: false)
            default:
                break
        }
        return cell
    }
}

extension FilterVC : FilterCellDelegate {
    func filterCell(didSwitchFilter cell: FilterTVC, isOn: Bool) {
        guard let code = cell.filterId else {return}
        switch cell.type {
        case .region:
            if isOn {
                viewModel?.addRegionFilterActive(key: code)
            }
            else {
                viewModel?.removeRegionFilterActive(key: code)
            }

        case .language:
            if isOn {
                viewModel?.addLanguageFilterActive(key: code)
            }
            else {
                viewModel?.removeLanguageFilterActive(key: code)
            }
        default:
            break
        }
        updateFilteringStatus()
    }
}



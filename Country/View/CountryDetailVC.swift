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
    
    var country :Country?
    var infos: [(label:String, data:CountryDataType)] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parseInfo()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(chooseFilter))
    }
    
    @objc func chooseFilter(){
        
    }
    
    func parseInfo(){
        infos.append((label:"name", data: CountryDataType.string(country?.name)))
        infos.append((label:"topLevelDomain", data: CountryDataType.string(country?.topLevelDomain?.joined(separator: ", "))))
        infos.append((label:"alpha2Code", data: CountryDataType.string(country?.alpha2Code)))
        infos.append((label:"alpha3Code", data: CountryDataType.string(country?.alpha3Code)))
        infos.append((label:"callingCodes", data: CountryDataType.string(country?.callingCodes?.joined(separator: ", "))))
        infos.append((label:"capital", data: CountryDataType.string(country?.capital)))
        infos.append((label:"altSpellings", data: CountryDataType.string(country?.altSpellings?.joined(separator: ", "))))
        infos.append((label:"region", data: CountryDataType.string(country?.region)))
        infos.append((label:"subregion", data: CountryDataType.string(country?.subregion)))
        infos.append((label:"population", data: CountryDataType.string("\(country?.population ?? 0)")))
        infos.append((label:"latlng", data: CountryDataType.string("\(country?.latlng?[0] ?? 0.0), \(country?.latlng?[1] ?? 0.0)" )))
        infos.append((label:"demonym", data: CountryDataType.string(country?.demonym)))
        infos.append((label:"area", data: CountryDataType.double((country?.area))))
        infos.append((label:"gini", data: CountryDataType.double(country?.gini)))
        infos.append((label:"timezones", data: CountryDataType.string(country?.timezones?.joined(separator: ", "))))
        infos.append((label:"borders", data: CountryDataType.string(country?.borders?.joined(separator: ", "))))
        infos.append((label:"nativeName", data: CountryDataType.string(country?.nativeName)))
        infos.append((label:"numericCode", data: CountryDataType.string(country?.numericCode)))
        infos.append((label:"currencies", data: CountryDataType.currencies(country?.currencies)))
        infos.append((label:"languages", data: CountryDataType.languages(country?.languages)))
        infos.append((label:"regionalBlocs", data: CountryDataType.regionalBlocs(country?.regionalBlocs)))
        infos.append((label:"cioc", data: CountryDataType.string(country?.cioc)))
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

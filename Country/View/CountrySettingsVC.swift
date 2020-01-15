//
//  CountrySettingsVC.swift
//  Country
//
//  Created by Federico Piccirilli on 20/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import UIKit

class CountrySettingsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter :CountryDetailPresenter!

    let settings = ["name","topLevelDomain","alpha2Code","alpha3Code","callingCodes","capital","altSpellings","region","subregion","population","latlng","demonym","area","gini","timezones","borders","nativeName","nativeName","currencies","languages","regionalBlocs","cioc"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

extension CountrySettingsVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTVC
        cell.delegate = self
        let data = settings[indexPath.row]
        cell.labelTitle?.text = data
        cell.filterId = data
        let on = !presenter.hiddenDetails.contains(data)
        cell.switchActive.isOn = on
        cell.switchActive.setOn(on, animated: false)
        return cell
    }
}

extension CountrySettingsVC : SettingCellDelegate {
    func settingCell(didSwitchFilter cell: SettingTVC, isOn: Bool) {
    guard let code = cell.filterId, let p = presenter else {return}
        if isOn{
            p.hiddenDetails.removeAll(where: {$0 == code})
        }
        else {
            if !p.hiddenDetails.contains(code){
                p.hiddenDetails.append(code)
            }
        }
    }
}

//
//  SettingTVC.swift
//  Country
//
//  Created by Federico Piccirilli on 20/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import UIKit

class SettingTVC: UITableViewCell {
    
    var delegate : SettingCellDelegate?
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var switchActive: UISwitch!
    
    var filterId :String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        if switchActive.isOn {
            delegate?.settingCell(didSwitchFilter:self, isOn: true)
        }
        else {
            delegate?.settingCell(didSwitchFilter:self, isOn: false)
        }
    }
    
}

protocol SettingCellDelegate {
    func settingCell(didSwitchFilter cell: SettingTVC ,isOn: Bool)
}

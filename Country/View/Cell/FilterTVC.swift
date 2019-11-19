//
//  FilterTVC.swift
//  Country
//
//  Created by Federico Piccirilli on 19/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import UIKit

enum FilterScope {
    case region, language
}

class FilterTVC: UITableViewCell {
    
    var delegate : FilterCellDelegate?
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var switchActive: UISwitch!
    
    var type :FilterScope?
    var filterId :String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        if switchActive.isOn {
            delegate?.filterCell(didSwitchFilter:self, isOn: true)
        }
        else {
            delegate?.filterCell(didSwitchFilter:self, isOn: false)
        }
    }
    
}

protocol FilterCellDelegate {
    func filterCell(didSwitchFilter cell: FilterTVC,isOn: Bool)
}

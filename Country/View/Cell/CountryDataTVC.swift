//
//  CountryDataTVC.swift
//  Country
//
//  Created by Federico Piccirilli on 19/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import UIKit

class CountryDataTVC: UITableViewCell {
    
    var delegate : FilterCellDelegate?
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(name : String, data: CountryDataType){
        labelName.text = name
        switch data {
            case .string(let stringValue):
                labelValue.text = stringValue
            case .currencies(let currValue):
                guard let currValues = currValue else {break}
                var currenciesString = ""
                for currency in currValues {
                    currenciesString.append("\(currency.name ?? "")(\(currency.symbol ?? "")),")
                }
                if currenciesString.count > 0 {currenciesString.removeLast()}
                labelValue.text = currenciesString
            case .languages(let langValue):
                guard let langValues = langValue else {break}
                var langString = ""
                for language in langValues {
                    langString.append("\(language.name ?? ""),")
                }
                if langString.count > 0 {langString.removeLast()}
                labelValue.text = langString
            case .regionalBlocs(let blocValue):
                guard let blocs = blocValue else {break}
                var blocsString = ""
                for bloc in blocs {
                    blocsString.append("\(bloc.name ?? ""),")
               }
                    if blocsString.count > 0 {blocsString.removeLast()}
               labelValue.text = blocsString
            case .double(let doubleVal):
                labelValue.text = "\(doubleVal ?? 0.0)"
        }
    }
}

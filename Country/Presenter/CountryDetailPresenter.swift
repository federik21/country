//
//  CountryDetailPresenter.swift
//  Country
//
//  Created by Federico Piccirilli on 15/01/2020.
//  Copyright © 2020 Federico Piccirilli. All rights reserved.
//
import Foundation
import SVGKit


class CountryDetailPresenter {
    
    var country: Country
    var hiddenDetails :[String] = []

    init(country :Country){
        self.country = country
    }
    
    func getFlag( handler: @escaping (UIImage) -> Void){
        guard let flagUrlString = country.flag else {return}
        guard let requestURL: URL = URL(string: flagUrlString) else {return}
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        let session :URLSessionProtocol = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) -> Void in
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    if (statusCode == 200), let dataResponse = data {
                        let anSVGImage: SVGKImage = SVGKImage(data: dataResponse)
                        let image = anSVGImage.uiImage
                        handler(image ?? UIImage())
            }
        })
        task.resume()
    }
    
    func parseInfo() ->  [(label:String, data:CountryDataType)]{
       var infos: [(label:String, data:CountryDataType)] = []
       infos.append((label:"name", data: CountryDataType.string(country.name)))
        infos.append((label:"topLevelDomain", data: CountryDataType.string(country.topLevelDomain?.joined(separator: ", "))))
        infos.append((label:"alpha2Code", data: CountryDataType.string(country.alpha2Code)))
        infos.append((label:"alpha3Code", data: CountryDataType.string(country.alpha3Code)))
        infos.append((label:"callingCodes", data: CountryDataType.string(country.callingCodes?.joined(separator: ", "))))
        infos.append((label:"capital", data: CountryDataType.string(country.capital)))
        infos.append((label:"altSpellings", data: CountryDataType.string(country.altSpellings?.joined(separator: ", "))))
        infos.append((label:"region", data: CountryDataType.string(country.region)))
        infos.append((label:"subregion", data: CountryDataType.string(country.subregion)))
        infos.append((label:"population", data: CountryDataType.string("\(country.population ?? 0)")))
       if country.latlng?.count ?? 0 > 0 {
                    infos.append((label:"latlng", data: CountryDataType.string("\(country.latlng?[0] ?? 0.0), \(country.latlng?[1] ?? 0.0)" )))
           }
        infos.append((label:"demonym", data: CountryDataType.string(country.demonym)))
        infos.append((label:"area", data: CountryDataType.double((country.area))))
        infos.append((label:"gini", data: CountryDataType.double(country.gini)))
        infos.append((label:"timezones", data: CountryDataType.string(country.timezones?.joined(separator: ", "))))
        infos.append((label:"borders", data: CountryDataType.string(country.borders?.joined(separator: ", "))))
        infos.append((label:"nativeName", data: CountryDataType.string(country.nativeName)))
        infos.append((label:"numericCode", data: CountryDataType.string(country.numericCode)))
        infos.append((label:"currencies", data: CountryDataType.currencies(country.currencies)))
        infos.append((label:"languages", data: CountryDataType.languages(country.languages)))
        infos.append((label:"regionalBlocs", data: CountryDataType.regionalBlocs(country.regionalBlocs)))
        infos.append((label:"cioc", data: CountryDataType.string(country.cioc)))
       
       for code in self.hiddenDetails {
           infos.removeAll(where: {$0.label == code})
       }
       
       return infos
    }
    
}

//
//  UserDataManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class UserDataManager: Manager {
    
    var main: TumDataManager?
    
    var handler: (([DataElement]) -> ())?
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        self.handler = handler
        if let user = main?.user?.name {
            main?.doPersonSearch(handler, query: user)
        } else {
            let url = getIdentityURL()
            Alamofire.request(.GET, url).responseString() { (response) in
                if let data = response.result.value {
                    let parsedXML = SWXMLHash.parse(data)
                    let rows = parsedXML["rowset"]["row"].all
                    if rows.count == 1 {
                        let person = rows[0]
                        if let firstname = person["vorname"].element?.text, lastname = person["familienname"].element?.text {
                            let name = firstname + " " + lastname
                            self.main?.doPersonSearch(handler, query: name)
                        }
                    }
                }
            }
        }
    }
    
    func getIdentityURL() -> String {
        let base = TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.Identity.rawValue
        if let token = main?.getToken() {
            return base + "?" + TUMOnlineWebServices.TokenParameter.rawValue + "=" + token + "&"
        }
        return ""
    }
    
    func getURL(id: String) -> String {
        let base = TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.PersonDetails.rawValue
        if let token = main?.getToken() {
            return base + "?" + TUMOnlineWebServices.TokenParameter.rawValue + "=" + token + "&" + TUMOnlineWebServices.IDParameter.rawValue + "=" + id
        }
        return ""
    }
}
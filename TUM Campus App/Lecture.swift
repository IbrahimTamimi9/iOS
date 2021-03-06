//
//  Lecture.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

import Sweeft
import SWXMLHash

final class Lecture: DataElement {
    
    let id: String
    let lectureID: String
    let module: String
    let name: String
    let semester: String
    let sws: Int
    let chair: String
    let contributors: String
    let type: String
    
    var detailsLoaded = false
    
    var details = [(String,String)]()
    
    init(id: String, lectureID: String, module: String, name: String,
         semester: String, sws: Int, chair: String, contributors: String, type: String) {
        self.id = id
        self.lectureID = lectureID
        self.module = module
        self.name = name
        self.semester = semester
        self.sws = sws
        self.chair = chair
        self.contributors = contributors
        self.type = type
        details.append(("Semester",semester))
        details.append(("Type",type))
        details.append(("Chair",chair))
        details.append(("Contributors",contributors))
    }
    
    func getCellIdentifier() -> String {
        return "lecture"
    }
    
    var text: String {
        return name
    }
    
}

extension Lecture: XMLDeserializable {
    
    convenience init?(from xml: XMLIndexer, api: TUMOnlineAPI, maxCache: CacheTime) {
        guard let name = xml["stp_sp_titel"].element?.text,
            let id = xml["stp_sp_nr"].element?.text,
            let swsString = xml["stp_sp_sst"].element?.text,
            let lectureID = xml["stp_lv_nr"].element?.text,
            let sws = Int(swsString),
            let semester = xml["semester_name"].element?.text,
            let chair = xml["org_name_betreut"].element?.text,
            let contributors = xml["vortragende_mitwirkende"].element?.text,
            let type = xml["stp_lv_art_name"].element?.text else {
            return nil
        }
        
        self.init(id: id,
                  lectureID: lectureID,
                  module: "", // TODO:
                  name: name,
                  semester: semester,
                  sws: sws,
                  chair: chair,
                  contributors: contributors,
                  type: type)
    }
    
}

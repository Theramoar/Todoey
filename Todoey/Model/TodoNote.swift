//
//  TodoNote.swift
//  Todoey
//
//  Created by Mihails Kuznecovs on 12/09/2018.
//  Copyright © 2018 Mihails Kuznecovs. All rights reserved.
//

import Foundation

// To conform the Encodable, Decodable the class must be contained ONLY of standard data types => Encodable, Decodable can be replaced with Codable
class TodoNote: Codable {
    
    var note: String = ""
    var checked: Bool = false
    
    
}

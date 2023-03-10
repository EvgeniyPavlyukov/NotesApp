//
//  Model.swift
//  Notes
//
//  Created by Eвгений Павлюков on 05.02.2023.
//

import Foundation

struct Model: Codable {
    var title: String
    var text: String
}

class Memory {
    static var indexCell = Int()
    static var detailedTitle = String()
    static var detailedText = String()
    static var dataTuplesArray = [Model]()
    static var notesTuplesArray = [(String, String)]()
}


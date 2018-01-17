//
//  Category.swift
//  Todoey
//
//  Created by Nam-Anh Vu on 1/16/18.
//  Copyright © 2018 TenTwelve. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

//
//  YSSQLiteDatabase.swift
//  PhoenixiOS
//
//  Created by phoenix on 2020/5/8.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SQLite

class YSSQLiteDatabase: NSObject {
    static let instance = YSSQLiteDatabase()

    let userTable = UsersTable()

    struct UsersTable {
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        let age = Expression<Int64>("age")
    }
}

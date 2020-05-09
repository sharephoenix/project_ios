//
//  YSSQLiteManager.swift
//  PhoenixiOS
//
//  Created by phoenix on 2020/5/8.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SQLite3
import SQLite

class YSSQLiteManager: NSObject {

    enum YSSQLiteError: Error {
        case onError(value: String)
    }

    static var instance = YSSQLiteManager()
    private override init() {}

    @discardableResult
    func createTable() throws -> Statement {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw YSSQLiteError.onError(value: "获取数据库路径失败")
        }
        let db = try Connection("\(documentUrl.absoluteString)/db.sqlite3")
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        let age = Expression<Int64>("age")

        let statement = try db.run(users.create(temporary: false, ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(age)
            t.column(email)
//            t.column(email, unique: true)
        })
        return statement
    }

    /// 返回 数据总条目数
    @discardableResult
    func insertData() throws -> Int64 {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw YSSQLiteError.onError(value: "获取数据库路径失败")
        }
        let db = try Connection("\(documentUrl.absoluteString)/db.sqlite3")
        let users = YSSQLiteDatabase.instance.userTable.users
        let name = YSSQLiteDatabase.instance.userTable.name
        let email = YSSQLiteDatabase.instance.userTable.email
        let age = Expression<Int64>("age")

        let insert = users.insert(name <- "Alice", email <- "alice@mac.com", age <- 22)
        let rowid = try db.run(insert)
        return rowid
    }

    /// 返回查询到的数据
    @discardableResult
    func selectData() throws -> [String] {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw YSSQLiteError.onError(value: "获取数据库路径失败")
        }
        let db = try Connection("\(documentUrl.absoluteString)/db.sqlite3")
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        let age = Expression<Int64>("age")

        let prepare = try db.prepare(users)
        var data: [String] = [String]()

        for user in prepare {
            data.append("id: \(user[id]), name: \(String(describing: user[name])), email: \(user[email]), age: \(user[age])")
        }
        return data
    }

    /// 更新总记录数
    @discardableResult
    func updateData() throws -> Int {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw YSSQLiteError.onError(value: "获取数据库路径失败")
        }
        let db = try Connection("\(documentUrl.absoluteString)/db.sqlite3")
        let users = Table("users")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        let alice = users.filter(email == "alice@mac.com")
        return try db.run(alice.update(email <- email.replace("me.com", with: "mac.com"), name <- "alex"))
    }

    /// 删除中记录数
    @discardableResult
    func deleteAllData() throws -> Int {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw YSSQLiteError.onError(value: "获取数据库路径失败")
        }
        let db = try Connection("\(documentUrl.absoluteString)/db.sqlite3")
        let users = Table("users")
        let name = Expression<String?>("name")
        let alice = users.filter(name == "alex")
        return try db.run(alice.delete())
    }

    /// 删除表格
    @discardableResult
    func dropUserTable() throws -> Int {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw YSSQLiteError.onError(value: "获取数据库路径失败")
        }
        let db = try Connection("\(documentUrl.absoluteString)/db.sqlite3")
        try db.execute("drop table users")
        return 0
    }
}

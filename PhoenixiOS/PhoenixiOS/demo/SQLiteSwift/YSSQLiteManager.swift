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
    static var instance = YSSQLiteManager()
    private override init() {}

    @discardableResult
    func createTable() throws -> Statement? {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let db = try Connection("\(documentUrl.absoluteString)/db.sqlite3")
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        let age = Expression<Int64>("age")
        db.rollbackHook {
            print("rollback")
        }

        try db.run(users.create { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(age)
            t.column(email, unique: true)
        })
//         CREATE TABLE "users" (
//             "id" INTEGER PRIMARY KEY NOT NULL,
//             "name" TEXT,
//             "email" TEXT NOT NULL UNIQUE
//         )

        // SELECT * FROM "users"

        let alice = users.filter(id == rowid)

        try db.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
        // WHERE ("id" = 1)

        try db.run(alice.delete())
//        // DELETE FROM "users" WHERE ("id" = 1)

        let b = try db.scalar(users.count) // 0
        print("\(b)")
        // SELECT count(*) FROM "users"
        return nil
    }

    func insertData() throws -> Statement? {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let db = try Connection("\(documentUrl.absoluteString)/db.sqlite3")
        let users = YSSQLiteDatabase.instance.userTable.users
        let id = YSSQLiteDatabase.instance.userTable.id
        let name = YSSQLiteDatabase.instance.userTable.name
        let email = YSSQLiteDatabase.instance.userTable.email

        let insert = users.insert(name <- "Alice", email <- "alice@mac.com")
        let rowid = try db.run(insert)
        // INSERT INTO "users" ("name", "email") VALUES ('Alice', 'alice@mac.com')
        let prepare = try db.prepare(users)
        for user in prepare {
            print("id: \(user[id]), name: \(String(describing: user[name])), email: \(user[email])")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
        return nil
    }

    func selectData(data: inout [String]) throws -> Statement? {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let db = try Connection("\(documentUrl.absoluteString)/db.sqlite3")
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")

        let prepare = try db.prepare(users)
        for user in prepare {
            data.append("id: \(user[id]), name: \(String(describing: user[name])), email: \(user[email])")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
        return nil
    }

    func updateData() throws -> Statement? {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let db = try Connection("\(documentUrl.absoluteString)/db.sqlite3")
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")


        let alice = users.filter(id == rowid)
        try db.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
        // WHERE ("id" = 1)
        return nil
    }
}

//
//  Todo.swift
//  ToDo-App
//
//  Created by Jadson on 22/04/22.
//

import Foundation

struct Todos: Codable {
    let items: Array<Todo>
}

struct Todo: Codable {
    let item: String
    let priority: Int
}

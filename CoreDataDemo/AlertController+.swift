//
//  AlertController+.swift
//  CoreDataDemo
//
//  Created by Asya Sher on 03.02.2023.
//

import Foundation

// there is enum about what mode can use alertController

enum Mode {
    case create, edit
    var title: String {
        switch self {
        case .create: return "Create New Task"
        case .edit: return "Edit Task"
        }
    }
    var placeholder: String {
        switch self {
        case .create: return "Enter new task"
        case .edit: return "Edit task"
        }
    }
    var actionTitle: String {
        switch self {
        case .create: return "Create"
        case .edit: return "Save"
        }
    }
}

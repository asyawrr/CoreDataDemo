//
//  AlertController.swift
//  CoreDataDemo
//
//  Created by Asya Sher on 30.01.2023.
//

import UIKit

extension UIAlertController {
    static func createAlertController(task: Task?, mode: Mode, completion: @escaping (Task) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: mode.title, message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
               textField.placeholder = mode.placeholder
            }
        
//        let action = UIAlertAction(title: mode.actionTitle, style: .default) { _ in
//            guard let nameToSave = alertController.textFields?.first?.text else {
//                completion(nil)
//                return
//            }
//            guard !nameToSave.isEmpty else { return }
//                completion(nameToSave)
//            }
//            alertController.addAction(action)
//
            return alertController
    }
    
    func action(task: Task?, mode: Mode?, completion: @escaping (String) -> Void) {

        let saveAction = UIAlertAction(title: mode?.actionTitle, style: .default) { nameToSave in
            guard let nameToSave = self.textFields?.first?.text else { return }
            guard !nameToSave.isEmpty else { return }
            completion(nameToSave)
        }
//
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        addAction(cancelAction)
        addAction(saveAction)
////
    }
    /// true working code
    
//    func setupAlertController(title: String, message: String, prefferedStyle: UIAlertController.Style) -> UIAlertController {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        return alertController
//    }
//
//    func action(task: Task?, completion: @escaping (String) -> Void) {
//
//        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] nameToSave in
//            guard let nameToSave = textFields?.first?.text else { return }
//            guard !nameToSave.isEmpty else { return }
//            completion(nameToSave)
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        addAction(cancelAction)
//        addAction(saveAction)
//        addTextField { (textField) in
//            textField.placeholder = "Enter item"
//        }
//    }
}
    
//    func action(for data: Task, completion: @escaping (String) -> Void) {
//        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
//            guard let nameToSave = self.textFields?.first?.text else { return }
//            guard !nameToSave.isEmpty else { return }
//            completion(nameToSave)
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
//
//        addAction(saveAction)
//        addAction(cancelAction)
//        addTextField { textField in
//        textField.placeholder = "New Task"
//    }
            
            
            //    func presentEditAlert(for data: [String], at indexPath: IndexPath, in tableView: UITableView, completion: @escaping (String?) -> Void) {
            //        var data = data
            //
            //        let alert = UIAlertController(title: "Edit item", message: nil, preferredStyle: .alert)
            //        alert.addTextField { textField in
            //            textField.text = data[indexPath.row]
            //        }
            //
            //        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            //            guard let newValue = alert.textFields?.first?.text else { return }
            //            data[indexPath.row] = newValue
            //            completion(newValue)
            //        }
            //
            //        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            //            data.remove(at: indexPath.row)
            //            completion(nil)
            //        }
            //        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            //
            //        alert.addAction(saveAction)
            //        alert.addAction(deleteAction)
            //        alert.addAction(cancelAction)
            //        present(alert, animated: true, completion: nil)
            //    }

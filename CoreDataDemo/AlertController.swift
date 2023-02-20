//
//  AlertController.swift
//  CoreDataDemo
//
//  Created by Asya Sher on 30.01.2023.
//

import UIKit

extension UIAlertController {
    static func createAlertController(task: Task?, mode: Mode) -> UIAlertController {
        let alertController = UIAlertController(title: mode.title, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = mode.placeholder
            textField.text = task?.name
        }
        return alertController
    }
    
    func action(task: Task?, mode: Mode, completion: @escaping (String) -> Void) {
        
        let saveAction = UIAlertAction(title: mode.actionTitle, style: .default) { nameToSave in
            guard let nameToSave = self.textFields?.first?.text else { return }
            guard !nameToSave.isEmpty else { return }
            completion(nameToSave)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        addAction(cancelAction)
        addAction(saveAction)
    }
    
}

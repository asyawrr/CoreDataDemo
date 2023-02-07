//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Asya Sher on 26.01.2023.
//

import Foundation
import CoreData


class StorageManager {
    static let shared = StorageManager()
    
    private var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext

    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task]? {
        var taskList = [Task]()
        
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return taskList
    }
        
    init() {
        viewContext = persistentContainer.viewContext
    }
    
    //MARK: - create, delete, edit
        
    func create (_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.name = taskName
        completion(task)
        saveContext()
    }
    
    func delete(task: Task) {
        if fetchData() != nil {
            viewContext.delete(task)
        }
        saveContext()
    }
    
    
    func edit(task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
}



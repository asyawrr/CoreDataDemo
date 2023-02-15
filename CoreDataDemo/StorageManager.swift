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
    
    private init() {
        viewContext = persistentContainer.viewContext
    }

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
    
    func fetchData(completion: @escaping ([Task]?) -> Void) {
        var taskList = [Task]()
        
        let fetchRequest = Task.fetchRequest()
        
        viewContext.perform { [unowned self] in
            do {
                taskList = try viewContext.fetch(fetchRequest)
                completion(taskList)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                completion(nil)
            }
        }
         
    }
    
    //MARK: - create, delete, edit
        
    func create (_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.name = taskName
        completion(task)
        saveContext()
    }
    
    func delete(task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    
    func edit(task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
}



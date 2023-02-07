//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by brubru on 29.09.2022.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
    var storage = StorageManager.shared
    // MARK: - private statements
    private let cellID = "task"
    private var taskList: [Task] = []

    // MARK: - overrides methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskList = storage.fetchData() ?? []
        tableView.reloadData()
    }

    // MARK: - setup view elements
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showAlert(mode: .create) { task in
            self.tableView.reloadData()
        }
    }
    
    private func save(_ taskName: String) {
        storage.create(taskName) { [unowned self] task in
            taskList.append(task)
            tableView.insertRows(at: [IndexPath(row: self.taskList.count - 1, section: 0)], with: .automatic)
        }
    }
    
}

// MARK: - UITabliViewDataSource methods
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        
        showAlert(task: task, mode: .edit) { task in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
//        showAlert(task: task) { task in
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
    }

// MARK: - editing elements methods
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storage.delete(task: task)
        }
    }
}

// MARK: - alert setup

extension TaskListViewController {
//    private func showAlert(task: Task? = nil, completion: ((Task) -> Void)? = nil) {
    func showAlert(task: Task? = nil, mode: Mode? = nil, completion: @escaping (Task) -> Void) {
        
        let alert = UIAlertController.createAlertController(task: task, mode: mode ?? .edit, completion: completion)
//        let alert = UIAlertController(title: mode.title, message: "What needed to-do?", preferredStyle: .alert)
        
        alert.action(task: task, mode: mode) { [ unowned self ] taskName in
            if let task = task {
                storage.edit(task: task, newName: taskName)
                completion(task)
            } else {
                self.save(taskName)
            }
        }
            
        present(alert, animated: true)
    }
//        var alertTitle: String
//
//        if task != nil {
//            alertTitle = "Edit Task"
//        } else {
//            alertTitle = "Create Task"
//        }
//        let alert = UIAlertController(title: alertTitle, message: "What needed to-do?", preferredStyle: .alert)
//
//        alert.action(task: task) { [unowned self] taskName in
//            if let task = task, let completion = completion {
//                storage.edit(task: task, newName: taskName)
//                completion(task)
//            } else {
//                self.save(taskName)
//            }
//        }
//        present(alert, animated: true)
//    }
}

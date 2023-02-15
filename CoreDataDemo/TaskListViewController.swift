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
        storage.fetchData(completion: { [weak self] tasks in
            guard let self = self else { return }
            
            if let tasks = tasks {
                self.taskList = tasks
                self.tableView.reloadData()
            } else  {
                print("Fetch error")
            }
        })
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        showAlert(mode: .create) { _ in
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
        tableView.deselectRow(at: indexPath, animated: true)
        let task = taskList[indexPath.row]
        
        showAlert(task: task, mode: .edit) { task in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

    }

// MARK: - editing elements methods
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
    func showAlert(task: Task? = nil, mode: Mode? = nil, completion: @escaping (Task) -> Void) {
        
        let alert = UIAlertController.createAlertController(task: task, mode: mode ?? .edit)
        
        alert.action(task: task, mode: mode) { [unowned self] taskName in
            if let task = task {
                storage.edit(task: task, newName: taskName)
                completion(task)
            } else {
                self.save(taskName)
            }
        }
            
        present(alert, animated: true)
    }
}

//
//  ViewController.swift
//  ios-core-data
//
//  Created by Erwindo Sianipar on 10/26/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var todo: [Todo]?
    private var nameTextField = UITextField()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var context: NSManagedObjectContext {
        get {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError()
            }
            return delegate.persistentContainer.viewContext
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupView()
    }
    
    private func setupView() {
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        readData()
        tableView.reloadData()
    }
    
    private func showSaveDataAlertForm() {
        let alert = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .default)
        let submitButton = UIAlertAction(title: "Submit", style: .default) { _ in
            self.saveData()
            self.readData()
            self.tableView.reloadData()
        }
        alert.addAction(submitButton)
        alert.addAction(cancelButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Insert What Todo"
            self.nameTextField = textField
        })
        
        self.present(alert, animated: true)
    }
    
    private func showUpdateDataAlertForm(todo: Todo) {
        let alert = UIAlertController(title: "Update Todo", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .default)
        let submitButton = UIAlertAction(title: "Submit", style: .default) { _ in
            todo.setValue(self.nameTextField.text, forKey: "name")
            self.readData()
            self.tableView.reloadData()
        }
        alert.addAction(submitButton)
        alert.addAction(cancelButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Insert What Todo"
            textField.text = todo.name
            self.nameTextField = textField
        })
        
        self.present(alert, animated: true)
    }
    
    private func showEditingOptionAlert(item: Int) {
        let alert = UIAlertController(title: "Edit Todo", message: nil, preferredStyle: .alert)
        let updateButton = UIAlertAction(title: "Update", style: .default) { _ in
            guard let todo = self.todo?[item] else {
                return
            }
            self.dismiss(animated: true, completion: {
                self.showUpdateDataAlertForm(todo: todo)
            })
        }
        alert.addAction(updateButton)
        self.present(alert, animated: true)
    }
    
    private func saveData() {
        do {
            let todo = Todo(context: context)
            todo.name = nameTextField.text?.capitalized
            try context.save()
        } catch (let error) {
            print(error)
        }
    }
    
    private func readData() {
        do {
            self.todo = try context.fetch(Todo.fetchRequest())
            self.tableView.reloadData()
        } catch (let error) {
            print(error)
        }
    }
    
    private func deleteData(item: Todo) {
        context.delete(item)
        do {
            try context.save()
        } catch (let error) {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            showSaveDataAlertForm()
        } else {
            showEditingOptionAlert(item: indexPath.row)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let todo = self.todo else {
            return section == 0 ? 1 : 0
        }
        return section == 0 ? 1 : todo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let todo = self.todo else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.textLabel?.text = indexPath.section == 0 ? "Add Todo" : todo[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
                guard let todo = self.todo else {
                    return
                }
                self.deleteData(item: todo[indexPath.row])
                self.readData()
                self.tableView.reloadData()
            }
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
            swipeActionConfig.performsFirstActionWithFullSwipe = true
            return swipeActionConfig
        }
        return .none
    }
}

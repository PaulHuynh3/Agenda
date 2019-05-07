//
//  TaskViewController.swift
//  Agenda
//
//  Created by Paul on 2019-05-04.
//  Copyright © 2019 PaulsWork. All rights reserved.
//

import UIKit
import CoreData
import AWSAppSync

class TaskViewController: UIViewController {

    @IBOutlet weak var addDataView: UIView! {
        didSet {
            addDataView.isHidden = true
        }
    }
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var desctiptionLabel: UILabel!
    @IBOutlet weak var choiceButton: UILabel!
    @IBOutlet weak var selectedTable: UITableView! {
        didSet {
            selectedTable.isHidden = true
        }
    }
    private var runType: RunType!
    private var coreDataManager = CoreDataManager()
    private let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
    private var tasks = [Task]()
    var appSyncClient: AWSAppSyncClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runType = RunType.viewTask
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        
        let resignKeyboardWithTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(resignKeyboardWithTapGesture)
        
//        let tasks = coreDataManager.fetchTasksBy(title: "First Task")
//        for task in tasks {
//          print(task)
//        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func persistTask() {
        let task = Task(entity: Task.entity(), insertInto: context)
        task.title = "Third Task"
        task.contentDescription = "This one has content"
        task.id = "Some ID"
        coreDataManager.saveContext()
        tasks.append(task)
    }
    
    private func showView() {
        choiceButton.isHidden = true
        selectedTable.isHidden = true
        addDataView.isHidden = false
        idLabel.isHidden = false
        nameLabel.isHidden = false
        desctiptionLabel.isHidden = false
        idTextField.isHidden = false
        idTextField.text = ""
        nameTextField.isHidden = false
        nameTextField.text = ""
        descriptionTextField.isHidden = false
        descriptionTextField.text = ""
    }
    
    @IBAction func viewTaskTapped(_ sender: UIButton) {
        addDataView.isHidden = true
        selectedTable.isHidden = false
        runType = RunType.viewTask
        selectData()
    }
    
    @IBAction func insertTapped(_ sender: UIButton) {
        showView()
        idTextField.isHidden = true
        idLabel.isHidden = true
        runType = RunType.insert
    }
    
    @IBAction func updateTapped(_ sender: UIButton) {
        showView()
        runType = RunType.update
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        showView()
        nameLabel.isHidden = true
        nameTextField.isHidden = true
        desctiptionLabel.isHidden = true
        descriptionTextField.isHidden = true
        runType = RunType.delete
    }
    
    @IBAction func runTapped(_ sender: Any) {
        switch runType {
        case .some(.viewTask):
            break
        case .some(.insert):
            if nameTextField.text!.count < 1 || descriptionTextField.text!.count < 1 {
                showAlert(title: "Error", messageString: "Please insert data")
            } else {
                insertData()
            }
        case .some(.update):
            if idTextField.text!.count < 1 || nameTextField.text!.count < 1 || descriptionTextField.text!.count < 1 {
                showAlert(title: "Error", messageString: "Please insert data")
            } else {
                updateData()
            }
        case .some(.delete):
            if idTextField.text!.count < 1{
                showAlert(title: "Error", messageString: "Please insert data")
            } else {
                deleteData()
            }
        case .none:
            break
        }
        idTextField.text = ""
        descriptionTextField.text = ""
        nameTextField.text = ""
    }
    
    func showAlert(title: String, messageString: String) {
        let alertController = UIAlertController(title: title, message: messageString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func selectData() {
        let selectQuery = ListTodosQuery()
        appSyncClient?.fetch(query: selectQuery, cachePolicy: .fetchIgnoringCacheData) {(result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            result?.data?.listTodos?.items?.forEach {
                let task = Task(context: self.context)
                task.title = $0?.name
                task.contentDescription = $0?.description
                self.tasks.append(task)
                self.selectedTable.reloadData()
            }
        }
    }
    
    //AWS API
    func insertData() {
        let insertQuery = CreateTodoInput(name: nameTextField.text!, description:descriptionTextField.text!)
        appSyncClient?.perform(mutation: CreateTodoMutation(input: insertQuery)) { (result, error) in
//            self.selectData()
            if let error = error as? AWSAppSyncClientError {
                print("Error occurred: \(error.localizedDescription )")
            } else if let resultError = result?.errors {
                print("Error saving the item on server: \(resultError)")
                return
            } else {
                self.showAlert(title: "Success", messageString: "Data Inserted")
            }
        }
    }
    
    func updateData() {
        var updateQuery = UpdateTodoInput(id: idTextField.text!)
        updateQuery.name = nameTextField.text!
        updateQuery.description = descriptionTextField.text!
        appSyncClient?.perform(mutation: UpdateTodoMutation(input: updateQuery)) { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                print("Error occurred: \(error.localizedDescription )")
            } else if let resultError = result?.errors {
                print("Error saving the item on server: \(resultError)")
                return
            } else {
                self.showAlert(title: "Success", messageString: "Data was updated in the server")
                print("Data Updated")
            }
        }
    }
    
    func deleteData() {
        let deleteQuery = DeleteTodoInput(id: idTextField.text!)
        appSyncClient?.perform(mutation: DeleteTodoMutation(input: deleteQuery)) { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                print("Error occurred: \(error.localizedDescription )")
            } else if let resultError = result?.errors {
                print("Error saving the item on server: \(resultError)")
                return
            } else {
                self.showAlert(title: "Success", messageString: "Data was deleted from the server")
                print("Data Deleted")
            }
        }
    }
}

extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") else {
            fatalError("Returned Cell failed to load the cellIdentifier was not found")
        }
        cell.textLabel?.text = tasks[indexPath.row].title
        cell.detailTextLabel?.text = tasks[indexPath.row].contentDescription
        cell.detailTextLabel?.isHidden = false
        return cell
    }
    
}

//
//  ViewController.swift
//  Agenda
//
//  Created by Paul on 2019-05-04.
//  Copyright © 2019 PaulsWork. All rights reserved.
//

import UIKit
import CoreData

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
    private var coreDataManager: CoreDataManager
    private let context: NSManagedObjectContext
    private var tasks: [Task]
    
    required init?(coder aDecoder: NSCoder) {
        coreDataManager = CoreDataManager()
        context = coreDataManager.persistentContainer.viewContext
        tasks = [Task]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runType = RunType.viewTask
        let tasks = coreDataManager.fetchTasksBy(title: "First Task")
        for task in tasks {
          print(task)
        }
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
//        selectData()
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
        case .viewTask?:
            print("selectData for now")//selectData()
        case .some(.insert):
            print("insert data")
        case .some(.update):
            print("update data")
        case .some(.delete):
            print("delete data")
        case .none:
            break
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

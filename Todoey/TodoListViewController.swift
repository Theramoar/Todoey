//
//  ViewController.swift
//  Todoey
//
//  Created by Mihails Kuznecovs on 09/09/2018.
//  Copyright © 2018 Mihails Kuznecovs. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Buy milk", "Kill Cow", "Eat Steak"]
    

    @IBOutlet var todoListTableView: UITableView!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
    
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Identifier of the storyboard identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //removes the grey "select" background
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var temporaryAddTextField = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action1) in
            // What will happen once the user clicks the Add Button on the alert
            self.itemArray.append(temporaryAddTextField.text!)
            
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { (alerttexField) in
            alerttexField.placeholder = "Create new item"
            temporaryAddTextField = alerttexField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
}



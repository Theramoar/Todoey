//
//  ViewController.swift
//  Todoey
//
//  Created by Mihails Kuznecovs on 09/09/2018.
//  Copyright © 2018 Mihails Kuznecovs. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [TodoNote]()
    
    let defaults = UserDefaults.standard
    

    @IBOutlet var todoListTableView: UITableView!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoListArray") as? [TodoNote]{ // for notes
            itemArray = items
       }
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Identifier of the storyboard identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.note
        
        // Use of Ternary operator. If the condition is not completed, do the second option // == true is not used as it is supposed to by the compiler
        cell.accessoryType = item.checked ? .checkmark : .none
                
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        tableView.reloadData()
        
        //removes the grey "select" background
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var temporaryAddTextField = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action1) in
            // What will happen once the user clicks the Add Button on the alert
            
            let newTodoNote = TodoNote()
            newTodoNote.note = temporaryAddTextField.text!
            self.itemArray.append(newTodoNote)
            // TODO - http://duc.ninja/2017/11/07/save-custom-object-into-userdefaults.html

            //adds the new array to the user defaults.
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
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



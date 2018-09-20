//
//  ViewController.swift
//  Todoey
//
//  Created by Mihails Kuznecovs on 09/09/2018.
//  Copyright © 2018 Mihails Kuznecovs. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [TodoNote]()
    var selectedCategory: Category? {
        // didSet wil trigger once the selectedCategory get set with a value
        didSet{
            loadItems()
        }
    }
    

    //Watch Udemy 251
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet var todoListTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // prints the path to the database
        
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        saveItems()
        
        //removes the grey "select" background
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var temporaryAddTextField = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action1) in
            // What will happen once the user clicks the Add Button on the alert
            
            let newTodoNote = TodoNote(context: self.context)
            newTodoNote.note = temporaryAddTextField.text!
            newTodoNote.checked = false
            newTodoNote.parentCategory = self.selectedCategory
            self.itemArray.append(newTodoNote)
           
            self.saveItems()
        }
        
        alert.addTextField { (alerttexField) in
            alerttexField.placeholder = "Create new item"
            temporaryAddTextField = alerttexField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItems() {
        do{
            try context.save()
        } catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<TodoNote> = TodoNote.fetchRequest(), predicate: NSPredicate? = nil) { //  = TodoNote.fetchRequest() the default value if nothing else is provided; "with" is the external parameter that is used when the method is called for the sake of comfortable reading
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let searchPredicate = predicate{
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
        }
        else{
          request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error loading context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<TodoNote> = TodoNote.fetchRequest()
        
        let predicate = NSPredicate(format: "note CONTAINS[cd] %@", searchBar.text!) //[cd] makes the query insensitive for case and diacritic
        
        request.sortDescriptors = [NSSortDescriptor(key: "note", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}



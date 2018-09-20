//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mihails Kuznecovs on 17/09/2018.
//  Copyright © 2018 Mihails Kuznecovs. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    // (UIApplication.shared.delegate as! AppDelegate) reference to the app delegate object that allow you to access any methods or variables added by your subclass of UIApplication
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "Add Category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action1) in
            //creates a new managedobject and appends the entered text to it
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            //append a new object to the array of items and then saves it to the DataBase
            self.categoryArray.append(newCategory)
                self.saveItems()
    
        }
        
        //adds the text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write here"
            textField = alertTextField
        }
        //adds action button to the allert
        alert.addAction(action)
        //draws the created alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categoryArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("Error saving context in Categories \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error loading context in Categories \(error)")
        }
        
    }
    
}

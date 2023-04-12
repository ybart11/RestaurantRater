//
//  MainViewController.swift
//  RestaurantRater
//
//  Created by Yovany Bartolome on 4/4/23.
//

import UIKit
import CoreData


class MainViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var txtRestaurantName: UITextField!
    @IBOutlet weak var txtRestaurantAddress: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    

    var currentRestaurant: Restaurant?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var entrees: [NSManagedObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        let textFields: [UITextField] = [txtRestaurantName, txtRestaurantAddress]
        
        for textfield in textFields {
            textfield.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingDidEnd)
            textfield.delegate = self
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveRestaurant))
        
        loadDataFromDatabase()
        
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if currentRestaurant == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentRestaurant = Restaurant(context: context)
        }

        currentRestaurant?.rname = txtRestaurantName.text
        currentRestaurant?.raddress = txtRestaurantAddress.text

        return true
    }
    
    @objc func saveRestaurant() {
        
        appDelegate.saveContext()
        
        let alert = UIAlertController(title: "Saved", message: "The restaurant has been saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Removes focus from the textfield when user hits return on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Add a prepare(for:sender:) method to pass the restaurant name to the RateDishViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RateDishSegue" {
            if let rateDishVC = segue.destination as? RateDishViewController {
                // Pass the restaurant name to the RateDishViewController
                rateDishVC.restaurantNameHolder = txtRestaurantName.text
            }
        }
        
        // For Table View
        if segue.identifier == "EditEntree" {
            let entreeController = segue.destination as? RateDishViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedEntree = entrees[selectedRow!] as? Entree
            entreeController?.currentEntree = selectedEntree!
            entreeController?.restaurantNameHolder = selectedEntree?.restaurant?.rname
        }
    }
    
    // MARK: Table View Data Source
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func loadDataFromDatabase() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Entree")

        do {
            entrees = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows you want to display in the table view
        return entrees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsCell", for: indexPath)

        // Configure the cell...
        let entree = entrees[indexPath.row] as? Entree
        cell.textLabel?.text = entree?.ename
        
        // Conditional Binding
        if let rating = entree?.erating {
            cell.detailTextLabel?.text = "Rating: " + String(describing: rating)
        } else {
            cell.detailTextLabel?.text = "No Rating"
        }
            
        // Optional Binding
        if let existingText = cell.detailTextLabel?.text {
            cell.detailTextLabel?.text = existingText + "         Type: " + (entree?.etype ?? "")
        } else {
            cell.detailTextLabel?.text = entree?.etype
        }
        
        // Compiler will infer that this is property of - - -
        cell.accessoryType = .detailDisclosureButton

        return cell
    }
    
}

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
    
    let restaurants = ["BT", "Chiptole", "Gustos", "Burger King"]

    
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
    }
    
    // MARK: Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows you want to display in the table view
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = restaurants[indexPath.row]
        return cell
    }
    
}

//
//  RateDishViewController.swift
//  RestaurantRater
//
//  Created by Yovany Bartolome on 4/4/23.
//

import UIKit
import CoreData


class RateDishViewController: UIViewController {
    
   
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var txtDishName: UITextField!
    @IBOutlet weak var txtDishType: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // Add a property to hold the restaurant name
    var restaurantNameHolder: String?
    
    var currentEntree: Entree? 
        
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if currentEntree != nil {
            txtDishName.text = currentEntree!.ename
            txtDishType.text = currentEntree!.etype
            segmentedControl.selectedSegmentIndex = Int(currentEntree!.erating) - 1
        }
        
        // Set the restaurant name label text to the restaurant name passed from MainViewController
        // Optional binding
        if let restaurantName = restaurantNameHolder {
            restaurantNameLabel.text = "Rate Dish for: " + restaurantName
        } else {
            restaurantNameLabel.text = ""
        }

        
        // Add a save button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEntree))
    }
    
//    @objc func saveEntree() {
//        let context = appDelegate.persistentContainer.viewContext
//
//        // Create a new instance of the Entree entity
//        let newEntree = Entree(entity: Entree.entity(), insertInto: context)
//
//        // Set the properties of the new Entree object
//        newEntree.ename = txtDishName.text
//        newEntree.etype = txtDishType.text
//        newEntree.erating = Int16(segmentedControl.selectedSegmentIndex + 1)
//
//        // Set the relationship between the new Dish object and the corresponding Restaurant object
//        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "rname == %@", restaurantNameHolder!)
//
//        do {
//            let restaurants = try context.fetch(fetchRequest)
//            if let restaurant = restaurants.first {
//                newEntree.restaurant = restaurant
//
//            }
//        } catch let error as NSError {
//            print("Could not fetch restaurants. \(error), \(error.userInfo)")
//        }
//
//        do {
//            try context.save()
//            print("Data saved successfully!")
//
//            // Create and show an alert controller to notify the user that the data was saved successfully
//            let alertController = UIAlertController(title: "Saved", message: "Your dish has been saved.", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertController, animated: true, completion: nil)
//
//        } catch let error as NSError {
//            print("Could not save data. \(error), \(error.userInfo)")
//
//            // Create and show an alert controller to notify the user that error occurred
//            let alertController = UIAlertController(title: "Error", message: "Something went wrong.", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
    
    @objc func saveEntree() {
        let context = appDelegate.persistentContainer.viewContext
        
        if let entree = currentEntree {
            
            // Update an existing Entree object
            entree.ename = txtDishName.text
            entree.etype = txtDishType.text
            entree.erating = Int16(segmentedControl.selectedSegmentIndex + 1)
        } else {
            
            // Create a new Entree object
            let newEntree = Entree(entity: Entree.entity(), insertInto: context)
            newEntree.ename = txtDishName.text
            newEntree.etype = txtDishType.text
            newEntree.erating = Int16(segmentedControl.selectedSegmentIndex + 1)
            
            // Set the relationship between the new Dish object and the corresponding Restaurant object
            let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "rname == %@", restaurantNameHolder!)
            
            do {
                let restaurants = try context.fetch(fetchRequest)
                if let restaurant = restaurants.first {
                    newEntree.restaurant = restaurant
            
                }
            } catch let error as NSError {
                print("Could not fetch restaurants. \(error), \(error.userInfo)")
            }
        }
        
        do {
            try context.save()
            print("Data saved successfully!")
            
            // Create and show an alert controller to notify the user that the data was saved successfully
            let alertController = UIAlertController(title: "Saved", message: "Your dish has been saved.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
                    
        } catch let error as NSError {
            print("Could not save data. \(error), \(error.userInfo)")
            
            // Create and show an alert controller to notify the user that error occurred
            let alertController = UIAlertController(title: "Error", message: "Something went wrong.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    
    // Removes focus from the textfield when user hits return on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

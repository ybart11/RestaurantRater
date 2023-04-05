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
        
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the restaurant name label text to the restaurant name passed from MainViewController
        restaurantNameLabel.text = "Rate Dish for: " + restaurantNameHolder!
        
        // Add a save button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEntree))
    }
    
    @objc func saveEntree() {
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a new instance of the Entree entity
        let newEntree = Entree(entity: Entree.entity(), insertInto: context)
            
        // Set the properties of the new Entree object
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
        
        do {
            try context.save()
            print("Data saved successfully!")
            
            // Create and show an alert controller to notify the user that the data was saved successfully
            let alertController = UIAlertController(title: "Saved", message: "Your dish has been saved.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
                    
        } catch let error as NSError {
            print("Could not save data. \(error), \(error.userInfo)")
        }
    }
    
    // Removes focus from the textfield when user hits return on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

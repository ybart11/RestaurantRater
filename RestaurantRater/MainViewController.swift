//
//  MainViewController.swift
//  RestaurantRater
//
//  Created by Yovany Bartolome on 4/4/23.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtRestaurantName: UITextField!
    @IBOutlet weak var txtRestaurantAddress: UITextField!
    
    var currentRestaurant: Restaurant?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
}

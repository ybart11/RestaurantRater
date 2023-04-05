//
//  RateDishViewController.swift
//  RestaurantRater
//
//  Created by Yovany Bartolome on 4/4/23.
//

import UIKit
import CoreData


protocol RateDishViewControllerDelegate: AnyObject {
    
}

class RateDishViewController: UIViewController {
    
   
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var txtDishName: UITextField!
    @IBOutlet weak var txtDishType: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var currentEntree: Entree?
    
    // Add a property to hold the restaurant name
    var restaurantNameHolder: String?
        
    weak var delegate: RateDishViewControllerDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the restaurant name label text to the restaurant name passed from MainViewController
        restaurantNameLabel.text = restaurantNameHolder
        
        // Add a save button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEntree))

        
    }
    
    @objc func saveEntree() {
        guard let restaurantName = restaurantNameHolder, !restaurantName.isEmpty else {
                return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            
            if currentEntree == nil {
                currentEntree = Entree(context: context)
            }
        
        currentEntree?.ename = txtDishName.text
        currentEntree?.etype = txtDishType.text
        currentEntree?.erating = Int16(segmentedControl.selectedSegmentIndex)

        appDelegate.saveContext()
    }
}

//
//  RateDishViewController.swift
//  RestaurantRater
//
//  Created by Yovany Bartolome on 4/4/23.
//

import UIKit


protocol RateDishViewControllerDelegate: AnyObject {
    func didSaveEntree()
}

class RateDishViewController: UIViewController {
    
    
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var txtDishName: UITextField!
    @IBOutlet weak var txtDishType: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // Add a property to hold the restaurant name
    var restaurantNameHolder: String?
        
    weak var delegate: RateDishViewControllerDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the restaurant name label text to the restaurant name passed from MainViewController
        restaurantName.text = restaurantNameHolder
        
        
    }

}

//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Chris Nady on 5/27/16.
//  Copyright © 2017 Nady Analytics LLC. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTableView: UITableView!
 
    let cellReuseIdentifier = "ExcerciseDescriptionViewCell"
    
    /*
         This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
         or constructed as part of adding a new meal.
     */
    
    var meal: Meal?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Table view setup
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        self.descriptionTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        descriptionTableView.rowHeight = UITableViewAutomaticDimension
        descriptionTableView.estimatedRowHeight = 65
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //Mark: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if meal?.details.count != nil {
            return self.meal!.details.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.descriptionTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        if meal?.details.count != nil {
        
            // set the text from the data model
            cell.textLabel?.text = meal?.details[indexPath.row]
            cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        } else {
            // Set placeholder text
            cell.textLabel?.text = "Placeholder for excercise description"
            meal?.details[indexPath.row] = (cell.textLabel?.text)!
            // Need to hide the add excercise description button at this stage, since the meal name needs to be added first.
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meal?.details.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            meal?.details.append((descriptionTableView.cellForRow(at: indexPath)!.textLabel?.text)!)
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addExcercise(_ sender: UIBarButtonItem) {
        
        if meal?.details != nil {
            meal?.details.append("Placeholder for excercise description")
            let indexPath = IndexPath(row: descriptionTableView.numberOfRows(inSection: 0), section: 0)
            descriptionTableView.insertRows(at: [indexPath], with: .fade)
        } else {
            print("Add and save workout name first")
        }
        
    }
    

    
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "showExcercise"?:
            
            var details = [String]()
            
            for x in 0..<descriptionTableView.numberOfRows(inSection: 0) {
                
                details.append((descriptionTableView.visibleCells[x].textLabel?.text)!)
                
            }
            
            let name = nameTextField.text ?? ""
            let rating = ratingControl.rating
            // Need to run a for loop to save the string in each table view cell.
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            meal = Meal(name: name, rating: rating, details: details)
            
            // To do: Add some code here to segue to the excercise description.
            
        
        default:
        
            // Configure the destination view controller only when the save button is pressed.
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
                return
            }
        
            var details = [String]()
        
            for x in 0..<descriptionTableView.numberOfRows(inSection: 0) {
            
                details.append((descriptionTableView.visibleCells[x].textLabel?.text)!)
            
            }
        
            let name = nameTextField.text ?? ""
            let rating = ratingControl.rating
            // Need to run a for loop to save the string in each table view cell.
        
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            meal = Meal(name: name, rating: rating, details: details)
        
        }
    }
    
    //MARK: Actions

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}


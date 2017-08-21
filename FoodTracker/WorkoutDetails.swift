//
//  WorkoutDetails.swift
//  FoodTracker
//
//  Created by Christopher Nady on 7/18/17.
//  Copyright © 2017 Nady Analytics LLC. All rights reserved.
//

import UIKit
import os.log

class WorkoutDetails: UITableView {
    
    //MARK: Properties
    
    var details = [Details]()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new workout.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            saveMeals()
        }
    }
    
    
    
    //MARK: Private Methods
    
    private func loadSampleMeals() {
        
        
        guard let meal1 = Meal(name: "Legs", rating: 5, details: "1. Machine Leg Press: 4 sets by 12 reps \n2. Machine Leg Curls: 4 sets by 12 reps \n3. Machine Calf Raises: 4 sets by 12 reps \n4. Machine Quad Extensions: 4 sets by 12 reps \n5. Machine Glute Kick Backs 4 sets by 12 reps") else {
            fatalError("Unable to instantiate workout1")
        }
        
        guard let meal2 = Meal(name: "Chest and Abs", rating: 5, details: "1. Plate Loaded Flat Press: 4 sets by 12 reps \n2. Plate Loaded Incline Press: 4 sets by 12 reps \n3. Machine Flys: 4 sets by 12 reps \n4. Machine Ab Curls: 4 sets by 12 reps \n5. Cable Crossover Rope Ab Curls: 4 sets by 12 reps") else {
            fatalError("Unable to instantiate workout1")
        }
        
        guard let meal3 = Meal(name: "Back and Calves", rating: 5, details: "1. Machine Lat Pull Downs: 4 sets by 12 reps \n2. Machine Rows: 4 sets by 12 reps \n3. Cable Crossover Pull Overs: 4 sets by 12 reps \n4. Machine Calf Raises: 4 sets by 12 reps") else {
            fatalError("Unable to instantiate workout1")
        }
        
        guard let meal4 = Meal(name: "Shoulders", rating: 5, details: "1. Plate Loaded Shoulder Press: 4 sets by 12 reps \n2. Machine Lateral Raises: 4 sets by 12 reps \n3. Machine Reverse Fly's: 4 sets by 12 reps \n4. Plate Loaded Shrugs: 4 sets by 12 reps") else {
            fatalError("Unable to instantiate workout1")
        }
        
        guard let meal5 = Meal(name: "Arms and Abs", rating: 5, details: "1. Cable Crossover Pushdowns: 4 sets by 12 reps \n2. Dumbell Curls: 4 sets by 12 reps \n3. Machine Close Grip Dips: 4 sets by 12 reps \n4. Machine Curls: 4 sets by 12 reps \n5. Machine Ab Curls: 4 sets by 12 reps \n6. Cable Crossver Rope Ab Curls: 4 sets by 12 reps") else {
            fatalError("Unable to instantiate workout1")
        }
        
        
        meals += [meal1, meal2, meal3, meal4, meal5]
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Workouts successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save workouts...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
}

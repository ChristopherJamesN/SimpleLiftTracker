//
//  Arms.swift
//  FoodTracker
//
//  Created by Christopher Nady on 7/19/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
class Arms: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Data model: These strings will be the data for the table view cells
    let excercises: [String] = ["Plate Loaded Leg Press: 4 sets of 12 reps each", "Machine Leg Curls: 4 sets of 12 reps each", "Plate Loaded Calf Raises: 4 sets of 12 reps each", "Machine Leg Press: 4 sets of 12 reps each", "Machine Glute Kick Backs: 4 sets of 12 reps each", "Machine Calf Raises: 4 sets of 12 reps each", "Machine Leg Extensions: 4 sets of 12 reps each"]
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    var tableView: UITableView = UITableView()
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.excercises.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.excercises[indexPath.row]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = CGRect(x: 40, y: 50, width: 320, height: 300)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.view.addSubview(tableView)
    }
    
}

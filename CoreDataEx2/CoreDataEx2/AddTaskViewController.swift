//
//  AddTaskViewController.swift
//  CoreDataEx2
//
//  Created by Omar Albeik on 12/10/15.
//  Copyright © 2015 Omar Albeik. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var task = ""
    var desc = ""
    var date = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTextField.text = task
        descriptionTextField.text = desc
        datePicker.date = date
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unresolved error \(error)")
            abort()
        }
        
        fetchedResultsController.delegate = self

    }
    
    // MARK: - Insert new object
    func insertNewObject(sender: AnyObject) {
        let task = Task(context: sharedContext)
        task.title = taskTextField.text!
        task.desc = descriptionTextField.text
        task.date = datePicker.date
        task.completed = false
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    // MARK: - Shared Context
    lazy var sharedContext: NSManagedObjectContext = {
        CoreDataStackManager.sharedInstance().managedObjectContext
        }()
    
    // MARK: - Fetched Results Controller
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Task")
        
        // Add a sort descriptor.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        // Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Return the fetched results controller. It will be the value of the lazy variable
        return fetchedResultsController
        } ()
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        insertNewObject(self)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

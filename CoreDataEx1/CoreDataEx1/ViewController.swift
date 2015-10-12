//
//  ViewController.swift
//  CoreDataEx1
//
//  Created by Omar Albeik on 11/10/15.
//  Copyright © 2015 Omar Albeik. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var names = [Student]()
    
    var sharedContext: NSManagedObjectContext {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let sharedContext = appDelegate.managedObjectContext
        return sharedContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set tableView delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        names = fetchAllStudents()
    }
    
    
    //MARK: tableView methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        let thisName: String = names[indexPath.row].name as String!
        cell.textLabel?.text = thisName
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let thisName = names[indexPath.row]
            names.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            sharedContext.deleteObject(thisName)
            
            do {
                try sharedContext.save()
            } catch {
                print("error saving data")
            }
            
        default:
            break
        }
    }
    
    
    func fetchAllStudents() -> [Student] {
        let fetchRequest = NSFetchRequest(entityName: "Student")
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Student]
        } catch {
            return [Student]()
        }
    }
    
    func saveAStudent(name: String) {
        let entity =  NSEntityDescription.entityForName("Student", inManagedObjectContext:sharedContext)
        let student = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: sharedContext) as! Student
        student.setValue(name, forKey: "name")
        
        do {
            try sharedContext.save()
            names.append(student)
        } catch {
            print("error adding name to sharedContext")
        }
        
        do {
            
        }
        
    }
    
    @IBAction func addBarButtonTapped(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler(nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .Default) { (action: UIAlertAction) -> Void in
            self.saveAStudent((alert.textFields?.first?.text)!)
            self.tableView.reloadData()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


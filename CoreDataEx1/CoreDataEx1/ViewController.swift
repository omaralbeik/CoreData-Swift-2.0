//
//  ViewController.swift
//  CoreDataEx1
//
//  Created by Omar Albeik on 12/10/15.
//  Copyright © 2015 Omar Albeik. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var people = [Person]()
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        people = fetchAllPeople()
        
    }
    
    //MARK: CoreData methods
    func fetchAllPeople() -> [Person] {
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Person]
        } catch {
            return [Person]()
        }
    }
    
    func saveAPerson(name: String) {
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: sharedContext)!
        let person = NSManagedObject(entity: entity, insertIntoManagedObjectContext: sharedContext) as! Person
        person.name = name
        
        do {
            try sharedContext.save()
            people.append(person)
        } catch {
            print("Error adding name to context")
        }
        
    }
    
    
    //MARK: tableView methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nameCell")!
        cell.textLabel?.text = people[indexPath.row].name!
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toPersonVCSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            
            let thisPerson = people[indexPath.row]
            people.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            sharedContext.deleteObject(thisPerson)
            
            do  {
                try sharedContext.save()
            } catch {
                print("Can't save the context after deleting")
            }
            
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPersonVCSegue" {
            let personVC = segue.destinationViewController as! PersonViewController
            let selectedPerson = tableView.indexPathForSelectedRow!.row
            personVC.name = people[selectedPerson].name!
        }
    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler(nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .Default) { (action: UIAlertAction) -> Void in
            if let name = alert.textFields?.first?.text {
                self.saveAPerson(name)
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
}


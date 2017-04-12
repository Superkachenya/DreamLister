//
//  MainVC.swift
//  DreamLister
//
//  Created by Danil on 28.02.17.
//  Copyright © 2017 VoitenkoDaniel. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController , UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attemptFetch(sortValue: segmentedControl.selectedSegmentIndex)
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 1
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editItem = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "toDetailsVC", sender: editItem)
        
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with:.fade)
            break
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! ItemCell
            configureCell(cell: cell, indexPath: indexPath!)
            break
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func configureCell(cell: ItemCell, indexPath:IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        cell.configureCell(item: item)
    }
    
    //MARK:IBActions
    @IBAction func actionTypeChanged(_ sender: UISegmentedControl) {
        attemptFetch(sortValue: sender.selectedSegmentIndex)
        tableView.reloadData()
    }
    
    //MARK: FRC
    func attemptFetch(sortValue: Int) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        var sortValueDescriptor: NSSortDescriptor?
        
        switch sortValue {
        case 0:
            sortValueDescriptor = NSSortDescriptor(key: "created", ascending: false)
            break
        case 1:
            sortValueDescriptor = NSSortDescriptor(key: "price", ascending: true)
            break
        case 2:
            sortValueDescriptor = NSSortDescriptor(key: "title", ascending: true)
            break
        case 3:
            sortValueDescriptor = NSSortDescriptor(key: "toType.type", ascending: true)
            break
        default:
            sortValueDescriptor = NSSortDescriptor(key: "created", ascending: false)
        }
        request.sortDescriptors = [sortValueDescriptor!]
        
        let resultFRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath:nil, cacheName: nil)
        resultFRC.delegate = self
        
        fetchedResultsController = resultFRC
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let detailsVC = segue.destination as! DetailsVC
            detailsVC.editItem = sender as? Item
            
        }
    }
}


//
//  CategoriesViewController.swift
//  Shop
//
//  Created by Dan Jiang on 2017/2/3.
//  Copyright © 2017年 Dan Thought Studio. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UITableViewController {

  fileprivate var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initFetchedResultsController()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Items" {
      if let cell = sender as? UITableViewCell,
      let indexPath = tableView.indexPath(for: cell),
      let sectionInfo = fetchedResultsController?.sections?[indexPath.section],
      let categories = sectionInfo.objects as? [NSManagedObject] {
        let category = categories[indexPath.row]
        let itemsViewController = segue.destination as! ItemsViewController
        itemsViewController.category = category
      }
    }
  }
  
  // MARK: - Private

  fileprivate func initFetchedResultsController() {
    fetchedResultsController = PersistenceController.sharedInstance.fetchedResultsController(enityName: "Category",
                                                                                             sortDescriptors: [NSSortDescriptor(key: "brand", ascending: false), NSSortDescriptor(key: "date", ascending: false)],
                                                                                             sectionNameKeyPath: "brand")
    fetchedResultsController?.delegate = self
    do {
      try fetchedResultsController!.performFetch()
      tableView.reloadData()
    } catch {
      print("!!! Error: perform fetch !!!\n\(error)\n")
    }
  }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CategoriesViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController?.sections?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sectionInfo = fetchedResultsController?.sections?[section] {
      return sectionInfo.numberOfObjects
    } else {
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let sectionInfo = fetchedResultsController?.sections?[section],
      let categories = sectionInfo.objects as? [NSManagedObject],
      let category = categories.first,
      let brand = category.value(forKey: "brand") as? Bool {
      return brand ? "Brands" : "Categories"
    } else {
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")!
    if let sectionInfo = fetchedResultsController?.sections?[indexPath.section], let categories = sectionInfo.objects as? [NSManagedObject] {
      let category = categories[indexPath.row]
      if let name = category.value(forKey: "name") as? String {
        cell.textLabel?.text = name
      }
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteRowAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
      if let sectionInfo = self.fetchedResultsController?.sections?[indexPath.section], let categories = sectionInfo.objects as? [NSManagedObject] {
        let category = categories[indexPath.row]
        PersistenceController.sharedInstance.deleteObject(object: category)
        PersistenceController.sharedInstance.save()
      }
    }
    return [deleteRowAction]
  }
  
}

// MARK: - NSFetchedResultsControllerDelegate

extension CategoriesViewController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    let indexSet = IndexSet(integer: sectionIndex)
    switch type {
    case .insert:
      tableView.insertSections(indexSet, with: .automatic)
    case .delete:
      tableView.deleteSections(indexSet, with: .automatic)
    default: break
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      if let newIndexPath = newIndexPath {
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      }
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    case .update:
      if let indexPath = indexPath {
        tableView.reloadRows(at: [indexPath], with: .automatic)
      }
    case .move:
      if let indexPath = indexPath, let newIndexPath = newIndexPath {
        tableView.moveRow(at: indexPath, to: newIndexPath)
      }
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
}

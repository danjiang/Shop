//
//  ItemsViewController.swift
//  Shop
//
//  Created by Dan Jiang on 2017/2/3.
//  Copyright © 2017年 Dan Thought Studio. All rights reserved.
//

import UIKit
import CoreData

class ItemsViewController: UITableViewController {

  var category: NSManagedObject!
  
  fileprivate var items: [NSManagedObject]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let name = category.value(forKey: "name") as? String {
      title = name
    }
    
    listItems()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "CreateItem" {
      let navigationController = segue.destination as! UINavigationController
      let createItemViewController = navigationController.topViewController as! CreateItemViewController
      createItemViewController.delegate = self
    }
  }
  
  // MARK: - Private
  
  fileprivate func listItems() {
    items = PersistenceController.sharedInstance.findObjects("Item", predicate: NSPredicate(format: "category = %@", category), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)])
    tableView.reloadData()
  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ItemsViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")!
    if let items = items {
      let item = items[indexPath.row]
      if let name = item.value(forKey: "name") as? String, let price = item.value(forKey: "price") as? Int {
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = "$ \(price)"
      }
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteRowAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
      if let items = self.items {
        let item = items[indexPath.row]
        PersistenceController.sharedInstance.deleteObject(object: item)
        PersistenceController.sharedInstance.save()
        self.listItems()
      }
    }
    return [deleteRowAction]
  }
  
}

extension ItemsViewController: CreateItemViewControllerDelegate {

  func didSave(on viewContoller: CreateItemViewController, with name: String, and price: Int) {
    let object = PersistenceController.sharedInstance.createObject("Item")
    object.setValue(category, forKey: "category")
    object.setValue(name, forKey: "name")
    object.setValue(price, forKey: "price")
    object.setValue(Date(), forKey: "date")
    PersistenceController.sharedInstance.save()
    self.listItems()
  }

}


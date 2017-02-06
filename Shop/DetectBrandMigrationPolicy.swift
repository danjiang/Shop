//
//  DetectBrandMigrationPolicy.swift
//  Shop
//
//  Created by Dan Jiang on 2017/2/3.
//  Copyright © 2017年 Dan Thought Studio. All rights reserved.
//

import CoreData

class DetectBrandMigrationPolicy: NSEntityMigrationPolicy {

  override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
    guard let name = sInstance.value(forKey: "name") as? String,
      let date = sInstance.value(forKey: "date") as? Date,
      let destinationEntityName = mapping.destinationEntityName else {
      return
    }
    let destinationContext = manager.destinationContext
    
    let dInstance = NSEntityDescription.insertNewObject(forEntityName: destinationEntityName, into: destinationContext)
    dInstance.setValue(name, forKey: "name")
    dInstance.setValue(date, forKey: "date")
    if ["Nike", "Adidas", "UA"].contains(name) {
      dInstance.setValue(true, forKey: "brand")
    } else {
      dInstance.setValue(false, forKey: "brand")
    }
    
    manager.associate(sourceInstance: sInstance, withDestinationInstance: dInstance, for: mapping)
  }

}

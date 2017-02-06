//
//  PersistenceController.swift
//  Shop
//
//  Created by Dan Jiang on 2017/2/3.
//  Copyright © 2017年 Dan Thought Studio. All rights reserved.
//

import Foundation
import CoreData

class PersistenceController {
  
  static let sharedInstance = PersistenceController()
  
  fileprivate let model = "Model"
  fileprivate let db = "db.sqlite"
  fileprivate var moc: NSManagedObjectContext
  
  fileprivate init() {
    // 找到通过 Xcode 创建的 Data Model 文件
    let modelURL = Bundle.main.url(forResource: model, withExtension: "momd")
    // 创建 NSManagedObjectModel
    let mom = NSManagedObjectModel(contentsOf: modelURL!)
    // 创建 NSPersistentStoreCoordinator
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom!)
    
    // 创建 NSManagedObjectContext，并指定是主线程类型
    moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    // NSManagedObjectContext 关联 NSPersistentStoreCoordinator
    moc.persistentStoreCoordinator = psc
    
    let fileManager = FileManager.default
    
    // 设置 NSPersistentStore 需要的一些参数
    var options = [String: Any]()
    options[NSMigratePersistentStoresAutomaticallyOption] = true
    options[NSInferMappingModelAutomaticallyOption] = true
    
    // 指定 SQLite 数据库文件存储位置
    let localStoreURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent(db)
    
    do {
      try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: localStoreURL, options: options)
    } catch {
      print("!!! Error: adding local persistent store to coordinator !!!\n\(error)\n")
    }
  }
  
  func fetchedResultsController(enityName: String, sortDescriptors: [NSSortDescriptor], sectionNameKeyPath: String?) -> NSFetchedResultsController<NSManagedObject> {
    let request = NSFetchRequest<NSManagedObject>(entityName: enityName)
    request.sortDescriptors = sortDescriptors
    return NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: sectionNameKeyPath, cacheName: "Master")
  }
  
  func findObjects(_ name: String, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [NSManagedObject]? {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
    request.predicate = predicate
    request.sortDescriptors = sortDescriptors
    do {
      return try moc.fetch(request) as? [NSManagedObject]
    } catch {
      print("!!! Error: Find \(name) !!!\n\(error)\n")
      return nil
    }
  }
  
  func findObject(_ objectId: NSManagedObjectID) -> NSManagedObject {
    return moc.object(with: objectId)
  }
  
  func createObject(_ name: String) -> NSManagedObject {
    return NSEntityDescription.insertNewObject(forEntityName: name, into: moc)
  }
  
  func deleteObject(object: NSManagedObject) {
    moc.delete(object)
  }
  
  func save() {
    do {
      try moc.save()
    } catch {
      print("!!! Error: save managed object in context !!!\n\(error)\n")
    }
  }
  
}

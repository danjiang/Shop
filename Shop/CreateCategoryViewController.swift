//
//  CreateCategoryViewController.swift
//  Shop
//
//  Created by Dan Jiang on 2017/2/3.
//  Copyright © 2017年 Dan Thought Studio. All rights reserved.
//

import UIKit

class CreateCategoryViewController: UIViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var brandSwitch: UISwitch!

  @IBAction func cancel(_ sender: UIBarButtonItem) {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
    
  @IBAction func save(_ sender: UIBarButtonItem) {
    presentingViewController?.dismiss(animated: true, completion: { 
      self.saveCategory()
    })
  }

  // MARK: - Private
  
  fileprivate func saveCategory() {
    let name = nameTextField.text!
    let object = PersistenceController.sharedInstance.createObject("Category")
    object.setValue(name, forKey: "name")
    object.setValue(false, forKey: "brand")
    object.setValue(Date(), forKey: "date")
    PersistenceController.sharedInstance.save()
  }

}

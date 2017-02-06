//
//  CreateItemViewController.swift
//  Shop
//
//  Created by Dan Jiang on 2017/2/3.
//  Copyright © 2017年 Dan Thought Studio. All rights reserved.
//

import UIKit
import CoreData

protocol CreateItemViewControllerDelegate {
  func didSave(on viewContoller: CreateItemViewController, with name: String, and price: Int)
}

class CreateItemViewController: UIViewController {

  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var priceStepper: UIStepper!
  @IBOutlet weak var priceLabel: UILabel!
  
  var delegate: CreateItemViewControllerDelegate?
  
  @IBAction func changePrice(_ sender: UIStepper) {
    let price = Int(priceStepper.value)
    priceLabel.text = "$ \(price)"
  }

  @IBAction func cancel(_ sender: UIBarButtonItem) {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func save(_ sender: UIBarButtonItem) {
    presentingViewController?.dismiss(animated: true, completion: {
      self.saveItem()
    })
  }
  
  // MARK: - Private
  
  fileprivate func saveItem() {
    let name = nameTextField.text!
    let price = Int(priceStepper.value)
    delegate?.didSave(on: self, with: name, and: price)
  }

}

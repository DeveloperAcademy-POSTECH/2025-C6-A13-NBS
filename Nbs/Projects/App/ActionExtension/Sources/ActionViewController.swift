//
//  ActionViewController.swift
//  ae
//
//  Created by 여성일 on 10/13/25.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presentSheet()
  }
}

// MARK: - Configuration Method
private extension ActionViewController {
  func configureViewController() {
    view.backgroundColor = .clear
  }
  
  func presentSheet() {
    print("present Sheet")
    let sheetViewController = UIViewController()
    sheetViewController.view.backgroundColor = .blue
    
    if let sheet = sheetViewController.sheetPresentationController {
      sheet.detents = [.medium(), .large()]
      sheet.prefersGrabberVisible = true
    }
    
    present(sheetViewController, animated: true, completion: nil)
  }
}



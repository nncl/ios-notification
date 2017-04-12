//
//  TaskViewController.swift
//  Reminder
//
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TaskViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var dpExpiration: UIDatePicker!
    
    // MARK: - Properties
    var task: Task!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if task != nil {
            tfName.text = task.name!
            dpExpiration.date = task.expiration as! Date
        }
    }

    // MARK: - IBActions
    @IBAction func addUpdateTask(_ sender: UIButton) {
        if task == nil {
            task = Task(context: context)
        }
        task.name = tfName.text
        task.expiration = dpExpiration.date as NSDate?
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Methods
}

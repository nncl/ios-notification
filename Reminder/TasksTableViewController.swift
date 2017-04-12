//
//  TasksTableViewController.swift
//  Reminder
//
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {
    
    // MARK: - Properties
    var dataSource: [Task] = []
    let dateformatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }()
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "edit" {
            let vc = segue.destination as! TaskViewController
            if sender is Task {
                vc.task = sender as! Task
            } else {
                vc.task = dataSource[tableView.indexPathForSelectedRow!.row]
            }
        }
    }

    // MARK: - Methods
    func loadTasks() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = dataSource[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = dateformatter.string(from: task.expiration as! Date)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = dataSource[indexPath.row]
            context.delete(task)
            do {
                try context.save()
                dataSource.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

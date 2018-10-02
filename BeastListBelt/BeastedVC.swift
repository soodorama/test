//
//  BeastedVC.swift
//  BeastListBelt
//
//  Created by Neil Sood on 9/21/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit
import CoreData

class BeastedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [Beast] = []
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchBeastedItems()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBeastedItems()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchBeastedItems() {
        let request: NSFetchRequest<Beast> = Beast.fetchRequest()
        
        let sortDate = NSSortDescriptor(key: "date", ascending: true)
        
        request.sortDescriptors = [sortDate]
        request.predicate = NSPredicate(format: "isBeasted = \(NSNumber(value:true))")
        
        do {
            tableData = try context.fetch(request)
        } catch {
            print("\(error)")
        }
        
    }

}

extension BeastedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeastedCell", for: indexPath)
        let beast = tableData[indexPath.row]
        cell.textLabel?.text = beast.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d"
        let date = dateFormatter.string(from: beast.date!)
        cell.detailTextLabel?.text = date
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, handler) in
            let beast = self.tableData[indexPath.row]
            self.context.delete(beast)
            
            do {
                try self.context.save()
            } catch {
                print("\(error)")
            }
            
            self.tableData.remove(at: indexPath.row)
            tableView.reloadData()
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}


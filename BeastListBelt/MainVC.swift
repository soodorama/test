//
//  MainVC.swift
//  BeastListBelt
//
//  Created by Neil Sood on 9/21/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [Beast] = []
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchToBeastItems()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchToBeastItems()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddEditSegue", sender: sender)
    }
    
    // prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEditSegue" {
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddEditVC
            dest.delegate = self
            
            if let indexPath = sender as? IndexPath {
                dest.indexPath = indexPath
                dest.textInField = tableData[indexPath.row].text!
            }
        }
    }
    
    
    func fetchToBeastItems() {
        let request: NSFetchRequest<Beast> = Beast.fetchRequest()
        
        
        // SORT BY DATE ON MAIN PAGE TOO??
        let sortDate = NSSortDescriptor(key: "date", ascending: true)
        
        request.sortDescriptors = [sortDate]
        request.predicate = NSPredicate(format: "isBeasted = \(NSNumber(value:false))")
        
        do {
            tableData = try context.fetch(request)
        } catch {
            print("\(error)")
        }
        
    }
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeastCell", for: indexPath) as! BeastCell
        let beast = tableData[indexPath.row]
        cell.beastLabel.text = beast.text
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AddEditSegue", sender: indexPath)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension MainVC: AddEditVCDelegate {
    func cancelPressed() {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }
    func savePressed(text: String, indexPath: IndexPath?) {
        if let indexPath = indexPath {
            
            
            // UPDATE DATE WHEN UPDATE BEASTITEM??
            
            print("update")
            let beast = tableData[indexPath.row]
            beast.date = Date()
            beast.text = text
            beast.isBeasted = false
        }
        else {
            print("add new")
            let beast = Beast(context: context)
            beast.isBeasted = false
            beast.date = Date()
            beast.text = text
            tableData.append(beast)
        }
        
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension MainVC: BeastCellDelegate {
    func beastPressed(sender: BeastCell) {
        print("in beastpressed delegate")
        let beast = tableData[(sender.indexPath?.row)!]
        if !beast.isBeasted {
            print("not beasted")
//            sender.beastButton.backgroundColor = .black
            beast.date = Date()
            beast.isBeasted = true
        }
        else {
            beast.isBeasted = false
//            sender.beastButton.backgroundColor = .orange
        }
        
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
        
        fetchToBeastItems()
        tableView.reloadData()
    }
}




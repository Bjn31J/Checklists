//
//  ViewController.swift
//  Checklists
//
//  Created by Benjamin Jaramillo on 16/03/23.
//

import UIKit

class ChecklistViewController: UITableViewController,
AddItemViewControllerDelegate{
    var checklist: Checklist!

    override func viewDidLoad() {
           super.viewDidLoad()
           navigationController?.navigationBar.prefersLargeTitles = true
           navigationItem.largeTitleDisplayMode = .never
           title = checklist.name
       }
    
    // Mark:- add item view controller delegates
    func itemDetailViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    func itemDetailViewController(
        _ controller: AddItemViewController,
        didFinishAdding item: ChecklistItem) {
            let newRowIndex = checklist.items.count
            checklist.items.append(item)
            
            let indexPath = IndexPath(row: newRowIndex, section: 0)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(
        _ controller: AddItemViewController,
        didFinishEditing item: ChecklistItem) {
            if let index = checklist.items.firstIndex(of: item){
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = tableView.cellForRow(at: indexPath){
                    configureText(for: cell, with: item)
                }
            }
        navigationController?.popViewController(animated: true)
            
    }
    //Mark:- navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //1
        if segue.identifier == "AddItem" {
            //2
            let controller = segue.destination as! AddItemViewController
            //3
            controller.delegate = self
        } else if segue.identifier == "EditItem"{
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    //Mark : - Table View Data Sourse
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return checklist.items.count
        
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell,with: item)
        return cell
    }
    
    // Mark: -Table view Delegate
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ){
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked{
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = " \(item.text)"
    }
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
        //1
            checklist.items.remove(at: indexPath.row)
        
        //2
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    
}

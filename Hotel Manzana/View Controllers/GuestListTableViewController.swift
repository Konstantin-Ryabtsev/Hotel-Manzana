//
//  GuestListTableViewController.swift
//  Hotel Manzana
//
//  Created by Konstantin Ryabtsev on 13.02.2022.
//

import UIKit

class GuestListTableViewController: UITableViewController {

    // MARK: - Properties
    let dataManager = DataManager()
    var guestList: [Registration]! {
        didSet {
            dataManager.saveGuestList(guestList)
        }
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        guestList = dataManager.loadGuestList() ?? Registration.loadDefaults()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EditSegue" else { return }
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        
        let guest = guestList[selectedPath.row]
        let destination = segue.destination as! AddRegistrationTableViewController
        destination.registration = guest
        destination.navigationItem.title = "Edit Registration"        
    }
    
}

// MARK: - UITableViewDataSource
extension GuestListTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guest = guestList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Guest", for: indexPath)
        
        cell.textLabel!.text = guest.fullName
        cell.detailTextLabel!.text = guest.registrationDesc
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedGuest = guestList.remove(at: sourceIndexPath.row)
        guestList.insert(movedGuest, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guestList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .none:
            break
        case .insert:
            break
        @unknown default:
            print(#line, #function, "Unknown case in file \(#file)")
            break
        }
    }
}

// MARK: - UITableViewDelegate
extension GuestListTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

// MARK: - Actions
extension GuestListTableViewController {
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveGuest" else { return }
        
        let source = segue.source as! AddRegistrationTableViewController
        let guest = source.registration
        
        if let selectedPath = tableView.indexPathForSelectedRow {
            // Edit cell
            guestList[selectedPath.row] = guest
            tableView.reloadRows(at: [selectedPath], with: .automatic)
        } else {
            // Add cell
            let indexPath = IndexPath(row: guestList.count, section: 0)
            guestList.append(guest)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}

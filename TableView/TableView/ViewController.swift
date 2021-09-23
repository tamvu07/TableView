//
//  ViewController.swift
//  TableView
//
//  Created by Vu Minh Tam on 8/6/21.
//

import UIKit

class User {
    let name: String
    var isFavorite: Bool
    var isMuted: Bool
    
    init(name: String, isFavorite: Bool, isMuted: Bool) {
        self.name = name
        self.isFavorite = isFavorite
        self.isMuted = isMuted
    }
}

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
 
    var users: [User] = [
        "Consumable",
        "Non-Consumable",
        "Auto-Renewing Subscriprion",
        "Non-Renewable Subscription",
        "Restore Purchases",
        "Bill Smith",
    ].compactMap({
        User(name: $0,
             isFavorite: false,
             isMuted: false)
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        IAPService.shared.getProducts()
    }


}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            IAPService.shared.purchase(product: .consumable)
        case 1:
            IAPService.shared.purchase(product: .nonConsumable)
        case 2:
            IAPService.shared.purchase(product: .autoRenewingSubscription)
        case 3:
            IAPService.shared.purchase(product: .nonRenewingSubscription)
        default:
            print("restore")
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(
            style: .destructive,
            title: "Delete")
            { _, indexPath in
                self.users.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        
        let user = users[indexPath.row]
        let favoriteActionTitle = user.isFavorite ? "Unfavorite" : "Favorite"
        let muteActionTitle = user.isMuted ? "Unmute" : "Mute"
        
        let favoriteAction = UITableViewRowAction(
            style: .normal,
            title: favoriteActionTitle)
            { _, indexPath in
            self.users[indexPath.row].isFavorite.toggle()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        
        let muteAction = UITableViewRowAction(
            style: .normal,
            title: muteActionTitle)
            { _, indexPath in
            self.users[indexPath.row].isMuted.toggle()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        
        favoriteAction.backgroundColor = .systemBlue
        muteAction.backgroundColor = .systemOrange
        
        return [deleteAction, favoriteAction, muteAction]
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].name
        if user.isFavorite {
            cell.backgroundColor = .systemBlue
        }
        else if user.isMuted {
            cell.backgroundColor = .systemOrange
        }
        else {
            cell.backgroundColor = nil
        }
        return cell
    }
}

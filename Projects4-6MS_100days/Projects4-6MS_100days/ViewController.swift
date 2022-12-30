//
//  ViewController.swift
//  Projects4-6MS_100days
//
//  Created by user226947 on 12/30/22.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        title = "Shopping List"
    }

    @objc func share() {
        let list = shoppingList.joined(separator: "\n")
        
        let avc = UIActivityViewController(activityItems: [list], applicationActivities: nil)
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true)
    }

    
    @objc func add() {
        let ac = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let addAction = UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else {
                return
            }
            
            self?.addIfNew(item: item)
            
        }
        ac.addAction(addAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }

    func addIfNew(item: String) {
    
        if shoppingList.first(where: { item.lowercased().contains($0) }) != nil {
        let ac = UIAlertController(title: "Error", message: "\"\(item)\" is already on the list", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

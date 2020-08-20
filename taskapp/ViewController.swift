//
//  ViewController.swift
//  taskapp
//
//  Created by FUSAMAMASAKI on 2020/08/03.
//  Copyright © 2020 FUSAMAMASAKI. All rights reserved.
//

import UIKit
import RealmSwift                        //追加(6.6)
import UserNotifications

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!

    let realm = try! Realm()//.objects(Task.self).filter("name BEGINSWITH '*categoly*'")       //追加(6.6)にobjectsとfilterを追加した！
    var taskArry = try! Realm().objects(Task.self).sorted(byKeyPath: "date",ascending: true) //追加(6.6)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchText.delegate = self
        searchText.placeholder = "Categoryを入力下さいよ！"
    }
    @IBOutlet weak var searchText: UISearchBar!  //ココから検索の為に追加
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let searchWord = searchBar.text {
            print(searchWord)
        }
    }                                            //ココまで検索の為に追加
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArry.count   //修正(6.7)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
                                // ここから追加(6.7)
        let task = taskArry[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
                                // ここまで追加(6.7)
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                                //ここから追加(7.4)
        if editingStyle ==  .delete{
            let task = self.taskArry[indexPath.row]
            
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            try! realm.write {
                self.realm.delete(task)
                tableView.deleteRows(at: [indexPath], with: .fade )
            }
            
            center.getPendingNotificationRequests {(requests:[UNNotificationRequest]) in
                for request in requests {
                    print("--------------")
                    print(request)
                    print("--------------")
                }
            }
        }                       //ここまで変更(7.4)
        
                                //ここからも追加
        try! realm.write {self.realm.delete(self.taskArry[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
                                //ここまでも追加
    }
                                //ここから更に追加(6.8)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "CellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArry[indexPath!.row]
        } else {
            let task = Task()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
                                //ここまで更に追加(6.8,6.9)
}


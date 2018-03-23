//
//  SearchFriendsViewController.swift
//  jzz
//
//  Created by wei lu on 15/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class SearchFriendsViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var contacts = [ContactsReview]()
    var filteredContacts = [ContactsReview]()
    let server = ServiceDataProcess()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.preparSearchbController()
        self.prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.filteredContacts.removeAll()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @objc fileprivate func preparSearchbController(){
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "UserName/Mobile Number"
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactsCell.self, forCellReuseIdentifier: "ContactsCell")
    }
    
    @objc fileprivate func prepareUI(){
        view.backgroundColor = globalStyle.backgroundColor
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath as IndexPath) as? ContactsCell else {
            return UITableViewCell()
        }
        let contacts: ContactsReview
        contacts = filteredContacts[indexPath.row]
        cell.cellTitle.text = contacts.FullName
        if let avatar = contacts.ProfilePhoto{
            if(avatar.isEmpty){
                cell.avatar.image = UIImage(named: "avatar")
            }else{
                let avatarUrl = GET_AVATAR + "/" + avatar
                self.server.retrieveCellImg(ImgURL: avatarUrl, image: cell.avatar, completion: {ret in
                    print(ret!)
                })
            }
            
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredContacts.count
        }
        return filteredContacts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFriend2", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showFriend2"){
            let path = tableView.indexPathForSelectedRow!
            let currentCell = self.tableView.cellForRow(at: path) as! ContactsCell
            
            if let controller = segue.destination as? ProfileViewController{
                controller.contacts =  self.filteredContacts[path.row]
                controller.avatar = currentCell.avatar.image
            }
        }
    }

    
    //MARK Search Controller
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        let user = UserDefaults.standard.object(forKey: "ActiveUser") as! String
        let phone = ""//UserDefaults.standard.object(forKey: "ActivePhone") as? String
        if(user == searchText || phone == searchText){
            server.serverError(.customeErrorMessage, ShowTargert: self,ErrorMessage:"You Cant not Add Yourself")
        }
        
        let request = httpData()
        request.data = ["FriendName":searchText]
        request.Httpmethod = .post
        self.pleaseWait()
        server.httpAct(requestUrl: SEARCH_CONTACT, Senddata: request, completion: {ret in
            var list = [ContactsReview]()
            let json = JSON(ret)
            
            self.clearAllNotice()
            
            if(json.array == nil){
                return
            }
            
            for value in json.array! {
                let new = ContactsReview(JSONData: value)
                list.append(new)
            }
            
            self.filteredContacts = list
            self.tableView.reloadData()
        })
        
        
    }
}

extension SearchFriendsViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.filteredContacts.removeAll()
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension SearchFriendsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController){
        //filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}



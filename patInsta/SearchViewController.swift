//
//  SearchViewController.swift
//  patInsta
//
//  Created by Reza Kashkoul on 23-Esfand-1400 .
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func searchBarAction(_ sender: Any) {
//        DispatchQueue.main.async { [self] in
//            if searchBar.text!.count >= 3 {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
//                    searchUser(userName: searchBar.text!)
//                }
//            }
//        }
    }
    
    let disposeBag = DisposeBag()
    var rows = PublishSubject<[UserElement]>()
    var users: [UserElement] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var selectedUsers : [UserElement]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLogin()
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
//        loadUsersData()
//        searchUser(userName: searchBar.text!)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        if let userList = userList {
            users = userList
        }
        title = "Search for users"
    }
    
    func showLogin() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        vc?.modalPresentationStyle = .fullScreen
        vc?.delegate = self
        present(vc!, animated: true, completion: nil)
    }
    
}


extension SearchViewController: LoginViewControllerDelegate {
    
    func setCookie(userCookie: String) {
        cookie = userCookie
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchUser(userName: searchBar.text!)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        searchBar.resignFirstResponder()
        return true
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.userNameLabel.text = userList?[indexPath.row].user.username
        
        
        let url = URL(string: userList?[indexPath.row].user.profilePicURL ?? "")
        do {
            
            DispatchQueue.global(qos: .background).async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.profileImage.image = UIImage(data: data!)
                }

            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        saveUsersData(userData: userList![indexPath.row])
        DispatchQueue.main.async {[self] in
            let vc = storyboard?.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
//            if selectedUsers != nil && selectedUsers!.contains(where: {$0.user.username == userList?[indexPath.row].user.username}) {
//            selectedUsers?.append((userList?[indexPath.row])!)
//            vc.selectedUsers = selectedUsers!
//
            
            
            guard let userData = userList?[indexPath.row] else { return }
//            }
//            selectedUsers?.append(userData)
            vc.selectedUser = userData
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController {
    
    func searchUser(userName: String) {
        
        let url = "https://www.instagram.com/web/search/topsearch/?context=blended&query=\(userName)&rank_token=0.08921901598003179&include_reel=true"
        let headers = [
            "Accept" : "*/*",
            "Accept-Language" : "en-US,en;q=0.9",
            "Accept-Encoding" : "gzip, deflate, br",
            "Host" : "www.instagram.com",
            "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Safari/605.1.15",
            "Connection" : " keep-alive",
            "Referer" : " https://www.instagram.com/",
            "Cookie" : cookie ,
            "X-ASBD-ID" : "198387",
            "X-Requested-With" : "XMLHttpRequest",
            "X-IG-App-ID" : "936619743392459",
            "X-IG-WWW-Claim" : "hmac.AR2YgqsTVBo4dOn5nhwrI9RM8-vz2c-0fgyMQe2oHZZ7ScCD"
        ]
        
        
        RxAlamofire.requestData(.get, url, headers: HTTPHeaders(headers))
            .subscribe(onNext: { [weak self] (response, json) in
                guard let self = self else { return }
                do {
                    let userData = try JSONDecoder().decode(UserQuery.self, from: json)
                    userList = userData.users
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("***** error in parse data")
                }
            }, onError: {(error) in
                print("***** error in OnError",error)
            }).disposed(by: disposeBag)
        
    }
}

extension SearchViewController {
    
//    func saveUsersData(userData: UserElement) {
//        do {
//            selectedUsers?.append(userData)
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(selectedUsers)
//            UserDefaults.standard.set(data, forKey: "userMemory")
//        } catch {
//            print("Unable to Encode userData (\(error.localizedDescription))")
//        }
//    }
//
//    func loadUsersData() {
//        if let data = UserDefaults.standard.data(forKey: "userMemory") {
//            do {
//                let decoder = JSONDecoder()
//                selectedUsers = try decoder.decode([UserElement].self, from: data)
//            } catch {
//                print("Unable to Decode userData (\(error))")
//            }
//        }
//    }
}

//    func loadData() {
//        searchBar
//            .rx.text
//            .orEmpty
//            .distinctUntilChanged()
//            .throttle(.seconds(2), scheduler: SerialDispatchQueueScheduler(qos: .background))
//            .subscribe(onNext: { text in
//                print(text)
//                self.searchViewModel.searchUser(userName: text)
//            })
//            .disposed(by: disposeBag)
//    }
//
//    func bindView() {
//
//        searchViewModel.tableRowsItem.bind(to: rows)
//            .disposed(by: disposeBag)
//
//        searchViewModel.tableRowsItem
//            .observe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
//            .bind(to: rows)
//            .disposed(by: disposeBag)
//        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
//
//        rows.bind(to: tableView.rx.items(cellIdentifier: "SearchTableViewCell", cellType: SearchTableViewCell.self)) {(row, item, cell) in
//            cell.userNameLabel.text = item.user.username
////            let url = URL(string: item.user.profilePicURL)
////            do {
////                DispatchQueue.main.async {
////                    let data = try? Data(contentsOf: url!)
////                    cell.profileImage.image = UIImage(data: data!)
////                }
////            }
//        }
//        .disposed(by: disposeBag)
//    }

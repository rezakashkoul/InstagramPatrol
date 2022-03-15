//
//  SearchViewController.swift
//  patInsta
//
//  Created by Reza Kashkoul on 23-Esfand-1400 .
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var rows = PublishSubject<[UserElement]>()
    let searchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLogin()
        title = "Search for users"
        tableView.keyboardDismissMode = .onDrag
        bindView()
        loadData()
    }
    
    func loadData() {
        searchBar
            .rx.text
            .orEmpty
            .distinctUntilChanged()
            .throttle(.seconds(2), scheduler: SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { text in
                print(text)
                self.searchViewModel.searchUser(userName: text)
            })
            .disposed(by: disposeBag)
    }
    
    func bindView() {
        
        searchViewModel.tableRowsItem.bind(to: rows)
            .disposed(by: disposeBag)
        
        searchViewModel.tableRowsItem
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
            .bind(to: rows)
            .disposed(by: disposeBag)
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        
        rows.bind(to: tableView.rx.items(cellIdentifier: "SearchTableViewCell", cellType: SearchTableViewCell.self)) {(row, item, cell) in
            cell.userNameLabel.text = item.user.username
//            let url = URL(string: item.user.profilePicURL)
//            do {
//                DispatchQueue.main.async {
//                    let data = try? Data(contentsOf: url!)
//                    cell.profileImage.image = UIImage(data: data!)
//                }
//            }
        }
        .disposed(by: disposeBag)
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
        searchBar.resignFirstResponder()
        return true
    }
    
    
}

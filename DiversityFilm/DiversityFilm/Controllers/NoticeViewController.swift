//
//  NoticeViewController.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/24.
//

import UIKit
import FirebaseFirestore

class NoticeViewController: UIViewController, UINavigationControllerDelegate {
    
    let noticeTableView = UITableView()
    let db = Firestore.firestore()
    var querySnapshot: QuerySnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        noticeTableView.dataSource = self
        noticeTableView.delegate = self
        noticeTableView.separatorStyle = .singleLine
        getNoticeData()
        
        navigationController?.delegate = self
        
        noticeTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(noticeTableView)
        NSLayoutConstraint.activate([
            noticeTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            noticeTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            noticeTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            noticeTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        noticeTableView.register(NoticeCell.self, forCellReuseIdentifier: "noticeCell")
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear // 내비게이션 바 밑줄 없애기
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black  // 색상 변경
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
}


extension NoticeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let noticeDetailViewController = NoticeDetailViewController()
        if let document = querySnapshot?.documents[indexPath.row] {
            noticeDetailViewController.noticeTitle = document.data()["title"] as? String
            noticeDetailViewController.noticeSubtitle = document.documentID
            noticeDetailViewController.noticeContent = document.data()["contents"] as? String
        }
        navigationController?.pushViewController(noticeDetailViewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return querySnapshot?.documents.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath) as! NoticeCell
        if let document = querySnapshot?.documents[indexPath.row] {
            // Document에서 필요한 데이터를 가져와서 Cell에 설정
            cell.titleLabel.text = document.data()["title"] as? String
            cell.subTitleLabel.text = document.documentID
        }
        return cell
    }
    
}


extension NoticeViewController {
    func getNoticeData() {
        let collectionRef = db.collection("Notice")
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.querySnapshot = querySnapshot
//                for document in self.querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
                self.noticeTableView.reloadData()
            }
        }
    }
}

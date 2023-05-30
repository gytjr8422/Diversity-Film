//
//  SearchViewController.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/27.
//

import UIKit
import FirebaseFirestore

final class SearchViewController: UIViewController, UIGestureRecognizerDelegate {

    let textField = UITextField()
    let searchImageView = UIImageView()
    let searchStackView = UIStackView()
    let containerView = UIView()
    let resultTableVeiw = UITableView()
    
    let db = Firestore.firestore()
    
    let loadImageManager = LoadImageManager()
    var searchDataArray = [Any]()
    var allFilms: AllFilms?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        self.resultTableVeiw.dataSource = self
        self.textField.delegate = self
        
        self.resultTableVeiw.register(SearchResultCell.self, forCellReuseIdentifier: "searchResultCell")
        setupViews()
    }
    
    // 테이블뷰 터치했을 때 키보드 닫기 위해서
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        self.searchImageView.image = searchImage
    }

    // textField에서 Return 키를 눌렀을 때 키보드를 닫기 위해 사용
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.endEditing(true)
        guard let text = textField.text, !text.isEmpty else {
            let alert = UIAlertController(title: "알림", message: "검색어를 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        let searchFilmName = self.textField.text
        self.searchFilms(searchFilmName: searchFilmName)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.searchImageView.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        return true
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let searchDetailViewController
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchDataArray.count > 0 {
            return self.searchDataArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultCell
        cell.filmImageView.image = nil
        cell.filmNameLabel.text = "일치하는 영화가 없습니다."
        
        if self.searchDataArray.count > 0 {
            self.allFilms = self.searchDataArray[indexPath.row] as? AllFilms
            
            if let movieNm = allFilms?.movieNm,
               let url = allFilms?.imgURL {
                cell.filmNameLabel.text = movieNm
                
                loadImageManager.loadImage(url: url) { image in
                    DispatchQueue.main.async {
                        // 셀이 재사용 되기 전에 이미지를 업데이트
                        // 두번째 셀로 돌아갔을 때 네번째 셀 데이터가 들어가있는 문제 해결
                        if image == nil {
                            cell.filmImageView.image = UIImage(systemName: "x.circle")
                        } else {
                            cell.filmImageView.image = image
                        }
                    }
                }
            }
        } else {
            cell.filmImageView.image = nil
            cell.filmNameLabel.text = "일치하는 영화가 없습니다."
        }
        return cell
    }
}


extension SearchViewController {
    func searchFilms(searchFilmName: String?) {
        self.searchDataArray = []
        let collectionRef = self.db.collection("AllFilms")
        if let searchFilmName = searchFilmName {
            let query = collectionRef.whereField("movieNm", isEqualTo: searchFilmName)
            
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    let decoder = JSONDecoder()
                    print(querySnapshot!.documents.count)
                    for document in querySnapshot!.documents {
                        do {
                            let data = document.data()
                            let jsonData = try JSONSerialization.data(withJSONObject: data)
                            let result = try decoder.decode(AllFilms.self, from: jsonData)
                            self.searchDataArray.append(result)
                        } catch let err {
                            print("err: \(err)")
                        }
                    }
                    self.resultTableVeiw.reloadData()
                }
            }
        }
        
    }
}


//MARK: - 뷰 오토레이아웃
extension SearchViewController {
    private func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear // 내비게이션 바 밑줄 없애기
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance

        self.searchImageView.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        self.textField.clearButtonMode = .always
        self.textField.placeholder = "정확한 영화 제목을 입력해주세요."

        self.searchStackView.translatesAutoresizingMaskIntoConstraints = false
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.searchImageView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.resultTableVeiw.translatesAutoresizingMaskIntoConstraints = false
        
        self.searchStackView.addArrangedSubview(self.searchImageView)
        self.searchStackView.addArrangedSubview(self.textField)
        
        self.searchStackView.axis = .horizontal
        self.searchStackView.spacing = 10
        
        self.containerView.backgroundColor = .systemGray6
        self.containerView.layer.cornerRadius = 5
        
        self.containerView.addSubview(self.searchStackView)
        self.view.addSubview(self.containerView)
        self.view.addSubview(self.resultTableVeiw)
        
        NSLayoutConstraint.activate([
            
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            self.searchImageView.widthAnchor.constraint(equalToConstant: 30),
            self.searchImageView.heightAnchor.constraint(equalToConstant: 30),
            self.searchStackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10),
            self.searchStackView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10),
            self.searchStackView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10),
            self.searchStackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10),
            
            self.resultTableVeiw.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.resultTableVeiw.topAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.resultTableVeiw.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.resultTableVeiw.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
}


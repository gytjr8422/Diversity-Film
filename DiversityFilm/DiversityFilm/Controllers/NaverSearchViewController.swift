//
//  SearchViewController.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/25.
//

import UIKit

class NaverSearchViewController: UIViewController, UIGestureRecognizerDelegate {

    let textField = UITextField()
    let searchImageView = UIImageView()
    let searchStackView = UIStackView()
    let containerView = UIView()
    let resultTableVeiw = UITableView()
    
    var searchData: NaverData?
    
    private let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String
    private let clientSecret = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        self.resultTableVeiw.dataSource = self
        self.textField.delegate = self
        
        setupViews()
    }
    
    // 테이블뷰 터치했을 때 키보드 닫기 위해서
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension NaverSearchViewController: UITextFieldDelegate {
    
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
        let filmName = self.textField.text
        self.getNaverData(filmName: filmName)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.searchImageView.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        return true
    }
}

extension NaverSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchData = searchData {
            return searchData.items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension NaverSearchViewController {
    
    func getNaverData(filmName: String?) {
        guard let filmName = filmName else { return }
        let naverURL = "https://openapi.naver.com/v1/search/movie?display=30&query="
        let urlWithPercentEscapes = "\(naverURL)\(filmName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        guard let url = URL(string: urlWithPercentEscapes) else { return }
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)

        guard let clientID = clientID else { return }
        guard let clientSecret = clientSecret else { return }
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                if let naver = self.parseNaverJSON(data) {
                    print(naver)
                    self.searchData = naver
                } else {
                    let error = NSError(domain: "Parsing error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON data"])
                    print(error)
                }
                self.resultTableVeiw.reloadData()
            } else {
                let error = NSError(domain: "Data error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve data"])
                print(error)
            }
        }
        task.resume()
    }

    func parseNaverJSON(_ naverData: Data) -> NaverData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NaverData.self, from: naverData)
            return decodedData
        } catch {
            return nil
        }
    }
}

//MARK: - 뷰 오토레이아웃
extension NaverSearchViewController {
    
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
        self.textField.placeholder = "영화 제목을 입력해주세요."

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

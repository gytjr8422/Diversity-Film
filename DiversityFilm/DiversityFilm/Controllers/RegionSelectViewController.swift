//
//  RegionSelectViewController.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/21.
//

import UIKit

class RegionSelectViewController: UIViewController {
    
    let regionTableView = UITableView()
    var currentTheaterDict: Dictionary<String, Array<String>>?
    var comingTheaterDict: Dictionary<String, Array<String>>?
    var selectedIndex: Int?
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        regionTableView.register(RegionSelectCell.self, forCellReuseIdentifier: "regionSelectCell")
        
        regionTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(regionTableView)
        NSLayoutConstraint.activate([
            regionTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            regionTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            regionTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            regionTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        regionTableView.dataSource = self
        
        navigationItem.title = "지역 선택"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.systemPink, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        let cancelButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.leftBarButtonItem = cancelButtonItem
    }
}

extension RegionSelectViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedIndex = selectedIndex else { return 0 }
    
        if selectedIndex == 0 {
            guard let currentTheaterDict = currentTheaterDict else { return 0 }
            return currentTheaterDict.count + 1
        } else {
            guard let comingTheaterDict = comingTheaterDict else { return 0 }
            return comingTheaterDict.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "regionSelectCell", for: indexPath) as! RegionSelectCell

        guard let selectedIndex = selectedIndex else { return UITableViewCell() }
        if indexPath.row == 0 {
            cell.regionLabel.text = "전체"
        } else {
            if selectedIndex == 0 {
                guard let currentTheaterDict = currentTheaterDict else { return UITableViewCell() }
                let regions = currentTheaterDict.keys.sorted()
                cell.regionLabel.text = regions[indexPath.row - 1]
            } else {
                guard let comingTheaterDict = comingTheaterDict else { return UITableViewCell() }
                let regions = comingTheaterDict.keys.sorted()
                cell.regionLabel.text = regions[indexPath.row - 1]
            }
        }
        return cell
    }

}

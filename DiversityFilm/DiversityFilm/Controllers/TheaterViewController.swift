//
//  TheaterViewController.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/19.
//

import UIKit

final class TheaterViewController: UIViewController {
    
    private let theaterTableView = UITableView()
    private lazy var containerView = UIView()
    private lazy var segmentedController = UISegmentedControl()
    private lazy var underLineVeiw = UIView()
    private lazy var leadingDistance: NSLayoutConstraint = {
        return underLineVeiw.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor)
    }()
    var boxOfficeData: BoxOfficeModel?
    var filmIndexRow = 0 // mainViewController에서 넘어오는 indexPath.row
    
    @objc func changedLinePosition() {
        theaterTableView.reloadData()
        let segmentIndex = CGFloat(segmentedController.selectedSegmentIndex)
        let segmentWidth = segmentedController.frame.width / CGFloat(segmentedController.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.leadingDistance.constant = leadingDistance
            self?.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "상영 영화관 현황"
        view.backgroundColor = .white
        setupSegmentedController()
        
        theaterTableView.dataSource = self
        
        theaterTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(theaterTableView)
        NSLayoutConstraint.activate([
            theaterTableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            theaterTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            theaterTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            theaterTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
}

extension TheaterViewController {
    
    private func setupSegmentedController() {
        
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedController.selectedSegmentTintColor = .clear
        segmentedController.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedController.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedController.insertSegment(withTitle: "현재 상영관", at: 0, animated: true)
        segmentedController.insertSegment(withTitle: "상영 예정관", at: 1, animated: true)
        
        //
        segmentedController.selectedSegmentIndex = 0
        
        // 선택 안 됐을 때 폰트
        segmentedController.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ],for: .normal)
        
        // 선택됐을 때
        segmentedController.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemPink,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ], for: .selected)
        
        segmentedController.addTarget(self, action: #selector(changedLinePosition), for: .valueChanged)
        
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        
        underLineVeiw.backgroundColor = .systemPink
        underLineVeiw.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        containerView.addSubview(segmentedController)
        containerView.addSubview(underLineVeiw)
        
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 40),
            
            segmentedController.topAnchor.constraint(equalTo: containerView.topAnchor),
            segmentedController.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            segmentedController.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            segmentedController.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            underLineVeiw.bottomAnchor.constraint(equalTo: segmentedController.bottomAnchor),
            underLineVeiw.heightAnchor.constraint(equalToConstant: 2),
            leadingDistance,
            underLineVeiw.widthAnchor.constraint(equalTo: segmentedController.widthAnchor, multiplier: 1 / CGFloat(segmentedController.numberOfSegments))
        ])
    }
}

extension TheaterViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            guard let currentTheaterCount = boxOfficeData?.boxOfficeResult[filmIndexRow].current_theater.count else {
                return 1
            }
//            let cellCount = Int(ceil(Double(currentTheaterCount) / 3))
//            return cellCount
            return currentTheaterCount
            
        case 1:
            guard let comingTheaterCount = boxOfficeData?.boxOfficeResult[filmIndexRow].coming_theater.count else {
                return 1
            }
//            let cellCount = Int(ceil(Double(comingTheaterCount) / 3))
//            return cellCount
            return comingTheaterCount
        
        default:
            guard let currentTheaterCount = boxOfficeData?.boxOfficeResult[filmIndexRow].current_theater.count else {
                return 1
            }
//            let cellCount = Int(ceil(Double(currentTheaterCount) / 3))
//            return cellCount
            return currentTheaterCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            let cell = UITableViewCell()
            return cell
            
        case 1:
            let cell = UITableViewCell()
            return cell
        
        default:
            let cell = UITableViewCell()
            return cell
        }
    }


}

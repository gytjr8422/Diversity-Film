//
//  TheaterViewController.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/19.
//

import UIKit

final class TheaterViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    private let theaterTableView = UITableView()
    private lazy var containerView = UIView()
    private lazy var segmentedController = UISegmentedControl()
    private lazy var underLineVeiw = UIView()
    private lazy var regionSelectView = UIView()
    private lazy var regionSelectButton = UIButton()
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
    
    @objc func buttonTapped() {
        let regionSelectViewController = RegionSelectViewController()
        let navigationController = UINavigationController(rootViewController: regionSelectViewController)
        
        navigationController.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if let sheet = navigationController.sheetPresentationController {
                
                //지원할 크기 지정
                sheet.detents = [.medium(), .large()]
                //크기 변하는거 감지
                sheet.delegate = self
                
                //시트 상단에 그래버 표시 (기본 값은 false)
                sheet.prefersGrabberVisible = true
                
                //처음 크기 지정 (기본 값은 가장 작은 크기)
                //sheet.selectedDetentIdentifier = .large
                
                //뒤 배경 흐리게 제거 (기본 값은 모든 크기에서 배경 흐리게 됨)
                //sheet.largestUndimmedDetentIdentifier = .medium
            }
        }
        present(navigationController, animated: true)
        regionSelectViewController.selectedIndex = segmentedController.selectedSegmentIndex
        if segmentedController.selectedSegmentIndex == 0 {
            regionSelectViewController.currentTheaterDict = boxOfficeData?.boxOfficeResult[filmIndexRow].current_theater
        } else {
            regionSelectViewController.comingTheaterDict = boxOfficeData?.boxOfficeResult[filmIndexRow].coming_theater
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "상영 영화관 현황"
        view.backgroundColor = .white
        setupSegmentedController()
        
        theaterTableView.dataSource = self
        theaterTableView.delegate = self
        regionSelectButton.translatesAutoresizingMaskIntoConstraints = false
        regionSelectButton.setTitle("  지역별 보기", for: .normal)
        regionSelectButton.setImage(UIImage(named: "burger-menu-2"), for: .normal)
        regionSelectButton.setTitleColor(.gray, for: .normal)
        regionSelectButton.imageView?.contentMode = .scaleAspectFit
        regionSelectButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        regionSelectButton.contentHorizontalAlignment = .center
        regionSelectButton.semanticContentAttribute = .forceLeftToRight
        regionSelectButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        regionSelectButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        regionSelectButton.contentHorizontalAlignment = .right
        regionSelectView.addSubview(regionSelectButton)
        
        regionSelectView.backgroundColor = UIColor(rgb: 0xFCF6F5)
        // view에 추가해서 containerView, theaterTableView랑 계층 맞추기
        view.addSubview(regionSelectView)
        regionSelectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            regionSelectButton.topAnchor.constraint(equalTo: regionSelectView.topAnchor, constant: 2),
            regionSelectButton.leadingAnchor.constraint(equalTo: regionSelectView.leadingAnchor, constant: 200),
            regionSelectButton.trailingAnchor.constraint(equalTo: regionSelectView.trailingAnchor, constant: -25),
            regionSelectButton.bottomAnchor.constraint(equalTo: regionSelectView.bottomAnchor, constant: -2),
            
            regionSelectView.heightAnchor.constraint(equalToConstant: 40),
            regionSelectView.topAnchor.constraint(equalTo: underLineVeiw.bottomAnchor),
            regionSelectView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            regionSelectView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        theaterTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(theaterTableView)
        NSLayoutConstraint.activate([
            theaterTableView.topAnchor.constraint(equalTo: regionSelectView.bottomAnchor),
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


extension TheaterViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedController.selectedSegmentIndex == 1 {
            guard let comingTheaterCount = boxOfficeData?.boxOfficeResult[filmIndexRow].coming_theater.count else {
                return 1
            }
//            let cellCount = Int(ceil(Double(comingTheaterCount) / 3))
//            return cellCount
            return comingTheaterCount
        } else {
            guard let currentTheaterCount = boxOfficeData?.boxOfficeResult[filmIndexRow].current_theater.count else {
                return 1
            }
//            let cellCount = Int(ceil(Double(currentTheaterCount) / 3))
//            return cellCount
            return currentTheaterCount
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedController.selectedSegmentIndex == 1 {
            let cell = UITableViewCell()
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }


}

//MARK: - Segmented Controller Auto Layout
extension TheaterViewController {
    
    private func setupSegmentedController() {
        
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedController.selectedSegmentTintColor = .clear
        segmentedController.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedController.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedController.insertSegment(withTitle: "현재 상영관", at: 0, animated: true)
        segmentedController.insertSegment(withTitle: "상영 예정관", at: 1, animated: true)
        
        segmentedController.selectedSegmentIndex = 0
        
        // 선택 안 됐을 때 폰트
        segmentedController.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ],for: .normal)
        
        // 선택됐을 때
        segmentedController.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x7b9acc),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ], for: .selected)
        
        segmentedController.addTarget(self, action: #selector(changedLinePosition), for: .valueChanged)
        
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        
        underLineVeiw.backgroundColor = UIColor(rgb: 0x7b9acc)
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
            
            underLineVeiw.topAnchor.constraint(equalTo: segmentedController.bottomAnchor),
            underLineVeiw.heightAnchor.constraint(equalToConstant: 2),
            leadingDistance,
            underLineVeiw.widthAnchor.constraint(equalTo: segmentedController.widthAnchor, multiplier: 1 / CGFloat(segmentedController.numberOfSegments))
        ])
    }
}

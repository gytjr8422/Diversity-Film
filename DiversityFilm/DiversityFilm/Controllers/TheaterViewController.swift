//
//  TheaterViewController.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/19.
//

import UIKit

// 데이터가 필요한 곳에서 프로토콜 선언
protocol RegionSelectViewControllerDelegate {
    func dismissRegionSelectViewController(selected: String, selectedCellIndex: Int, segmentSelectedIndex: Int?)
}

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
    
    var currentSelectedRegion = "전체"
    var comingSelectedRegion = "전체"
    var currentSelectedCellIndex = 0
    var comingSelectedCellIndex = 0
    
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
    
    // 지역 선택 모달 띄우기
    @objc func buttonTapped() {
        let regionSelectViewController = RegionSelectViewController()
        let navigationController = UINavigationController(rootViewController: regionSelectViewController)
        regionSelectViewController.delegate = self // 데이터 전달 델리게이트
        
        navigationController.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if let sheet = navigationController.sheetPresentationController {
                
                //지원할 크기 지정
                sheet.detents = [.medium(), .large()]
                //크기 변화 감지
                sheet.delegate = self
                //시트 상단에 그래버 표시 (기본 값은 false)
//                sheet.prefersGrabberVisible = true
                
                //처음 크기 지정 (기본 값은 가장 작은 크기)
                //sheet.selectedDetentIdentifier = .large
                
                //뒤 배경 흐리게 제거 (기본 값은 모든 크기에서 배경 흐리게 됨)
                //sheet.largestUndimmedDetentIdentifier = .medium
            }
        }
        
        present(navigationController, animated: true)
        
        regionSelectViewController.segmentSelectedIndex = segmentedController.selectedSegmentIndex

        regionSelectViewController.currentSelectedCellIndex = currentSelectedCellIndex
        regionSelectViewController.comingSelectedCellIndex = comingSelectedCellIndex
        
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
        
        theaterTableView.register(TheaterViewCell.self, forCellReuseIdentifier: "theaterViewCell")
        theaterTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        theaterTableView.dataSource = self
        theaterTableView.delegate = self
        theaterTableView.allowsSelection = false
        theaterTableView.separatorStyle = .none
        
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
        if segmentedController.selectedSegmentIndex == 1 {
            if comingSelectedRegion == "전체" {
                if let comingTheaterCount = boxOfficeData?.boxOfficeResult[filmIndexRow].coming_theater.count {
                    if comingTheaterCount == 0 {
                        return 1
                    }
                    return comingTheaterCount
                }
            }
        } else {
            if currentSelectedRegion == "전체" {
                if let currentTheaterCount = boxOfficeData?.boxOfficeResult[filmIndexRow].current_theater.count {
                    if currentTheaterCount == 0 {
                        return 1
                    }
                    return currentTheaterCount
                }
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if segmentedController.selectedSegmentIndex == 1 {
            if let comingTheater = boxOfficeData?.boxOfficeResult[filmIndexRow].coming_theater {
                if comingTheater.count == 0 {
                    header?.textLabel?.text = "상영 예정 영화관이 존재하지 않습니다."
                } else {
                    if comingSelectedRegion == "전체" {
                        let regions = comingTheater.keys.sorted()
                        header?.textLabel?.text = regions[section]
                    } else {
                        header?.textLabel?.text = comingSelectedRegion
                    }
                }
            }
        } else {
            if let currentTheater = boxOfficeData?.boxOfficeResult[filmIndexRow].current_theater {
                if currentTheater.count == 0 {
                    header?.textLabel?.text = "현재 상영 영화관이 존재하지 않습니다."
                } else {
                    if currentSelectedRegion == "전체" {
                        let regions = currentTheater.keys.sorted()
                        header?.textLabel?.text = regions[section]
                    } else {
                        header?.textLabel?.text = currentSelectedRegion
                    }
                }
            }
//            if currentSelectedRegion == "전체" {
//                if let currentTheater = boxOfficeData?.boxOfficeResult[filmIndexRow].current_theater {
//                    let regions = currentTheater.keys.sorted()
//                    header?.textLabel?.text = regions[section]
//                }
//            } else {
//                header?.textLabel?.text = currentSelectedRegion
//            }
        }
        
        header?.textLabel?.font = UIFont(name: "Pretendard-Medium", size: 15)

        return header
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedController.selectedSegmentIndex == 1 {
            guard let comingTheater = boxOfficeData?.boxOfficeResult[filmIndexRow].coming_theater else { return 1 }
            // 상영 예정 영화관 없으면 없다고 표시할 셀 1개만 표시
            if comingTheater.count == 0 {
                return 0
            } else {
                
                if comingSelectedRegion == "전체" {
                    let regions = comingTheater.keys.sorted()
                    guard let comingTheaterSections = comingTheater[regions[section]] else { return 1 }
                    return comingTheaterSections.count
                } else {
                    guard let comingSelectedRegionValues = comingTheater[comingSelectedRegion] else { return 1 }
                    return comingSelectedRegionValues.count
                }
            }
        } else {
            guard let currentTheater = boxOfficeData?.boxOfficeResult[filmIndexRow].current_theater else { return 1 }
            if currentTheater.count == 0 {
                return 0
            } else {
                
                if currentSelectedRegion == "전체" {
                    let regions = currentTheater.keys.sorted()
                    guard let currentTheaterSections = currentTheater[regions[section]] else { return 1 }
                    return currentTheaterSections.count
                } else {
                    guard let currentSelectedRegionValues = currentTheater[currentSelectedRegion] else { return 1 }
                    return currentSelectedRegionValues.count
                }
            }
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "theaterViewCell", for: indexPath) as! TheaterViewCell
        if segmentedController.selectedSegmentIndex == 1 {
            if comingSelectedRegion == "전체" {
                if let comingTheater = boxOfficeData?.boxOfficeResult[filmIndexRow].coming_theater {
                    if comingTheater.count == 0 {
                        return cell
                    }
                    let regions = comingTheater.keys.sorted()
                    guard let theater = comingTheater[regions[indexPath.section]] else { return UITableViewCell() }
                    cell.theaterLabel.text = theater[indexPath.row]
                    return cell
                }
            } else {
                guard let comingTheaterRegionList = boxOfficeData?.boxOfficeResult[filmIndexRow].coming_theater[comingSelectedRegion] else { return UITableViewCell() }
                cell.theaterLabel.text = comingTheaterRegionList[indexPath.row]
                return cell
            }
        } else {
            if currentSelectedRegion == "전체" {
                if let currentTheater = boxOfficeData?.boxOfficeResult[filmIndexRow].current_theater {
                    if currentTheater.count == 0 {
                        return cell
                    }
                    let regions = currentTheater.keys.sorted()
                    guard let theater = currentTheater[regions[indexPath.section]] else { return UITableViewCell() }
                    cell.theaterLabel.text = theater[indexPath.row]
                    return cell
                }
            } else {
                guard let currentTheaterRegionList = boxOfficeData?.boxOfficeResult[filmIndexRow].current_theater[currentSelectedRegion] else { return UITableViewCell() }
                cell.theaterLabel.text = currentTheaterRegionList[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

//MARK: - 지역 선택 모달 뷰 데이터 전달 delegate
extension TheaterViewController: RegionSelectViewControllerDelegate {
    func dismissRegionSelectViewController(selected: String, selectedCellIndex: Int, segmentSelectedIndex: Int?) {
        if segmentSelectedIndex == 0 {
            self.currentSelectedRegion = selected
            self.currentSelectedCellIndex = selectedCellIndex
        } else {
            self.comingSelectedRegion = selected
            self.comingSelectedCellIndex = selectedCellIndex
        }
        theaterTableView.reloadData()
        print("이전 뷰: \(currentSelectedRegion), \(comingSelectedRegion), \(self.currentSelectedCellIndex), \(self.comingSelectedCellIndex)")
    }
}

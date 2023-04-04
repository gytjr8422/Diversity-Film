//
//  ViewController.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/07.
//

import UIKit
import FirebaseFirestore

final class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var filmCollectionView: UICollectionView!
    
    let loadImageManager = LoadImageManager()
    let setupCellsManager = SetupCellsManager()
    
    let db = Firestore.firestore()
    var boxOfficeData: BoxOfficeModel?
    var dateTitle = ""
    
    let layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "박스오피스 순위"
        
        navigationController?.delegate = self
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: filmCollectionView.frame.width, height: filmCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        filmCollectionView.collectionViewLayout = layout
        filmCollectionView.showsHorizontalScrollIndicator = false
        filmCollectionView.isPagingEnabled = true
        
        filmCollectionView.dataSource = self
        filmCollectionView.delegate = self

        filmCollectionView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellWithReuseIdentifier: K.cellNibIdentifier)
        
        loadBoxOffice(time: self.compareTime())
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.detailSegue, let nextVC = segue.destination as? DetailViewController, let indexPath = filmCollectionView.indexPathsForSelectedItems?.first {
            let selectedCell = filmCollectionView.cellForItem(at: indexPath) as! FilmCell
            nextVC.filmTitle = selectedCell.filmNameLabel.text
            nextVC.boxOfficeData = boxOfficeData
            nextVC.filmIndexRow = indexPath.row
            nextVC.filmImage = selectedCell.filmImageView.image
            nextVC.backgroundColor = selectedCell.labelView.backgroundColor
            nextVC.imageViewTextColor = selectedCell.filmNameLabel.textColor
        }
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // segue 설정
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.detailSegue, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let boxOfficeData = self.boxOfficeData else { return 0 }
        print(boxOfficeData.boxOfficeResult.count)
        return boxOfficeData.boxOfficeResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellNibIdentifier, for: indexPath) as! FilmCell
        // 셀이 재사용되기 때문에 전의 데이터가 보이지 않도록 하기 위한 초기화
        cell.filmNameLabel.text = ""
        cell.filmNameLabel.font = UIFont.boldSystemFont(ofSize: 21)
        cell.filmImageView.image = nil
        cell.setupActivityIndicator() // activityIndicator 추가
        cell.rankLabel.text = ""
        cell.newImageView.image = nil
        cell.noImageLabel.text = ""
        
//        cell.filmImageView.layer.shadowOffset = CGSizeMake(0, 0)
//        cell.filmImageView.layer.shadowColor = UIColor.black.cgColor
//        cell.filmImageView.layer.shadowOpacity = 0.23
//
//        cell.labelView.layer.shadowOffset = CGSizeMake(0, 0)
//        cell.labelView.layer.shadowColor = UIColor.black.cgColor
//        cell.labelView.layer.shadowOpacity = 0.23
        
        if let movieNm = self.boxOfficeData?.boxOfficeResult[indexPath.row].movieNm,
           let url = self.boxOfficeData?.boxOfficeResult[indexPath.row].imgURL,
           let rank = self.boxOfficeData?.boxOfficeResult[indexPath.row].rank,
           let oldAndNew = self.boxOfficeData?.boxOfficeResult[indexPath.row].rankOldAndNew {
            cell.rankLabel.text = rank
            
            cell.filmNameLabel.text = movieNm
            if let customFont = UIFont(name: "Pretendard-Medium", size: 20) {
                cell.filmNameLabel.font = customFont
            }
            
            if movieNm.count > 20 {
                if let customFont = UIFont(name: "Pretendard-Medium", size: 16) {
                    cell.filmNameLabel.font = customFont
                }
            }
            
            if url == "https://kobis.or.kr/kobis/business/mast/mvie/findDiverMovList.do#" {
                setupNoImageCell(cell: cell)
                if oldAndNew == "NEW" {
                    cell.setupNewImage(cellWidth: cell.frame.size.width)
                }
            } else {
                loadImageManager.loadImage(url: url) { image in
                    DispatchQueue.main.async {
                        // 셀이 재사용 되기 전에 이미지를 업데이트
                        // 두번째 셀로 돌아갔을 때 네번째 셀 데이터가 들어가있는 문제 해결
                        if let cell = collectionView.cellForItem(at: indexPath) as? FilmCell {
                            if image == nil {
                                self.setupNoImageCell(cell: cell)
                            } else {
                                cell.filmImageView.image = image
                                cell.activityIndicator.removeFromSuperview()
                                
                                let backgroundColor = cell.filmImageView.image?.averageColor
                                cell.labelView.backgroundColor = backgroundColor
                                //                        cell.contentView.backgroundColor = backgroundColor
                                //                        self.labelTextColor = self.setupLabelColor(backgroundColor: backgroundColor)
                                cell.filmNameLabel.textColor = self.setupCellsManager.setupLabelColor(backgroundColor: backgroundColor)
                                if oldAndNew == "NEW" {
                                    cell.setupNewImage(cellWidth: cell.frame.size.width)
                                }
                            }
                        }
                    }
                }
            }            
            print("movieNm: \(movieNm)")
            print("url: \(url)")
            print("oldAndNew: \(oldAndNew)")
        }
        return cell
    }
    
}

extension MainViewController {
    private func setupNoImageCell(cell: FilmCell) {
        cell.activityIndicator.removeFromSuperview()
        
        cell.noImageLabel.numberOfLines = 0
        if let customFont = UIFont(name: "Pretendard-Medium", size: 20) {
            cell.noImageLabel.font = customFont
        }
        
        cell.noImageLabel.text = "영화 <\(String(describing: cell.filmNameLabel.text!))>의 포스터를\n불러올 수 없습니다.\n\n화면을 터치하면\n영화 상세정보를\n확인할 수 있습니다."
        
        if let noImageText = cell.noImageLabel.text {
            let attrString = NSMutableAttributedString(string: noImageText)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            cell.noImageLabel.attributedText = attrString
        }
        
        cell.noImageLabel.textAlignment = .center
        cell.noImageLabel.textColor = UIColor(rgb: 0xFCF6F5)
        cell.filmImageView.addSubview(cell.noImageLabel)
        cell.noImageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.noImageLabel.centerXAnchor.constraint(equalTo: cell.filmImageView.centerXAnchor),
            cell.noImageLabel.centerYAnchor.constraint(equalTo: cell.filmImageView.centerYAnchor),
            cell.noImageLabel.leadingAnchor.constraint(equalTo: cell.filmImageView.leadingAnchor, constant: 40),
            cell.noImageLabel.trailingAnchor.constraint(equalTo: cell.filmImageView.trailingAnchor, constant: -40)
        ])
        
        cell.filmImageView.image = nil
        cell.filmImageView.backgroundColor = UIColor(rgb: 0x7b9acc)
        cell.labelView.backgroundColor = UIColor(rgb: 0x7b9acc)
        cell.filmNameLabel.textColor = UIColor(rgb: 0xFCF6F5)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    // 스크롤 사이즈 반환
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: filmCollectionView.frame.size.width, height: filmCollectionView.frame.size.height)
    }
}

extension MainViewController {
    
    func getDateString(timeInterval: Double) -> String {
        let date = Date(timeIntervalSinceNow: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func getTitleDateString(dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        guard let date = dateFormatter.date(from: dateString) else { return ""}
        
        dateFormatter.dateFormat = "(yyyy년 M월 d일 기준)"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func compareTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let currentTimeString = dateFormatter.string(from: Date())
        let currentTime = dateFormatter.date(from: currentTimeString)

        let comparisonTime = dateFormatter.date(from: "01:30")

        if currentTime! > comparisonTime! {
            let dateString = getDateString(timeInterval: -86400)
            print("현재 시간은 01:30 이후입니다.")
            dateTitle = getTitleDateString(dateString: dateString)
            return dateString
        } else {
            let dateString = getDateString(timeInterval: -172800)
            print("현재 시간은 01:30 이전입니다.")
            dateTitle = getTitleDateString(dateString: dateString)
            return dateString
        }
    }
    
    // firebase에서 데이터 가져오기
    func loadBoxOffice(time: String) {
        let docRef = db.collection(K.FStore.collectionName).document(time)
        docRef.getDocument { (document, error) in
            if let e = error {
                print("There was an issue retrieving data from firestore. \(e)")
            } else if let document = document, document.exists {
                let decoder = JSONDecoder()
                do {
                    let data = document.data()
                    let jsonData = try JSONSerialization.data(withJSONObject: data!)
                    let result = try decoder.decode(BoxOfficeModel.self, from: jsonData)
                    self.boxOfficeData = result
                    // reloadData를 해줘야 collectionView에 데이터가 들어감.
                    DispatchQueue.main.async {
                        self.filmCollectionView.reloadData()
                    }
                } catch let err {
                    print("err: \(err)")
                }
            } else {
                let dateString = self.getDateString(timeInterval: -172800)
                self.loadBoxOffice(time: dateString)
                print("데이터가 존재하지 않습니다.")
            }
        }
    }
}


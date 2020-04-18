//
//  ViewController.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 18/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import UIKit
import SVPullToRefresh
import RxSwift
import RxCocoa
import SkeletonView

class ViewController: UIViewController {
    
    lazy var refreshControls: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.systemGray
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControls: UIRefreshControl) {
        self.refresh()
    }
    @IBOutlet weak var openMenuButton: UIButton!
    @IBOutlet weak var filterMenuButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.register(UINib(nibName: "AwardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AwardCollectionViewCell")
            collectionView.delaysContentTouches = false
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.alwaysBounceVertical = true
            collectionView.addSubview(refreshControls)
            collectionView.isSkeletonable = true
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                layout.sectionInset = .init(top: 0, left: 20, bottom: 20, right: 20)
            }
        }
    }
    
    var awardInteractor: AwardInteractor? = AwardInteractor(params: ["device" : "ios", "query" : "office"])
    var marginCenter = 20
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.showOnboardingLogin()
        
        self.openMenuButton.rx.tap
        .debounce(0.5, scheduler: MainScheduler.instance)
        .subscribe({
            [weak self] _ in
            self?.actionOpenMenuButton()
        })
        .disposed(by: disposeBag)
        
        self.filterMenuButton.rx.tap
        .debounce(0.5, scheduler: MainScheduler.instance)
        .subscribe({
            [weak self] _ in
            self?.actionFilternMenuButton()
        })
        .disposed(by: disposeBag)
        
        self.refreshControls.beginRefreshing()
        self.collectionView.setContentOffset(CGPoint(x: 0, y: -refreshControls.frame.size.height), animated: true)
        self.collectionView.prepareSkeleton(completion: { done in
            let gradient = SkeletonGradient(baseColor: UIColor.gray)
            self.collectionView.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(0.25))
        })
        
        self.refresh()
        collectionView.addInfiniteScrolling {
            if let awardInteractor = self.awardInteractor {
                awardInteractor.nextWith(success: {
                    self.collectionView.infiniteScrollingView.stopAnimating()
                    self.collectionView.showsInfiniteScrolling = self.awardInteractor!.hasNext
                    self.collectionView.reloadData()
                }, failure: { error in
                    self.collectionView.infiniteScrollingView.stopAnimating()
                })
            }
        }
    }
    
    func actionOpenMenuButton() {
        self.setAlertMessage(title: "Info", message: "Sory this feature not created yet")
    }
    
    func actionFilternMenuButton() {
        // maaf saya belum sempat mengerjekan fitur filter, kalo saya deskripsikan cara membuat nya saya akan bikin variable selected filter di class ini dan di class filter,
        // 1. jadi, kalo user telah filter sesuatu akan muncul badge di samping icon filter, kalo belum badge akan hide
        // 2. yang kedua ketika push ke class filter, selected object dari class main akan di bawa dan di set di selected class filter kemudian akan di set di masing2 view filter yang ada.
        // 3. setelah user melakukan filter kembali, object selected akan di kirim kembali ke main class by protocol, di set ke variable selected main class, kemudian akan reload value yang ada.
        self.setAlertMessage(title: "Info", message: "Sory this feature not created yet")
    }
    
    func showOnboardingLogin(){
        if !PreferenceManager.instance.finishedOnboarding {
            let controller = LoginViewController.instantiateViewController()
            controller.hidesBottomBarWhenPushed = true
            controller.loginViewControllerDelegate = self
            let navController = UINavigationController(rootViewController: controller)
            navController.isNavigationBarHidden = true
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func refresh(){
        self.collectionView.hideSkeleton()
        let gradient = SkeletonGradient(baseColor: UIColor.gray)
        collectionView.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(0.25))
        self.awardInteractor?.refresh(success: { () in
            self.collectionView.hideSkeleton(transition: .crossDissolve(0.25))
            self.refreshControls.endRefreshing()
            self.collectionView.showsInfiniteScrolling = self.awardInteractor!.hasNext
            self.collectionView.reloadData()
        }, failure: { error in
            self.collectionView.hideSkeleton(transition: .crossDissolve(0.25))
            self.refreshControls.endRefreshing()
            self.collectionView.reloadData()
        })
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView {
            if let awardInteractor = awardInteractor, awardInteractor.items.count != 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AwardCollectionViewCell", for: indexPath) as! AwardCollectionViewCell
                cell.award = awardInteractor.items[indexPath.row]
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let awardInteractor = awardInteractor {
            return awardInteractor.items.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AwardCollectionViewCell", for: indexPath) as! AwardCollectionViewCell
            cell.freezeAnimations()
            
        }
    }
}

extension ViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "AwardCollectionViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionView {
            if UIDevice().isPhone() {
                let widthCard = (self.widthScreen - CGFloat((marginCenter * 2)))// 20 margin center, left rifht center
                return CGSize(width: widthCard, height: 231)
            } else {
                if DeviceInfo.Orientation.isLandscape {
                    let widthCard = (self.widthScreen - CGFloat((marginCenter * 4))) / 3 // 20 margin center, left rifht center
                    return CGSize(width: widthCard, height: 231)
                } else {
                    let widthCard = (self.widthScreen - CGFloat((marginCenter * 3))) / 2 // 20 margin center, left rifht center
                    return CGSize(width: widthCard, height: 231)
                }
            }
        }
        
        return CGSize.zero
    }
}

extension ViewController : LoginViewControllerDelegate {
    func loginViewController(needRefresh controller: LoginViewController) {
        self.refresh()
    }
}



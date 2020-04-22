//
//  FireBoard.swift
//  TrendingFire
//
//  Created by Alex D'Agostino on 9/7/19.
//  Copyright © 2019 Alex D'Agostino. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMobileAds

class FireBoard: UIViewController,LateLoadingProtocol {

    fileprivate var cardCurrentlyDisplayed:Bool = false
    fileprivate var refreshControl:UIRefreshControl = UIRefreshControl()
    fileprivate var currentlyFetching = true
    
    var selectedCategory = "All"
    var upDatingNewCategory = false
    let pickerArray = ["All","Paintings","Photography","Apparel"]
    var bannerView: GADBannerView!
    
    var fireAnimations:TrendingFireAnimations?
    
    //card management
    func setUpTable() {
        if(upDatingNewCategory == false) {
            self.tableViewBoard.delegate = self
            self.tableViewBoard.dataSource = self
            self.tableViewBoard.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            self.tableViewBoard.showsVerticalScrollIndicator = false
            self.view.addSubview(self.tableViewBoard)
            setUpTableView(v:view,table:tableViewBoard)
            if #available(iOS 10.0, *) {
                tableViewBoard.refreshControl = refreshControl
            } else {
                tableViewBoard.addSubview(refreshControl)
            }
            refreshControl.addTarget(self, action: #selector(refreshRankData(_:)), for: .valueChanged)
            currentlyFetching = false
            self.fireLoadingView.removeFromSuperview()
        } else {
            self.tableViewBoard.reloadData()
            removeSpinner()
            upDatingNewCategory = false
        }
    }
    
    @objc private func refreshRankData(_ sender: Any) {
        if(upDatingNewCategory != true) {
            self.delegate?.requestRankCards(category:selectedCategory.lowercased())
            upDatingNewCategory = true
            return;
        }
        self.refreshControl.endRefreshing()
    }

    //delegate and navaigation
    weak var delegate:ViewController?
    
    func updateTable(arr:ImageHolder,refresh:Bool){
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableViewBoard.reloadData()
                self.removeSpinner()
            }
        }
    
    @objc func backTap() {
        fireAnimations?.fireToMain()
    }
    
    //lifecycle
    let tableViewBoard: UITableView = UITableView()
    let fireLoadingView: UIImageView = UIImageView()
    
    override func loadView() {
        super.loadView()
        view.addSubview(catPickerView)
        view.addSubview(fireProfileButton)
        view.addSubview(rankTitle)
    }

    override func viewDidLoad() {
        //setting up ads
        fireAnimations = TrendingFireAnimations(controller:self)
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-2312447022233574/2582035698"
        bannerView.rootViewController = self
        addBannerViewToView(v:view,bannerView:bannerView)
        bannerView.load(GADRequest())
        
        catPickerView.dataSource = self
        catPickerView.delegate = self
        
        //setup views
        fireLoadingView.image = UIImage(named:"logowhite")
        fireLoadingView.translatesAutoresizingMaskIntoConstraints = false
        setUpFireProfileButton(v:view)
        setUpRankTitle(v:view)
        setUpCatPickerView(v:self.view)
        
        refreshControl = UIRefreshControl()

        if(delegate?.rankImagesHolder.updated == false) {
            self.setUpTable()
            showSpinner(onView: tableViewBoard)
        } else {
            self.setUpTable()
        }
    }

    //card action functions
    @objc func exitCard(_ sender: UITapGestureRecognizer? = nil) {
        cardCurrentlyDisplayed = false
        if(sender != nil){
            sender!.view!.removeFromSuperview()
        }
    }

    func addCardView(index:Int) {
        if(cardCurrentlyDisplayed == true) {
            return;
        }
        cardCurrentlyDisplayed = true

        let popUpCardView = UIView(frame:CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 0, height: 0))
        self.view.addSubview(popUpCardView)
        setUpPopUpCardView(popUpView:popUpCardView,v:self.view)
        
        let cardTap = UITapGestureRecognizer(target: self, action: #selector(self.exitCard(_:)))
        popUpCardView.addGestureRecognizer(cardTap)
        
        let imageHolder = UIImageView.init(frame: CGRect(x: popUpCardView.frame.width/2, y: popUpCardView.frame.height/2, width: 0, height: 0))
        popUpCardView.addSubview(imageHolder)
    setUpImageHolder(imageHolder:imageHolder,pv:popUpCardView,image:delegate!.rankImagesHolder.cardArray[index].image)
    
        let infoView = UIView(frame: CGRect(x: 0 , y: 0, width: popUpCardView.frame.width, height: popUpCardView.frame.height))
        popUpCardView.addSubview(infoView)
        setUpTextView(textView:infoView,popUpCardView:popUpCardView)
        
        let titleLabel = UILabel()
        infoView.addSubview(titleLabel)
    setUpTitleLabel(titleLabel:titleLabel,infoView:infoView,title:delegate!.rankImagesHolder.cardArray[index].title)
                
        let descLabel = UILabel()
        infoView.addSubview(descLabel)
    setUpDescLabel(descLabel:descLabel,infoView:infoView,description:delegate!.rankImagesHolder.cardArray[index].descText)

        let linkButton = FireButton()
        infoView.addSubview(linkButton)
        linkButton.fireLink = delegate!.rankImagesHolder.cardArray[index].link
        setUpLinkButton(linkButton:linkButton,infoView:infoView)
        linkButton.addTarget(self, action: #selector(self.goToLinkDestination), for: .touchUpInside)

        let rankLabel = UILabel()
        popUpCardView.addSubview(rankLabel)
        setUpRankLabel(rankLabel: rankLabel, infoView: infoView, rank: delegate!.rankImagesHolder.cardArray[index].rankTxt)

        let authorLabel = UILabel()
        popUpCardView.addSubview(authorLabel)
        setUpAuthorLabel(authorLabel: authorLabel, infoView: infoView, author: delegate!.rankImagesHolder.cardArray[index].authorTxt)
        
        fireAnimations?.popUpCard()
    }
}


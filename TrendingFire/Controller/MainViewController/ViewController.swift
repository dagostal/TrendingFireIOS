//
//  ViewController.swift
//  TrendingFire
//
//  Created by Alex D'Agostino on 8/10/19.
//  Copyright © 2019 Alex D'Agostino. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire
import SafariServices
import GoogleMobileAds


class ViewController: UIViewController {
    
    let Userdefaults = UserDefaults.standard
    var cardIsTapped: Bool = false
    var swipeUpButton:UIButton!
    var loadedNativeAdForCycle:GADUnifiedNativeAd?
    var userID = ""
    var loggedIn: Bool = false
    var selectedCategories: [String] = ["all"]
    var dataSource: [Card] = []
    
    var myKolodaView: KolodaView!
    var categoryButton: dropDownBtn = dropDownBtn.init(frame:CGRect(x:0,y:0,width:0,height:0))
    
    fileprivate var categoryOptions = ["Paintings","Photography","Apparel"]
    fileprivate var userRank: String = ""
    fileprivate var username: String = ""
    
    //card management
    //setting up cards, function runs after 5 cards are loaded
    func assignCards(arr: [Card]) {
        self.dataSource = arr
        setUpKolodaView(v:view,kView:myKolodaView)
        myKolodaView.delegate = self
        myKolodaView.dataSource = self
        myKolodaView.visibleCardsDirection = .top
        loadingView.removeFromSuperview()
    }
    
    func assignRankAndName(arr:[String:String]) {
        username = arr["username"]!
        userRank = arr["rank"]!
        setUpRankView(rank:userRank,profileView:profileButton)
    }
    
    func resetDeck(selectedCat:[String]) {
        self.removeCardDesc()
        view.addSubview(loadingView)
        setUpLoadingView(v:view)
        removeKolodaView: for n in 0...self.view.subviews.count-1 {
            if(self.view.subviews[n].tag==4){
                self.view.subviews[n].removeFromSuperview()
                break removeKolodaView
            }
        }
        myKolodaView = KolodaView()
        myKolodaView.tag = 4
        view.addSubview(myKolodaView)        
        requestMainCards(category: self.selectedCategories)
    }

    //navigation actions
    @objc func profileImageTap() {
        self.performSegue(withIdentifier: "move1", sender: self)
    }
    
    @objc func fireBoardButtonTap() {
        self.performSegue(withIdentifier: "move2", sender: self)
    }
    
    //view controller delegate functions
    weak var delegate: LateLoadingProtocol?
    
    func notifyFireBoard() {  
        delegate?.updateTable(arr:self.rankImagesHolder,refresh:false)
    }
    
    func notifyProfileBoard() {
        delegate?.updateTable(arr:self.createdImagesHolder,refresh:false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "move1") {
            if let profileViewController = segue.destination as? ProfileViewController {
                profileViewController.profileRank = userRank
                profileViewController.userName = username
                profileViewController.loggedIn = self.loggedIn
                profileViewController.createdImagesHolder = createdImagesHolder
                profileViewController.trendingImagesHolder = trendingImagesHolder
                profileViewController.userID = self.userID
                profileViewController.delegate = self
                self.delegate = profileViewController
            }
        }
         if(segue.identifier == "move2") {
            if let fireBoardController = segue.destination as? FireBoard {
//                fireBoardController.rankImagesHolder = rankImagesHolder
                fireBoardController.delegate = self
                self.delegate = fireBoardController
            }
        }
    }
    
    // MARK: Lifecycle / controler
    //image objs that hold data from network requests
    var rankImagesHolder: ImageHolder!
    var createdImagesHolder: ImageHolder!
    var trendingImagesHolder: ImageHolder!
    //ad for card
    var adLoader: GADAdLoader!

    override func loadView() {
        super.loadView()
        view.addSubview(profileButton)
        view.addSubview(fireBoardButton)
        view.addSubview(loadingView)
        view.addSubview(trendingFireLabelView)
        view.addSubview(categoryButton)
        view.addSubview(rankView)
        myKolodaView = KolodaView()
        myKolodaView.tag = 4
        view.addSubview(myKolodaView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = setUserId()
        loggedIn = setLoggedInStatus()
        setUpAdLoadForCard()
        //setup dropDownFilter
        categoryButton.delegate = self
        categoryButton.dropView.dropDownOptions = categoryOptions
        //setup views
        setUpProfileButton(v:self.view)
        setUpLoadingView(v:self.view)
        setUpFireBoardButton(v:self.view)
        setUpTrendingLabel(v:self.view)
        setUpProfileCatView(categoryButton:categoryButton,v:self.view)
        
        //card modals for holding card info...
        createdImagesHolder = ImageHolder()
        trendingImagesHolder = ImageHolder()
        rankImagesHolder = ImageHolder()
    
        swipeUpButton = UIButton()
        //network requests
        if(loggedIn) {
            requestMainCards(category:["all"])
            requestProfileCards(userid:userID)
            requestTrendingCards(userid:userID)
            requestRankCards(category:"all")
            requestTrendingRank(userid: userID)
        } else {
            requestMainCards(category:["all"])
            requestRankCards(category:"all")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(Userdefaults.object(forKey: "firstTime") == nil) {
            self.present(trendingFireAlerts(alertName: "firstTimeAlert",sender:self), animated: true)
            Userdefaults.set(false,forKey: "firstTime")
        }
        userID = setUserId()
        loggedIn = setLoggedInStatus()
        
        if(loggedIn==false) {
            Userdefaults.set(" ",forKey: "userID")
            userID = setUserId()
            userRank = "0"
            username = ""
            createdImagesHolder = ImageHolder()
            trendingImagesHolder = ImageHolder()
        } else {
            requestTrendingRank(userid: userID)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("ALERT -- memory overload -- ALERT")
        //dispose of resources before moving to the new controller
    }
    
        //cardButton actions
    func addInfoBoxView(title:String,author:String,description:String,rank:String,link:String) {
        let infoBoxView = UIView()
        infoBoxView.tag = 5
        self.view.addSubview(infoBoxView)
        setUpInfoBoxView(infoBox:infoBoxView,v:self.view)
                
        let titleLabel = UILabel()
        infoBoxView.addSubview(titleLabel)
        setUpTitleLabel(titleLabel:titleLabel,infoView:infoBoxView,title:title)
            
        let descLabel = UILabel()
        infoBoxView.addSubview(descLabel)
        setUpDescLabel(descLabel:descLabel,infoView:infoBoxView,description:description)

        let linkButton = FireButton()
        linkButton.fireLink = link
        infoBoxView.addSubview(linkButton)

        setUpLinkButton(linkButton: linkButton, infoView: infoBoxView)
        linkButton.addTarget(self, action: #selector(self.goToLinkDestination), for: .touchUpInside)
        
        let rankLabel = UILabel()
        infoBoxView.addSubview(rankLabel)
        setUpRankLabel(rankLabel: rankLabel, infoView: infoBoxView, rank: rank)
                
        let authorLabel = UILabel()
        infoBoxView.addSubview(authorLabel)
        setUpAuthorLabel(authorLabel: authorLabel, infoView:infoBoxView, author: author)
                
        self.view.addSubview(swipeUpButton)
        swipeUpButton.setImage(UIImage(named:"justthelogo"), for: .normal)
            
        swipeUpButton.translatesAutoresizingMaskIntoConstraints = false
        swipeUpButton.widthAnchor.constraint(equalTo: infoBoxView.widthAnchor,multiplier: 0.15).isActive = true
        swipeUpButton.heightAnchor.constraint(equalTo: infoBoxView.heightAnchor,multiplier:0.2).isActive = true
        swipeUpButton.bottomAnchor.constraint(equalTo: infoBoxView.topAnchor).isActive = true
        NSLayoutConstraint(item: swipeUpButton!, attribute: .centerX, relatedBy: .equal, toItem: infoBoxView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        swipeUpButton.addTarget(self,action: #selector(self.swipeUpAction), for: .touchUpInside)
                
        let shareButton = UIButton()
        let flagButton = UIButton()
                
        if #available(iOS 13.0, *) {
            let shareImg = UIImage(systemName: "square.and.arrow.up")?.withTintColor(.white,renderingMode:.alwaysOriginal)
            shareButton.setImage(shareImg, for: .normal)
            let flagImg = UIImage(systemName:"flag")?.withTintColor(.white,renderingMode:.alwaysOriginal)
            flagButton.setImage(flagImg, for: .normal)
        } else {
            shareButton.setImage(UIImage(named:"logowhite"), for: .normal)
            flagButton.setImage(UIImage(named:"logowhite"), for: .normal)
        }
        infoBoxView.addSubview(shareButton)
        setUpShareButton(shareButton:shareButton,v:self.view)
        
        infoBoxView.addSubview(flagButton)
        setUpFlagButton(flagButton:flagButton,v:self.view)
            
        UIView.animate(withDuration: 0.3) {
            infoBoxView.alpha = 1.0
            titleLabel.alpha = 1.0
            authorLabel.alpha = 1.0
            rankLabel.alpha = 1.0
            descLabel.alpha = 1.0
            shareButton.alpha = 1.0
            flagButton.alpha = 1.0
            self.swipeUpButton.alpha = 1.0
        }
    }

    @objc func flagCard() {
        self.present(trendingFireAlerts(alertName: "flagAlert",sender:self), animated: true)
    }
        
    @objc func swipeUpAction(sender:UIButton) {
        sender.removeFromSuperview()
        self.myKolodaView.swipe(.up)
    }
    
    @objc func shareCard(sender:UIView) {
        shareCardAlert(self:self,sender:sender)
    }
        
    func removeCardDesc() {
        if(self.cardIsTapped == true) {
            self.cardIsTapped = false
            self.swipeUpButton.removeFromSuperview()
            var viewsToAnimated:[UIView] = []
            var descMasterView:UIView = UIView()
            findDescView: for n in 0...self.view.subviews.count-1 {
                if(self.view.subviews[n].tag==5){
                    descMasterView = self.view.subviews[n]
                    for k in 0...self.view.subviews[n].subviews.count - 1 {
                        viewsToAnimated.append(self.view.subviews[n].subviews[k])
                    }
                    break findDescView
                }
            }
            UIView.animate(withDuration: 0.2, animations: {
                descMasterView.alpha = 0.0
                viewsToAnimated[0].alpha = 0.0
                viewsToAnimated[1].alpha = 0.0
                viewsToAnimated[2].alpha = 0.0
                viewsToAnimated[3].alpha = 0.0
                viewsToAnimated[4].alpha = 0.0
                viewsToAnimated[5].alpha = 0.0
                viewsToAnimated[6].alpha = 0.0
                self.swipeUpButton.alpha = 0.0
            }, completion: {(finished: Bool) in
                 descMasterView.removeFromSuperview()
            })
        }
    }
    
    
}

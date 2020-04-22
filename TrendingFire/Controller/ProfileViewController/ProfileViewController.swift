//
//  NewProfileController.swift
//  TrendingFire
//
//  Created by alex on 1/31/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,LateLoadingProtocol {

    fileprivate var imagePicker = UIImagePickerController()
    fileprivate var refreshControl:UIRefreshControl = UIRefreshControl()
    var vSpinner:UIView?
    var cardCurrentlyDisplayed: Bool = false
    
    var NametextInInputField: String = ""
    var DesctextInInputField: String = ""
    var LinktextInInputField: String = ""
    
//    var vSpinner : UIView?
    
    let pickerArray = ["Paintings","Photography","Apparel"]
    var selectedCategory: String = "Paintings"
    
    var profileAnimations:TrendingFireAnimations?
    var imageToUpload:UIImage?
        
    var profileRank:String = ""
    var userName:String = ""
    var userID:String?
    var loggedIn:Bool = false
    var toggleOnFire: Bool = false

    var tableViewBoard:UITableView!
    
    // navigation & delegates
    @objc func profileImageTap() {
        self.performSegue(withIdentifier: "moveToProfileViewInfo", sender: self)
    }

    @objc func backTap() {
        profileAnimations?.profileToMainAnimation()
    }
    
    @objc func moveToSignUp(){
        self.performSegue(withIdentifier: "alert", sender: self)
    }
    
    weak var delegate: ViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dc = segue.destination as? ProfileInfo {
            dc.userID = self.userID
        }
    }
    
    @objc private func refreshProfileData(_ sender: Any) {
        if(loggedIn){
            if(toggleOnFire==false) {
                self.delegate?.requestProfileCards(userid: userID!)
                return;
            } else {
                self.delegate?.requestTrendingCards(userid: userID!)
                return;
            }
        }
        self.refreshControl.endRefreshing()
    }
    //table & card management
    private func setUpTable() {
        if #available(iOS 10.0, *) {
            tableViewBoard.refreshControl = refreshControl
        } else {
            tableViewBoard.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshProfileData(_:)), for: .valueChanged)
        tableImageHolder = createdImagesHolder
        setUpTableView(t:tableViewBoard,v:view)
        tableViewBoard.dataSource = self
        tableViewBoard.register(UITableViewCell.self, forCellReuseIdentifier: "fireCards")
        tableViewBoard.reloadData()
    }

    func updateTable(arr:ImageHolder,refresh:Bool) {
        removeSpinner()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableViewBoard.reloadData()
            }
    }
    
    @objc func changeToggle() {
    //        toggleContainerView.setTitle("My Cards", for: .normal)
        if(toggleOnFire == true) {
            tableImageHolder = createdImagesHolder
            self.tableViewBoard.reloadData()
            toggleOnFire = false
            toggleLabel.text = "My Cards"
        } else {
            tableImageHolder = trendingImagesHolder
            self.tableViewBoard.reloadData()
            toggleLabel.text = "Saved Cards"
            toggleOnFire = true
        }
    }
    //lifecycle
    var createdImagesHolder: ImageHolder!
    var trendingImagesHolder:ImageHolder!
    var tableImageHolder: ImageHolder!
    
    override func loadView() {
        super.loadView()
        view.addSubview(profileProfileButton)
        view.addSubview(toggleContainerView)
        view.addSubview(createCardButton)
        view.addSubview(toggleLabel)
        view.addSubview(profileRankView)
        view.addSubview(nameLabel)
        tableViewBoard = UITableView(frame: CGRect(x: 40, y: 35, width: 0, height: 0))
        view.addSubview(tableViewBoard)
        self.tableViewBoard.delegate = self
        self.tableViewBoard.dataSource = self
        
        view.addSubview(profileBackButton)
    }    
    
    override func viewDidLoad() {
        profileAnimations = TrendingFireAnimations(controller:self)
        self.hideKeyboardWhenTappedAround() 
        setUpProfileProfileButton(v:view)
        setupProfileBackButton(v:view)
        setUpCreateCardButton(v:view)
        setUpToggleLabel(v:view)
        setUpProfileRankView(rank: profileRank, profileView: profileProfileButton)
        setupNameLabel(name:userName,v:self.view)

        self.setUpTable()
    }
    
    //card creation text inputs
    @objc func getDescText(sender:UITextField){
        DesctextInInputField = sender.text!
    }
    @objc func getNameText(sender:UITextField){
        NametextInInputField = sender.text!
    }
    
    @objc func getLinkText(sender:UITextField){
        LinktextInInputField = sender.text!
    }
    //submit card upload
    @objc func submitInfo(sender:UIButton) {
        if(imageToUpload == nil || DesctextInInputField.count < 1 || NametextInInputField.count < 1) {
            self.present(trendingFireAlerts(alertName: "missingInfo",sender:self), animated: true)
            return;
        }
        if(self.selectedCategory=="Apparel" && userID != "12345678") {
            self.present(trendingFireAlerts(alertName: "cantDoApperal",sender:self), animated: true)
            return;
        }
        if(NametextInInputField.count > 19) {
            self.present(trendingFireAlerts(alertName: "nameTooLong",sender:self), animated: true)
            return;
        }
        if(DesctextInInputField.count > 29) {
            self.present(trendingFireAlerts(alertName: "descTooLong",sender:self), animated: true)
            return;
        }
        
        showSpinner(onView: self.view)
        let params: [String: String] = [
            "desc" : DesctextInInputField,
            "linkTxt":LinktextInInputField,
            "titleTxt":NametextInInputField,
            "category":selectedCategory,
            "userID": userID!
        ]
        uploadCard(params:params,imageToUpload: imageToUpload!,sender:self,popUpView: sender.superview!)
    }

    @objc func upLoadImage(sender:UIButton) {
        upLoadImageAlert(self:self,sender:sender)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageToUpload = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.dismiss(animated: false, completion: nil)
        addPhotoButton.setImage(imageToUpload, for: .normal)
        addPhotoButton.backgroundColor = .black
    }
        
    @objc func createCard() {
        if(loggedIn == false) {
            self.present(trendingFireAlerts(alertName:"createAccount",sender:self),animated: true)
            return;
        }
        cardCurrentlyDisplayed = true
        
        let createCardNewView = UIView(frame:CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 0, height: 0))
        self.view.addSubview(createCardNewView)
        setUpCreateCardNewView(newView:createCardNewView,v:self.view)
        
        let cardTap = UITapGestureRecognizer(target: self, action: #selector(self.exitCard(_:)))
        createCardNewView.addGestureRecognizer(cardTap)
                
        createCardNewView.addSubview(addPhotoButton)
        setUpAddPhotoButton(newView:createCardNewView)
        addPhotoButton.addTarget(self, action: #selector(upLoadImage), for: .touchUpInside)
        
        let nameTextFieldInput = UITextField()
        createCardNewView.addSubview(nameTextFieldInput)
        setUpNameTextField(nameTextFieldInput:nameTextFieldInput,newView:createCardNewView)
    
        nameTextFieldInput.addTarget(self, action: #selector(getNameText), for: .editingChanged)
        nameTextFieldInput.delegate = self
            
        let descFieldInput = UITextField()
        createCardNewView.addSubview(descFieldInput)
        setUpDescTextField(descFieldInput: descFieldInput, newView: createCardNewView)
        descFieldInput.addTarget(self, action: #selector(getDescText), for: .editingChanged)
        descFieldInput.delegate = self
                
        let linkFieldInput = UITextField()
        createCardNewView.addSubview(linkFieldInput)
        setUpLinkTextField(linkFieldInput:linkFieldInput,newView:createCardNewView)
        linkFieldInput.addTarget(self, action: #selector(getLinkText), for: .editingChanged)
        linkFieldInput.delegate = self
        
        let catPickerView = UIPickerView()
        createCardNewView.addSubview(catPickerView)
        setUpCatPickerView(catView:catPickerView,newView:createCardNewView)
        
        catPickerView.dataSource = self
        catPickerView.delegate = self
         
        let submitButton: UIButton = UIButton(frame: CGRect(x:createCardNewView.frame.width/2,y:createCardNewView.frame.height/2,width:0,height:0))
        createCardNewView.addSubview(submitButton)
        submitButton.addTarget(self, action: #selector(submitInfo), for: .touchUpInside)
        setUpSubmitButton(submitButton:submitButton,newView:createCardNewView)
                             
        profileAnimations?.popUpCard()
    }
    
    //card tap functions
    @objc func exitCard(_ sender: UITapGestureRecognizer? = nil) {
        cardCurrentlyDisplayed = false
        NametextInInputField = ""
        DesctextInInputField = ""
        if(sender != nil){
            sender!.view!.removeFromSuperview()
        }
    }
    
    func addCardView(tableSource:[Card],index:Int) {
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
        setUpImageHolder(imageHolder:imageHolder,pv:popUpCardView,image:tableSource[index].image)
    
        let infoView = UIView(frame: CGRect(x: 0 , y: 0, width: popUpCardView.frame.width, height: popUpCardView.frame.height))
        popUpCardView.addSubview(infoView)
        setUpTextView(textView:infoView,popUpCardView:popUpCardView)
        
        let titleLabel = UILabel()
        infoView.addSubview(titleLabel)
        setUpTitleLabel(titleLabel:titleLabel,infoView:infoView,title:tableSource[index].title)
                
        let descLabel = UILabel()
        infoView.addSubview(descLabel)
        setUpDescLabel(descLabel:descLabel,infoView:infoView,description:tableSource[index].descText)

        let linkButton = FireButton()
        infoView.addSubview(linkButton)
        linkButton.fireLink = tableSource[index].link
        setUpLinkButton(linkButton:linkButton,infoView:infoView)
        linkButton.addTarget(self, action: #selector(self.goToLinkDestination), for: .touchUpInside)

        let rankLabel = UILabel()
        popUpCardView.addSubview(rankLabel)
        setUpRankLabel(rankLabel: rankLabel, infoView: infoView, rank: tableSource[index].rankTxt)

        let authorLabel = UILabel()
        popUpCardView.addSubview(authorLabel)
        setUpAuthorLabel(authorLabel: authorLabel, infoView: infoView, author: tableSource[index].authorTxt)
                
        profileAnimations?.popUpCard()
    }
}

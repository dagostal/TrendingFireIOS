//
//  NewProfileController.swift
//  TrendingFire
//
//  Created by alex on 1/31/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreData



class ProfileViewController: loadViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    override func updateProfileTables(){
        removeSpinner()
        DispatchQueue.main.async {
            self.setUpTable()
        }
    }
            
    
    var imagePicker = UIImagePickerController()
    var profileCardArray: [Card] = []
    var profileTableArray:[RankCardObj] = []
    var initialPersonalImgsLoaded = false
    var cardCurrentlyDisplayed: Bool = false
    var imageToUpload:UIImage?
    var profileRank:String?
    var refreshProfileBoardCompleted = false
    var trendingCardRefreshComplete = false

       
    var didBeingEnteringTextBool: Bool = false
    var numberOfUsersCards: Int = 0
    var numberofFireCards: Int = 0
    
    var imagesInPersonalBoard: [UIImage] = []
    
    var NametextInInputField: String = ""
    var DesctextInInputField: String = ""
    var LinktextInInputField: String = ""
        
    
    let addPhotoButton: UIButton = {
        let button = UIButton()
         return button
      }()
    
    let masterView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    

    let createCardButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.backgroundColor = UIColor.black
        button.setImage(UIImage(named: "createFlame"), for: .normal)
        button.addTarget(self, action: #selector(createCard), for: .touchUpInside)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 2
        return button
    }()
    

    
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "blackprofileicon"), for: .normal)
        button.addTarget(self, action: #selector(profileImageTap), for: .touchUpInside)
       return button
    }()
    

        
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rank"), for: .normal)
        button.addTarget(self, action: #selector(backTap), for: .touchUpInside)
        return button
        }()
    
    
override func upDateTrendingImgs() {
    print("trending images updated!!!")
    if(toggleOnFire == false){
        return;
    } else {
        print("updated trneding imgs")
        DispatchQueue.main.async {
            self.tableViewBoard.delegate = self
            self.tableViewBoard.dataSource = self
            self.tableViewBoard.register(UITableViewCell.self, forCellReuseIdentifier: "trending")
            self.tableViewBoard.reloadData()
          }
    }
}
    
    
    
    
@objc private func refreshBoard(_ sender: Any) {
        print("refreshsing trending board")
            refreshTrendingBoard()
            refreshProfileBoard()
}

    
    
     let refreshControl = UIRefreshControl()
        
    
    var toggleOnFire: Bool = false
    
    @objc func changeToggle() {
        toggleContainerView.setTitle("My Cards", for: .normal)
        if(toggleOnFire == true) {
            self.tableViewBoard.delegate = nil
            self.tableViewBoard.dataSource = nil
            tableViewBoard.reloadData()
            
           
            tableViewBoard.register(UITableViewCell.self, forCellReuseIdentifier: "firecards")
            self.tableViewBoard.delegate = self
            self.tableViewBoard.dataSource = self
            
            toggleOnFire = false
        } else {
            toggleContainerView.setTitle("Saved Cards", for: .normal)
            if(trendingImagesObj.updated==false) {
            
                self.tableViewBoard.delegate = nil
                self.tableViewBoard.dataSource = nil
                toggleOnFire = true
                tableViewBoard.reloadData()
            } else {
            self.tableViewBoard.delegate = nil
            self.tableViewBoard.dataSource = nil
            tableViewBoard.reloadData()
//            let newSource = trendingDataSoruce(arr:trendingImagesObj,tabe:tableViewBoard)
//
//            self.tableViewBoard.dataSource = self
            self.tableViewBoard.delegate = self
            self.tableViewBoard.dataSource = self
            tableViewBoard.register(UITableViewCell.self, forCellReuseIdentifier: "trending")
            
            //switch to trending view....how do i do that.
        toggleOnFire = true
            }
                
    }
        

    }
    
    @objc func profileImageTap() {
        self.performSegue(withIdentifier: "moveToProfileViewInfo", sender: self)
    }
    
    
    @objc func getDescText(sender:UITextField){
        DesctextInInputField = sender.text!
        print(sender.text!)
    }
    @objc func getNameText(sender:UITextField){
        NametextInInputField = sender.text!
        print(sender.text!)
    }
    
    @objc func getLinkText(sender:UITextField){
        LinktextInInputField = sender.text!
        print(sender.text!)
    }


    
    
    
    
    
    @objc func submitInfo(sender:UIButton) {
        print("attempting to upload card..")
        if(imageToUpload == nil) {
            print("no image selected")
            let alert = UIAlertController(title: "No Image Selected", message: "Please select an image to upload", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
            self.present(alert, animated: true)
            return;
        }
        if(DesctextInInputField.count < 1 || NametextInInputField.count < 1) {
            print("no description given")
            let alert = UIAlertController(title: "No Description", message: "Please include information about your card", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
            self.present(alert, animated: true)
            return;
        }
        showSpinner(onView: self.view)
        let imgData = imageToUpload!.jpegData(compressionQuality: 0.2)!
        
        let Userdefaults = UserDefaults.standard
        let params: [String: String] = [
            "desc" : DesctextInInputField,
            "linkTxt":LinktextInInputField,
            "titleTxt":NametextInInputField,
            "userID": Userdefaults.object(forKey: "userID") as! String
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "photo",fileName: "file.jpg", mimeType: "image/jpg")
                for (key, value) in params {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    } //Optional for extra parameters
            },
        to:"https://agile-dusk-73308.herokuapp.com/upload")
        { (result) in
            switch result {
                
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })

                upload.responseJSON { response in
                    if(response.result.value != nil) {
                        let responseData = JSON(response.result.value!)
                        if(responseData["success"] == "true") {
                            print("great success!")
                            self.DesctextInInputField = ""
                            self.NametextInInputField = ""
                            self.LinktextInInputField = ""
                            self.imageToUpload = nil
                            self.removeSpinner()
                            sender.superview!.removeFromSuperview()
                    let alert = UIAlertController(title: "Success", message: "Card Uploaded Successfully", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    } else {
                        print("upload failed")
                        self.removeSpinner()
                        let alert = UIAlertController(title: "Error", message: "Connection Error, could not upload card", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Can't connect to server", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                     
                }

            case .failure(let encodingError):
                print(encodingError)
                print("ERROR UPLOADING IMAGE")
                let alert = UIAlertController(title: "Error", message: "Connection Error, could not upload card", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Fuck", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
      }

      
    
    @objc func upLoadImage(sender:UIButton) {
        
                var imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self

                let actionSheet = UIAlertController(title: "photoSource", message: "pick a card", preferredStyle: .actionSheet)
            

                actionSheet.addAction(UIAlertAction(title:"Photo Library",style:.default,handler:{(action:UIAlertAction) in
                    imagePickerController.sourceType = .photoLibrary
                    self.present(imagePickerController, animated: true, completion:nil)
        
                }))
        
                actionSheet.addAction(UIAlertAction(title:"Cancel",style:.cancel,handler:{(action:UIAlertAction) in
        
                }))
        
            self.present(actionSheet,animated:true,completion:nil)
    
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageToUpload = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.dismiss(animated: false, completion: nil)
        //

        addPhotoButton.setImage(imageToUpload, for: .normal)
        addPhotoButton.backgroundColor = .black
        
    }
        

    @objc func createCard() {
        cardCurrentlyDisplayed = true
        
        let createCardNewView = UIView(frame:CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 0, height: 0))
        
        
            createCardNewView.backgroundColor = UIColor.black
            createCardNewView.layer.borderColor = UIColor.white.cgColor
            createCardNewView.layer.borderWidth = 1
            createCardNewView.layer.cornerRadius = 1
            
            self.view.addSubview(createCardNewView)
        
        
            let cardTap = UITapGestureRecognizer(target: self, action: #selector(self.exitCard(_:)))
            createCardNewView.addGestureRecognizer(cardTap)
        //
            createCardNewView.translatesAutoresizingMaskIntoConstraints = false
            createCardNewView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            createCardNewView.topAnchor.constraint(equalTo: view.topAnchor,constant: 70).isActive = true
            createCardNewView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.85).isActive = true
            createCardNewView.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.85).isActive = true
     
                    
//            addPhotoButton.backgroundColor = .yellow
            addPhotoButton.setImage(UIImage(named:"addImage"), for: .normal)
            addPhotoButton.layer.borderColor = UIColor.white.cgColor
            addPhotoButton.layer.borderWidth = 1
        
            addPhotoButton.addTarget(self, action: #selector(upLoadImage), for: .touchUpInside)
            createCardNewView.addSubview(addPhotoButton)
            
            addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
            addPhotoButton.leadingAnchor.constraint(equalTo: createCardNewView.leadingAnchor,constant:75).isActive = true
            addPhotoButton.trailingAnchor.constraint(equalTo: createCardNewView.trailingAnchor,constant: -75).isActive = true
            addPhotoButton.topAnchor.constraint(equalTo: createCardNewView.topAnchor,constant: 20).isActive = true
            addPhotoButton.heightAnchor.constraint(equalTo: createCardNewView.heightAnchor,multiplier: 0.3).isActive = true
        
            
   
        
        let nameTextFieldInput = UITextField()
        nameTextFieldInput.layer.borderColor = UIColor.white.cgColor
        nameTextFieldInput.layer.borderWidth = 1
        nameTextFieldInput.layer.cornerRadius = 2
            
        nameTextFieldInput.placeholder = "Card Name"
            
        nameTextFieldInput.font = UIFont(name: "Herculanum",size: 16)!
        nameTextFieldInput.borderStyle = UITextField.BorderStyle.roundedRect
        nameTextFieldInput.autocorrectionType = UITextAutocorrectionType.no
        nameTextFieldInput.keyboardType = UIKeyboardType.default
        nameTextFieldInput.returnKeyType = UIReturnKeyType.done
        nameTextFieldInput.clearButtonMode = UITextField.ViewMode.whileEditing
        nameTextFieldInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        nameTextFieldInput.addTarget(self, action: #selector(getNameText), for: .editingChanged)
        nameTextFieldInput.delegate = self
        
        createCardNewView.addSubview(nameTextFieldInput)
            
        nameTextFieldInput.translatesAutoresizingMaskIntoConstraints = false
        nameTextFieldInput.centerXAnchor.constraint(equalTo: createCardNewView.centerXAnchor).isActive = true
        nameTextFieldInput.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor,constant: 50).isActive = true
        nameTextFieldInput.heightAnchor.constraint(equalTo: createCardNewView.heightAnchor,multiplier: 0.1).isActive = true
           nameTextFieldInput.widthAnchor.constraint(equalTo: createCardNewView.widthAnchor,multiplier: 0.6).isActive = true
        
             
            let textFieldInput = UITextField()
            textFieldInput.layer.borderColor = UIColor.white.cgColor
            textFieldInput.layer.borderWidth = 1
            textFieldInput.layer.cornerRadius = 2
                
            textFieldInput.placeholder = "Card Description"
                
            textFieldInput.font = UIFont(name: "Herculanum",size: 16)!
            textFieldInput.borderStyle = UITextField.BorderStyle.roundedRect
            textFieldInput.autocorrectionType = UITextAutocorrectionType.no
            textFieldInput.keyboardType = UIKeyboardType.default
            textFieldInput.returnKeyType = UIReturnKeyType.done
            textFieldInput.clearButtonMode = UITextField.ViewMode.whileEditing
            textFieldInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            textFieldInput.addTarget(self, action: #selector(getDescText), for: .editingChanged)
            textFieldInput.delegate = self
            
            createCardNewView.addSubview(textFieldInput)
                
            textFieldInput.translatesAutoresizingMaskIntoConstraints = false
            textFieldInput.centerXAnchor.constraint(equalTo: createCardNewView.centerXAnchor).isActive = true
            textFieldInput.topAnchor.constraint(equalTo: nameTextFieldInput.bottomAnchor,constant: 20).isActive = true
            textFieldInput.heightAnchor.constraint(equalTo: createCardNewView.heightAnchor,multiplier: 0.1).isActive = true
           textFieldInput.widthAnchor.constraint(equalTo: createCardNewView.widthAnchor,multiplier: 0.6).isActive = true
                
        //
        
        
        
                  let linkFieldInput = UITextField()
                  linkFieldInput.layer.borderColor = UIColor.white.cgColor
                  linkFieldInput.layer.borderWidth = 1
                  linkFieldInput.layer.cornerRadius = 2
                      
                  linkFieldInput.placeholder = "Link"
                      
                  linkFieldInput.font = UIFont(name: "Herculanum",size: 16)!
                  linkFieldInput.borderStyle = UITextField.BorderStyle.roundedRect
                  linkFieldInput.autocorrectionType = UITextAutocorrectionType.no
                  linkFieldInput.keyboardType = UIKeyboardType.default
                  linkFieldInput.returnKeyType = UIReturnKeyType.done
                  linkFieldInput.clearButtonMode = UITextField.ViewMode.whileEditing
                  linkFieldInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                  linkFieldInput.addTarget(self, action: #selector(getLinkText), for: .editingChanged)
                  linkFieldInput.delegate = self
                  
                  createCardNewView.addSubview(linkFieldInput)
                      
                  linkFieldInput.translatesAutoresizingMaskIntoConstraints = false
                  linkFieldInput.centerXAnchor.constraint(equalTo: createCardNewView.centerXAnchor).isActive = true
                  linkFieldInput.topAnchor.constraint(equalTo: textFieldInput.bottomAnchor,constant: 20).isActive = true
                  linkFieldInput.heightAnchor.constraint(equalTo: createCardNewView.heightAnchor,multiplier: 0.1).isActive = true
                 linkFieldInput.widthAnchor.constraint(equalTo: createCardNewView.widthAnchor,multiplier: 0.6).isActive = true
                      
              //
        
             let submitButton: UIButton = UIButton(frame: CGRect(x:createCardNewView.frame.width/2,y:createCardNewView.frame.height/2,width:0,height:0))
             
                 submitButton.backgroundColor = .black
                 submitButton.layer.borderColor = UIColor.white.cgColor
                 submitButton.layer.borderWidth = 1
                 submitButton.addTarget(self, action: #selector(submitInfo), for: .touchUpInside)
                 submitButton.setTitle("Submit Card",for:.normal)
                 submitButton.titleLabel?.font! = UIFont(name: "Herculanum",size: 16)!
                 
                 
             
                 createCardNewView.addSubview(submitButton)
                     
                 submitButton.translatesAutoresizingMaskIntoConstraints = false
             submitButton.centerXAnchor.constraint(equalTo: createCardNewView.centerXAnchor).isActive = true
                 submitButton.topAnchor.constraint(equalTo: linkFieldInput.bottomAnchor,constant: 40).isActive = true
                 submitButton.heightAnchor.constraint(equalTo: createCardNewView.heightAnchor,multiplier: 0.08).isActive = true
             submitButton.widthAnchor.constraint(equalTo: createCardNewView.heightAnchor,multiplier: 0.4).isActive = true
             

                   UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 11, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                       self.view.layoutIfNeeded()
                   }, completion: nil)
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("hello world")
    }
    
    
    
    @objc func backTap() {
//        self.performSegue(withIdentifier: "profileToFire", sender: self)
        dismiss(animated:false,completion:nil)
    }
//
    @objc func exitCard(_ sender: UITapGestureRecognizer? = nil) {
        
        cardCurrentlyDisplayed = false
        if(didBeingEnteringTextBool == true){
            self.view.endEditing(true)
            didBeingEnteringTextBool = false
            return
        }
        if(sender != nil){
            print("removing!")
            sender!.view!.removeFromSuperview()
        }
    }
    
    
    

    
       
    var container: NSPersistentContainer!

//make sure the correct functions are being exectued in laod view v.s. view did load.....
    override func loadView() {
        super.loadView()

        //where do you add view and load view ...might set up here
        // Do any additional setup after loading the view.
    }
    
   
    var personalImagesObj: PersonalImages!
    var trendingImagesObj:TrendingImages!
    var trendinglabel:UILabel!
    
    override func viewDidLoad() {

        trendinglabel = UILabel()
        trendinglabel.text = profileRank
        trendinglabel.textColor = .green
        trendinglabel.textAlignment = .center
        
        view.addSubview(profileButton)
        view.addSubview(createCardButton)
        view.addSubview(loadingView)
        view.addSubview(toggleContainerView)
        view.addSubview(masterView)
        view.addSubview(backButton)
        view.addSubview(trendinglabel)
        setUpProfileButton()
        setUpbackButton()
        setUpCreateCardButton()
        setUpTrendingNumber()
        self.setUpTable()
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        if(self.personalImagesObj.updated == false) {
            print("waiting")
            showSpinner(onView: masterView)
        }
    }
    

    
    private func setUpTable() {
        if #available(iOS 10.0, *) {
                 tableViewBoard.refreshControl = refreshControl
                     } else {
                 tableViewBoard.addSubview(refreshControl)
             }
        refreshControl.addTarget(self, action: #selector(refreshBoard(_:)), for: .valueChanged)
            profileTableArray = personalImagesObj.cardArray
            masterView.addSubview(tableViewBoard)
            setUpMasterView()
            tableViewBoard.dataSource = self
            tableViewBoard.register(UITableViewCell.self, forCellReuseIdentifier: "fireCards")
            tableViewBoard.reloadData()
        
       }
       
    

    let toggleContainerView: UIButton = {
        let toggle = UIButton()
        toggle.backgroundColor = .black
        toggle.layer.borderWidth = 1
        toggle.layer.borderColor = UIColor.white.cgColor
        toggle.setTitle("My Cards", for: .normal)
        toggle.titleLabel?.textColor = .white
        toggle.titleLabel?.font! = UIFont(name: "Herculanum",size: 16)!
        toggle.addTarget(self, action: #selector(changeToggle), for: .touchUpInside)
        return toggle
        
    }()
    
    
    let tableViewBoard: UITableView = {
        print("adding tableview!")
        let tv = UITableView(frame: CGRect(x: 40, y: 35, width: 0, height: 0))
        tv.backgroundColor = .red
        tv.layer.borderColor = UIColor.white.cgColor
        tv.layer.borderWidth = 20
        tv.layer.cornerRadius = 8
     
        return tv
    }()
    
    let loadingView: UIView = {
        let lView = UIView()
        lView.layer.borderColor = UIColor.green.cgColor
        lView.backgroundColor = .green
        lView.translatesAutoresizingMaskIntoConstraints = false
        return lView
    }()
    

    
    func addCardView(card:Int,tableSource:[RankCardObj],index:Int) {
        if(cardCurrentlyDisplayed == true) {
            return;
        }
             cardCurrentlyDisplayed = true
                    
                    let newView = UIView(frame:CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 0, height: 0))

                    newView.backgroundColor = UIColor.black

                    let cardTap = UITapGestureRecognizer(target: self, action: #selector(self.exitCard(_:)))
                    newView.addGestureRecognizer(cardTap)

                    let imageHolder = UIImageView.init(frame: CGRect(x: newView.frame.width/2, y: newView.frame.height/2, width: 0, height: 0))
                    imageHolder.image = tableSource[index].img



                    imageHolder.backgroundColor = UIColor.red
                    newView.addSubview(imageHolder)
                    imageHolder.translatesAutoresizingMaskIntoConstraints = false

                    imageHolder.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
                    imageHolder.topAnchor.constraint(equalTo: newView.topAnchor,constant: 25).isActive = true
                    imageHolder.widthAnchor.constraint(equalTo: newView.widthAnchor,multiplier: 0.8).isActive = true
                    imageHolder.heightAnchor.constraint(equalTo: newView.heightAnchor,multiplier: 0.5).isActive = true

                    self.view.addSubview(newView)

                    newView.layer.borderColor = UIColor.white.cgColor
                    newView.layer.borderWidth = 1
                    newView.layer.cornerRadius = 8

                    newView.translatesAutoresizingMaskIntoConstraints = false
                    newView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:15).isActive = true
                    newView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15).isActive = true
                    newView.topAnchor.constraint(equalTo: view.topAnchor,constant: 70).isActive = true
                    newView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.8).isActive = true


            //
                    var textView = UIView(frame: CGRect(x: 0 , y: 0, width: newView.frame.width, height: newView.frame.height))
                                    //
                        newView.addSubview(textView)
                                    
                                textView.translatesAutoresizingMaskIntoConstraints = false
                                textView.bottomAnchor.constraint(equalTo: newView.bottomAnchor,constant:-10).isActive = true
                                textView.widthAnchor.constraint(equalTo: newView.widthAnchor,multiplier:0.85).isActive = true
                                textView.heightAnchor.constraint(equalTo: newView.heightAnchor,multiplier:0.3).isActive = true
                                textView.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
                                            
                                
                                textView.layer.borderColor = UIColor.white.cgColor
                                textView.layer.borderWidth = 1
                                textView.layer.cornerRadius = 8
                                
                                var titleView = UILabel()
                                titleView.text = tableSource[index].title
                                titleView.font! = UIFont(name: "Herculanum",size: 22)!
                                textView.addSubview(titleView)
                    //            titleView.backgroundColor = .green
                                titleView.textAlignment = .center
                                
                                titleView.translatesAutoresizingMaskIntoConstraints = false
                                titleView.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
                                titleView.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
                                titleView.heightAnchor.constraint(equalTo: textView.heightAnchor,multiplier:0.3).isActive = true
                                titleView.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
                                titleView.textColor = .white
                                
                                
                                let descView = UILabel()
                                descView.text = tableSource[index].descText
                                descView.font! = UIFont(name: "Herculanum",size: 18)!
                                textView.addSubview(descView)
                    //            descView.backgroundColor = .blue
                                descView.textAlignment = .center
                                descView.textColor = .white
                                
                                descView.translatesAutoresizingMaskIntoConstraints = false

                                descView.topAnchor.constraint(equalTo: titleView.bottomAnchor,constant:5).isActive = true
                                descView.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
                                descView.heightAnchor.constraint(equalTo: textView.heightAnchor,multiplier:0.3).isActive = true
                                descView.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
                    //
                                
                                let linkView = UIButton()
                                linkView.setTitle("Originn", for: .normal)
                                linkView.titleLabel!.font = UIFont(name: "Herculanum",size: 18)!
                                textView.addSubview(linkView)
                    //            linkView.backgroundColor = .red
                                linkView.titleLabel!.textAlignment = .center

                                
                                linkView.translatesAutoresizingMaskIntoConstraints = false
                                linkView.topAnchor.constraint(equalTo: descView.bottomAnchor,constant:5).isActive = true
                                linkView.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
                                linkView.heightAnchor.constraint(equalTo: textView.heightAnchor,multiplier:0.3).isActive = true
                                linkView.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
                    

                            let rankLabel = UILabel()
                          
                            let degreeText = tableSource[index].rankTxt + "°"
                            rankLabel.text = degreeText
                            rankLabel.textColor = .orange
                            newView.addSubview(rankLabel)
                                //
                            rankLabel.translatesAutoresizingMaskIntoConstraints = false
                            rankLabel.font! = UIFont(name: "Herculanum",size: 18)!
                            rankLabel.bottomAnchor.constraint(equalTo: textView.topAnchor,constant:-20).isActive = true
                            rankLabel.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 80).isActive = true
                                            
                                            
                            let authorLabel = UILabel()
                            authorLabel.text = tableSource[index].authorTxt
                            authorLabel.textColor = .white
                            authorLabel.font! = UIFont(name: "Herculanum",size: 12)!
                            newView.addSubview(authorLabel)
                    //
                                authorLabel.translatesAutoresizingMaskIntoConstraints = false
                                authorLabel.bottomAnchor.constraint(equalTo: textView.topAnchor,constant:-20).isActive = true
                                authorLabel.trailingAnchor.constraint(equalTo: newView.trailingAnchor, constant: -40).isActive = true
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 11, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                        self.view.layoutIfNeeded()
                    }, completion: nil)
    }
    
    
  
    func setUpMasterView() {
        masterView.translatesAutoresizingMaskIntoConstraints = false
        
        masterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        masterView.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.8).isActive = true
        masterView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.5).isActive = true
        masterView.topAnchor.constraint(equalTo: toggleContainerView.bottomAnchor, constant: 10).isActive = true
        

        masterView.layer.borderWidth = 10.0
        
        
        masterView.addSubview(tableViewBoard)
        tableViewBoard.dataSource = self
        setUpTableView()
        
    }
    
    func setUptoggleContainerView() {
        toggleContainerView.translatesAutoresizingMaskIntoConstraints = false
        toggleContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toggleContainerView.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.5).isActive = true
        toggleContainerView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.04).isActive = true
        toggleContainerView.topAnchor.constraint(equalTo: createCardButton.bottomAnchor, constant: 60).isActive = true
    }
    func setUpTableView(){
        tableViewBoard.delegate = self
    
        tableViewBoard.translatesAutoresizingMaskIntoConstraints = false
        tableViewBoard.widthAnchor.constraint(equalTo: masterView.widthAnchor).isActive = true
        tableViewBoard.heightAnchor.constraint(equalTo: masterView.heightAnchor).isActive = true
        tableViewBoard.topAnchor.constraint(equalTo: masterView.topAnchor).isActive = true
        

        tableViewBoard.layer.borderWidth = 3.0
        tableViewBoard.layer.cornerRadius = 20
        
    }
    
    private func setUpProfileButton(){
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15).isActive = true
        profileButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
      }
    
    private func setUpTrendingNumber(){
        trendinglabel.translatesAutoresizingMaskIntoConstraints = false
        trendinglabel.topAnchor.constraint(equalTo:profileButton.bottomAnchor).isActive = true
        trendinglabel.leadingAnchor.constraint(equalTo: profileButton.leadingAnchor).isActive = true
        trendinglabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        trendinglabel.widthAnchor.constraint(equalTo:profileButton.widthAnchor).isActive = true
    }
    
    func setUpbackButton(){
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        backButton.layer.borderWidth = 2.0
    }
    func setUpCreateCardButton() {
        createCardButton.translatesAutoresizingMaskIntoConstraints = false
        createCardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createCardButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.4).isActive = true
        createCardButton.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 20).isActive = true
        createCardButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        createCardButton.layer.borderWidth = 2.0
        setUptoggleContainerView()
    }
    
    
    
}


extension ProfileViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
//        print("TextField should begin editing method called")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        didBeingEnteringTextBool = true
//        print("TextField did begin editing method called")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//        print("TextField should snd editing method called")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//        print("TextField did end editing method called")
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
//        print("TextField did end editing with reason method called")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
//        print("While entering the characters this method gets called")
//        print(range)
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
//        print("TextField should clear method called")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        
//        self.view.endEditing(true)
        didBeingEnteringTextBool = false
//        print("TextField should return method called")
        textField.resignFirstResponder()
        return true
    }

}



                  

             // perform some initialization here
            

    
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        let tappedCell = tableView.cellForRow(at:indexPath)
        if(toggleOnFire == false) {
            addCardView(card:indexPath.row,tableSource:profileTableArray,index:indexPath.row)
        } else {
            addCardView(card:indexPath.row,tableSource:trendingImagesObj.cardArray,index:indexPath.row)
        }
        
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Make the first row larger to accommodate a custom cell.
        // Use the default size for all other rows.
        return 60
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(toggleOnFire == true) {
            return trendingImagesObj.cardArray.count
        } else {
            return profileTableArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        
        // Configure the cell’s contents.
        
        if(toggleOnFire == true && trendingImagesObj.updated == true){
            print("changing to trending imgs!")
            print(trendingImagesObj.cardArray)
            let cell = tableView.dequeueReusableCell(withIdentifier: "trending", for: indexPath)
            cell.textLabel!.text = trendingImagesObj.cardArray[indexPath.row].descText
            cell.imageView!.image = trendingImagesObj.cardArray[indexPath.row].img
            cell.imageView!.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 0.25).isActive = true
            cell.imageView!.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            cell.imageView!.translatesAutoresizingMaskIntoConstraints = false
            cell.imageView!.clipsToBounds = true
            cell.textLabel!.textAlignment = .center
            cell.textLabel!.widthAnchor.constraint(equalTo: tableView.widthAnchor,multiplier: 0.75).isActive = true
            cell.textLabel!.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            cell.textLabel!.leadingAnchor.constraint(equalTo: cell.imageView!.trailingAnchor).isActive = true
            cell.textLabel!.font! = UIFont(name: "Herculanum",size: 16)!
            cell.textLabel!.translatesAutoresizingMaskIntoConstraints = false
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "fireCards", for: indexPath)
        cell.textLabel!.text = profileTableArray[indexPath.row].descText
        cell.imageView!.image = profileTableArray[indexPath.row].img
        cell.imageView!.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 0.25).isActive = true
        cell.imageView!.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        cell.imageView!.translatesAutoresizingMaskIntoConstraints = false
        
        cell.imageView!.clipsToBounds = true
        
        
        cell.textLabel!.textAlignment = .center
        cell.textLabel!.lineBreakMode = .byCharWrapping
        cell.textLabel!.numberOfLines = 3
        
        
        cell.textLabel!.widthAnchor.constraint(equalTo: tableView.widthAnchor,multiplier: 0.75).isActive = true
        cell.textLabel!.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        cell.textLabel!.leadingAnchor.constraint(equalTo: cell.imageView!.trailingAnchor).isActive = true
        cell.textLabel!.font! = UIFont(name: "Herculanum",size: 16)!
        cell.textLabel!.translatesAutoresizingMaskIntoConstraints = false
                
        return cell
        
    }
    
}
//
//
//

//
//  ProfileViewControleler.swift
//  TrendingFire
//
//  Created by Alex D'Agostino on 8/11/19.
//  Copyright © 2019 Alex D'Agostino. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewControleler: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var textPassedOver: String?
    
    
    @objc func backFireTap() {
        print("going back to main screen.!")
        self.performSegue(withIdentifier: "backToMainFromProfile", sender: self)
    }
    
    @objc func createCard() {
        print("create card")
    }
    
    
    
    let backToFireButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
//        button.setImage(UIImage(named: "profileicon"), for: .normal)
        button.addTarget(self, action: #selector(backFireTap), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let createCardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.green
        //        button.setImage(UIImage(named: "profileicon"), for: .normal)
        button.addTarget(self, action: #selector(createCard), for: .touchUpInside)
        //        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var imagesInPersonalBoard: [UIImage] = []
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    
    private func setUpTable(arr:[UIImage]){
        
        for index in 0..<arr.count {
            imagesInPersonalBoard.append(arr[index])
        }
        
        view.addSubview(tableViewBoard)
        tableViewBoard.delegate = self
        tableViewBoard.dataSource = self
        tableViewBoard.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadingView.removeFromSuperview()
        setUpTableView()
    }
    
    
    
    private func getCards() {
        var imageArray: [UIImage] = []
        Alamofire.request("https://frozen-temple-71617.herokuapp.com/cards", method:.get).responseJSON {
            response in
            if response.result.isSuccess {
                print("SUCCESS!")
                var responseData = JSON(response.result.value!)
                for index in 0..<responseData.count {
                    //                    let urlString = String(describing: responseData[index]["pic"])
                    //                    let url = NSURL(string: urlString)! as URL
                    //                    let imageData: NSData = NSData(contentsOf: url)
                    //                    array.append(UIImage(data:imageData)
                    var image: UIImage?
                    let urlString = responseData[index]["pic"]
                    let url = NSURL(string: String(describing: responseData[index]["pic"]))! as URL
                    if let imageData: NSData = NSData(contentsOf: url) {
                        image = UIImage(data: imageData as Data)
                    }
                    imageArray.append(image!)
                    
                }
                print("got urls")
                self.setUpTable(arr:imageArray)
            }
            else {
                print("failure to retreieve cards")
                print(response.result.error!)
            }
        }
    }
    
    
    
    
    
    

//make sure the correct functions are being exectued in laod view v.s. view did load.....
    override func loadView() {
        super.loadView()
        getCards()
        view.addSubview(backToFireButton)
        view.addSubview(createCardButton)
        view.addSubview(loadingView)
        setUpBackButton()
        setUpLoadingView()
        setUpCreateCardButton()
//        view.addSubview(tableViewBoard)
//        tableViewBoard.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableViewBoard.delegate = self
//        tableViewBoard.dataSource = self
//        setUpTableView()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLoad() {
//        let pickerController = UIImagePickerController()
//        pickerController.delegate = self
//        pickerController.allowsEditing = true
//        pickerController.mediaTypes = ["public.image", "public.movie"]
//        pickerController.sourceType = .camera
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedCell = tableView.cellForRow(at:indexPath)
        addCardView(card:animals[indexPath.row],imageName:imagesInPersonalBoard[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Make the first row larger to accommodate a custom cell.
        // Use the default size for all other rows.
        return 100
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell’s contents.
        
        cell.textLabel!.text = animals[indexPath.row]
        cell.imageView!.image = imagesInPersonalBoard[indexPath.row]
        return cell
    }

    @objc func backTap() {
        print("going back to main screen.!")
        self.performSegue(withIdentifier: "backToMainFromLeaderBoard", sender: self)
    }
    
    @objc func exitCard(_ sender: UITapGestureRecognizer? = nil) {
        
        if(sender != nil){
            sender!.view!.removeFromSuperview()
        }
        
    }
    
    
    
    let tableViewBoard: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    let loadingView: UIView = {
        let lView = UIView()
        lView.layer.borderColor = UIColor.green.cgColor
        lView.backgroundColor = .red
        lView.translatesAutoresizingMaskIntoConstraints = false
        return lView
    }()
    
    
    func addCardView(card:String,imageName:UIImage) {
        let newView = UIView(frame:CGRect(x: 200, y: 300, width: 0, height: 0))
        newView.backgroundColor = UIColor.yellow
        let cardTap = UITapGestureRecognizer(target: self, action: #selector(self.exitCard(_:)))
        newView.addGestureRecognizer(cardTap)
        
        let imageHolder = UIImageView.init(image: imageName)
        newView.addSubview(imageHolder)
        imageHolder.translatesAutoresizingMaskIntoConstraints = false
        
        imageHolder.bottomAnchor.constraint(equalTo: newView.bottomAnchor,constant: -200).isActive = true
        imageHolder.leadingAnchor.constraint(equalTo: newView.leadingAnchor,constant: 35).isActive = true
        imageHolder.trailingAnchor.constraint(equalTo: newView.trailingAnchor,constant: -35).isActive = true
        imageHolder.topAnchor.constraint(equalTo: newView.topAnchor,constant: 15).isActive = true
        
        
        
        let cardName = UILabel()
        cardName.text = card
        cardName.textAlignment = .center
        
        cardName.layer.borderColor = UIColor.white.cgColor
        cardName.layer.borderWidth = 3
        cardName.layer.cornerRadius = 13
        newView.addSubview(cardName)
        
        cardName.translatesAutoresizingMaskIntoConstraints = false
        cardName.topAnchor.constraint(equalTo: imageHolder.bottomAnchor,constant:20).isActive = true
        cardName.trailingAnchor.constraint(equalTo: newView.trailingAnchor,constant:-25).isActive = true
        cardName.leadingAnchor.constraint(equalTo: newView.leadingAnchor,constant: 25).isActive = true
        cardName.bottomAnchor.constraint(equalTo: newView.bottomAnchor,constant:-20).isActive = true
        
        
        
        
        self.view.addSubview(newView)
        
        newView.layer.borderColor = UIColor.white.cgColor
        newView.layer.borderWidth = 5
        newView.layer.cornerRadius = 13
        
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:15).isActive = true
        newView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15).isActive = true
        newView.topAnchor.constraint(equalTo: view.topAnchor,constant: 150).isActive = true
        newView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100).isActive = true
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 11, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func setUpTableView(){
        tableViewBoard.translatesAutoresizingMaskIntoConstraints = false
        tableViewBoard.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50).isActive = true
        tableViewBoard.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        tableViewBoard.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true
        tableViewBoard.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100).isActive = true
        tableViewBoard.layer.borderWidth = 2.0
    }
    func setUpBackButton(){
        backToFireButton.translatesAutoresizingMaskIntoConstraints = false
        backToFireButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50).isActive = true
        backToFireButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        backToFireButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        //        button.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100).isActive = true
        backToFireButton.layer.borderWidth = 2.0
    }
    private func setUpLoadingView() {
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 75).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -75).isActive = true
//        loadingView.topAnchor.constraint(equalTo: createCardButton.bottomAnchor, constant: 250).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50).isActive = true
    }
    
    func setUpCreateCardButton() {
        
        createCardButton.translatesAutoresizingMaskIntoConstraints = false
        createCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50).isActive = true
        createCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        createCardButton.topAnchor.constraint(equalTo: backToFireButton.bottomAnchor, constant: 50).isActive = true
        createCardButton.bottomAnchor.constraint(equalTo: loadingView.topAnchor,constant: -50).isActive = true
        createCardButton.layer.borderWidth = 2.0
    }
    
    
    
    
    
}

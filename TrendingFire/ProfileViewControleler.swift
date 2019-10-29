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
    
    var descArray: [String] = []
    var rankArray: [String] = []
    var authorArray: [String] = []
    
    var textPassedOver: String?
    
    
    @objc func backFireTap() {
        dismiss(animated:true,completion:nil)
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
 
    
    private func setUpTable(arr:[UIImage]){
        
        for index in 0..<arr.count {
            imagesInPersonalBoard.append(arr[index])
        }
        
        view.addSubview(tableViewBoard)
        tableViewBoard.delegate = self
        tableViewBoard.dataSource = self
        tableViewBoard.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setUpTableView()
    }
    
    
    
    private func getCards() {
        var imageArray: [UIImage] = []
        Alamofire.request("https://agile-dusk-73308.herokuapp.com/cards", method:.get).responseJSON {
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
                    self.descArray.append(String(describing: responseData[index]["desc"]))
                    self.rankArray.append(String(describing: responseData[index]["rank"]))
                    self.authorArray.append(String(describing: responseData[index]["author"]))
                    
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
//        view.addSubview(createCardButton)
        view.addSubview(loadingView)
        setUpBackButton()
        setUpLoadingView()
//        setUpCreateCardButton()
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
        addCardView(card:indexPath.row,imageName:imagesInPersonalBoard[indexPath.row])
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
        
        cell.textLabel!.text = descArray[indexPath.row]
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
        lView.backgroundColor = .green
        lView.translatesAutoresizingMaskIntoConstraints = false
        return lView
    }()
    
    
    func addCardView(card:Int,imageName:UIImage) {
        let newView = UIView(frame:CGRect(x: 200, y: 300, width: 0, height: 0))
        newView.backgroundColor = UIColor.black
        
        let cardTap = UITapGestureRecognizer(target: self, action: #selector(self.exitCard(_:)))
        newView.addGestureRecognizer(cardTap)
        
        let imageHolder = UIImageView.init(image: imageName)
        newView.addSubview(imageHolder)
        imageHolder.translatesAutoresizingMaskIntoConstraints = false
        
        imageHolder.leadingAnchor.constraint(equalTo: newView.leadingAnchor,constant: 35).isActive = true
        imageHolder.trailingAnchor.constraint(equalTo: newView.trailingAnchor,constant: -35).isActive = true
        imageHolder.topAnchor.constraint(equalTo: newView.topAnchor,constant: 15).isActive = true
        imageHolder.heightAnchor.constraint(equalTo: newView.heightAnchor,multiplier: 0.5).isActive = true
        
//
//
//
        
        self.view.addSubview(newView)
        
        newView.layer.borderColor = UIColor.white.cgColor
        newView.layer.borderWidth = 5
        newView.layer.cornerRadius = 13
        
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:15).isActive = true
        newView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15).isActive = true
        newView.topAnchor.constraint(equalTo: view.topAnchor,constant: 70).isActive = true
        newView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.8).isActive = true
        
        
        
        let rankLabel = UILabel(frame:CGRect(x: 100, y: 20, width: 150, height: 30))
        let degreeText = self.rankArray[card] + "°"
        rankLabel.text = degreeText
        rankLabel.textColor = .orange
        newView.addSubview(rankLabel)
        //
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.topAnchor.constraint(equalTo: imageHolder.bottomAnchor,constant:15).isActive = true
        rankLabel.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 175).isActive = true
                    
        let authorLabel = UILabel(frame:CGRect(x: 10, y: 40, width: 150, height: 30))
        authorLabel.text = self.authorArray[card]
        authorLabel.textColor = .white
        newView.addSubview(authorLabel)
                    
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.topAnchor.constraint(equalTo: imageHolder.bottomAnchor,constant:25).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: newView.trailingAnchor, constant: -40).isActive = true
                    
 
        
    var textView = UIView(frame: CGRect(x: newView.frame.minX - 10 , y: newView.frame.minY, width: newView.frame.width, height: newView.frame.height))
            newView.addSubview(textView)
            
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.topAnchor.constraint(equalTo: imageHolder.bottomAnchor,constant:55).isActive = true
            textView.trailingAnchor.constraint(equalTo: newView.trailingAnchor,constant:-25).isActive = true
            textView.leadingAnchor.constraint(equalTo: newView.leadingAnchor,constant: 25).isActive = true
        textView.heightAnchor.constraint(equalTo: newView.heightAnchor,multiplier:0.3).isActive = true
        
            textView.layer.borderColor = UIColor.white.cgColor
            textView.layer.borderWidth = 3
            textView.layer.cornerRadius = 13
                
                        
            let cardLabel = UILabel(frame:CGRect(x: 10, y: 20, width: textView.frame.width, height: 20))
            cardLabel.text = self.descArray[card]
            cardLabel.textColor = .white
            cardLabel.backgroundColor = .black
            cardLabel.contentMode = .scaleAspectFill
            textView.addSubview(cardLabel)
            
            
            cardLabel.translatesAutoresizingMaskIntoConstraints = false
            cardLabel.topAnchor.constraint(equalTo: textView.topAnchor,constant:15).isActive = true
            cardLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor,constant:10).isActive = true
            cardLabel.widthAnchor.constraint(equalToConstant: 275).isActive = true
            cardLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 11, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func setUpTableView(){
        tableViewBoard.translatesAutoresizingMaskIntoConstraints = false
        tableViewBoard.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50).isActive = true
        tableViewBoard.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        tableViewBoard.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        tableViewBoard.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.6).isActive = true

        tableViewBoard.layer.borderWidth = 2.0
        
        loadingView.removeFromSuperview()
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
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        loadingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
    }
    
//    func setUpCreateCardButton() {
//        createCardButton.translatesAutoresizingMaskIntoConstraints = false
//        createCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50).isActive = true
//        createCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
//        createCardButton.topAnchor.constraint(equalTo: backToFireButton.bottomAnchor, constant: 50).isActive = true
//        createCardButton.bottomAnchor.constraint(equalTo: loadingView.topAnchor,constant: -25).isActive = true
//        createCardButton.layer.borderWidth = 2.0
//    }
//
    
    
}

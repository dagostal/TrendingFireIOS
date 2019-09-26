//
//  FireBoard.swift
//  TrendingFire
//
//  Created by Alex D'Agostino on 9/7/19.
//  Copyright © 2019 Alex D'Agostino. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FireBoard: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let imagesInLeaderBoard: [UIImage] = []
    
    @objc func backTap() {
        print("going back to main screen.!")
        self.performSegue(withIdentifier: "backToMainFromLeaderBoard", sender: self)
    }
    
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    var imagesForTable: [UIImage] = []
    
    
    func setUpTable(arr:[UIImage]){

            for index in 0..<arr.count {
                imagesForTable.append(arr[index])
            }
        
            view.addSubview(tableViewBoard)
            tableViewBoard.delegate = self
            tableViewBoard.dataSource = self
            tableViewBoard.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            loadingView.removeFromSuperview()
            setUpTableView()
    }
    
  
    
    func getCards() {
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
    
    
    
    let backToFireButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: 20, width: 100, height: 50))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(backTap), for: .touchUpInside)
        //        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override func loadView() {

        super.loadView()
        view.addSubview(backToFireButton)
        view.addSubview(loadingView)
        // Do any additional setup after loading the view.
    }
    override func viewDidLoad() {
        getCards()
        setUpLoadingView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell’s contents.
    
        cell.textLabel!.text = animals[indexPath.row]
        cell.imageView!.image = imagesForTable[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedCell = tableView.cellForRow(at:indexPath)
        addCardView(card:animals[indexPath.row],imageName:imagesForTable[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Make the first row larger to accommodate a custom cell.
        // Use the default size for all other rows.
        return 100
    }
    
    
    @objc func exitCard(_ sender: UITapGestureRecognizer? = nil) {
        
        if(sender != nil){
            sender!.view!.removeFromSuperview()
        }
        
    }
    
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
        tableViewBoard.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        tableViewBoard.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100).isActive = true
        tableViewBoard.layer.borderWidth = 2.0
    }
    private func setUpLoadingView() {
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 75).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -75).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -250).isActive = true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
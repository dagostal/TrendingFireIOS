//
//  ViewController.swift
//  TrendingFire
//
//  Created by Alex D'Agostino on 8/10/19.
//  Copyright © 2019 Alex D'Agostino. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON




var numberOfCards: Int = 5

class ViewController: UIViewController {
    
        fileprivate var dataSource: [[String:String]] = {
            var array: [[String:String]] = []
            for index in 0..<numberOfCards {
                array.append(["img":"image\((index + 1))"])
            }
            return array
        }()
    
    fileprivate var imageArr: [UIImage] = []
    fileprivate var tapped: Bool = false
    //
    
    
    func assignCards(arr: [[String:String]],reff:Bool) {
        if(reff == true) {
            for i in 0..<arr.count {
                dataSource.append(arr[i])
            }
            let position = myKolodaView.currentCardIndex
            myKolodaView.insertCardAtIndexRange(position..<position + 8, animated: true)
            loadingView.removeFromSuperview()
        } else {
            self.dataSource = arr
            print("setting up cards...")
            setUpKoloda()
            myKolodaView.delegate = self
            myKolodaView.dataSource = self
            myKolodaView.visibleCardsDirection = .top
            loadingView.removeFromSuperview()
        }
    }
    

    func getCards(refresh:Bool) {
        if(refresh == true) {
            var cardArray: [[String:String]] = []
            Alamofire.request("https://agile-dusk-73308.herokuapp.com/cards", method:.get).responseJSON {
                response in
                if response.result.isSuccess {
                    print("SUCCESS!")
                    let responseData = JSON(response.result.value!)
                    for index in 0..<responseData.count {
                        let urlString = String(describing: responseData[index]["pic"])
                        let descText = String(describing: responseData[index]["desc"])
                        let rankTxt = String(describing: responseData[index]["rank"])
                        let authorTxt = String(describing: responseData[index]["author"])
                        let card = [ "img" : urlString,"desc" : descText,"rank":rankTxt,"author":authorTxt]
                        cardArray.append(card)
                        
                        var imageForCard: UIImage?
                        let url = NSURL(string: urlString)! as URL
                        if let imageData: NSData = NSData(contentsOf: url) {
                                print("generating image..")
                                imageForCard = UIImage(data: imageData as Data)
                        }
                        self.imageArr.append(imageForCard!)
                    }
                    
                    //the UIImages need to be premade...ideally here...so the loadscreen will be viewed as x num of cards pulled from database are turned into UIImage objs, so there is no lag with the swipe. what data sctructure would best do this? i want to ideally keep the images with the desc,rank,author, ect, but image in uiimage and others are strings. dictionaries?
                  
                    
                    self.assignCards(arr:cardArray,reff:refresh)
                } else {
                    print("error in request")
                    return;
                }
            }
        }
        else {
        var cardArray: [[String:String]] = []
                Alamofire.request("https://agile-dusk-73308.herokuapp.com/cards", method:.get).responseJSON {
                    response in
                    if response.result.isSuccess {
                        print("success! got data")
                        let responseData = JSON(response.result.value!)
                        for index in 0..<responseData.count {
                            let urlString = String(describing: responseData[index]["pic"])
                            let descText = String(describing: responseData[index]["desc"])
                            let rankTxt = String(describing: responseData[index]["rank"])
                            let authorTxt = String(describing: responseData[index]["author"])
                            let card = [ "img" : urlString,"desc" : descText,"rank":rankTxt,"author":authorTxt]
                            cardArray.append(card)
                            
                             var imageForCard: UIImage?
                             let url = NSURL(string: urlString)! as URL
                             if let imageData: NSData = NSData(contentsOf: url) {
                                        print("generating image..")
                                        imageForCard = UIImage(data: imageData as Data)
                                }
                        self.imageArr.append(imageForCard!)
                            
                        }

                        //the UIImages need to be premade...ideally here...so the loadscreen will be viewed as x num of cards pulled from database are turned into UIImage objs, so there is no lag with the swipe. what data sctructure would best do this? i want to ideally keep the images with the desc,rank,author, ect, but image in uiimage and others are strings. dictionaries?
                        self.assignCards(arr:cardArray,reff:refresh)
                    } else {
                        print("error in request")
                        return;
                    }
                }
        }
    }
    
//
    @objc func profileImageTap() {
        self.performSegue(withIdentifier: "move1", sender: self)
    }
    
    @objc func fireBoardButtonTap() {
        self.performSegue(withIdentifier: "move2", sender: self)
    }
    
    @objc func rightButtonTap() {
        myKolodaView.swipe(.right)
    }

    @objc func leftButtonTap() {
        myKolodaView.swipe(.left)
    }
//
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profileicon"), for: .normal)
        button.addTarget(self, action: #selector(profileImageTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    let fireBoardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rank"), for: .normal)
        button.addTarget(self, action: #selector(fireBoardButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let trendingFireLabelView: UILabel = {
        let label = UILabel()
        label.text = "Trending Fire"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let swipeRightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(rightButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let swipeLeftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(leftButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()



  

    
//    @IBOutlet weak var myKolodaView: KolodaView!
    let myKolodaView: KolodaView = {
        let kView = KolodaView()
        kView.layer.borderColor = UIColor.green.cgColor
        kView.layer.backgroundColor = UIColor.black.cgColor
        kView.translatesAutoresizingMaskIntoConstraints = false
        return kView
    }()
    
    let loadingView: UIView = {
        let lView = UIView()
        lView.backgroundColor = .blue
        lView.translatesAutoresizingMaskIntoConstraints = false
        return lView
    }()
    
    // MARK: Lifecycle

    override func loadView() {
        super.loadView()
        view.addSubview(profileButton)
        view.addSubview(fireBoardButton)
        view.addSubview(loadingView)
        view.addSubview(trendingFireLabelView)
        view.addSubview(swipeLeftButton)
        view.addSubview(swipeRightButton)
        view.addSubview(myKolodaView)
        getCards(refresh: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfileButton()
        setUpLoadingView()
        setUpFireBoardButton()
        setUpTrendingLabel()
        setUpLeftButton()
        setUpRightButton()
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory overloas")
        //dispose of resources before moving to the new controller
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toProfile") {
            let destinationViewControler = segue.destination as! ProfileViewControleler
        }
    }
    var leftAnchor: NSLayoutConstraint?
    var rightAnchor: NSLayoutConstraint?
    var topAnchor: NSLayoutConstraint?
    var bottomAnchor: NSLayoutConstraint?
    
    var widthAnchor: NSLayoutConstraint?
    var heightAnchor: NSLayoutConstraint?
    
    
    private func setUpKoloda(){
        leftAnchor = myKolodaView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50)
        leftAnchor?.isActive = true
        rightAnchor = myKolodaView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50)
        rightAnchor?.isActive = true
        topAnchor = myKolodaView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150)
        topAnchor?.isActive = true
        heightAnchor = myKolodaView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.5)
        heightAnchor?.isActive = true
    }
    
    
    
    private func setUpLoadingView() {
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        loadingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
    }
    private func setUpProfileButton(){
        profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 25).isActive = true
        profileButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    private func setUpFireBoardButton(){
        fireBoardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -25).isActive = true
        fireBoardButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        fireBoardButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        fireBoardButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    private func setUpTrendingLabel(){
        trendingFireLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 150).isActive = true
        trendingFireLabelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        trendingFireLabelView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        trendingFireLabelView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }

    private func setUpLeftButton(){
        swipeLeftButton.leadingAnchor.constraint(equalTo:view.leadingAnchor,constant: 50).isActive = true
        swipeLeftButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        swipeLeftButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        swipeLeftButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
    }
//
    private func setUpRightButton(){
        swipeRightButton.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant: -50).isActive = true
        swipeRightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        swipeRightButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        swipeRightButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
    }

//
//


    
    
    private func enlargeKoloda(){
        
        leftAnchor?.isActive = false
        rightAnchor?.isActive = false
        topAnchor?.isActive = false
        heightAnchor?.isActive = false
        

        leftAnchor = myKolodaView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:15)
        leftAnchor?.isActive = true
        rightAnchor = myKolodaView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15)
        rightAnchor?.isActive = true
        topAnchor = myKolodaView.topAnchor.constraint(equalTo: view.topAnchor,constant: 125)
        topAnchor?.isActive = true
        heightAnchor = myKolodaView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.8 )
        heightAnchor?.isActive = true
                
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
              
    }

//
    

    private func shrinkKoloda(){
        self.tapped = false
       
        leftAnchor?.isActive = false
        rightAnchor?.isActive = false
        topAnchor?.isActive = false
        heightAnchor?.isActive = false
             
        leftAnchor = myKolodaView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:50)
        leftAnchor?.isActive = true
        rightAnchor = myKolodaView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50)
        rightAnchor?.isActive = true
        topAnchor = myKolodaView.topAnchor.constraint(equalTo: view.topAnchor,constant: 150)
        topAnchor?.isActive = true
        heightAnchor = myKolodaView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.5 )
        heightAnchor?.isActive = true

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.setNeedsLayout()
        }, completion: nil)
    }
    
    
    
}

// MARK: KolodaViewDelegate
// all these extentions make the ViewControler class confrom to the two protocols....the extention is just used for organizing the code better. dont get confused.:)
extension ViewController: KolodaViewDelegate {
    //
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        getCards(refresh: true)
    }
    
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int,tappedBottomRight: Bool) {

            if(self.tapped == false){
                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                if(tappedBottomRight == true) {
                    impactFeedbackgenerator.prepare()
                    impactFeedbackgenerator.impactOccurred()
                    enlargeKoloda()
                    self.tapped = true
                }
            } else {
                print(self.tapped)
                print("already tapped")
            }
    }
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.up,.left,.right]
    }
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        shrinkKoloda()
        let params: [String: String] = [
            "swipe" : direction.rawValue,
            "card" : String(myKolodaView.currentCardIndex)
        ]
        Alamofire.request("https://agile-dusk-73308.herokuapp.com/cards", method:.post,parameters: params)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    print("SUCCESS!")
                }
        }
    }
}

// MARK: KolodaViewDataSource

extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
//        var imageForCard: UIImage?
//        let urlString = dataSource[index]["img"]!
//
//        let url = NSURL(string: String(describing: urlString))! as URL
//        if let imageData: NSData = NSData(contentsOf: url) {
//                        print("generating image..")
//                        imageForCard = UIImage(data: imageData as Data)
//                }
        return UIImageView(image:imageArr[index])
//        return UIImageView(image: imageForCard)
    }
    func koloda(_ koloda: KolodaView, descTextForCardAt index: Int) -> String {
        return dataSource[index]["desc"]!
    }
    func koloda(_ koloda: KolodaView, rankForCardAt index: Int) -> String {
           return dataSource[index]["rank"]!
       }
    func koloda(_ koloda: KolodaView, authorForCardAt index: Int) -> String {
           return dataSource[index]["author"]!
       }
//
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
////        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
//    }
}

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
var imageUrls: [UIImage] = []

class ViewController: UIViewController {
    
    
    @objc func profileImageTap() {
        self.performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    @objc func fireBoardButtonTap() {
        self.performSegue(withIdentifier: "toFireBoard", sender: self)
    }
    
    func assignCards(arr: [UIImage],reff:Bool) {
        if(reff == true) {
            //should i replace the data source or append? i would think replace, but example is append...need to look at logic behinf kolaoda count and datssource count..
//            myKolodaView.countOfCards = 0
//            myKolodaView.currentCardIndex = 0
            for i in 0..<arr.count {
                dataSource.append(arr[i])
            }
            //self.dataSource = arr
            let position = myKolodaView.currentCardIndex
            myKolodaView.insertCardAtIndexRange(position..<position + 8, animated: true)
            loadingView.removeFromSuperview()
        } else {
            self.dataSource = arr
            print("setting up cards...")
            view.addSubview(myKolodaView)
            loadingView.removeFromSuperview()
            setUpKoloda()
            myKolodaView.delegate = self
            myKolodaView.dataSource = self
            myKolodaView.visibleCardsDirection = .top
        }
    }
    
    
    fileprivate var dataSource: [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "image1")!)
        }
        return array
    }()
    
    
    func getCards(refresh:Bool) {
        var array: [UIImage] = []
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
                            array.append(image!)
                        }
                        print("got urls")
                        self.assignCards(arr:array,reff:refresh)
                    }
                    else {
                        print("failure to retreieve cards")
                        print(response.result.error!)
                    }
                }
        }
    
//

    
    let profileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.green
        button.setImage(UIImage(named: "profileicon"), for: .normal)
        button.addTarget(self, action: #selector(profileImageTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    let fireBoardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.yellow
//        button.setImage(UIImage(named: "profileicon"), for: .normal)
        button.addTarget(self, action: #selector(fireBoardButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    

  

    
//    @IBOutlet weak var myKolodaView: KolodaView!
    let myKolodaView: KolodaView = {
        let kView = KolodaView()
        kView.layer.borderColor = UIColor.red.cgColor
        kView.translatesAutoresizingMaskIntoConstraints = false
        return kView
    }()
    
    let loadingView: UIView = {
        let lView = UIView()
        lView.layer.borderColor = UIColor.green.cgColor
        lView.backgroundColor = .red
        lView.translatesAutoresizingMaskIntoConstraints = false
        return lView
    }()
//
//    fileprivate var dataSource: [UIImage] = {
//        var array: [UIImage] = []
//        Alamofire.request("https://frozen-temple-71617.herokuapp.com/cards", method:.get).responseJSON {
//            response in
//            if response.result.isSuccess {
//                print("SUCCESS!")
//                var responseData = JSON(response.result.value!)
//                for index in 0..<responseData.count {
////                    let urlString = String(describing: responseData[index]["pic"])
////                    let url = NSURL(string: urlString)! as URL
////                    let imageData: NSData = NSData(contentsOf: url)
////                    array.append(UIImage(data:imageData)
//                    var image: UIImage?
//                    let urlString = responseData[index]["pic"]
//
//                    let url = NSURL(string: String(describing: responseData[index]["pic"]))! as URL
//                    if let imageData: NSData = NSData(contentsOf: url) {
//                        image = UIImage(data: imageData as Data)
//                    }
//                array.append(image!)
//                }
//            }
//            else {
//                print("failure to retreieve cards")
//                print(response.result.error!)
//            }
//        }
//        print("outside of while loop")
//        return array
//    }()
    
    // MARK: Lifecycle

    override func loadView() {
        super.loadView()
        view.addSubview(profileButton)
        view.addSubview(fireBoardButton)
        view.addSubview(loadingView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfileButton()
        setUpFireBoardButton()
        setUpLoadingView()
        getCards(refresh: false)
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //dispose of resources before moving to the new controller
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toProfile") {
            let destinationViewControler = segue.destination as! ProfileViewControleler
            destinationViewControler.textPassedOver = "Alex"
        }
    }

    var leftAnchor: NSLayoutConstraint?
    var rightAnchor: NSLayoutConstraint?
    var topAnchor: NSLayoutConstraint?
    var bottomAnchor: NSLayoutConstraint?
    
    var widthAnchor: NSLayoutConstraint?
    var heightAnchor: NSLayoutConstraint?
    
    private func setUpKoloda(){
        
        leftAnchor = myKolodaView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 75)
        leftAnchor?.isActive = true
        rightAnchor = myKolodaView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -75)
        rightAnchor?.isActive = true
        topAnchor = myKolodaView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250)
        topAnchor?.isActive = true
        bottomAnchor = myKolodaView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -250)
        bottomAnchor?.isActive = true
    }
    private func setUpLoadingView() {
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 75).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -75).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -250).isActive = true
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


    
    private func enlargeKoloda(){
        leftAnchor?.isActive = false
        bottomAnchor?.isActive = false
        rightAnchor?.isActive = false
        topAnchor?.isActive = false
//
//        heightAnchor?.isActive = true
//
//        widthAnchor?.isActive = true
        leftAnchor = myKolodaView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:15)
        leftAnchor?.isActive = true
        rightAnchor = myKolodaView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15)
        rightAnchor?.isActive = true
        topAnchor = myKolodaView.topAnchor.constraint(equalTo: view.topAnchor,constant: 150)
        topAnchor?.isActive = true
        bottomAnchor = myKolodaView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100)
        bottomAnchor?.isActive = true
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    
    
    
    private func shrinkKoloda(){
        leftAnchor?.isActive = false
        bottomAnchor?.isActive = false
        rightAnchor?.isActive = false
        topAnchor?.isActive = false
        
        leftAnchor = myKolodaView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 75)
        leftAnchor?.isActive = true
        rightAnchor = myKolodaView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -75)
        rightAnchor?.isActive = true
        topAnchor = myKolodaView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250)
        topAnchor?.isActive = true
        bottomAnchor = myKolodaView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -250)
        bottomAnchor?.isActive = true
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.setNeedsLayout()
        }, completion: nil)
    }
    // MARK: IBActions
}

// MARK: KolodaViewDelegate
// all these extentions make the ViewControler class confrom to the two protocols....the extention is just used for organizing the code better. dont get confused.:)
extension ViewController: KolodaViewDelegate {
    //
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        let position = myKolodaView.currentCardIndex
//        for i in 1...4 {
//            dataSource.append(UIImage(named: "image1")!)
//        }
//        myKolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
////        getCards(refresh : true)
        view.addSubview(loadingView)
        setUpLoadingView()
        getCards(refresh: true)
        
    }
    
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int,tappedBottomRight: Bool) {
        
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        if(tappedBottomRight == true) {
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
            enlargeKoloda()
        }
    }
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.up,.left,.right]
    }
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        let params: [String: String] = [
            "swipe" : direction.rawValue,
            "card" : String(myKolodaView.currentCardIndex)
        ]
        
        Alamofire.request("https://frozen-temple-71617.herokuapp.com/rankCard", method:.post,parameters: params)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    print("SUCCESS!")
                }
        }
       shrinkKoloda()
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
        return UIImageView(image: dataSource[Int(index)])
    }
//
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
////        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
//    }
}

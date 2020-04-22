//
//  FireBoardControllerViews.swift
//  TrendingFire
//
//  Created by alex on 3/29/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit
import GoogleMobileAds


let fireProfileButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "logowhite"), for: .normal)
    button.addTarget(FireBoard(), action: #selector(FireBoard.backTap), for: .touchUpInside)
    return button
}()
    
let rankTitle: UIButton = {
    let button = UIButton()
    
    button.setTitle("All Time Fire", for: .normal)

    button.backgroundColor = .black    
    button.titleLabel?.textColor = .white
    button.titleLabel?.font! = UIFont(name: "Herculanum",size: 24)!
    return button
}()
//
//let backButton: UIButton = {
//    let button = UIButton()
//    button.setImage(UIImage(named: "logowhite"), for: .normal)
//    return button
//}()

var rankCatButton: dropDownBtn = {
    let pbutton = dropDownBtn.init(frame:CGRect(x:0,y:0,width:0,height:0))
    pbutton.translatesAutoresizingMaskIntoConstraints = false
    return pbutton
}()

var catPickerView : UIPickerView = {
   let pv = UIPickerView()
   return pv
}()


func setUpFireProfileButton(v:UIView){
    fireProfileButton.translatesAutoresizingMaskIntoConstraints = false

    
    NSLayoutConstraint(item: fireProfileButton, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.15, constant: 0).isActive = true
    NSLayoutConstraint(item: fireProfileButton, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 0.15, constant: 0).isActive = true
    
    fireProfileButton.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.1).isActive = true
    fireProfileButton.widthAnchor.constraint(equalTo: v.widthAnchor,multiplier: 0.15).isActive = true
}
 
func setUpRankTitle(v:UIView){
//    rankTitle.backgroundColor = .red
    rankTitle.titleLabel?.textAlignment = .center
    rankTitle.translatesAutoresizingMaskIntoConstraints = false
    rankTitle.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    rankTitle.widthAnchor.constraint(equalTo: v.widthAnchor, multiplier: 0.7).isActive = true
    rankTitle.heightAnchor.constraint(equalTo: v.heightAnchor, multiplier: 0.1).isActive = true
    
    NSLayoutConstraint(item: rankTitle, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.18, constant: 0).isActive = true
}

func setUpTableView(v:UIView,table:UITableView){
    table.translatesAutoresizingMaskIntoConstraints = false
    table.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    table.widthAnchor.constraint(equalTo: v.widthAnchor, multiplier: 0.85).isActive = true
    table.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.6).isActive = true
    table.topAnchor.constraint(equalTo: catPickerView.bottomAnchor,constant: 10).isActive = true
    table.layer.borderWidth = 2.0

}


func setUpFireLoadingView(v:UIView,loadingView:UIView) {
    loadingView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    loadingView.topAnchor.constraint(equalTo: v.topAnchor, constant: 100).isActive = true
    loadingView.heightAnchor.constraint(equalTo: v.heightAnchor, multiplier: 0.3).isActive = true
    loadingView.widthAnchor.constraint(equalTo: v.widthAnchor, multiplier: 0.3).isActive = true
}

func addBannerViewToView(v:UIView,bannerView: GADBannerView) {
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    v.addSubview(bannerView)
    bannerView.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
    bannerView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    bannerView.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.1).isActive = true
    bannerView.widthAnchor.constraint(equalTo: v.widthAnchor).isActive = true
 }

func setUpCatPickerView(v:UIView) {
    catPickerView.backgroundColor = .black
    
    catPickerView.translatesAutoresizingMaskIntoConstraints = false
    catPickerView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
    catPickerView.heightAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.15).isActive = true
    catPickerView.widthAnchor.constraint(equalTo: v.heightAnchor,multiplier: 0.2).isActive = true
     
    NSLayoutConstraint(item: catPickerView, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 0.37, constant: 0).isActive = true
}

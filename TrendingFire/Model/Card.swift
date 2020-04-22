//
//  Card.swift
//  TrendingFire
//
//  Created by alex on 1/1/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import Foundation
import UIKit

class Card {
    let urlString: String
    let descText: String
    let rankTxt: String
    let authorTxt: String
    let id : String
    let title : String
    let link : String
    //placeholder image if image does not load
    var image: UIImage = UIImage(named: "image1")!
    
    init(url:String,desc:String,rank:String,author:String,cardid:String,cardTitle:String,cardLink:String) {
        urlString = url
        descText = desc
        rankTxt = rank
        authorTxt = author
        id = cardid
        title = cardTitle
        link = cardLink
        
    }
}

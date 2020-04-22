//
//  ImageHolder.swift
//  TrendingFire
//
//  Created by alex on 3/29/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit

class ImageHolder: NSObject {
    
    var cardArray: [Card] = []
    var updated:Bool = false
    
    func upDateCardArray(arr:[Card]){
        self.cardArray = arr
    }
}

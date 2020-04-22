//
//  RomanNumeral.swift
//  TrendingFire
//
//  Created by alex on 4/5/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit

func numToRomanNumeral(num:Int) -> String {
    
    switch num {
        case 0:
            return "I"
        case 1:
            return "II"
        case 2:
            return "III"
        case 3:
            return "IV"
        case 4:
            return "V"
        case 5:
            return "VI"
        case 6:
            return "VII"
        case 7:
            return "VIII"
        case 8:
            return "IX"
        default:
            return "X"
        }
}

//
//  LateLoadingProtocol.swift
//  TrendingFire
//
//  Created by alex on 3/29/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

protocol LateLoadingProtocol: AnyObject {
    func updateTable(arr: ImageHolder,refresh:Bool)
}

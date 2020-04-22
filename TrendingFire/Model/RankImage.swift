//
//  RankImage.swift
//  TrendingFire
//
//  Created by alex on 1/5/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import Foundation
import CoreData




class RankImage: NSManagedObject {
    
    
    class func findOrCreateRankImg(matching imgInfo:RankImage,in context:NSManagedObjectContext) throws ->RankImage{
        
        let request: NSFetchRequest<RankImage> = RankImage.fetchRequest()
        request.predicate = NSPredicate(format:"id=%@",imgInfo.id!)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "data base inconsistecy")
                print("found a matching id, will not save image")
                return matches[0]
            } else {
                print("no matching id found..saving card")
            }
        } catch {
                throw error
            }
        let newRankImg = RankImage(context:context)
        newRankImg.id = imgInfo.id
        newRankImg.author = imgInfo.author
        newRankImg.desc = imgInfo.desc
        newRankImg.rank = imgInfo.rank
        newRankImg.imagePath = imgInfo.imagePath
        print("saved a new rank image!")
        return newRankImg
        }
    
   
}
        

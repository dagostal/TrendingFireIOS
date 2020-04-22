//
//  fetchrnkImagesfromCoreData.swift
//  TrendingFire
//
//  Created by alex on 3/29/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit

class fetchrnkImagesfromCoreData: NSObject {

}
//
//func getRankCardsFromDB() {
//        if let context = container?.viewContext {
//                //not on main thread here
//
////                //on main thread here..
////        context.perform {
//            let requestAllRnkImgs: NSFetchRequest<RankImage> = RankImage.fetchRequest()
//            requestAllRnkImgs.sortDescriptors = [NSSortDescriptor(key:"rank",ascending: true)]
//            print("got fetch request")
//            let rnkImags = try? context.fetch(requestAllRnkImgs)
//            print("got fetch request")
//            if(rnkImags != nil) {
////
//                let arr = rnkImags!
//
//                for index in 0..<rnkImags!.count {
//
//
//                    let imgDataPathString = arr[index].imagePath!
//
//                    let pathurl = URL(string:imgDataPathString)
//                    let fileExists = FileManager.default.fileExists(atPath: pathurl!.path)
//
//                    do {
//
//                        let imageData = try Data(contentsOf: pathurl!)
//
//                        let rnkImage = UIImage(data: imageData as Data)
//                        self.imagesForTable.append(rnkImage!)
//                        self.descTextsArray.append(arr[index].desc!)
//                        if(self.imagesForTable.count > 9){
//                            self.setUpTable()
//                        }
//                    } catch {
////                        print (" error")
//                    }
//                }
//            }
//    }
//}
//

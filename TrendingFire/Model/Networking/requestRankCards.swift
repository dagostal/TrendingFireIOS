

import UIKit
import SwiftyJSON
import Alamofire
import CoreData
import Imaginary


extension ViewController {
    
    func requestRankCards(category:String){
        if let url = URL(string:"https://agile-dusk-73308.herokuapp.com/rankCards?cat="+category) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleRankImgs(data:response:error:))
            task.resume()
        }
    }
    
func handleRankImgs(data:Data?,response: URLResponse?,error:Error?) {
    if error != nil {
        print("error getting rank images from server")
        print(error!)
        return
        }
    if let safeData = data {
        
        let dataJSON = JSON(safeData)
        //i think all these bugs are causing by multiple aysnc threads trying to update the array...
        let serialRankQueue = DispatchQueue(label: "update.rank.queue")
        var updateRnkObj = [Card]()
        
        var countOfRankImage = 0
        print("got rank data")
        for index in 0..<dataJSON.count {
            let urlString = String(describing: dataJSON[index]["pic"])
            let descText = String(describing: dataJSON[index]["desc"])
            let rankTxt = String(describing: dataJSON[index]["rank"])
            let authorTxt = String(describing: dataJSON[index]["author"])
            let cardId = String(describing: dataJSON[index]["_id"])
            let linkTxt = String(describing: dataJSON[index]["link"])
            let titleTxt = String(describing: dataJSON[index]["title"])
            
            let imageUrl = NSURL(string: urlString)! as URL
            let session = URLSession(configuration: .default)

            let downloadRnkImgTask = session.dataTask(with: imageUrl) { (data, response, error) in
                if let e = error {
                    print("--")
                    print("Error downloading rank image: \(e)")
                    print(imageUrl,titleTxt)
                    print("--")
                } else {
                    if let imageData = data {
                        if let imageForRankObj = UIImage(data: imageData as Data) {
                            let rc = Card(url: urlString, desc: descText, rank: rankTxt, author: authorTxt, cardid: cardId,cardTitle: titleTxt,cardLink: linkTxt)
                            rc.image = imageForRankObj
                            serialRankQueue.async {
                                print("loaded rank image..",countOfRankImage)
                                updateRnkObj.append(rc)
                                countOfRankImage = countOfRankImage + 1
                                if(countOfRankImage == 10) {
                                    print("all 10 rank imags ready to render")
                                    let sortedRankArray = self.sortArray(arr: updateRnkObj)
                                    DispatchQueue.main.async {
                                        self.rankImagesHolder.upDateCardArray(arr: sortedRankArray)
                                        self.rankImagesHolder.updated = true
                                        self.notifyFireBoard()
                                    }
                                    return;
                                }
                            }
                        } else {
                            print("error:could not convert data into image")
                            return;
                        }
                    } else {
                        print("error: could not download img data")
                        return;
                    }
                  }
                }
                downloadRnkImgTask.resume()
            }
        }
    }

    func sortArray(arr: [Card]) -> [Card]{
                //need to convert txt to int so i can compare...
        var sortedArr: [Card] = []
        
        master: for i in 0..<arr.count {
            let rankInt1 = Int(arr[i].rankTxt)!
        
            compare: for k in 0..<sortedArr.count {
                let rankInt2 = Int(sortedArr[k].rankTxt)!
            
                if(rankInt1 > rankInt2) {
                    sortedArr.insert(arr[i],at:k)
                    continue master
                }
            }
            sortedArr.append(arr[i])
        }
        return sortedArr
    }
}

//
//  DropDownView.swift
//  TrendingFire
//
//  Created by alex on 4/4/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit


class dropDownView:UIView,UITableViewDelegate,UITableViewDataSource {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate: dropDownProtocol!

    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        tableView.backgroundColor = .black
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.font! = UIFont(name: "Herculanum",size: 12)!
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        cell.textLabel?.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        cell.textLabel?.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let wasSelected = self.delegate.dropDownPressed(selectedCat: dropDownOptions[indexPath.row], index: indexPath.row)
        if(wasSelected == true) {
            tableView.cellForRow(at: indexPath)?.textLabel?.backgroundColor = .black
            tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .white
        } else {
            tableView.cellForRow(at: indexPath)?.textLabel?.backgroundColor = .white
            tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .black
        }
    }
    
}


class dropDownBtn: UIButton,dropDownProtocol {
        
    func dropDownPressed(selectedCat: String,index:Int) -> Bool {
    
        var itemFound = false
        let selectedCatLowerCase = selectedCat.lowercased()
        
        for i in 0..<delegate!.selectedCategories.count {
            if delegate!.selectedCategories[i] == selectedCatLowerCase {
                itemFound = true
                delegate?.selectedCategories.remove(at: i)
                return itemFound
            }
        }
        if(itemFound == false) {
            delegate?.selectedCategories.append(selectedCatLowerCase)
            return itemFound
        }
        
//        self.dismissDropDown()
//        self.setTitle("Categories",for:.normal)
//        delegate?.selectedCategory = selectedCat
//        self.delegate?.resetDeck(selectedCat:selectedCat)
        
    }
    
    var dropView = dropDownView()
    var height = NSLayoutConstraint()
    
    var delegate: ViewController?
    var lastSentFilter: [String]!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.lastSentFilter = ["all"]
        self.backgroundColor = .black
        dropView = dropDownView.init(frame:CGRect(x:0,y:0,width:0, height:0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    var doneOpening = false
    var isBeingTouched = false
    
    func tappedOutside(){
        if(self.lastSentFilter != self.delegate!.selectedCategories) {
                  self.delegate?.resetDeck(selectedCat: self.delegate!.selectedCategories)
                  self.lastSentFilter = self.delegate!.selectedCategories
              }
              isOpen = false
              NSLayoutConstraint.deactivate([self.height])
              self.height.constant = 0
              NSLayoutConstraint.activate([self.height])
              
              UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                  self.dropView.center.y -= self.dropView.frame.height/2
                  self.dropView.layoutIfNeeded()
              }, completion: { (finished: Bool) in
                  self.doneOpening = false
              })
     }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if( isOpen == false){
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            
            if(self.dropView.tableView.contentSize.height>150){
                self.height.constant = 150
            } else{
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.dropView.superview?.bringSubviewToFront(self.dropView)
                self.dropView.layoutIfNeeded()
                
                self.dropView.center.y += self.dropView.frame.height/2
            }, completion: { (finished: Bool) in
                self.doneOpening = true
            })
        } else {
            //to to check if anything in the arary was changed...if not, dont send req...
            if(self.lastSentFilter != self.delegate!.selectedCategories) {
                self.delegate?.resetDeck(selectedCat: self.delegate!.selectedCategories)
                self.lastSentFilter = self.delegate!.selectedCategories
            }
            isOpen = false
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height/2
                self.dropView.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.doneOpening = false
            })
        }
    }
    
    func dismissDropDown(){
//        isOpen = false
//        NSLayoutConstraint.deactivate([self.height])
//        self.height.constant = 0
//        NSLayoutConstraint.activate([self.height])
//
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//            self.dropView.center.y -= self.dropView.frame.height/2
//            self.dropView.layoutIfNeeded()
//        }, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol dropDownProtocol {
    func dropDownPressed(selectedCat:String,index:Int) -> Bool
}

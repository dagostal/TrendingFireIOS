//
//  ProfileViewControllerExtentions.swift
//  TrendingFire
//
//  Created by alex on 4/8/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableImageHolder.cardArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.black
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addCardView(tableSource:tableImageHolder.cardArray,index:indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "fireCards", for: indexPath)
        
        cell.viewWithTag(50)?.removeFromSuperview()
        cell.viewWithTag(60)?.removeFromSuperview()
        
        let textHolder = UIView()
        cell.subviews[0].addSubview(textHolder)
        textHolder.tag = 50
    
        textHolder.translatesAutoresizingMaskIntoConstraints = false
        textHolder.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        textHolder.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        textHolder.widthAnchor.constraint(equalTo: cell.widthAnchor,multiplier: 0.65).isActive = true

        let textHolder2 = UILabel()
        textHolder.addSubview(textHolder2)
        textHolder2.text = tableImageHolder.cardArray[indexPath.section].title
        textHolder2.font! = UIFont(name: "Herculanum",size: 16)!
        
        textHolder2.translatesAutoresizingMaskIntoConstraints = false
        textHolder2.trailingAnchor.constraint(equalTo: textHolder.trailingAnchor).isActive = true
        textHolder2.heightAnchor.constraint(equalTo: textHolder.heightAnchor).isActive = true
        textHolder2.widthAnchor.constraint(equalTo: textHolder.widthAnchor,multiplier:0.9).isActive = true
        textHolder2.textAlignment = .left

        let imageHolder = UIImageView(image:UIImage(named:"frame_2"))
        cell.subviews[0].addSubview(imageHolder)
        imageHolder.tag = 60
        
        imageHolder.translatesAutoresizingMaskIntoConstraints = false
        imageHolder.trailingAnchor.constraint(equalTo: textHolder.leadingAnchor).isActive = true
        imageHolder.leadingAnchor.constraint(equalTo: cell.leadingAnchor,constant: 15).isActive = true
        imageHolder.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        
        let imageHolder2 = UIImageView(image:tableImageHolder.cardArray[indexPath.section].image)
        imageHolder.addSubview(imageHolder2)
        imageHolder2.translatesAutoresizingMaskIntoConstraints = false
        imageHolder2.centerXAnchor.constraint(equalTo: imageHolder.centerXAnchor).isActive = true
        imageHolder2.centerYAnchor.constraint(equalTo: imageHolder.centerYAnchor).isActive = true
        imageHolder2.widthAnchor.constraint(equalTo: imageHolder.widthAnchor,multiplier:0.655).isActive = true
        imageHolder2.heightAnchor.constraint(equalTo: imageHolder.heightAnchor,multiplier:0.71).isActive = true

        return cell
    }
}



extension ProfileViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}


extension ProfileViewController: UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
       var label = UILabel()
       if let v = view as? UILabel { label = v }
       label.font =  UIFont(name: "Herculanum",size: 16)!
       label.textColor = UIColor.white
       label.text =  pickerArray[row]
       label.textAlignment = .center
       return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = pickerArray[row]
    }
    
}



import UIKit

extension FireBoard:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate!.rankImagesHolder.cardArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.black
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        cell.viewWithTag(60)?.removeFromSuperview()
        
        let masterView = UIView()
        masterView.tag = 60
        cell.subviews[0].addSubview(masterView)
        
        masterView.translatesAutoresizingMaskIntoConstraints = false
        masterView.heightAnchor.constraint(equalTo:cell.heightAnchor,multiplier:0.7).isActive = true
        masterView.widthAnchor.constraint(equalTo:cell.widthAnchor).isActive = true
        masterView.centerXAnchor.constraint(equalTo:cell.centerXAnchor).isActive = true
        masterView.centerYAnchor.constraint(equalTo:cell.centerYAnchor).isActive = true
        
        
        let rankView = UIView()
        masterView.addSubview(rankView)
        rankView.translatesAutoresizingMaskIntoConstraints = false

        rankView.heightAnchor.constraint(equalTo:masterView.heightAnchor).isActive = true
        rankView.leadingAnchor.constraint(equalTo:masterView.leadingAnchor).isActive = true
        rankView.widthAnchor.constraint(equalTo:masterView.widthAnchor,multiplier: 0.33).isActive = true

        let rankViewHolder = UILabel()
        rankViewHolder.text = numToRomanNumeral(num:indexPath.section)
        rankViewHolder.textColor = .white
        rankView.addSubview(rankViewHolder)
        rankViewHolder.translatesAutoresizingMaskIntoConstraints = false

        rankViewHolder.heightAnchor.constraint(equalTo:rankView.heightAnchor).isActive = true
        rankViewHolder.leadingAnchor.constraint(equalTo:rankView.leadingAnchor).isActive = true
        rankViewHolder.widthAnchor.constraint(equalTo:rankView.widthAnchor,multiplier: 0.5).isActive = true
        rankViewHolder.textAlignment = .center
        rankViewHolder.lineBreakMode = .byCharWrapping
        rankViewHolder.numberOfLines = 3
        rankViewHolder.textColor = .white
        rankViewHolder.font = UIFont(name: "Herculanum",size: 20)

        let imageViewHolder = UIImageView()
        masterView.addSubview(imageViewHolder)

        imageViewHolder.translatesAutoresizingMaskIntoConstraints = false
        imageViewHolder.heightAnchor.constraint(equalTo:masterView.heightAnchor).isActive = true
        imageViewHolder.leadingAnchor.constraint(equalTo:rankView.trailingAnchor).isActive = true
        imageViewHolder.widthAnchor.constraint(equalTo: masterView.widthAnchor,multiplier: 0.33).isActive = true

        let imageViewHolderTwo = UIImageView()
        imageViewHolder.addSubview(imageViewHolderTwo)
        imageViewHolderTwo.translatesAutoresizingMaskIntoConstraints = false
        imageViewHolderTwo.heightAnchor.constraint(equalTo:imageViewHolder.heightAnchor).isActive = true
        imageViewHolderTwo.widthAnchor.constraint(equalTo: imageViewHolder.widthAnchor,multiplier: 0.6).isActive = true
        imageViewHolderTwo.centerXAnchor.constraint(equalTo: imageViewHolder.centerXAnchor).isActive = true
        imageViewHolderTwo.image = UIImage(named:"frame_2")

        let imageViewHolderThree = UIImageView()
        imageViewHolderTwo.addSubview(imageViewHolderThree)
        imageViewHolderThree.translatesAutoresizingMaskIntoConstraints = false
        imageViewHolderThree.heightAnchor.constraint(equalTo:imageViewHolderTwo.heightAnchor,multiplier: 0.71).isActive = true
        imageViewHolderThree.widthAnchor.constraint(equalTo: imageViewHolderTwo.widthAnchor,multiplier: 0.655).isActive = true
        imageViewHolderThree.centerXAnchor.constraint(equalTo: imageViewHolderTwo.centerXAnchor).isActive = true
        imageViewHolderThree.centerYAnchor.constraint(equalTo: imageViewHolderTwo.centerYAnchor).isActive = true
        imageViewHolderThree.image = delegate!.rankImagesHolder.cardArray[indexPath.section].image

        let textHolder = UIView()
        masterView.addSubview(textHolder)
        textHolder.translatesAutoresizingMaskIntoConstraints = false
        textHolder.heightAnchor.constraint(equalTo:masterView.heightAnchor).isActive = true
        textHolder.leadingAnchor.constraint(equalTo:imageViewHolder.trailingAnchor).isActive = true
        textHolder.trailingAnchor.constraint(equalTo:masterView.trailingAnchor).isActive = true

        let textLabelTwo = UILabel()
        textHolder.addSubview(textLabelTwo)
        textLabelTwo.text = delegate!.rankImagesHolder.cardArray[indexPath.section].rankTxt + "°"
        textLabelTwo.translatesAutoresizingMaskIntoConstraints = false
        textLabelTwo.heightAnchor.constraint(equalTo: masterView.heightAnchor).isActive = true
        textLabelTwo.widthAnchor.constraint(equalTo: textHolder.widthAnchor,multiplier:0.5).isActive = true
        textLabelTwo.trailingAnchor.constraint(equalTo: textHolder.trailingAnchor).isActive = true
        textLabelTwo.textAlignment = .center
        textLabelTwo.lineBreakMode = .byCharWrapping
        textLabelTwo.numberOfLines = 3
        textLabelTwo.font = UIFont(name: "Herculanum",size: 16)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addCardView(index:indexPath.section)
    }
}



extension FireBoard: UIPickerViewDataSource,UIPickerViewDelegate {
    
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
        4
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = pickerArray[row]
        self.delegate?.requestRankCards(category:pickerArray[row].lowercased())
        upDatingNewCategory = true
        showSpinner(onView: tableViewBoard)
    }
    
}

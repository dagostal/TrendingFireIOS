//
//  KolodaCardStorage.swift
//  Pods
//
//  Created by Eugene Andreyev on 3/30/16.
//
//

import Foundation
import UIKit

extension KolodaView {
    
    func createCard(at index: Int, frame: CGRect? = nil) -> DraggableCardView {
        let cardView = generateCard(frame ?? frameForTopCard())
        configureCard(cardView, at: index)
        return cardView
    }
    
    func generateCard(_ frame: CGRect) -> DraggableCardView {
        let cardView = DraggableCardView(frame: frame)
        cardView.delegate = self
        return cardView
    }
    
    func configureCard(_ card: DraggableCardView, at index: Int) {
        // this is where the uiimage view is being appended..retrieves the uiImage from view controller in contentView...and appends it in card.configure
        let contentView = dataSource!.koloda(self, viewForCardAt: index)
        //this is where the uiimage view is appended to the card...overlayview is nil bc i killed the function in the view controller\

        card.configure(contentView, overlayView: dataSource?.koloda(self, viewForCardOverlayAt: index))
        
        //Reconfigure drag animation constants from Koloda instance.
        if let rotationMax = self.rotationMax {
            card.rotationMax = rotationMax
        }
        if let rotationAngle = self.rotationAngle {
            card.rotationAngle = rotationAngle
        }
        if let scaleMin = self.scaleMin {
            card.scaleMin = scaleMin
        }
    }
    
}

//
//  DraggableCardView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 4/23/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import pop
import GoogleMobileAds

public enum DragSpeed: TimeInterval {
    case slow = 2.0
    case moderate = 1.5
    case `default` = 0.8
    case fast = 0.4
}

protocol DraggableCardDelegate: class {
    
    func card(_ card: DraggableCardView, wasDraggedWithFinishPercentage percentage: CGFloat, inDirection direction: SwipeResultDirection)
    func card(_ card: DraggableCardView, wasSwipedIn direction: SwipeResultDirection)
    func card(_ card: DraggableCardView, shouldSwipeIn direction: SwipeResultDirection) -> Bool
    func card(cardWasReset card: DraggableCardView)
    func card(cardWasTapped card: DraggableCardView,tappedBottomRight:Bool)
    func card(cardSwipeThresholdRatioMargin card: DraggableCardView) -> CGFloat?
    func card(cardAllowedDirections card: DraggableCardView) -> [SwipeResultDirection]
    func card(cardShouldDrag card: DraggableCardView) -> Bool
    func card(cardSwipeSpeed card: DraggableCardView) -> DragSpeed
    func card(cardPanBegan card: DraggableCardView)
    func card(cardPanFinished card: DraggableCardView)
}

//Drag animation constants
private let defaultRotationMax: CGFloat = 1.0
private let defaultRotationAngle = CGFloat(Double.pi) / 10.0
private let defaultScaleMin: CGFloat = 0.8



private let screenSize = UIScreen.main.bounds.size

//Reset animation constants
private let cardResetAnimationSpringBounciness: CGFloat = 10.0
private let cardResetAnimationSpringSpeed: CGFloat = 20.0
private let cardResetAnimationKey = "resetPositionAnimation"
private let cardResetAnimationDuration: TimeInterval = 0.2
internal var cardSwipeActionAnimationDuration: TimeInterval = DragSpeed.fast.rawValue

public class DraggableCardView: UIView, UIGestureRecognizerDelegate {
    
    //Drag animation constants
    public var rotationMax = defaultRotationMax
    public var rotationAngle = defaultRotationAngle
    public var scaleMin = defaultScaleMin
    public var cardHeightAnchor: NSLayoutDimension?
    public var cardWidthAnchor: NSLayoutDimension?
    private var cardDescText: String?
    private var rankTxt: String?
    private var author: String?
    private var titleTxt: String?
    private var linkTxt: String?
    var cardId: String?
    private var tappedBottomRightBoolean: Bool = false
    
    weak var delegate: DraggableCardDelegate? {
        didSet {
            configureSwipeSpeed()
        }
    }
    
    internal var dragBegin = false
    
    private var overlayView: OverlayView?
    public private(set) var contentView: UIView?
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var animationDirectionY: CGFloat = 1.0
    private var dragDistance = CGPoint.zero
    private var swipePercentageMargin: CGFloat = 0.0
    
    
    //MARK: Lifecycle
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        self.cardDescText = "HERE"
        
        setup()
    }

    
    override public var frame: CGRect {
        didSet {
            if let ratio = delegate?.card(cardSwipeThresholdRatioMargin: self) , ratio != 0 {
                swipePercentageMargin = ratio
            } else {
                swipePercentageMargin = 1.0
            }
        }
    }
    
    deinit {
        removeGestureRecognizer(panGestureRecognizer)
        removeGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setup() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DraggableCardView.panGestureRecognized(_:)))
        addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DraggableCardView.tapRecognized(_:)))
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
        
        if let delegate = delegate {
            cardSwipeActionAnimationDuration = delegate.card(cardSwipeSpeed: self).rawValue
        }
    }
    
    //MARK: Configurations
    //this is where the ui image is put on the draggable card..no overlay view, killed that
    //can i add the frame to the draggable view with the uiimage...
    //
    func configure(_ view: UIView, overlayView: OverlayView?) {
        
        self.overlayView?.removeFromSuperview()
        self.contentView?.removeFromSuperview()

        
        if let overlay = overlayView {
            self.overlayView = overlay
            overlay.alpha = 0;
            self.addSubview(overlay)
            configureOverlayView()
            self.insertSubview(view, belowSubview: overlay)
        } else {
            self.addSubview(view)
        }
        
        self.contentView = view
        configureContentView()
    }
    
    //function that I made to add desc, rank, author to card
    //deeted these...if i need again just make one func/
//    func descTextConfigure(_ desc:String) {
//        self.cardDescText = desc
//    }
//    func rankConfigure(_ rank:String) {
//        self.rankTxt = rank
//    }
//    func authorConfigure(_ author:String) {
//        self.author = author
//    }
//    func cardIdConfigure(_ id:String) {
//        self.cardId = id
//    }
//    func cardTitleconfigure(_ id:String) {
//           self.titleTxt = id
//       }
//    func cardLinkConfigure(_ id:String) {
//           self.linkTxt = id
//       }
    
    
    private func configureOverlayView() {
        if let overlay = self.overlayView {
            overlay.translatesAutoresizingMaskIntoConstraints = false
//
            let width = NSLayoutConstraint(
                item: overlay,
                attribute: .width,
                relatedBy: .equal,
                toItem: self,
                attribute: .width,
                multiplier: 1.0,
                constant: 0)
            let height = NSLayoutConstraint(
                item: overlay,
                attribute: .height,
                relatedBy: .equal,
                toItem: self,
                attribute: .height,
                multiplier: 1.0,
                constant: 0)
            let top = NSLayoutConstraint (
                item: overlay,
                attribute: .top,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1.0,
                constant: 0)
            let leading = NSLayoutConstraint (
                item: overlay,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self,
                attribute: .leading,
                multiplier: 1.0,
                constant: 0)
            addConstraints([width,height,top,leading])
        }
    }
    //this is where the ui image size within the draggable view is set..
    //where i most likely need to adjust size of ui image view to make room for a bottom view...migh have to build new functions in here to reconfig the subviews when enlarged..
    //declared in card class..
    var leftAnchorImage: NSLayoutConstraint?
    var rightAnchorImage: NSLayoutConstraint?
    var topAnchorImage: NSLayoutConstraint?
    var bottomAnchorImage: NSLayoutConstraint?
    
    @objc func goToLink() {
        let urlString = self.linkTxt!
        
        if let url = URL(string: urlString) {
              UIApplication.shared.open(url)
          }
      }
    
    
    private func configureContentView() {
        if let contentView = self.contentView {
//            contentView.translatesAutoresizingMaskIntoConstraints = false
//            contentView.widthAnchor.constraint(equalTo:self.widthAnchor,multiplier: 0.8).isActive = true
//            contentView.topAnchor.constraint(equalTo:self.topAnchor,constant: 10).isActive = true
//            contentView.heightAnchor.constraint(equalTo:self.heightAnchor,multiplier:0.6).isActive = true
//            contentView.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive = true
            
            //new code for new design..
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.widthAnchor.constraint(equalTo:self.widthAnchor,multiplier:0.67).isActive = true
            contentView.heightAnchor.constraint(equalTo:self.heightAnchor,multiplier:0.74).isActive = true
            contentView.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive = true
            contentView.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
            
            
            let frameImage = UIImageView(image: UIImage(named:"frame_2"))
            self.addSubview(frameImage)
            
            frameImage.translatesAutoresizingMaskIntoConstraints = false
            
            frameImage.widthAnchor.constraint(equalTo:self.widthAnchor,multiplier:1).isActive = true
            frameImage.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
            frameImage.heightAnchor.constraint(equalTo:self.heightAnchor,multiplier:1).isActive = true
            frameImage.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive = true
            
            
            //new code for new design..
            
            
            
            
            //declared in card class..but setting constraints for ui image, not card
            
//            leftAnchorImage = contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
//            leftAnchorImage?.isActive = true
//            rightAnchorImage = contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//            rightAnchorImage?.isActive = true
//            topAnchorImage = contentView.topAnchor.constraint(equalTo: self.topAnchor)
//            topAnchorImage?.isActive = true
//            bottomAnchorImage = contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//            bottomAnchorImage?.isActive = true
//
////
//        var textView = UIView(frame: CGRect(x: self.frame.minX - 10 , y: self.frame.minY, width: self.frame.width, height: self.frame.height))
//                //
//            self.addSubview(textView)
//
//            textView.translatesAutoresizingMaskIntoConstraints = false
//            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant:-10).isActive = true
//            textView.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier:0.85).isActive = true
//            textView.heightAnchor.constraint(equalTo: self.heightAnchor,multiplier:0.3).isActive = true
//            textView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//
//
//            textView.layer.borderColor = UIColor.white.cgColor
//            textView.layer.borderWidth = 1
//            textView.layer.cornerRadius = 8
//
//            var titleView = UILabel()
//            titleView.text = self.titleTxt
//            titleView.font! = UIFont(name: "Herculanum",size: 22)!
//            textView.addSubview(titleView)
////            titleView.backgroundColor = .green
//            titleView.textAlignment = .center
//
//            titleView.translatesAutoresizingMaskIntoConstraints = false
//            titleView.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
//            titleView.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
//            titleView.heightAnchor.constraint(equalTo: textView.heightAnchor,multiplier:0.3).isActive = true
//            titleView.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
//            titleView.textColor = .white
//
//
//            var descView = UILabel()
//            descView.text = self.cardDescText
//            descView.font! = UIFont(name: "Herculanum",size: 18)!
//            textView.addSubview(descView)
////            descView.backgroundColor = .blue
//            descView.textAlignment = .center
//            descView.textColor = .white
//
//            descView.translatesAutoresizingMaskIntoConstraints = false
//
//            descView.topAnchor.constraint(equalTo: titleView.bottomAnchor,constant:5).isActive = true
//            descView.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
//            descView.heightAnchor.constraint(equalTo: textView.heightAnchor,multiplier:0.3).isActive = true
//            descView.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
////
//
//            var linkView = UIButton()
//            linkView.setTitle("Origin", for: .normal)
//            linkView.titleLabel!.font = UIFont(name: "Herculanum",size: 18)!
//            textView.addSubview(linkView)
////            linkView.backgroundColor = .red
//            linkView.titleLabel!.textAlignment = .center
//            linkView.addTarget(self, action: #selector(goToLink), for: .touchUpInside)
//
//            linkView.translatesAutoresizingMaskIntoConstraints = false
//            linkView.topAnchor.constraint(equalTo: descView.bottomAnchor,constant:5).isActive = true
//            linkView.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
//            linkView.heightAnchor.constraint(equalTo: textView.heightAnchor,multiplier:0.3).isActive = true
//            linkView.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
////
//
////////
//////
//        let rankLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
//        let degreeText = self.rankTxt! + "°"
//        rankLabel.text = degreeText
//        rankLabel.textColor = .orange
//        self.addSubview(rankLabel)
//            //
//        rankLabel.translatesAutoresizingMaskIntoConstraints = false
//        rankLabel.font! = UIFont(name: "Herculanum",size: 18)!
//        rankLabel.bottomAnchor.constraint(equalTo: textView.topAnchor,constant:-10).isActive = true
//        rankLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80).isActive = true
//
//
//        let authorLabel = UILabel(frame:CGRect(x: 10, y: 40, width: 150, height: 30))
//        authorLabel.text = self.author
//        authorLabel.textColor = .white
//        authorLabel.font! = UIFont(name: "Herculanum",size: 12)!
//        self.addSubview(authorLabel)
////
//            authorLabel.translatesAutoresizingMaskIntoConstraints = false
//            authorLabel.bottomAnchor.constraint(equalTo: textView.topAnchor,constant:-10).isActive = true
//            authorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
////////
////            let width = NSLayoutConstraint(
////                item: contentView,
////                attribute: .width,
////                relatedBy: .equal,
////                toItem: self,
////                attribute: .width,
////                multiplier: 1.0,
////                constant: 0)
////            let height = NSLayoutConstraint(
////                item: contentView,
////                attribute: .height,
////                relatedBy: .equal,
////                toItem: self,
////                attribute: .height,
////                multiplier: 1.0,
////                constant: 0)
////            let top = NSLayoutConstraint (
////                item: contentView,
////                attribute: .top,
////                relatedBy: .equal,
////                toItem: self,
////                attribute: .top,
////                multiplier: 1.0,
////                constant: 0)
////            let leading = NSLayoutConstraint (
////                item: contentView,
////                attribute: .leading,
////                relatedBy: .equal,
////                toItem: self,
////                attribute: .leading,
////                multiplier: 1.0,
////                constant: 0)
//
////            addConstraints([top])
        }
    }
    
    func addAdView(adView:GADUnifiedNativeAdView,nativeAd:GADUnifiedNativeAd){
        //first..remove the images...
        for view in self.subviews{
            view.removeFromSuperview()
        }
               
        let frameImage = UIImageView(image: UIImage(named:"frame_2"))
        self.addSubview(frameImage)
               
        frameImage.translatesAutoresizingMaskIntoConstraints = false
               
        frameImage.widthAnchor.constraint(equalTo:self.widthAnchor,multiplier:1).isActive = true
        frameImage.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        frameImage.heightAnchor.constraint(equalTo:self.heightAnchor,multiplier:1).isActive = true
        frameImage.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive = true
        
        
        
        let nativeAdPlaceHolder = UIView()
        
        self.addSubview(nativeAdPlaceHolder)
        
        nativeAdPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        nativeAdPlaceHolder.widthAnchor.constraint(equalTo:self.widthAnchor,multiplier:0.67).isActive = true
        nativeAdPlaceHolder.heightAnchor.constraint(equalTo:self.heightAnchor,multiplier:0.74).isActive = true
        nativeAdPlaceHolder.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive = true
        nativeAdPlaceHolder.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        nativeAdPlaceHolder.backgroundColor = .white
        
        
        
        
        
        nativeAdPlaceHolder.addSubview(adView)
        adView.layer.borderColor = UIColor.black.cgColor
        adView.layer.borderWidth = 1
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.widthAnchor.constraint(equalTo:nativeAdPlaceHolder.widthAnchor).isActive = true
        adView.heightAnchor.constraint(equalTo:nativeAdPlaceHolder.heightAnchor).isActive = true
        adView.centerXAnchor.constraint(equalTo:nativeAdPlaceHolder.centerXAnchor).isActive = true
        adView.centerYAnchor.constraint(equalTo:nativeAdPlaceHolder.centerYAnchor).isActive = true
        
        adView.nativeAd = nativeAd
        
        let headlineV = UILabel()
        headlineV.textAlignment = .center
        headlineV.textColor = .black
        headlineV.font! = UIFont(name: "Herculanum",size: 9)!
        adView.headlineView = headlineV
        (adView.headlineView as? UILabel)?.text = nativeAd.headline
        adView.addSubview(headlineV)
        
        headlineV.translatesAutoresizingMaskIntoConstraints = false
        headlineV.widthAnchor.constraint(equalTo:adView.widthAnchor).isActive = true
        headlineV.heightAnchor.constraint(equalTo:adView.heightAnchor,multiplier:0.2).isActive = true
        headlineV.centerXAnchor.constraint(equalTo:adView.centerXAnchor).isActive = true
        headlineV.topAnchor.constraint(equalTo:adView.topAnchor).isActive = true
        
        //        (adView.bodyView as? UILabel)?.text = nativeAd.body
        //        adView.bodyView?.isHidden = nativeAd.body == nil
        
        
        
        let bodyView = UILabel()
        bodyView.textAlignment = .center
        bodyView.textColor = .black
        bodyView.font! = UIFont(name: "Herculanum",size: 12)!
        (adView.bodyView as? UILabel)?.text = nativeAd.body
        adView.bodyView?.isHidden = nativeAd.body == nil
        
        adView.addSubview(bodyView)
        
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.widthAnchor.constraint(equalTo:adView.widthAnchor).isActive = true
        bodyView.heightAnchor.constraint(equalTo:adView.heightAnchor,multiplier:0.05).isActive = true
        bodyView.centerXAnchor.constraint(equalTo:adView.centerXAnchor).isActive = true
        bodyView.bottomAnchor.constraint(equalTo:adView.bottomAnchor).isActive = true
                
        
        let mediaV: GADMediaView = GADMediaView()
        
        adView.mediaView = mediaV
        adView.mediaView?.mediaContent = nativeAd.mediaContent
        
        adView.addSubview(mediaV)
        
        mediaV.translatesAutoresizingMaskIntoConstraints = false
        mediaV.widthAnchor.constraint(equalTo:adView.widthAnchor).isActive = true
        mediaV.topAnchor.constraint(equalTo:headlineV.bottomAnchor).isActive = true
        mediaV.centerXAnchor.constraint(equalTo:adView.centerXAnchor).isActive = true
        mediaV.bottomAnchor.constraint(equalTo:bodyView.topAnchor).isActive = true

        // Populate the native ad view with the native ad assets.
        // The headline is guaranteed to be present in every native ad.
        
        
        
        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
//        (adView.bodyView as? UILabel)?.text = nativeAd.body
//        adView.bodyView?.isHidden = nativeAd.body == nil
//
//        (adView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
//        adView.callToActionView?.isHidden = nativeAd.callToAction == nil
//
//        (adView.iconView as? UIImageView)?.image = nativeAd.icon?.image
//        adView.iconView?.isHidden = nativeAd.icon == nil
//
////        (adView.starRatingView as? UIImageView)?.image = imageOfStars(fromStarRating:nativeAd.starRating)
////        adView.starRatingView?.isHidden = nativeAd.starRating == nil
//
//        (adView.storeView as? UILabel)?.text = nativeAd.store
//        adView.storeView?.isHidden = nativeAd.store == nil
//
//        (adView.priceView as? UILabel)?.text = nativeAd.price
//        adView.priceView?.isHidden = nativeAd.price == nil



        // In order for the SDK to process touch events properly, user interaction
        // should be disabled.
        adView.callToActionView?.isUserInteractionEnabled = false
        
        print(adView.subviews)
        
        return;
    }
    
    func configureSwipeSpeed() {
        if let delegate = delegate {
            cardSwipeActionAnimationDuration = delegate.card(cardSwipeSpeed: self).rawValue
        }
    }
    
    //MARK: GestureRecognizers
    @objc func panGestureRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
        dragDistance = gestureRecognizer.translation(in: self)
        
        let touchLocation = gestureRecognizer.location(in: self)
        
        switch gestureRecognizer.state {
        case .began:
            
            let firstTouchPoint = gestureRecognizer.location(in: self)
            let newAnchorPoint = CGPoint(x: firstTouchPoint.x / bounds.width, y: firstTouchPoint.y / bounds.height)
            let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
            let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
            layer.anchorPoint = newAnchorPoint
            layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)
            removeAnimations()
            
            dragBegin = true
            
            animationDirectionY = touchLocation.y >= frame.size.height / 2 ? -1.0 : 1.0
            layer.rasterizationScale = UIScreen.main.scale
            layer.shouldRasterize = true
            delegate?.card(cardPanBegan: self)
            
        case .changed:
            let rotationStrength = min(dragDistance.x / frame.width, rotationMax)
            let rotationAngle = animationDirectionY * self.rotationAngle * rotationStrength
            let scaleStrength = 1 - ((1 - scaleMin) * abs(rotationStrength))
            let scale = max(scaleStrength, scaleMin)
            
            var transform = CATransform3DIdentity
            transform = CATransform3DScale(transform, scale, scale, 1)
            transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, dragDistance.x, dragDistance.y, 0)
            layer.transform = transform
            
            let percentage = dragPercentage
            updateOverlayWithFinishPercent(percentage, direction:dragDirection)
            if let dragDirection = dragDirection {
                //100% - for proportion
                delegate?.card(self, wasDraggedWithFinishPercentage: min(abs(100 * percentage), 100), inDirection: dragDirection)
            }
            
        case .ended:
            swipeMadeAction()
            delegate?.card(cardPanFinished: self)
            layer.shouldRasterize = false
            
        default:
            layer.shouldRasterize = false
            resetViewPositionAndTransformations()
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard gestureRecognizer == tapGestureRecognizer, touch.view is UIControl else {
            return true
        }
        return false
    }
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == panGestureRecognizer else {
            return true
        }
        return delegate?.card(cardShouldDrag: self) ?? true
    }
    
    @objc func tapRecognized(_ recogznier: UITapGestureRecognizer) {
        
//        print(KolodaView.tapped)
//
//        let cardTapLocation = recogznier.location(in: self)
//        var tappedBottomRight: Bool
////
////
//        let image = self.subviews[0]
////
//////
////
//    if(tappedBottomRightBoolean == false) {
//
//
//
//            self.layer.borderColor = UIColor.white.cgColor
//            self.layer.borderWidth = 3
//            self.layer.cornerRadius = 8
//            bottomAnchorImage?.isActive = false
//            leftAnchorImage?.isActive = false
//            rightAnchorImage?.isActive = false
//            topAnchorImage?.isActive = false
//
//
////
//
//            bottomAnchorImage = image.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -200)
//            leftAnchorImage = image.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 35)
//            rightAnchorImage = image.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -35)
//            topAnchorImage = image.topAnchor.constraint(equalTo: self.topAnchor,constant: 15)
//            bottomAnchorImage?.isActive = true
//            leftAnchorImage?.isActive = true
//            rightAnchorImage?.isActive = true
//            topAnchorImage?.isActive = true
//
//
//            let rankLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
//            let degreeText = self.rankTxt! + "°"
//            rankLabel.text = degreeText
//            rankLabel.textColor = .orange
//            image.addSubview(rankLabel)
////
//            rankLabel.translatesAutoresizingMaskIntoConstraints = false
//            rankLabel.topAnchor.constraint(equalTo: image.bottomAnchor,constant:15).isActive = true
//            rankLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 100).isActive = true
//
//
//            let authorLabel = UILabel(frame:CGRect(x: 10, y: 40, width: 150, height: 30))
//            authorLabel.text = self.author
//            authorLabel.textColor = .white
//            authorLabel.font! = UIFont(name: "Herculanum",size: 12)!
//            image.addSubview(authorLabel)
//
//            authorLabel.translatesAutoresizingMaskIntoConstraints = false
//            authorLabel.topAnchor.constraint(equalTo: image.bottomAnchor,constant:25).isActive = true
//            authorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
//
//
//        var textView = UIView(frame: CGRect(x: self.frame.minX - 10 , y: self.frame.minY, width: self.frame.width, height: self.frame.height))
//            //
//            image.addSubview(textView)
//
//            textView.translatesAutoresizingMaskIntoConstraints = false
//            textView.topAnchor.constraint(equalTo: image.bottomAnchor,constant:55).isActive = true
//            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant:-25).isActive = true
//            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 25).isActive = true
//            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant:-20).isActive = true
//
//            textView.layer.borderColor = UIColor.white.cgColor
//            textView.layer.borderWidth = 3
//            textView.layer.cornerRadius = 8
//
//
//            let cardLabel = UILabel()
//            cardLabel.text = self.cardDescText
//            cardLabel.textColor = .white
//            cardLabel.font! = UIFont(name: "Herculanum",size: 18)!
//            cardLabel.contentMode = .scaleAspectFill
//            cardLabel.textAlignment = .center
//            cardLabel.numberOfLines = 0
//            cardLabel.lineBreakMode = .byWordWrapping
//            textView.addSubview(cardLabel)
//
//
//            cardLabel.translatesAutoresizingMaskIntoConstraints = false
//            cardLabel.topAnchor.constraint(equalTo: textView.topAnchor,constant:15).isActive = true
//            cardLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor,constant:10).isActive = true
//            cardLabel.widthAnchor.constraint(equalToConstant: 275).isActive = true
//            cardLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
////
//
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 11, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
//
//                self.layoutIfNeeded()
//            }, completion: nil)
//
//
//
//        tappedBottomRight = true
//        tappedBottomRightBoolean = true
//
//
//      }
        delegate?.card(cardWasTapped: self,tappedBottomRight: tappedBottomRightBoolean)
    }
    
    //MARK: Private
    
    private var directions: [SwipeResultDirection] {
        return delegate?.card(cardAllowedDirections: self) ?? [.left, .right]
    }
    
    private var dragDirection: SwipeResultDirection? {
        //find closest direction
        let normalizedDragPoint = dragDistance.normalizedDistanceForSize(bounds.size)
        return directions.reduce((distance:CGFloat.infinity, direction:nil)) { closest, direction in
            let distance = direction.point.distanceTo(normalizedDragPoint)
            if distance < closest.distance {
                return (distance, direction)
            }
            return closest
            }.direction
    }
    
    private var dragPercentage: CGFloat {
        guard let dragDirection = dragDirection else { return 0 }
        // normalize dragDistance then convert project closesest direction vector
        let normalizedDragPoint = dragDistance.normalizedDistanceForSize(frame.size)
        let swipePoint = normalizedDragPoint.scalarProjectionPointWith(dragDirection.point)
        
        // rect to represent bounds of card in normalized coordinate system
        let rect = SwipeResultDirection.boundsRect
        
        // if point is outside rect, percentage of swipe in direction is over 100%
        if !rect.contains(swipePoint) {
            return 1.0
        } else {
            let centerDistance = swipePoint.distanceTo(.zero)
            let targetLine = (swipePoint, CGPoint.zero)
            
            // check 4 borders for intersection with line between touchpoint and center of card
            // return smallest percentage of distance to edge point or 0
            return rect.perimeterLines
                .compactMap { CGPoint.intersectionBetweenLines(targetLine, line2: $0) }
                .map { centerDistance / $0.distanceTo(.zero) }
                .min() ?? 0
        }
    }
    
    
    private func updateOverlayWithFinishPercent(_ percent: CGFloat, direction: SwipeResultDirection?) {
        overlayView?.overlayState = direction
        let progress = max(min(percent/swipePercentageMargin, 1.0), 0)
        overlayView?.update(progress: progress)
    }
    
    private func swipeMadeAction() {
        let shouldSwipe = { direction in
            return self.delegate?.card(self, shouldSwipeIn: direction) ?? true
        }
        if let dragDirection = dragDirection , shouldSwipe(dragDirection) && dragPercentage >= swipePercentageMargin && directions.contains(dragDirection) {
            swipeAction(dragDirection)
        } else {
            resetViewPositionAndTransformations()
        }
    }
    
    func animationPointForDirection(_ direction: SwipeResultDirection) -> CGPoint {
        guard let superview = self.superview else {
            return .zero
        }
        
        let superSize = superview.bounds.size
        let space = max(screenSize.width, screenSize.height)
        switch direction {
        case .left, .right:
            // Optimize left and right position
            let x = direction.point.x * (superSize.width + space)
            let y = 0.5 * superSize.height
            return CGPoint(x: x, y: y)
            
        default:
            let x = direction.point.x * (superSize.width + space)
            let y = direction.point.y * (superSize.height + space)
            return CGPoint(x: x, y: y)
        }
    }
    
    func animationRotationForDirection(_ direction: SwipeResultDirection) -> CGFloat {
        return CGFloat(direction.bearing / 2.0 - Double.pi / 4)
    }
    
    private func swipeAction(_ direction: SwipeResultDirection) {
        overlayView?.overlayState = direction
        overlayView?.alpha = 1.0
        delegate?.card(self, wasSwipedIn: direction)
        let translationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
        translationAnimation?.duration = cardSwipeActionAnimationDuration
        translationAnimation?.fromValue = NSValue(cgPoint: POPLayerGetTranslationXY(layer))
        translationAnimation?.toValue = NSValue(cgPoint: animationPointForDirection(direction))
        translationAnimation?.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
        layer.pop_add(translationAnimation, forKey: "swipeTranslationAnimation")
    }
    
    private func resetViewPositionAndTransformations() {
        delegate?.card(cardWasReset: self)
        
        removeAnimations()
        
        let resetPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
        resetPositionAnimation?.fromValue = NSValue(cgPoint:POPLayerGetTranslationXY(layer))
        resetPositionAnimation?.toValue = NSValue(cgPoint: CGPoint.zero)
        resetPositionAnimation?.springBounciness = cardResetAnimationSpringBounciness
        resetPositionAnimation?.springSpeed = cardResetAnimationSpringSpeed
        resetPositionAnimation?.completionBlock = {
            (_, _) in
            self.layer.transform = CATransform3DIdentity
            self.dragBegin = false
        }
        
        layer.pop_add(resetPositionAnimation, forKey: "resetPositionAnimation")
        
        let resetRotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
        resetRotationAnimation?.fromValue = POPLayerGetRotationZ(layer)
        resetRotationAnimation?.toValue = CGFloat(0.0)
        resetRotationAnimation?.duration = cardResetAnimationDuration
        
        layer.pop_add(resetRotationAnimation, forKey: "resetRotationAnimation")
        
        let overlayAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        overlayAlphaAnimation?.toValue = 0.0
        overlayAlphaAnimation?.duration = cardResetAnimationDuration
        overlayAlphaAnimation?.completionBlock = { _, _ in
            self.overlayView?.alpha = 0
        }
        overlayView?.pop_add(overlayAlphaAnimation, forKey: "resetOverlayAnimation")
        
        let resetScaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        resetScaleAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
        resetScaleAnimation?.duration = cardResetAnimationDuration
        layer.pop_add(resetScaleAnimation, forKey: "resetScaleAnimation")
    }
    
    //MARK: Public
    func removeAnimations() {
        pop_removeAllAnimations()
        layer.pop_removeAllAnimations()
    }
    
    func swipe(_ direction: SwipeResultDirection, completionHandler: @escaping () -> Void) {
        if !dragBegin {
            delegate?.card(self, wasSwipedIn: direction)
            
            let swipePositionAnimation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
            swipePositionAnimation?.fromValue = NSValue(cgPoint:POPLayerGetTranslationXY(layer))
            swipePositionAnimation?.toValue = NSValue(cgPoint:animationPointForDirection(direction))
            swipePositionAnimation?.duration = cardSwipeActionAnimationDuration
            swipePositionAnimation?.completionBlock = {
                (_, _) in
                self.removeFromSuperview()
                completionHandler()
            }
            
            layer.pop_add(swipePositionAnimation, forKey: "swipePositionAnimation")
            
            let swipeRotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
            swipeRotationAnimation?.fromValue = POPLayerGetRotationZ(layer)
            swipeRotationAnimation?.toValue = CGFloat(animationRotationForDirection(direction))
            swipeRotationAnimation?.duration = cardSwipeActionAnimationDuration
            
            layer.pop_add(swipeRotationAnimation, forKey: "swipeRotationAnimation")
            
            overlayView?.overlayState = direction
            let overlayAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            overlayAlphaAnimation?.toValue = 1.0
            overlayAlphaAnimation?.duration = cardSwipeActionAnimationDuration
            overlayView?.pop_add(overlayAlphaAnimation, forKey: "swipeOverlayAnimation")
        }
    }
}

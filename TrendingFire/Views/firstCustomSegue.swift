
//
//  transitionFromRight.swift
//  TrendingFire
//
//  Created by alex on 4/5/20.
//  Copyright © 2020 Alex D'Agostino. All rights reserved.
//

import UIKit


class firstCustomSegue: UIStoryboardSegue {
     override func perform() {
           let src = self.source
           let dst = self.destination

           src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
           dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)

           UIView.animate(withDuration: 0.15,
                                 delay: 0.0,
                               options: .curveEaseInOut,
                            animations: {
                                   dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
                                   },
                           completion: { finished in
                                   src.present(dst, animated: false, completion: nil)
                                       }
                           )
       }
}


class secondCustomSegue: UIStoryboardSegue {
     override func perform() {
           let src = self.source
           let dst = self.destination

           src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
           dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)

           UIView.animate(withDuration: 0.15,
                                 delay: 0.0,
                               options: .curveEaseInOut,
                            animations: {
                                   dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
                                   },
                           completion: { finished in
                                   src.present(dst, animated: false, completion: nil)
                                       }
                           )
       }
}


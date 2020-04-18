//
//  ImageCollectionViewCell.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 17/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

class AwardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewCell: UIView!{
        didSet{
            viewCell.clipsToBounds = true
            viewCell.layer.cornerRadius = 8
            viewCell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            
            viewCell.layer.masksToBounds = false
            viewCell.layer.shadowColor = UIColor.black.cgColor
            viewCell.layer.shadowOffset = CGSize.zero
            viewCell.layer.shadowOpacity = Float(0.2)
            viewCell.layer.shadowRadius = CGFloat(4)
            viewCell.isSkeletonable = true
        }
    }
    @IBOutlet weak var imageViewCell: UIImageView!{
        didSet{
            imageViewCell.isSkeletonable = true
            imageViewCell.clipsToBounds = true
            imageViewCell.layer.cornerRadius = 8
            imageViewCell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var awardTypeLabel: UILabel!{
        didSet{
            awardTypeLabel.isSkeletonable = true
        }
    }
    
    var award : Award?{
        didSet {
            if let award = award {
                if let image = award.images, let url = URL(string: image) {
                    imageViewCell.kf.indicatorType = .activity
                    imageViewCell.kf.setImage(with: url, options: [
                        .transition(.fade(0.2)),
                        .cacheOriginalImage
                    ], progressBlock: nil) { (image, error, cacheType, url) in
                    }
                }
                
                titleLabel.text = award.title
                awardTypeLabel.setAwardType(awardType: award.awardsType)
            }
        }
    }
    
    var disabledHighlightedAnimation = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.isSkeletonable = true
        // Initialization code
    }
    
    func resetTransform() {
        transform = .identity
    }

    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }

    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }

    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation {
            return
        }
        let animationOptions: UIView.AnimationOptions = true
        ? [.allowUserInteraction] : []
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .init(scaleX: 0.96, y: 0.96)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }

}

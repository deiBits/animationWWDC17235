//
//  ViewController.swift
//  Emoji
//
//  Created by natarajan b on 4/17/22.
//

import UIKit
import QuartzCore

class ViewController : UIViewController {
    var containerView : EmojiView?
    let maxContainerSize = CGSize (width: 300, height: 540)
    var currentContainerExpansion: Double = 0 {
        didSet {
            containerView?.layer.timeOffset = currentContainerExpansion
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        // Container Frame needs to be set with start of touch!
        let containerFrame = CGRect(origin: CGPoint(x: view.bounds.midX - maxContainerSize.width / 2, y:view.bounds.midY - maxContainerSize.height / 2), size: maxContainerSize)
        self.containerView = EmojiView(frame: containerFrame)
        containerView?.backgroundColor = UIColor.orange
        view.addSubview(containerView!)
        setupAnimations()
        let rec = UIPanGestureRecognizer(target: self, action: #selector (handlePan))
        view.addGestureRecognizer(rec)
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        let dragDistanceY = recognizer.translation(in: view).y
        let scaledDragAmount = Double(dragDistanceY / maxContainerSize.height)
        // scale from ~..height to ~0…1
        currentContainerExpansion = min(max (currentContainerExpansion + scaledDragAmount, 0), 1)
        // clamp to 0-1 range so we don't have to set a fill mode on the main animation
        recognizer.setTranslation(.zero, in: view)
    }
    
    func setupAnimations() {
        if let containerLayer = containerView?.layer, let emojiLayers = containerView?.emojilayers {
            containerLayer.speed = 0
            containerLayer.masksToBounds = true
            containerLayer.cornerRadius = 10
            let animation = CABasicAnimation(keyPath: "bounds.size.height")
            animation.fromValue = 80
            animation.toValue = self.maxContainerSize.height
            animation.duration = 1
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            let widthAnimation = CABasicAnimation(keyPath: "bounds.size.width")
            widthAnimation.fromValue = 80
            widthAnimation.toValue = self.maxContainerSize.width
            widthAnimation.duration = 0.2
            widthAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            containerLayer.add(animation, forKey: nil)
            containerLayer.add (widthAnimation, forKey: nil)

            let baseStartTime = containerLayer.convertTime(CACurrentMediaTime(),from:nil)
            for i in emojiLayers.indices {
                let layer = emojiLayers[i]
                let animation = CABasicAnimation(keyPath: "transform.scale.xy")
                animation.fromValue = 0.01
                animation.toValue = 1
                animation.duration = 0.1
                animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
                animation.beginTime = baseStartTime + 0.028 * Double(i) // start each animation slightly later
                animation.fillMode = CAMediaTimingFillMode.backwards // apply the initial value before the animation
                layer.add(animation, forKey: nil)
                containerLayer.addSublayer(layer)
            }
        }
    }
}

//
//  TabViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 09/11/20.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        var swipe = UISwipeGestureRecognizer(target: self, action: #selector(SwipeGesture))
        swipe.numberOfTouchesRequired = 1
        swipe.direction = .left
        
        self.view.addGestureRecognizer(swipe)
        
        swipe = UISwipeGestureRecognizer(target: self, action: #selector(SwipeGesture))
        swipe.numberOfTouchesRequired = 1
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)


    }
    @objc private func SwipeGesture(swipe: UISwipeGestureRecognizer){
        
        switch swipe.direction {
        case .left:
            if selectedIndex < 4 {
                self.selectedIndex = self.selectedIndex + 1
            }

            break
        case .right:
            if selectedIndex > 0 {
                self.selectedIndex = self.selectedIndex - 1
            }

            
            break
        default:
            break
        }
        
    }
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabViewAnimation()
    }
    
    
}
class TabViewAnimation : NSObject,UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        destination.transform = CGAffineTransform(translationX: 0, y: destination.frame.height)
        destination.alpha = 0.0
        destination.transform = .init(scaleX: 1.5, y: 1.5)
        

        transitionContext.containerView.addSubview(destination)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations:{
                        destination.alpha = 1.0
                        destination.transform = .identity},completion: {
            transitionContext.completeTransition($0)})
        
    }
    
    
}

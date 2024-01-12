//
//  ViewController.swift
//  Magic QR
//
//  Created by Garik Hovsepyan on 12.01.24.
//

import UIKit

class RootViewController: UIViewController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarController = UITabBarController()
        
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = UIColor(red: 0.76, green: 0.04, blue: 0.76, alpha: 1.00)

        let titlesAndImageNames: [(title: String, imageName: String, viewController: UIViewController)] = [
            ("Home", "house.fill", HomePageView()),
            ("Analytics", "chart.bar.fill", AnalyticsView()),
            ("Magic QR", "plus.viewfinder", QRGeneratorView()),
            ("History", "clock.fill", HistoryView()),
            ("Profile", "person.crop.circle.fill", UserProfileView())
        ]

        let viewControllers = titlesAndImageNames.map { config in
            let viewController = config.viewController
            viewController.tabBarItem = UITabBarItem(title: config.title, 
                                                     image: UIImage(systemName: config.imageName),
                                                     selectedImage: nil)
            return viewController
        }

        tabBarController.viewControllers = viewControllers
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
        tabBarController.delegate = self
    }

    // MARK: - UITabBarControllerDelegate

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        animateTabBarItem(tabBarController: tabBarController)
    }

    private func animateTabBarItem(tabBarController: UITabBarController) {
        guard let selectedButton = tabBarController.tabBar.subviews.compactMap({ $0 as? UIControl }).first(where: { $0.isSelected }) else {
            return
        }
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.3
        scaleAnimation.duration = 0.2
        scaleAnimation.autoreverses = true
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        selectedButton.layer.add(scaleAnimation, forKey: "scaleAnimation")
    }
}

//
//  TutorialPageViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 2/25/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    var tutorialBlurViewController: TutorialBlurViewController!
    
    let viewControllerDatas: [(image: UIImage, description: String)] = [
        (image: #imageLiteral(resourceName: "Tutorial1"), description: NSLocalizedString("TUTORIAL1", comment: "")),
        (image: #imageLiteral(resourceName: "Tutorial2"), description: NSLocalizedString("TUTORIAL2", comment: "")),
        (image: #imageLiteral(resourceName: "Tutorial3"), description: NSLocalizedString("TUTORIAL3", comment: "")),
        (image: #imageLiteral(resourceName: "Tutorial4"), description: NSLocalizedString("TUTORIAL4", comment: "")),
        (image: #imageLiteral(resourceName: "Tutorial5"), description: NSLocalizedString("TUTORIAL5", comment: "")),
        (image: #imageLiteral(resourceName: "Tutorial6"), description: NSLocalizedString("TUTORIAL6", comment: ""))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        setViewControllers([viewControllerWith(index: 0)], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        tutorialBlurViewController.dismiss(animated: true, completion: nil)
    }
    
    func viewControllerWith(index: Int) -> UIViewController {
        let tutorialViewController = storyboard!.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        
        tutorialViewController.tutorialPageViewController = self
        tutorialViewController.pageIndex = index
        
        if index < viewControllerDatas.count {
            tutorialViewController.image = viewControllerDatas[index].image
            tutorialViewController.text = viewControllerDatas[index].description
        } else {
            tutorialViewController.isLastViewController = true
        }
        
        return tutorialViewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let tutorialViewController = viewController as! TutorialViewController
        
        let pageIndex = tutorialViewController.pageIndex
        let previousIndex = pageIndex-1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard viewControllerDatas.count+1 > previousIndex else {
            return nil
        }
        
        return viewControllerWith(index: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let tutorialViewController = viewController as! TutorialViewController
        
        let pageIndex = tutorialViewController.pageIndex
        let nextIndex = pageIndex+1
        
        guard nextIndex < viewControllerDatas.count+1 else {
            return nil
        }
        
        return viewControllerWith(index: nextIndex)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerDatas.count+1
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        let tutorialViewController = viewControllers!.first! as! TutorialViewController
        
        return tutorialViewController.pageIndex
    }
}

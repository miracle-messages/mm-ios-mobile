//
//  IntroViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 9/28/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIPageViewControllerDelegate {

    var pageViewController : UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        displayPreInterviewSlides()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    
    func displayPreInterviewSlides() -> Void {
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController

        self.pageViewController.dataSource = self

        if let firstViewController = orderedViewControllers.first {
            self.pageViewController.setViewControllers([firstViewController],
                                                       direction: UIPageViewControllerNavigationDirection.forward,
                                                       animated: true,
                                                       completion: nil)
        }

        /* We are substracting 30 because we have a start again button whose height is 30*/
        self.pageViewController.view.frame = CGRect(x:0, y:0, width:self.view.frame.width, height: self.view.frame.height)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
    }

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.newStepViewController(stepNumber: "One"),
            self.newStepViewController(stepNumber: "Two"),
            self.newStepViewController(stepNumber: "Three"),
            self.newStepViewController(stepNumber: "Four"),
            self.newStepViewController(stepNumber: "Five")
        ]
    }()

    private func newStepViewController(stepNumber: String) -> UIViewController {
        let step = "Step\(stepNumber)ViewController"
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: step)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension IntroViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]

    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
}



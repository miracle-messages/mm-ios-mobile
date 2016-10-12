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

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageControl.backgroundColor = UIColor.clear

        self.navigationController!.navigationBar.topItem!.title = ""


        let rightBarButton = UIBarButtonItem(title: "Skip", style: UIBarButtonItemStyle.plain, target: self, action: #selector(IntroViewController.didSelectSkipBtn))

        self.navigationItem.setRightBarButton(rightBarButton, animated: true)

        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        //2
//        textView.textAlignment = .center
//        textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
//        textView.textColor = UIColor.black
//        self.startButton.layer.cornerRadius = 4.0
        //3
        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "Slide 1")
        imgOne.contentMode = UIViewContentMode.scaleAspectFill
        imgOne.clipsToBounds = true
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "Slide 2")
        imgTwo.contentMode = UIViewContentMode.scaleAspectFill
        imgTwo.clipsToBounds = true
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "Slide 3")
        imgThree.contentMode = UIViewContentMode.scaleAspectFill
        imgThree.clipsToBounds = true
        let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFour.image = UIImage(named: "Slide 4")
        imgFour.contentMode = UIViewContentMode.scaleAspectFill
        imgFour.clipsToBounds = true
        let imgFive = UIImageView(frame: CGRect(x:scrollViewWidth*4, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFive.image = UIImage(named: "Slide 5")
        imgFive.contentMode = UIViewContentMode.scaleAspectFill
        imgFive.clipsToBounds = true
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        self.scrollView.addSubview(imgFive)
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 5, height:self.scrollView.frame.height)
        self.scrollView.delegate = self


        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear

//        displayPreInterviewSlides()



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

    func didSelectSkipBtn() -> Void {
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentSize.width - self.scrollView.frame.width, y: 0), animated: true)
        self.pageControl.currentPage = 5
        updateSlideText(currentPage: 5)
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

extension IntroViewController : UIScrollViewDelegate {
    //MARK: UIScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        updateSlideText(currentPage: currentPage)
    }

    func updateSlideText(currentPage: CGFloat) -> Void {
        // Change the text accordingly
        if Int(currentPage) == 0{
            titleLabel.text = "Step 1: Ask the Question"

            textView.text = "Do you have any family or friends that you would like to reunite with, even if you don’t know how to reach them?"
        }else if Int(currentPage) == 1{
            titleLabel.text = "Step 2: Offer to Record Video"


            textView.text = "As a volunteer with Miracle Messages, I would be happy to help you record a short video message to your loved ones if you'd like. \n\nBefore I do, I just want to make sure you are okay with the potential risks and that we are on the same page with expectations."
        }else if Int(currentPage) == 2{
            titleLabel.text = ""

            textView.text = "First, your Miracle Message video will be made public and may be shared widely to help volunteers try to locate your loved one(s)."
        }else if Int(currentPage) == 3{
            titleLabel.text = ""
            textView.text = "Second, while 90% of loved ones have responded positively to their Miracle Messages, we cannot know for sure how your loved one(s) will respond, or if they will respond, or how long it may take them to respond."
        } else {
            titleLabel.text = ""
            textView.text = "And third, while we have many volunteers trying to locate loved ones, we may not be able to find or reach your loved one(s). The only guarantee here is that this is an opportunity for you to record a short video message to someone you love, to say whatever is on your heart that you'd like to say, and that we will try our best to deliver it and help facilitate any response or reunion that results. \n\nSound good?"
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.startButton.alpha = 1.0
            })
        }
    }
}



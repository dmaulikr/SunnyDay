   //
//  PageViewController.swift
//  Sunnyday
//
//  Created by Parth on 5/23/17.
//  Copyright © 2017 Bhoiwala. All rights reserved.
//

import UIKit
   
class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource  {

    lazy var pages : [UIViewController] = {
        return [self.VCInstance(name: "ViewController"),
                self.VCInstance(name: "HourlyController")]
    }()
    
    private func VCInstance(name: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        if let firtVC = pages.first {
            setViewControllers([firtVC], direction: .forward, animated: true, completion: nil)
            
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews{
            if view is UIScrollView{
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl{
                view.backgroundColor = UIColor.clear
            }
                
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages.last
        }
        guard pages.count > previousIndex else {
            return nil
        }
        return pages[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        let nextIndex
            = viewControllerIndex +  1
        guard nextIndex < pages.count else {
            return pages.first
        }
        guard pages.count > nextIndex else {
            return nil
        }
        return pages[nextIndex]
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

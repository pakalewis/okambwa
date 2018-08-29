import UIKit

class SampleProfilesViewController: UIViewController {
    deinit {
        print("-- Deinit SampleProfilesViewController")
    }
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var pages = [UIViewController]()
    
    var pageControl: UIPageControl = UIPageControl()
    
    class func samplePages() -> [UIViewController] {
        var pages = [UIViewController]()
        if let sampleDogs = DataManagement.shared.allDogs(type: .sample) {
            for dog in sampleDogs {
                let details = DogDetailsViewController.instance(mode: .readOnly)
                details.dogModel = dog.model()
                pages.append(details)
            }
        }
        return pages
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pages = SampleProfilesViewController.samplePages()
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.backgroundColor = .white
        pageViewController.willMove(toParentViewController: self)
        view.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: self)
        if let firstPage = pages.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
        } else {            
            pageViewController.setViewControllers([UIViewController()], direction: .forward, animated: false, completion: nil)
        }
        
        if let nav = navigationController {
            let size = nav.navigationBar.bounds.size
            let origin = CGPoint(x: size.width / 2, y: size.height / 2)

            pageControl = UIPageControl(frame: CGRect(x: origin.x, y: origin.y, width: 0, height: 0))
            pageControl.backgroundColor = .clear
            pageControl.numberOfPages = pages.count
            pageControl.currentPage = 0
            pageControl.pageIndicatorTintColor = Colors._777777
            pageControl.currentPageIndicatorTintColor = .black
            self.navigationItem.titleView = pageControl
        }
    }
    
    func indexOf(viewController: UIViewController) -> Int? {
        for (index, vc) in pages.enumerated() {
            if viewController == vc {
                return index
            }
        }
        return nil
    }
}

extension SampleProfilesViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = indexOf(viewController: viewController), index > 0 {
            return pages[index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let page = pageViewController.viewControllers?.first, let index = indexOf(viewController: page) {
            pageControl.currentPage = index
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = indexOf(viewController: viewController), index < pages.count - 1 {
            return pages[index + 1]
        }
        return nil
    }
}

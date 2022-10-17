import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - typealias
    
    typealias ModelPresentationStyle = UIModalPresentationStyle
    typealias ModalTransitionStyle = UIModalTransitionStyle
    
    // MARK: - UINavigationBar Style
    
    /// 設定 NavigationBar 的顏色
    /// - Parameters:
    ///   - backgroundColor: navigationBar 的背景色
    ///   - tintColor: navigationBar 的色調顏色，預設為 UIColor.white
    ///   - foregroundColor: navigationBar 上的文字顏色，預設為 UIColor.white
    public func setupNavigationBarStyle(backgroundColor: UIColor?,
                                        tintColor: UIColor? = .white,
                                        foregroundColor: UIColor? = .white) {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundColor
            self.navigationController?.navigationBar.tintColor = tintColor
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : foregroundColor ?? .white
            ]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            self.navigationController?.navigationBar.barTintColor = backgroundColor
            self.navigationController?.navigationBar.tintColor = tintColor
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : foregroundColor ?? .white
            ]
        }
    }
    
    // MARK: - UINavigationController.present
    
    /// NavigationController.presentViewController 跳頁 (帶 Closure)
    /// - Parameters:
    ///   - viewController: 要跳頁到的 UIViewController
    ///   - animated: 是否要換頁動畫，預設為 true
    ///   - isFullScreen: 是否全螢幕顯示，預設為 false
    ///   - completion: 換頁過程中，要做的事，預設為 nil
    public func presentViewController(viewController: UIViewController,
                                      animated: Bool = true,
                                      isFullScreen: Bool = false,
                                      completion: (() -> Void)? = nil) {
        let navigationVC = UINavigationController(rootViewController: viewController)
        self.navigationController?.present(navigationVC, animated: animated, completion: completion)
    }
    
    // MARK: - UINavigationController.push
    
    /// NavigationController.pushViewController 跳頁 (不帶 Closure)
    /// - Parameters:
    ///   - viewController: 要跳頁到的 UIViewController
    ///   - animated: 是否要換頁動畫，預設為 true
    public func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        if #available(iOS 15.0, *) {
            if let navigationController = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: animated)
            }
        } else {
            if let navigationController = UIApplication.shared
                .windows
                .first(where: { $0.isKeyWindow })?.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: animated)
            }
        }
    }
    
    /// NavigationController.pushViewController 跳頁 (帶 Closure)
    /// - Parameters:
    ///   - viewController: 要跳頁到的 UIViewController
    ///   - animated: 是否要換頁動畫
    ///   - completion: 換頁過程中，要做的事
    public func pushViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: @escaping () -> Void) {
        self.navigationController?.pushViewController(viewController, animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    
    // MARK: - UINavigationController.pop
    
    /// NavigationController.popViewController 回上一頁 (不帶 Closure)
    /// - Parameters:
    ///   - animated: 是否要換頁動畫，預設為 true
    public func popViewController(_ animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    /// NavigationController.popViewController 回上一頁 (帶 Closure)
    /// - Parameters:
    ///   - animated: 是否要換頁動畫
    ///   - completion: 換頁過程中，要做的事
    public func popViewController(animated: Bool, completion: @escaping () -> Void) {
        self.navigationController?.popViewController(animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    
    /// NavigationController.popToViewController 回到指定 ViewController (不帶 Closure)
    /// - Parameters:
    ///   - currectVC: 目前所在的 ViewController
    ///   - popVC_index: 在 NavigationController.viewControllers 中，指定 ViewController 的 index
    ///   - animated: 是否要換頁動畫，預設為 true
    public func popToViewController(currectVC viewController: UIViewController,
                                    popVC_index: Int,
                                    animated: Bool = true) {
        guard let currectVC_index = navigationController?.viewControllers.firstIndex(of: self) else { return }
        if let vc = navigationController?.viewControllers[currectVC_index - popVC_index] {
            self.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    
    /// NavigationController.popToViewController 回到指定 ViewController (帶 Closure)
    /// - Parameters:
    ///   - currectVC: 目前所在的 ViewController
    ///   - popVC_index: 在 NavigationController.viewControllers 中，指定 ViewController 的 index
    ///   - animated: 是否要換頁動畫
    ///   - completion: 換頁過程中，要做的事
    public func popToViewController(currectVC viewController: UIViewController,
                                    popVC_index: Int,
                                    animated: Bool,
                                    completion: @escaping () -> Void) {
        guard let currectVC_index = navigationController?.viewControllers.firstIndex(of: self) else { return }
        if let vc = navigationController?.viewControllers[currectVC_index - popVC_index] {
            self.navigationController?.popToViewController(vc, animated: animated)
        }
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    
    /// NavigationController.popToRootViewController 回到 Root ViewController
    /// - Parameters:
    ///   - animated: 是否要換頁動畫，預設為 true
    public func popToRootViewController(_ animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    // MARK: - UINavigationController.dismiss
    
    /// NavigationController.dismiss (帶 Closure)
    /// - Parameters:
    ///   - animated: 是否要關閉動畫，預設為 true
    ///   - completion: 關閉過程中，要做的事，預設為 nil
    public func dismissViewController(_ animated: Bool = true, completion: (()-> Void)? = nil) {
        self.navigationController?.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: - UIViewController.popUp
    
    /// ViewController.popUp (帶 Closure)
    /// - Parameters:
    ///   - viewController: 要彈出的 ViewController
    ///   - modalPresentationStyle: UIModalPresentationStyle，預設為 .overFullScreen
    ///   - modalTransitionStyle: UIModalTransitionStyle，預設為 .coverVertical
    ///   - animated: 是否要彈出動畫，預設為 true
    ///   - completion: 彈出過程中，要做的事，預設為 nil
    public func popUpViewController(viewController: UIViewController,
                                    modalPresentationStyle: ModelPresentationStyle = .overFullScreen,
                                    modalTransitionStyle: ModalTransitionStyle = .coverVertical,
                                    animated: Bool = true,
                                    completion: (()-> Void)? = nil) {
        viewController.modalPresentationStyle = modalPresentationStyle
        viewController.modalTransitionStyle = modalTransitionStyle
        self.present(viewController, animated: animated, completion: completion)
    }
    
    /// ViewController.dismissPopUp
    /// - Parameters:
    ///   - animated: 是否要關閉動畫，預設為 true
    ///   - completion: 關閉過程中，要做的事，預設為 nil
    public func dismissPopUpViewController(_ animated: Bool = true, completion: (()-> Void)? = nil) {
        self.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: - UITabBarViewController Create
    
    /// 建立主畫面底下的 UITabBarController
    /// - Parameters:
    ///   - vcs: 要加入 TabBarController 的 Controller
    ///   - vcTitleArray: 各頁面的 Title 陣列
    ///   - imageNameArray: 各頁面 icon 的圖片名稱陣列，UIImage(systemName: )
    ///   - modelPresentationStyle: 呈現樣式，預設為 UIModalPresentationStyle.fullScreen
    /// - Returns: 建立好的 UITabBarController
    public func createThreeTabBarViewController(vcs: [UIViewController],
                                                vcTitleArray: [String],
                                                imageNameArray: [String],
                                                modelPresentationStyle: ModelPresentationStyle = .fullScreen) -> UITabBarController {
        let tabBarVC = UITabBarController()
        
        let navVC1 = UINavigationController(rootViewController: vcs[0])
        let navVC2 = UINavigationController(rootViewController: vcs[1])
        let navVC3 = UINavigationController(rootViewController: vcs[2])
        
        navVC1.title = vcTitleArray[0]
        navVC2.title = vcTitleArray[1]
        navVC3.title = vcTitleArray[2]
        
        let navVCArray = [navVC1, navVC2, navVC3]
        
        tabBarVC.setViewControllers(navVCArray, animated: false)
        
        if let items = tabBarVC.tabBar.items {
            for x in 0 ..< items.count {
                items[x].image = UIImage(systemName: imageNameArray[x])
            }
        }
                
        tabBarVC.modalPresentationStyle = modelPresentationStyle
        
        return tabBarVC
    }
}

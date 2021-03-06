//
//  UIKitExtensiones.swift
//  FastPeek
//
//  Created by Antonio Epifani on 24/02/22.
//  Copyright © 2022 Antonio Epifani. All rights reserved.
//

import UIKit
import XCTest

public extension XCTestCase {
    
    /// This method prepares a ``NoAnimationNavigationController``  inside the key window
    /// and gives it a first viewcontroller
    func setupRootNavigationControllerInWindow() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let navigationController = NoAnimationNavigationController()
        let vc = UIViewController()
        navigationController.viewControllers = [vc]
        
        window.rootViewController = navigationController
    }
    
    ///``UIPreparedTestCase`` instances call this method in their ``setUp`` method in
    /// order to hook view lifecycle events to expectations. Please avoid using this method directly; instead,
    /// resort to using ``UIPreparedTestCase`` class instead
    func prepareUIKitForTesting() {
        UIViewController.swizzlePresent()
        UIViewController.swizzleViewDidAppear()
        UIViewController.swizzleViewDidLayoutSubviews()
        UIViewController.swizzleViewDidDisappear()
    }
    
    /// Changes the root View Controller in the currenty key window, in order for it to be able
    /// to appear. Please make sure to run this method before testing any rendered element in the view of
    /// `viewController`.
    /// - Parameter viewController: the View Controller that shall appear on simulator screen
    ///  as soon as window is rendered
    func setRootViewController(to viewController: UIViewController?) {
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    
    /// A reference to the root view controller in the current key window
    var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    
    /// This method uses expectation to wait a user defined amount of time. This can be useful to prevent the simulator
    /// from exiting from the application as soon as the test asserments complete, and allow to observe the graphical
    /// rendering of the tested code. Beware that this method does not pause the application, which effectively keeps running
    /// in foreground. This means that interactions, animations and possible background events can occur in the specified time interval
    /// - Parameter timeout: The amount in seconds to wait, after which the test fulfills the expectation and ends continues running the test
    func wait(timeout: TimeInterval) {
        let expectation = XCTestExpectation(description: "Waiting for \(timeout) seconds")
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: {
            expectation.fulfill()
        })
        XCTWaiter().wait(for: [expectation], timeout: timeout + 1)
    }
}

fileprivate var viewAppearedExpectations: [ObjectIdentifier: XCTestExpectation] = [:]
fileprivate var subviewsLaidOutExpectations: [ObjectIdentifier: XCTestExpectation] = [:]
fileprivate var viewDisappearedExpectations: [ObjectIdentifier: XCTestExpectation] = [:]

// MARK: swizzling methods
extension UIViewController: ViewLifeCycleNotifier {
    public var viewAppearedExpectation: XCTestExpectation? {
        get {
            viewAppearedExpectations[ObjectIdentifier(self)] ?? XCTestExpectation(description: "view did appear")
        }
        set {
            viewAppearedExpectations[ObjectIdentifier(self)] = newValue
        }
    }
    
    public var viewDisappearedExpectation: XCTestExpectation? {
        get {
            viewDisappearedExpectations[ObjectIdentifier(self)] ?? XCTestExpectation(description: "view did appear")
        }
        set {
            viewDisappearedExpectations[ObjectIdentifier(self)] = newValue
        }
    }
    
    public var subviewsLaidOutExpectation: XCTestExpectation? {
        get {
            subviewsLaidOutExpectations[ObjectIdentifier(self)] ?? XCTestExpectation(description: "view did lay out subviews")
        }
        set {
            subviewsLaidOutExpectations[ObjectIdentifier(self)] = newValue
        }
    }
    
    static func swizzlePresent() {
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, #selector(present(_:animated:completion:))),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, #selector(present_swizzling_method(_:animated:completion:))) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    static func swizzleViewDidAppear() {
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, #selector(viewDidAppear(_:))),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, #selector(viewDidAppear_swizzling_method(_:))) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    static func swizzleViewDidLayoutSubviews() {
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, #selector(viewDidLayoutSubviews)),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, #selector(viewDidLayoutSubviews_swizzling_method)) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    static func swizzleViewDidDisappear() {
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, #selector(viewDidDisappear(_:))),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, #selector(viewDidDisappear_swizzling_method)) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    @objc private func present_swizzling_method(_ presentingViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        present_swizzling_method(presentingViewController, animated: false, completion: completion)
    }
    
    @objc private func viewDidAppear_swizzling_method(_ animated: Bool) {
        viewDidAppear_swizzling_method(animated)
        viewAppearedExpectation?.fulfill()
    }
    
    @objc private func viewDidDisappear_swizzling_method(_ animated: Bool) {
        viewDidDisappear_swizzling_method(animated)
        viewDisappearedExpectation?.fulfill()
    }
    
    @objc private func viewDidLayoutSubviews_swizzling_method() {
        viewDidLayoutSubviews_swizzling_method()
        subviewsLaidOutExpectation?.fulfill()
    }
}

public extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        if let navigation = self as? UINavigationController, let topViewController = navigation.topViewController {
            return topViewController.topMostViewController()
        }
        return self
    }
}

class NoAnimationNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
}

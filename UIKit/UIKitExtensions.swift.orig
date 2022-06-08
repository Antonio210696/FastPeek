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
    
    func setupRootViewControllerInWindow() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let navigationController = NoAnimationNavigationController()
        let vc = UIViewController()
        navigationController.viewControllers = [vc]
        
        window.rootViewController = navigationController
    }
    
    func prepareUIKitForTesting() {
        UIViewController.swizzlePresent()
        UIViewController.swizzleViewDidAppear()
        UIViewController.swizzleViewDidLayoutSubviews()
        UIViewController.swizzleViewDidDisappear()
    }
    
    func setRootViewController(to viewController: UIViewController?) {
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    func wait(timeout: TimeInterval) {
        let expectation = XCTestExpectation(description: "Waiting for \(timeout) seconds")
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: {
            expectation.fulfill()
        })
        XCTWaiter().wait(for: [expectation], timeout: timeout + 1)
    }
}

// MARK: rendered graphics test helpers
public extension XCTestCase {
    
    func testViewIsVisible(_ view: UIView) {
        XCTAssertNotEqual(view.frame.height, .zero)
        XCTAssertNotEqual(view.frame.width, .zero)
        XCTAssertNotEqual(view.alpha, .zero)
        XCTAssertFalse(view.isHidden)
    }
    
    func testViewIsNotVisible(_ view: UIView) {
        if !view.isHidden, view.frame != .zero, view.alpha != 0, view.superview != nil {
            XCTFail()
        }
    }
    
    func testView(_ view: UIView, isOnTheLeftOf secondView: UIView) {
        let firstViewFrame: CGRect = view.superview!.convert(view.frame, to: nil)
        let secondViewFrame: CGRect = secondView.superview!.convert(secondView.frame, to: nil)
        
        XCTAssertGreaterThanOrEqual(Int(secondViewFrame.minX), Int(firstViewFrame.maxX))
    }
    
    func testView(_ view: UIView, isOnTheRightOf secondView: UIView) {
        let firstViewFrame: CGRect = view.superview!.convert(view.frame, to: nil)
        let secondViewFrame: CGRect = secondView.superview!.convert(secondView.frame, to: nil)
        
        XCTAssertGreaterThanOrEqual(Int(firstViewFrame.minX), Int(secondViewFrame.maxX))
    }
    
    func testView(_ view: UIView, isAbove secondView: UIView) {
        let firstViewFrame: CGRect = view.superview!.convert(view.frame, to: nil)
        let secondViewFrame: CGRect = secondView.superview!.convert(secondView.frame, to: nil)
        
        XCTAssertLessThanOrEqual(Int(firstViewFrame.maxY), Int(secondViewFrame.minY))
    }
    
    func testView(_ view: UIView, isBelow secondView: UIView) {
        let firstViewFrame: CGRect = view.superview!.convert(view.frame, to: nil)
        let secondViewFrame: CGRect = secondView.superview!.convert(secondView.frame, to: nil)
        
        XCTAssertLessThanOrEqual(Int(secondViewFrame.maxY), Int(firstViewFrame.minY))
    }
    
    func testView(_ view: UIView, isCenteredVerticallyWithRespectTo secondView: UIView) {
        let firstViewCenter: CGPoint = view.superview!.convert(view.center, to: nil)
        let secondViewCenter: CGPoint = secondView.superview!.convert(secondView.center, to: nil)
        
        XCTAssertEqual(Int(firstViewCenter.y), Int(secondViewCenter.y))
    }
    
    func testView(_ view: UIView, isCenteredHorizontallyWithRespectTo secondView: UIView) {
        let firstViewCenter: CGPoint = view.superview!.convert(view.center, to: nil)
        let secondViewCenter: CGPoint = secondView.superview!.convert(secondView.center, to: nil)
        
        XCTAssertEqual(Int(firstViewCenter.x), Int(secondViewCenter.x))
    }
    
    func testView(_ view: UIView, isInside secondView: UIView) {
        
        let firstViewFrame: CGRect = view.superview!.convert(view.frame, to: nil)
        let secondViewFrame: CGRect = secondView.superview!.convert(secondView.frame, to: nil)
        
        XCTAssertGreaterThanOrEqual(Int(firstViewFrame.minX), Int(secondViewFrame.minX))
        XCTAssertLessThanOrEqual(Int(firstViewFrame.maxX), Int(secondViewFrame.maxX))
        XCTAssertGreaterThanOrEqual(Int(firstViewFrame.minY), Int(secondViewFrame.minY))
        XCTAssertLessThanOrEqual(Int(firstViewFrame.maxY), Int(secondViewFrame.maxY))
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

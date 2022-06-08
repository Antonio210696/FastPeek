//
//  ViewControllerTest.swift
//  FastPeek
//
//  Created by Antonio Epifani on 22/03/22.
//  Copyright © 2022 Antonio Epifani. All rights reserved.
//

import XCTest
import UIKit

/// Using this class to keep windows clean after each isolated viewcontroller test
open class UIPreparedTestCase: XCTestCase {
    
    var window: UIWindow?
    
    public var rootWindow: UIWindow {
        return window!
    }
    
    open override func setUp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        prepareUIKitForTesting()
    }
    
    open override func tearDown() {
        window = nil
        prepareUIKitForTesting()
    }
}

// MARK: methods to test visual correctness
public extension UIPreparedTestCase {
    /// A series of assertion that check if the current view is visible when view layout is rendered
    /// - Parameter view: view to be checked
    func testViewIsVisible(_ view: UIView) {
        XCTAssertNotEqual(view.frame.height, .zero)
        XCTAssertNotEqual(view.frame.width, .zero)
        XCTAssertNotEqual(view.alpha, .zero)
        XCTAssertFalse(view.isHidden)
    }
    
    /// A series of assertion that make sure the view is not visible when the view layout is rendered
    /// - Parameter view: view to be checked
    func testViewIsNotVisible(_ view: UIView) {
        if !view.isHidden, view.frame != .zero, view.alpha != 0, view.superview != nil {
            XCTFail()
        }
    }
    
    /// Check if a view is on the left of another. The assertion does not succeed if the two views overlap on the horizontal axis
    /// - Parameters:
    ///   - view: view meant to be on the left
    ///   - secondView: view meant to be on the right
    func testView(_ view: UIView, isOnTheLeftOf secondView: UIView) {
        let firstViewFrame: CGRect = view.superview!.convert(view.frame, to: nil)
        let secondViewFrame: CGRect = secondView.superview!.convert(secondView.frame, to: nil)
        
        XCTAssertGreaterThanOrEqual(Int(secondViewFrame.minX), Int(firstViewFrame.maxX))
    }
    
    /// Check if a view is on the right of another. The assertion does not succeed if the two views overlap on the horizontal axis
    /// - Parameters:
    ///   - view: view meant to be on the right
    ///   - secondView: view meant to be on the left
    func testView(_ view: UIView, isOnTheRightOf secondView: UIView) {
        let firstViewFrame: CGRect = view.superview!.convert(view.frame, to: nil)
        let secondViewFrame: CGRect = secondView.superview!.convert(secondView.frame, to: nil)
        
        XCTAssertGreaterThanOrEqual(Int(firstViewFrame.minX), Int(secondViewFrame.maxX))
    }
    
    /// Check if a view is above another. The assertion does not succeed if the two views  overlap on the vertical axis
    /// - Parameters:
    ///   - view: view meant to be above
    ///   - secondView: view meant to be below
    func testView(_ view: UIView, isAbove secondView: UIView) {
        let firstViewFrame: CGRect = view.superview!.convert(view.frame, to: nil)
        let secondViewFrame: CGRect = secondView.superview!.convert(secondView.frame, to: nil)
        
        XCTAssertLessThanOrEqual(Int(firstViewFrame.maxY), Int(secondViewFrame.minY))
    }
    
    /// Check if a view is below another. The assertion does not succeed if the two views  overlap on the vertical axis
    /// - Parameters:
    ///   - view: view meant to be below
    ///   - secondView: view meant to be above
    func testView(_ view: UIView, isBelow secondView: UIView) {
        let firstViewFrame: CGRect = view.superview!.convert(view.frame, to: nil)
        let secondViewFrame: CGRect = secondView.superview!.convert(secondView.frame, to: nil)
        
        XCTAssertLessThanOrEqual(Int(secondViewFrame.maxY), Int(firstViewFrame.minY))
    }
    
    /// Check if two views are aligned on the vertical axis. Here ordering of views as parameters does not matter
    /// - Parameters:
    ///     the two views to be compared
    func testView(_ view: UIView, isCenteredVerticallyWithRespectTo secondView: UIView) {
        let firstViewCenter: CGPoint = view.superview!.convert(view.center, to: nil)
        let secondViewCenter: CGPoint = secondView.superview!.convert(secondView.center, to: nil)
        
        XCTAssertEqual(Int(firstViewCenter.y), Int(secondViewCenter.y))
    }
    
    /// Check if two views are aligned on the horizontal axis. Here ordering of views as parameters does not matter
    /// - Parameters:
    ///     the two views to be compared
    func testView(_ view: UIView, isCenteredHorizontallyWithRespectTo secondView: UIView) {
        let firstViewCenter: CGPoint = view.superview!.convert(view.center, to: nil)
        let secondViewCenter: CGPoint = secondView.superview!.convert(secondView.center, to: nil)
        
        XCTAssertEqual(Int(firstViewCenter.x), Int(secondViewCenter.x))
    }
    
    
    /// Check if a view is contained inside another. If any of the borders of the first view is outside of the second one, the assertion fails
    /// - Parameters:
    ///   - view: view meant to be inside
    ///   - secondView: view meant to be outside
    func testView(_ view: UIView, isInside secondView: UIView) {
        
        let firstViewFrame: CGRect = view.superview!.convert(view.frame, to: nil)
        let secondViewFrame: CGRect = secondView.superview!.convert(secondView.frame, to: nil)
        
        XCTAssertGreaterThanOrEqual(Int(firstViewFrame.minX), Int(secondViewFrame.minX))
        XCTAssertLessThanOrEqual(Int(firstViewFrame.maxX), Int(secondViewFrame.maxX))
        XCTAssertGreaterThanOrEqual(Int(firstViewFrame.minY), Int(secondViewFrame.minY))
        XCTAssertLessThanOrEqual(Int(firstViewFrame.maxY), Int(secondViewFrame.maxY))
    }
}


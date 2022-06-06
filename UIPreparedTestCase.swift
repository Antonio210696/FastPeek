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


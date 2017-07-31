//
//  InspectableView.swift
//  SMSpotlightSearchViewDemo
//
//  Created by Si Ma on 7/31/17.
//  Copyright © 2017 Si Ma. All rights reserved.
//
/*
 * Description:
 *
 * A UIView subclass which makes some frequently used CALayer properties
 * exposing to Interface Builder
 */

import UIKit

open class InspectableView: UIView {
    
    @IBInspectable open var maskToBounds: Bool {
        get {
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    @IBInspectable open var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    @IBInspectable open var borderColour: UIColor? {
        get {
            if let cgColour = self.layer.borderColor {
                return UIColor(cgColor: cgColour)
            }
            else {
                return nil
            }
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable open var shadowColor: UIColor? {
        get {
            if let cgColour = self.layer.shadowColor {
                return UIColor(cgColor: cgColour)
            }
            else {
                return nil
            }
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable open var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    @IBInspectable open var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    @IBInspectable open var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
}

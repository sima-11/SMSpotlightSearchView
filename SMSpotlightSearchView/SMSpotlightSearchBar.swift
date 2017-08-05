/*
 *  SpotlightSearchBar.swift
 *
 *  Created by Si Ma on 7/20/17.
 *  Copyright © 2017 Si Ma. All rights reserved.
 *
 *  Description:
 *
 *  This InspectableView subclass constains a synamically drawn search icon to mark the type of the input
 *  and a text field for input.
 *  Most of the styling properties are editable in IB.
 *
 *  SMSpotlightSearchBarDelegate is basically a wrapper of UITextFieldDelegate.
 */

import UIKit

public typealias SMSpotlightSearchBarDidEndEditingReason = UITextFieldDidEndEditingReason

@objc public protocol SMSpotlightSearchBarDelegate: NSObjectProtocol {
    
    @objc optional func searchBarShouldBeginEditing(_ searchBar: SMSpotlightSearchBar) -> Bool
    @objc optional func searchBarDidBeginEditing(_ searchBar: SMSpotlightSearchBar)
    @objc optional func searchBarShouldEndEditing(_ searchBar: SMSpotlightSearchBar) -> Bool
    @objc optional func searchBarDidEndEditing(_ searchBar: SMSpotlightSearchBar)
    @objc optional func searchBar(_ searchBar: SMSpotlightSearchBar, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func searchBarDidChangeText(_ searchBar: SMSpotlightSearchBar)
    @objc optional func searchBarShouldClear(_ searchBar: SMSpotlightSearchBar) -> Bool
    @objc optional func searchBarShouldReturn(_ searchBar: SMSpotlightSearchBar) -> Bool
    @objc optional func searchBarDidEndEditing(_ searchBar: SMSpotlightSearchBar, reason: SMSpotlightSearchBarDidEndEditingReason)
}

@IBDesignable public class SMSpotlightSearchBar: InspectableView {
    
    var font: UIFont? {
        get {
            return self.textField.font
        }
        set {
            self.textField.font = newValue
        }
    }
    @IBInspectable var searchIconColour: UIColor {
        get {
            return self.searchIconView.colour
        }
        set {
            self.searchIconView.colour = newValue
        }
    }
    @IBInspectable var textColour: UIColor? {
        get {
            return self.textField.textColor
        }
        set {
            self.textField.textColor = newValue
        }
    }
    @IBInspectable var text: String? {
        get {
            return self.textField.text
        }
        set {
            self.textField.text = newValue
        }
    }
    @IBInspectable var resultTypeImage: UIImage? {
        get {
            return self.resultTypeImageView.image
        }
        set {
            self.resultTypeImageView.image = newValue
        }
    }
    @IBInspectable var margin: CGFloat {
        get {
            return self.layoutMargins.left
        }
        set {
            self.layoutMargins = UIEdgeInsets(top: newValue, left: newValue, bottom: newValue, right: newValue)
        }
    }
    
    @IBOutlet weak var delegate: SMSpotlightSearchBarDelegate?
    
    
    // UI elements
    private var searchIconView: SearchIconView!
    private var textField: UITextField!
    private var resultTypeImageView: UIImageView!
    
    
    deinit {
        self.delegate = nil
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUIElements()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUIElements()
    }
    
    public convenience init(frame: CGRect, font: UIFont?, textColour: UIColor?) {
        self.init(frame: frame)
        
        if let font = font {
            self.font = font
        }
        if let textColour = textColour {
            self.textColour = textColour
        }
    }
    
    public override func resignFirstResponder() -> Bool {
        return self.textField.resignFirstResponder()
    }
    
    private func setupUIElements() {
        self.addSearchIconView()
        self.applyConstraintsOnSearchIconView()
        self.addResultTypeImageView()
        self.applyConstraintsOnResultTypeImageView()
        self.addTextfield()
        self.applyConstraintsOnTextField()
    }
    
    private func addSearchIconView() {
        self.searchIconView = SearchIconView(frame: .zero)
        self.searchIconView.backgroundColor = UIColor.clear
        self.addSubview(self.searchIconView)
    }
    
    private func applyConstraintsOnSearchIconView() {
        self.searchIconView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.searchIconView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.searchIconView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.searchIconView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: self.searchIconView, attribute: .width, relatedBy: .equal, toItem: self.searchIconView, attribute: .height, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, widthConstraint])
    }
    
    private func addResultTypeImageView() {
        self.resultTypeImageView = UIImageView(frame: .zero)
        self.resultTypeImageView.contentMode = .scaleAspectFit
        self.addSubview(self.resultTypeImageView)
    }
    
    private func applyConstraintsOnResultTypeImageView() {
        self.resultTypeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: self.resultTypeImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.resultTypeImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self.resultTypeImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: self.resultTypeImageView, attribute: .width, relatedBy: .equal, toItem: self.resultTypeImageView, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, widthConstraint, trailingConstraint])
    }
    
    private func addTextfield() {
        self.textField = UITextField(frame: .zero)
        self.textField.borderStyle = .none
        self.textField.backgroundColor = UIColor.clear
        self.textField.tintColor = UIColor.darkGray
        self.textField.autocorrectionType = .no
        self.textField.textColor = self.textColour
        self.textField.font = self.font
        self.textField.delegate = self
        self.addSubview(self.textField)
        
        // Listen to text change
        self.textField.addTarget(self, action: #selector(SMSpotlightSearchBar.textFieldDidChangeText(_:)), for: .editingChanged)
    }
    
    private func applyConstraintsOnTextField() {
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.textField, attribute: .left, relatedBy: .equal, toItem: self.searchIconView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self.textField, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    // Private class to draw search icon
    private class SearchIconView: UIView {
        var colour = UIColor.gray {
            didSet{
                self.setNeedsDisplay()
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.setNeedsDisplay()
        }
        
        override func draw(_ rect: CGRect) {
            
            let currentContext = UIGraphicsGetCurrentContext()
            guard let context = currentContext else {
                return
            }
            
            let squareTwo = CGFloat(sqrt(2.0))
            let size = rect.size
            let iconCentre = CGPoint(x: size.width / 1.8, y: size.height / 1.8)
            let margin = size.width * 0.3
            let radius = (size.width - margin*2) * 2 / (CGFloat(2.0) + squareTwo) / 2
            let circleCentre = CGPoint(x: iconCentre.x - radius/squareTwo, y: iconCentre.y - radius/squareTwo)
            
            context.saveGState()
            
            context.setStrokeColor(self.colour.cgColor)
            context.setLineWidth(2.0)
            
            // Draw circle
            context.addEllipse(in: CGRect(x: circleCentre.x - radius, y: circleCentre.y - radius, width: radius*2, height: radius*2))
            
            // Draw line
            context.move(to: iconCentre)
            context.addLine(to: CGPoint(x: size.width - margin, y: size.height - margin))
            
            context.strokePath()
            
            context.restoreGState()
        }
    }
}

extension SMSpotlightSearchBar: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let shouldBeginEditing = self.delegate?.searchBarShouldBeginEditing?(self) {
            return shouldBeginEditing
        }
        else {
            return true
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.searchBarDidBeginEditing?(self)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let shouldEndEditing = self.delegate?.searchBarShouldEndEditing?(self) {
            return shouldEndEditing
        }
        else {
            return true
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.searchBarDidEndEditing?(self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.delegate?.searchBarDidEndEditing?(self, reason: reason)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let shouldChangeCharacters = self.delegate?.searchBar?(self, shouldChangeCharactersIn: range, replacementString: string) {
            return shouldChangeCharacters
        }
        else {
            return true
        }
    }
    
    public func textFieldDidChangeText(_ textField: UITextField) {
        self.delegate?.searchBarDidChangeText?(self)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let shouldClear = self.delegate?.searchBarShouldClear?(self){
            return shouldClear
        }
        else {
            return true
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let shouldReturn = self.delegate?.searchBarShouldReturn?(self){
            return shouldReturn
        }
        else {
            return true
        }
    }
}

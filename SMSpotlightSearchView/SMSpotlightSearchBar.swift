//
//  SpotlightSearchBar.swift
//  SMSpotlightSearchBar
//
//  Created by Si Ma on 7/20/17.
//

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

public class SMSpotlightSearchBar: UIView {
    
    var font: UIFont = UIFont.systemFont(ofSize: 20.0) {
        didSet {
            self.textField.font = self.font
        }
    }
    var textColour: UIColor = UIColor.black {
        didSet {
            self.textField.textColor = self.textColour
        }
    }
    var text: String? {
        get {
            return self.textField.text
        }
        set {
            self.textField.text = self.text
        }
    }
    
    weak var delegate: SMSpotlightSearchBarDelegate?
    
    
    // UI properties
    private var searchIconView: SearchIconView!
    private var textField: UITextField!
    
    
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
        self.setupSearchBar()
        self.setupTextField()
    }
    
    private func setupSearchBar() {
        // Add search icon
        self.searchIconView = SearchIconView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.height, height: self.frame.size.height))
        self.searchIconView.backgroundColor = UIColor.clear
        self.addSubview(self.searchIconView)
        
        // Add constraints
        self.searchIconView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.searchIconView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.searchIconView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.searchIconView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: self.searchIconView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, widthConstraint])
    }
    
    private func setupTextField() {
        // Add textfield
        self.textField = UITextField(frame: CGRect(x: self.searchIconView.frame.origin.x + self.searchIconView.frame.size.width, y: 0.0, width: self.frame.size.width - self.frame.size.height * 2, height: self.frame.size.height))
        self.textField.borderStyle = .none
        self.textField.backgroundColor = UIColor.clear
        self.textField.tintColor = UIColor.darkGray
        self.textField.autocorrectionType = .no
        self.textField.textColor = self.textColour
        self.textField.font = self.font
        self.textField.delegate = self
        self.addSubview(self.textField)
        
        // Add constraints
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.textField, attribute: .left, relatedBy: .equal, toItem: self.searchIconView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self.textField, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        
        // Listen to text change
        self.textField.addTarget(self, action: #selector(SMSpotlightSearchBar.textFieldDidChangeText(_:)), for: .editingChanged)
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
            
            // Draw line
            context.move(to: iconCentre)
            context.addLine(to: CGPoint(x: size.width - margin, y: size.height - margin))
            context.strokePath()
            
            // Draw circle
            context.addArc(center: circleCentre, radius: radius, startAngle: 0.0, endAngle: CGFloat.pi * 2, clockwise: true)
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

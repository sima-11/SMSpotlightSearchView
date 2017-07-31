/*
 *  SMSpotlightSearchView.swift
 *
 *  Created by Si Ma on 7/22/17.
 *  Copyright © 2017 Si Ma. All rights reserved.
 *
 *  Description:
 *
 *  This InspectableView subclass constains a search bar, a table view (for result list),
 *  a result detail container (to give additional info of a result).
 *
 *  Most of the styling properties of the view itself are editable in IB.
 *
 *  SMSpotlightSearchBarDelegate, UITableViewDatasource & UITableViewDelegate are not implemented here,
 *  but should be implemented in a view controller
 */

import UIKit

@IBDesignable public class SMSpotlightSearchView: InspectableView {
    
    @IBInspectable var dividerColour: UIColor = UIColor.lightGray {
        didSet{
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var searchBarHeightConstraintConstant: CGFloat {
        get {
            return self.searchBarHeightConstraint.constant
        }
        set {
            self.searchBarHeightConstraint.constant = newValue
            self.layoutSubviews()
        }
    }
    
    // UI Elements
    private(set) var searchBar: SMSpotlightSearchBar!
    private(set) var resultListTableView: UITableView!
    private(set) var resultDetailContainerView: UIView!
    private var searchResultContainer: UIView!
    
    // Constaints
    fileprivate var resultListFullWidthConstraint: NSLayoutConstraint!
    fileprivate var resultList40PercentWidthConstraint: NSLayoutConstraint!
    private var searchBarHeightConstraint: NSLayoutConstraint!
    
    // Result container dividers widths
    private let horizontalDividerWidth: CGFloat = 0.5
    private let verticalDividerWidth: CGFloat = 0.5
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUIElements()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUIElements()
    }
    
    public convenience init(frame: CGRect, dividerColour: UIColor?) {
        self.init(frame: frame)
        if let colour = dividerColour {
            self.dividerColour = colour
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    private func setupUIElements() {
        self.searchBar = SMSpotlightSearchBar(frame: CGRect.zero, font: nil, textColour: nil)
        self.addSubview(self.searchBar)
        self.applyConstraintsOnSearchBar()
        
        self.searchResultContainer = UIView(frame: CGRect.zero)
        self.searchResultContainer.backgroundColor = UIColor.clear
        self.addSubview(self.searchResultContainer)
        self.applyConstraintsOnSearchResultContainerView()
        
        self.resultListTableView = UITableView(frame: CGRect.zero, style: .plain)
        self.resultListTableView.separatorStyle = .none
        self.searchResultContainer.addSubview(self.resultListTableView)
        self.applyConstraintsOnResultListTableView()
        
        self.resultDetailContainerView = UIView(frame: CGRect.zero)
        self.resultDetailContainerView.backgroundColor = UIColor.clear
        self.searchResultContainer.addSubview(self.resultDetailContainerView)
        self.applyConstraintsOnResultDetailContainerView()
    }
    
    private func applyConstraintsOnSearchBar() {
        let topConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        self.searchBarHeightConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, self.searchBarHeightConstraint])
    }
    
    private func applyConstraintsOnSearchResultContainerView() {
        let topConstraint = NSLayoutConstraint(item: self.searchResultContainer, attribute: .top, relatedBy: .equal, toItem: self.searchBar, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.searchResultContainer, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.searchResultContainer, attribute: .leading, relatedBy: .equal, toItem: self.searchBar, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self.searchResultContainer, attribute: .trailing, relatedBy: .equal, toItem: self.searchBar, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        self.searchResultContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    private func applyConstraintsOnResultListTableView() {
        let topConstraint = NSLayoutConstraint(item: self.resultListTableView, attribute: .top, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.resultListTableView, attribute: .bottom, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.resultListTableView, attribute: .leading, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        self.resultListFullWidthConstraint = NSLayoutConstraint(item: self.resultListTableView, attribute: .width, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .width, multiplier: 1.0, constant: 0.0)
        self.resultList40PercentWidthConstraint = NSLayoutConstraint(item: self.resultListTableView, attribute: .width, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .width, multiplier: 0.4, constant: -self.verticalDividerWidth)
        
        self.resultListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint])
    }
    
    private func applyConstraintsOnResultDetailContainerView() {
        let topConstraint = NSLayoutConstraint(item: self.resultDetailContainerView, attribute: .top, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.resultDetailContainerView, attribute: .bottom, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.resultDetailContainerView, attribute: .leading, relatedBy: .equal, toItem: self.resultListTableView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self.resultDetailContainerView, attribute: .trailing, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        self.resultDetailContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    // MARK: Update search result style based on horizontal size class
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            self.adjustSearchResultUIWithHorizontalSizeClass(horizontalSizeClass: self.traitCollection.horizontalSizeClass)
        }
    }
    
    private func adjustSearchResultUIWithHorizontalSizeClass(horizontalSizeClass: UIUserInterfaceSizeClass) {
        DispatchQueue.main.async {
            if self.traitCollection.horizontalSizeClass == .compact {
                self.resultDetailContainerView.isHidden = true
                self.resultList40PercentWidthConstraint.isActive = false
                self.resultListFullWidthConstraint.isActive = true
            }
            else {
                self.resultDetailContainerView.isHidden = false
                self.resultListFullWidthConstraint.isActive = false
                self.resultList40PercentWidthConstraint.isActive = true
            }
            self.layoutSubviews()
        }
    }
    
    func updateSearchViewHeightWithConstraint(heightConstraint: NSLayoutConstraint, expandingValue: CGFloat, animated: Bool) {
        
        guard let superView = self.superview else { return }
        guard self.frame.size.height != self.searchBar.frame.size.height + expandingValue else { return }
        
        DispatchQueue.main.async {
            // Force to finish all ongoing layout update
            self.layoutIfNeeded()
            
            var resultContainerAlpha: CGFloat
            if expandingValue > 0.0 {
                resultContainerAlpha = 1.0
            }
            else {
                resultContainerAlpha = 0.0
            }
            
            if animated == true {
                UIView.animate(withDuration: 0.07, animations: {
                    self.searchResultContainer.alpha = resultContainerAlpha
                    heightConstraint.constant = self.searchBar.frame.size.height + expandingValue
                    superView.layoutIfNeeded()
                })
            }
            else {
                self.searchResultContainer.alpha = resultContainerAlpha
                heightConstraint.constant = self.searchBar.frame.size.height + expandingValue
                superView.layoutIfNeeded()
            }
        }
    }
    
    override public func draw(_ rect: CGRect) {
        
        guard self.frame.size.height > self.searchBar.frame.origin.y + self.searchBar.frame.size.height else {return}
        
        let currentContext = UIGraphicsGetCurrentContext()
        guard let context = currentContext else {
            return
        }
        context.saveGState()
        
        let horizontalDividerStartPoint = CGPoint(x: self.searchBar.frame.origin.x, y: self.searchBar.frame.size.height - self.horizontalDividerWidth/2)
        let horizontalDividerEndPoint = CGPoint(x: self.searchBar.frame.size.width, y: horizontalDividerStartPoint.y)
        
        context.setStrokeColor(self.dividerColour.cgColor)
        context.setLineWidth(self.horizontalDividerWidth)
        context.move(to: horizontalDividerStartPoint)
        context.addLine(to: horizontalDividerEndPoint)
        context.strokePath()
        
        
        // Only draw the vertical divider in .regular mode
        guard self.traitCollection.horizontalSizeClass == .regular else {
            context.restoreGState()
            return
        }
        
        let verticalDividerStartPoint = CGPoint(x: self.searchResultContainer.frame.size.width * self.resultList40PercentWidthConstraint.multiplier + verticalDividerWidth/2, y: self.searchBar.frame.size.height + self.horizontalDividerWidth/2)
        let verticalDividerEndPoint = CGPoint(x: verticalDividerStartPoint.x, y: self.frame.size.height)
        
        context.setLineWidth(self.verticalDividerWidth)
        context.move(to: verticalDividerStartPoint)
        context.addLine(to: verticalDividerEndPoint)
        context.strokePath()
        
        context.restoreGState()
    }
}

/* Explanation for this extension:
 *
 * IB can't read the value of self.traitCollection yet, so you won't be able to 
 * see the correct layout without manually activate/deactivate the two constraints which
 * manage the tableView's width from prepareForInterfaceBuilder()
 *
 * prepareForInterfaceBuilder() won't be called during runtime
 */
extension SMSpotlightSearchView {
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.resultListTableView.backgroundColor = UIColor.clear
        
        self.resultListFullWidthConstraint.isActive = false
        self.resultList40PercentWidthConstraint.isActive = true
    }
}

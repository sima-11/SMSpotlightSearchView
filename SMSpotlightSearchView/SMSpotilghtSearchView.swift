//
//  SpotilghtSearchPanel.swift
//  SMSpotlightSearchView
//
//  Created by Si Ma on 7/22/17.
//

import UIKit

public class SMSpotlightSearchView: UIView {
    
    var dividerColour: UIColor = UIColor.lightGray {
        didSet{
            self.setNeedsDisplay()
        }
    }
    var heightConstraintIdentifier = ""
    
    private(set) var searchBar: SMSpotlightSearchBar!
    private(set) var resultListTableView: UITableView!
    private(set) var resultDetailContainerView: UIView!
    private var searchResultContainer: UIView!
    
    private var resultListFullWidthConstraint: NSLayoutConstraint!
    private var resultList40PercentWidthConstraint: NSLayoutConstraint!
    
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
        self.addSearchBarConstraints()
        
        self.searchResultContainer = UIView(frame: CGRect.zero)
        self.searchResultContainer.backgroundColor = UIColor.clear
        self.addSubview(self.searchResultContainer)
        self.addSearchResultContainerViewConstraints()
        
        self.resultListTableView = UITableView(frame: CGRect.zero, style: .plain)
        self.resultListTableView.separatorStyle = .none
        self.searchResultContainer.addSubview(self.resultListTableView)
        self.addResultListTableViewConstraints()
        
        self.resultDetailContainerView = UIView(frame: CGRect.zero)
        self.resultDetailContainerView.backgroundColor = UIColor.clear
        self.searchResultContainer.addSubview(self.resultDetailContainerView)
        self.addResultDetailContainerViewConstraints()
    }
    
    private func addSearchBarConstraints() {
        
        let topConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, heightConstraint])
    }
    
    private func addSearchResultContainerViewConstraints() {
        
        let topConstraint = NSLayoutConstraint(item: self.searchResultContainer, attribute: .top, relatedBy: .equal, toItem: self.searchBar, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.searchResultContainer, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.searchResultContainer, attribute: .leading, relatedBy: .equal, toItem: self.searchBar, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self.searchResultContainer, attribute: .trailing, relatedBy: .equal, toItem: self.searchBar, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        self.searchResultContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    private func addResultListTableViewConstraints() {
        
        let topConstraint = NSLayoutConstraint(item: self.resultListTableView, attribute: .top, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.resultListTableView, attribute: .bottom, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.resultListTableView, attribute: .leading, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        self.resultListFullWidthConstraint = NSLayoutConstraint(item: self.resultListTableView, attribute: .width, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .width, multiplier: 1.0, constant: -self.verticalDividerWidth)
        self.resultList40PercentWidthConstraint = NSLayoutConstraint(item: self.resultListTableView, attribute: .width, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .width, multiplier: 0.4, constant: 0.0)
        
        self.resultListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint])
    }
    
    private func addResultDetailContainerViewConstraints() {
        
        let topConstraint = NSLayoutConstraint(item: self.resultDetailContainerView, attribute: .top, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.resultDetailContainerView, attribute: .bottom, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: self.resultDetailContainerView, attribute: .leading, relatedBy: .equal, toItem: self.resultListTableView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self.resultDetailContainerView, attribute: .trailing, relatedBy: .equal, toItem: self.searchResultContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        self.resultDetailContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    func adjustSearchResultUIWithHorizontalSizeClass(horizontalSizeClass: UIUserInterfaceSizeClass) {
        
        DispatchQueue.main.async {
            if self.traitCollection.horizontalSizeClass == .compact {
                self.resultDetailContainerView.isHidden = true
                self.resultList40PercentWidthConstraint.isActive = false
                self.resultListFullWidthConstraint.isActive = true
                self.layoutSubviews()
            }
            else {
                self.resultDetailContainerView.isHidden = false
                self.resultListFullWidthConstraint.isActive = false
                self.resultList40PercentWidthConstraint.isActive = true
                self.layoutSubviews()
            }
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
        
        guard self.resultListTableView.frame.size.width < self.searchResultContainer.frame.size.width else {return}
        
        let verticalDividerStartPoint = CGPoint(x: self.resultListTableView.frame.origin.x + self.resultListTableView.frame.size.width + verticalDividerWidth/2, y: self.searchBar.frame.size.height + self.horizontalDividerWidth/2)
        let verticalDividerEndPoint = CGPoint(x: verticalDividerStartPoint.x, y: self.frame.size.height)
        
        context.setLineWidth(self.verticalDividerWidth)
        context.move(to: verticalDividerStartPoint)
        context.addLine(to: verticalDividerEndPoint)
        context.strokePath()
        
        context.restoreGState()
    }
}

//
//  ViewController.swift
//  SMSpotlightSearchViewDemo
//
//  Created by Si Ma on 7/19/17.
//

/*  Description:
 *
 *  This view controller shows some snippets of how to use SMSpotlightSearchView
 *  E.g. Assign delegates, set search result detail view, etc.
 *
 *  UITableViewDatasource & UITableViewDelegate must be implement 
 *  in order to present the result list
 *
 *
 * ************************** IMPORTANT **************************
 *  Updating the "Height Constraint" is CRITICAL
 *  Otherwise the search view won't expand to show the result
 */

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchView: SMSpotlightSearchView!
    var personInfoDetailView: PersonInfoDetailView!
    var imageView: UIImageView!
    
    var result = [Any]()
    var typingTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         *** Uncomment this block to programmatically styling ***
         
        self.searchView.backgroundColor = UIColor(white: 0.95, alpha: 0.85)
        self.searchView.layer.masksToBounds = true
        self.searchView.layer.borderColor = UIColor.gray.cgColor
        self.searchView.layer.borderWidth = 0.5
        self.searchView.layer.cornerRadius = 10.0
        */
        
        self.searchView.resultListTableView.backgroundColor = UIColor.clear
        self.searchView.resultListTableView.separatorStyle = .none
        self.initialiseDetailViews()
        
        // Set delegates
        self.searchView.searchBar.delegate = self
        self.searchView.resultListTableView.dataSource = self
        self.searchView.resultListTableView.delegate = self
    }
    
    // Initialise possible detail views
    func initialiseDetailViews() {
        
        // PersonInfoDetailView
        self.personInfoDetailView = Bundle.main.loadNibNamed("PersonInfoDetail", owner: self, options: nil)![0] as! PersonInfoDetailView
        self.personInfoDetailView.backgroundColor = UIColor.clear
        
        // ImageView
        self.imageView = UIImageView(frame: CGRect.zero)
        self.imageView.contentMode = .scaleAspectFit
    }
    
    func addSubviewToDetailContainerView(subview: UIView) {
        // If subview is already added to the container, do nothing
        if subview.isDescendant(of: self.searchView.resultDetailContainerView) {
            return
        }
        
        DispatchQueue.main.async {
            // Remove the current subview from container
            for view in self.searchView.resultDetailContainerView.subviews {
                view.removeFromSuperview()
            }
            
            // Add new subview to the container
            self.searchView.resultDetailContainerView.addSubview(subview)
            
            // Apply constraints
            let topConstraint = NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: self.searchView.resultDetailContainerView, attribute: .top, multiplier: 1.0, constant: 0.0)
            let bottomConstraint = NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: self.searchView.resultDetailContainerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            let leadingConstraint = NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: self.searchView.resultDetailContainerView, attribute: .leading, multiplier: 1.0, constant: 0.0)
            let trailingConstraint = NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: self.searchView.resultDetailContainerView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            
            subview.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
            
            // Update layout
            self.searchView.resultDetailContainerView.layoutIfNeeded()
        }
    }
    
    func showResultDetail(detail: Any) {
        if let personInfo = detail as? PersonInfo {
            self.addSubviewToDetailContainerView(subview: self.personInfoDetailView)
            
            DispatchQueue.main.async {
                self.searchView.searchBar.resultTypeImage = UIImage(named: "contactsIcon")
                self.personInfoDetailView.nameLabel.text = "\(personInfo.name) \(personInfo.surname)"
                self.personInfoDetailView.genderLabel.text = personInfo.gender == .Male ? "Male" : "Female"
                self.personInfoDetailView.regionLabel.text = personInfo.region
            }
        }
        else if let imageInfo = detail as? ImageInfo {
            self.addSubviewToDetailContainerView(subview: self.imageView)
            
            DispatchQueue.main.async {
                self.searchView.searchBar.resultTypeImage = UIImage(named: "imageIcon")
                self.imageView.image = UIImage(named: "\(imageInfo.name).\(imageInfo.format)")
            }
        }
        else {
            self.searchView.searchBar.resultTypeImage = nil
            return
        }
    }
    
    func buildMockInfo() -> [Any] {
        let person1 = PersonInfo(name: "Jack", surname: "Depp", gender: .Male, region: "Owensboro")
        let person2 = PersonInfo(name: "Jack", surname: "DiCaprio", gender: .Male, region: "Los Angeles")
        let person3 = PersonInfo(name: "Joe", surname: "Daniels", gender: .Male, region: "Tennessee")
        let image1 = ImageInfo(name: "Jackie Chan", format: "jpg")
        let image2 = ImageInfo(name: "Just Push Play", format: "jpg")
        
        var info = [Any]()
        info.append(person1)
        info.append(person2)
        info.append(person3)
        info.append(image1)
        info.append(image2)
        
        return info
    }
    
    func searchAllInfoWithText(text: String?) {
        self.result.removeAll()
        
        guard let t = text, t != "" else { return }
        let allInfo = self.buildMockInfo()
        for info in allInfo {
            if let personInfo = info as? PersonInfo {
                if (personInfo.name + " " + personInfo.surname).lowercased().hasPrefix(t.lowercased()) {
                    self.result.append(info)
                }
            }
            else if let imageInfo = info as? ImageInfo {
                if (imageInfo.name + "." + imageInfo.format).lowercased().hasPrefix(t.lowercased()) {
                    self.result.append(info)
                }
            }
        }
    }
    
    
    // MARK: Update search result
    
    func updateSearchResult() {
        DispatchQueue.main.async {
            self.searchView.resultListTableView.reloadData()
        }
        
        /*
         Look for the height constraint of the search view with an identifier
         In this case, the identifier is initially set in Main.storyboard
         
         The height constraint can also be an IBOutlet
         So that you don't have to loop through all constraints of the search view
         */
        var heightConstraint: NSLayoutConstraint?
        for constraint in self.searchView.constraints {
            if constraint.identifier == "SearchViewHeight" {
                heightConstraint = constraint
                break
            }
        }
        
        if let constraint = heightConstraint {
            if self.result.count > 0 {
                self.searchView.updateSearchViewHeightWithConstraint(heightConstraint: constraint, expandingValue: 350.0, animated: false)
                
                DispatchQueue.main.async {
                    self.searchView.resultListTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
                    self.showResultDetail(detail: self.result[0])
                }
            }
            else {
                self.searchView.updateSearchViewHeightWithConstraint(heightConstraint: constraint, expandingValue: 0.0, animated: true)
                DispatchQueue.main.async {
                    self.searchView.searchBar.resultTypeImage = nil
                }
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.searchView.traitCollectionDidChange(previousTraitCollection)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
}

extension ViewController: SMSpotlightSearchBarDelegate {
    func searchBarDidChangeText(_ searchBar: SMSpotlightSearchBar) {
        
        self.typingTimer?.invalidate()
        self.typingTimer = nil
        
        self.typingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {(timer: Timer) in
            self.typingTimer?.invalidate()
            self.typingTimer = nil
            
            self.searchAllInfoWithText(text: searchBar.text)
            self.updateSearchResult()
        })
    }
    
    func searchBarShouldReturn(_ searchBar: SMSpotlightSearchBar) -> Bool {
        let _ = searchBar.resignFirstResponder()
        return true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell!.backgroundColor = UIColor.clear
        
        let info = self.result[indexPath.row]
        if let personInfo = info as? PersonInfo {
            cell!.textLabel?.text = "\(personInfo.name) \(personInfo.surname)"
        }
        else if let imageInfo = info as? ImageInfo {
            cell!.textLabel?.text = "\(imageInfo.name).\(imageInfo.format)"
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let info = self.result[indexPath.row]
        self.showResultDetail(detail: info)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
}


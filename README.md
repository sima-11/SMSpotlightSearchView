<p align="center"><img src ="/Screenshots/example_1.png"/></p>

# SMSpotlightSearchView
- Custom search / text input control for iOS.
- Written in Swift.


# How To Use
#### Step 1 Import SMSpotlightSearchView
Drag the folder `SMSpotlightSearView` into your Xcode project.

Note: 
InspectableView is used to show some handy visual configurations in Interface Builder. Feel free to drop it if you'll do styling programmatically.
Also, if you only feel interested in the search bar, then only add `SMSpotlightSearchBar.swift` to the project.

#### Step 2 Initialise SMSpotlightSearchView
#### Using Storyboard
You can configure the visual presentation of both SMSpotlightSearchView or SMSpotlightSearchBar from a storyboard. E.g.
<p align="center"><img src ="/Screenshots/example_IB configuration.png"/></p>

#### Programmatically
Simply use `SMSpotlightSearchView(frame:)` to initialise your search view by using the default colour for dividers (the horizontal and vertical lines in search result view).

To set colour for the dividers, either use `SMSpotlightSearchView(frame:, dividerColour:)` or set the `dividerColour` property after the initialisation.

E.g.:
```swift
let searchView = SMSpotlightSearchView(frame: YOUR_FRAME, dividerColour: YOUR_COLOUR)
```

#### Step 3 Set Delegates
In order to do actual search and present search result, these are the delegates that should be set and implemented:
`searchView.searchBar.delegate` - this is a wrapper of UITextFieldDelegate, which is used to react to editing of the search input box.
`searchView.resultListTableView.dataSource` and `searchView.resultListTableView.delegate` - UITableView's datasource and delegate, which is used to present result.


#### Step 4 *IMPORTANT* Update Height Constraint
Regardless of whether using storyboard or not, if applying Auto Layout in your project, you will have to update the height constraint of the search view in order to show/hide the search result view.
Simply call `searchView.updateSearchViewHeightWithConstraint(heightConstraint:, expandingValue:, animated:)`, which takes the height constraint and a value you would like its height to be. 

E.g.:
```swift
searchView.updateSearchViewHeightWithConstraint(heightConstraint: constraint, expandingValue: YOUR_VALUE, animated: false)
```

# More Info
The framework comes with a sample project to demonstrate how to use it.


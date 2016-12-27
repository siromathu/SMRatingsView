# SMRatingsView

`SMRatingsView` is a `UIView` subclass that creates a customizable rating view containing rating stars in it. 

# Usage

`SMRatingsView` can be created as simple as this

    let ratingsView = SMRatingsView(frame: CGRect(x: 20, y: 300, width: self.view.frame.size.width-40, height: 60))
    view.addSubview(ratingsView)
    
or, with a little more customisation like this

    let ratingsView = SMRatingsView(frame: CGRect(x: 20, y: 300, width: self.view.frame.size.width-40, height: 60),
                                        numberOfStars: 5,
                                        selectionStyle: Style.pan,
                                        selectedImage: UIImage(named: "selectedStar"),
                                        deselectedImage: UIImage(named: "deselectedStar"))
    view.addSubview(ratingsView)
    
    
# Description

A simple initialization gives you 

    1. Default 5 stars
    2. Tap gesture and Pan gesture
    3. Default selected and deselected image from unicode
    
It can be customized to show custom images, number of stars to be shown and style of selection.

//
//  SMRatingsView.swift
//  Project
//
//  Created by Siroson Mathuranga Sivarajah on 12/10/16.
//  Copyright © 2016 Siroson Mathuranga Sivarajah. All rights reserved.
//

// MARK: - Types
enum Style {
    case tap, pan, both
}

import UIKit

let deselectedStar = "☆"
let selectedStar = "⭐"

class SMRatingsView: UIView {
    
    // MARK:- Properties
    var numberOfStars = 5
    
    private var starViews = [UIImageView]()
    private var panGesture: UIPanGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    
    private var selectedImage: UIImage!
    private var deselectedImage: UIImage!
    
    // MARK:- Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setInitialView(numberOfStars: nil, selectionStyle: nil, selectedImage: nil, deselectedImage: nil)
    }
    
    convenience init(frame: CGRect, numberOfStars: Int) {
        self.init(frame: frame)
        
        setInitialView(numberOfStars: numberOfStars, selectionStyle: nil, selectedImage: nil, deselectedImage: nil)
    }
    
    convenience init(frame: CGRect, numberOfStars: Int, selectionStyle: Style) {
        self.init(frame: frame)
        
        setInitialView(numberOfStars: numberOfStars, selectionStyle: selectionStyle, selectedImage: nil, deselectedImage: nil)
    }
    
    convenience init(frame: CGRect, numberOfStars: Int, selectionStyle: Style, selectedImage: UIImage, deselectedImage: UIImage) {
        self.init(frame: frame)
        
        setInitialView(numberOfStars: numberOfStars, selectionStyle: selectionStyle, selectedImage: selectedImage, deselectedImage: deselectedImage)
    }
    
    func setInitialView(numberOfStars: Int?, selectionStyle: Style?, selectedImage: UIImage?, deselectedImage: UIImage?) {
        
        if let numberOfStars = numberOfStars {
            self.numberOfStars = numberOfStars
        }
        
        // Get respective images
        if let selectedImage = selectedImage {
            self.selectedImage = selectedImage
        } else {
            self.selectedImage = selectedStar.image(size: CGSize(width: frame.size.width/CGFloat(self.numberOfStars), height: frame.size.width/CGFloat(self.numberOfStars)))
        }
        
        if let deselectedImage = deselectedImage {
            self.deselectedImage = deselectedImage
        } else {
            self.deselectedImage = deselectedStar.image(size: CGSize(width: frame.size.width/CGFloat(self.numberOfStars), height: frame.size.width/CGFloat(self.numberOfStars)))
        }
        
        // Initialize corresponding gesture
        if let selectionStyle = selectionStyle {
            switch selectionStyle {
            case .tap:
                setTapGesture()
            case .pan:
                setPanGesture()
            case .both:
                setTapGesture()
                setPanGesture()
            }
        }
        else {
            setTapGesture()
            setPanGesture()
        }
        
        // Setup subviews
        setRatingsView()
    }
    
    // MARK- Convenience Methods
    private func setPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    private func setTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    private func setRatingsView() {
        let ratingStarWidth = self.frame.size.width/CGFloat(numberOfStars)
        
        for i in 0..<numberOfStars {
            let imageView = UIImageView(image: deselectedImage)
            imageView.frame = CGRect(x: CGFloat(i)*ratingStarWidth, y: 0, width: ratingStarWidth, height: self.frame.size.height)
            imageView.contentMode = .scaleAspectFit
            imageView.tag = i
            starViews.append(imageView)
            self.addSubview(imageView)
        }
    }
    
    private func reset(touchPoint: CGPoint) {
        let ratingStarWidth = self.frame.size.width/CGFloat(numberOfStars)
        let count = Int(touchPoint.x/ratingStarWidth + 1.0)
        
        for i in 0..<numberOfStars {
            if i < Int(count) {
                starViews[i].image = selectedImage
            }
            else {
                starViews[i].image = deselectedImage
            }
        }
    }
    
    // MARK:- Gesture Handlers
    @objc private func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let touchPoint = gestureRecognizer.location(in: self)
            reset(touchPoint: touchPoint)
        }
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self)
        reset(touchPoint: touchPoint)
    }
}

fileprivate extension String {
    func image(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let img = renderer.image { ctx in
            let rect = CGRect(origin: CGPoint.zero, size: size)
            (self as NSString).draw(in: rect, withAttributes: [NSFontAttributeName: UIFont.systemFont(ofSize: size.width-5)])
        }
        
        return img
    }
}

extension SMRatingsView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

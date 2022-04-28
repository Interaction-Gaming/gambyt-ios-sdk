//
//  UIView+extension.swift
//  mal-ios
//
//  Created by Noah Karman on 5/21/19.
//  Copyright © 2019 Interaction Gaming. All rights reserved.
//

import UIKit

extension UIView {
    func addSubViewAndFillParent(_ subView: UIView?) {
        if let subView = subView {
            subView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(subView)
            let bindings: [String: AnyObject] = ["subView": subView]
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
        }
    }

    func addSubViewToMarginsOfParent(_ subView: UIView?) {
        if let subView = subView {
            subView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(subView)
            let bindings: [String: AnyObject] = ["subView": subView]
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[subView]-|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[subView]-|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
        }
    }

    //https://stackoverflow.com/questions/25551053/cornerradius-with-border-glitch-around-border credit to @CRDave for this bezier path extension
    func makeBorderWithCornerRadius(radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let rect = self.bounds;

        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))

        // Create the shape layer and set its path
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path  = maskPath.cgPath

        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer

        //Create path for border
        let borderPath = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))

        // Create the shape layer and set its path
        let borderLayer = CAShapeLayer()

        borderLayer.frame       = rect
        borderLayer.path        = borderPath.cgPath
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor   = UIColor.clear.cgColor
        borderLayer.lineWidth   = borderWidth * UIScreen.main.nativeScale
        borderLayer.name        = "border_layer"

        //Add this layer to give border.
        self.layer.addSublayer(borderLayer)
    }

    func removeBorderWithCornerRadius() {
        if let sublayers = self.layer.sublayers {
            for layer: CALayer in sublayers {
                if layer.name == "border_layer" {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }

    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.layer.add(animation, forKey: nil)
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
     }

    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func addShadow(radius: CGFloat, opacity: Float,
                   color: UIColor, xOffset: CGFloat, yOffset: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}

// MARK: - Autolayout

extension UIView {
    var autolayout: Bool {
        get {
            return !translatesAutoresizingMaskIntoConstraints
        }
        
        set(newValue) {
            translatesAutoresizingMaskIntoConstraints = !newValue
        }
    }
    
    @discardableResult func withAutoLayout() -> Self {
        autolayout = true
        return self
    }
    
    func constraintsToPinEdgesToSuperviewEdges(priority: UILayoutPriority = UILayoutPriority(1000.0),
                                               leading: CGFloat = 0.0,
                                               trailing: CGFloat = 0.0,
                                               top: CGFloat = 0.0,
                                               bottom: CGFloat = 0.0) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        var constraints = [topAnchor.constraint(equalTo: superview.topAnchor, constant: top)]
        constraints.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading))
        constraints.append(trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailing))
        constraints.append(bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom))

        for constraint in constraints {
            constraint.priority = priority
        }
        
        return constraints
    }

    func constraintsToPinToSuperviewLeading(inset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return [leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset)]
    }

    func constraintsToPinToSuperviewTrailing(inset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return [trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset)]
    }

    func constraintsToPinToSuperviewTop(inset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return [topAnchor.constraint(equalTo: superview.topAnchor, constant: inset)]
    }

    func constraintsToPinToSuperviewTopSafe(inset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return [topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: inset)]
    }

    func constraintsToPinToSuperviewBottom(inset: CGFloat = 0.0) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return [bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset)]
    }

    func constraintsToSetHeight(height: CGFloat) -> [NSLayoutConstraint] {
        return [heightAnchor.constraint(equalToConstant: height)]
    }

    func constraintsToSetWidth(width: CGFloat) -> [NSLayoutConstraint] {
        return [widthAnchor.constraint(equalToConstant: width)]
    }


    func constraintsToSetWidthProportionalTo(view: UIView? = nil, multiplier: CGFloat) -> [NSLayoutConstraint] {
        guard let viewToMatch = view ?? superview else { return [] }
        return [widthAnchor.constraint(equalTo: viewToMatch.widthAnchor, multiplier: multiplier)]
    }

    func constraintsToSetHeightProportionalTo(view: UIView? = nil, multiplier: CGFloat) -> [NSLayoutConstraint] {
        guard let viewToMatch = view ?? superview else { return [] }
        return [heightAnchor.constraint(equalTo: viewToMatch.heightAnchor, multiplier: multiplier)]
    }
    
    func constraintsToSetHeightProportionalToWidth(ratio: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .height,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .width,
                                   multiplier: ratio,
                                   constant: 0)]
    }

    /**
     Aligns this views X axis to another view's X axis

     - Parameter view: The view whose X axis this view's X axis will be aligned to (defaults to the view's superview)
     - Parameter offset: Amount in pixels to offset the alignment
     */


    func constraintsToAlignX(view: UIView? = nil, offset: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let view = view ?? superview else { return [] }
        return [centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset)]
    }

    /**
     Aligns this view's Y axis to another view's Y axis

     - Parameter view: The view whose Y axis this view's Y axis will be aligned to (defaults to the view's superview)
     - Parameter offset: Amount in pixels to offset the alignment
     */
    func constraintsToAlignY(view: UIView? = nil, offset: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let view = view ?? superview else { return [] }
        return [centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset)]
    }

    func constraintsToCenterInSuperview() -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return [
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ]
    }

    func constraintsToSetDimensions(width: CGFloat? = nil, height: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if let width = width {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }
        return constraints
    }
}

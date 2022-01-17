//
//  CardView.swift
//

import UIKit

@IBDesignable
class UICardView: UIView {
    
    @IBInspectable public var topLeft: Bool = false      { didSet { updateCorners() } }
    @IBInspectable public var topRight: Bool = false     { didSet { updateCorners() } }
    @IBInspectable public var bottomLeft: Bool = false   { didSet { updateCorners() } }
    @IBInspectable public var bottomRight: Bool = false  { didSet { updateCorners() } }
    @IBInspectable public var cornerRadius: CGFloat = 0  { didSet { updateCorners() } }
    
    @IBInspectable
    open var borderColor: UIColor? {
        get {
            guard let bcolor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: bcolor)
        }
        set(value) {
            layer.borderColor = value?.cgColor
        }
    }
    
    @IBInspectable
    open var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set(value) {
            layer.shadowOffset = value
        }
    }
    
    @IBInspectable
    open var shadowColor: UIColor? {
        get {
            guard let sColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: sColor)
        }
        set(value) {
            layer.shadowColor = value?.cgColor
        }
    }
    
    @IBInspectable
    open var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set(value) {
            layer.shadowOpacity = value
        }
    }
    
    @IBInspectable
    open var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set(value) {
            layer.shadowPath = value
        }
    }
    
    @IBInspectable
    open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(value) {
            layer.shadowRadius = value
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(value) {
            layer.borderWidth = value
        }
    }
    
    @IBInspectable
    open var opacity: Float {
        get {
            return layer.opacity
        }
        set(value) {
            layer.opacity = value
        }
    }
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateCorners()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateCorners()
    }
    
    private func updateCorners() {
        var corners = CACornerMask()
        
        if topLeft     { corners.formUnion(.layerMinXMinYCorner) }
        if topRight    { corners.formUnion(.layerMaxXMinYCorner) }
        if bottomLeft  { corners.formUnion(.layerMinXMaxYCorner) }
        if bottomRight { corners.formUnion(.layerMaxXMaxYCorner) }
        
        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
    }
}

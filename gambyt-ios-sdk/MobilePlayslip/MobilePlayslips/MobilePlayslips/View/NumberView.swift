import UIKit

@IBDesignable
class KenoHotNumberView: NumberView {}

@IBDesignable
class AoNHotNumberView: NumberView {}

@IBDesignable
class KenoColdNumberView: NumberView {}

@IBDesignable
class AoNColdNumberView: NumberView {}

@IBDesignable
class CircleNumberView: NumberView {}

@IBDesignable
class MultiplierView: NumberView {
    override func setup() {
        view = loadViewFromNib()
        addSubViewAndFillParent(view)
        numberLabel?.text = nil
        numberLabel?.isAccessibilityElement = true
        isAccessibilityElement = true
    }

    override var number: Int? {
        get {
            return numberLabel?.text != nil ? Int(numberLabel!.text!) : nil
        }
        set {
            numberLabel?.text = newValue != nil ? "\(String(newValue!))X" : nil
        }
    }
}

@IBDesignable
class RoundedRectNumberView: NumberView {
    override func setup() {
        view = loadViewFromNib()
        addSubViewAndFillParent(view)

        animationView = LotteryAnimationView(animationName: .numberRectableLoad)
        addSubViewAndFillParent(animationView)

        numberLabel?.text = nil
        isAccessibilityElement = true
        numberLabel?.isAccessibilityElement = true
    }
}

@IBDesignable
class FilledCircleNumberView: NumberView {
    override func setup() {
        view = loadViewFromNib()
        addSubViewAndFillParent(view)

        animationView = LotteryAnimationView(animationName: .numberBallWhiteFill)
        addSubViewAndFillParent(animationView)
        
        numberLabel?.text = nil
        isAccessibilityElement = true
        self.accessibilityTraits = .staticText
        numberLabel?.isAccessibilityElement = true
    }
}

@IBDesignable
class EmptyCircleNumberView: NumberView {
    override func setup() {
        view = loadViewFromNib()
        addSubViewAndFillParent(view)
        isAccessibilityElement = true
        self.accessibilityTraits = .staticText
        self.heightAnchor.constraint(equalToConstant: 32).isActive = true
        self.widthAnchor.constraint(equalToConstant: 32).isActive = true
        numberLabel?.isAccessibilityElement = true
    }
}

@IBDesignable
class NumberView: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var numberLabel: UILabel?
    
    @IBInspectable var animateOnLoad: Bool = true {
        didSet {
            animationView?.isHidden = !animateOnLoad
        }
    }
    
    var animationView: LotteryAnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        view = loadViewFromNib()
        addSubViewAndFillParent(view)
        
        animationView = LotteryAnimationView(animationName: .numbersFadeInDark)
        addSubViewAndFillParent(animationView)
        
        numberLabel?.text = nil
        isAccessibilityElement = true
        numberLabel?.isAccessibilityElement = true
        self.accessibilityTraits = .staticText
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    func loadNumberAnimation() {
        guard self.animateOnLoad else { return }
        
        self.view.alpha = 0.0
        animationView?.alpha = 1.0
        animationView?.isHidden = false
        
        self.animationView?.play(toFrame: 30.0, completion: { (complete) in
            if complete {
                // fade out on completion
                UIView.animate(withDuration: 0.1) {
                    self.animationView?.alpha = 0.0
                    self.animationView?.isHidden = true
                }
            }
        })
        
        // fade label back in while animation is playing for smoothest transition
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            UIView.animate(withDuration: 1.0) {
                self.view.alpha = 1.0
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        number = 7
        super.prepareForInterfaceBuilder()
    }
    
    var number: Int? {
        get {
            return numberLabel?.text != nil ? Int(numberLabel!.text!) : nil
        }
        set {
            loadNumberAnimation()
            numberLabel?.text = newValue != nil ? String(newValue!) : nil
        }
    }
}

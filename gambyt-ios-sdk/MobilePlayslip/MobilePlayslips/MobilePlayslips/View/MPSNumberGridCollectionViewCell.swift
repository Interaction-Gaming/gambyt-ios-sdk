//
//  NumberGridCollectionViewCell.swift
//  mal-ios
//
//  Created by Noah Karman on 5/27/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit

enum ExposedEdge {
    case top
    case left
    case right
    case bottom
}

class MPSNumberGridCollectionViewCell: UICollectionViewCell {
    
    let label = UILabel()
    
    var number: Int? {
        didSet {
            if let number = number {
                self.label.text = String(number)
            }
        }
    }
    
    var grayLabel = false {
        didSet {
            label.textColor = grayLabel ? .playslipDisabledText : .black
        }
    }
    
    var exposedEdges: [ExposedEdge] = [] {
        didSet {
            for edge in exposedEdges {
                addSingleEdgeBorder(for: edge)
            }
        }
    }
    
    override func prepareForReuse() {
        self.backgroundColor = .white
        label.text = nil
        label.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        _init()
    }
    
    func _init() {
        self.borderColor = .black
        self.borderWidth = 1
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "RobotoSlab-Regular", size: 17.0)
        self.addSubViewAndFillParent(label)
        self.clipsToBounds = false
    }
    
    func addSingleEdgeBorder(for edge: ExposedEdge) {
        let frame = edge == .bottom || edge == .top ?
            CGRect(x: 0, y: 0, width: self.frame.width, height: 1) :
            CGRect(x: 0, y: 0, width: 1, height: self.frame.height)
        
        let edgeView = UIView(frame: frame)
        edgeView.backgroundColor = .black
        edgeView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(edgeView)
        self.bringSubviewToFront(edgeView)
        
        switch edge {
        case .left:
            edgeView.widthAnchor.constraint(equalToConstant: 1).isActive = true
            edgeView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            
            edgeView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            edgeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            edgeView.trailingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        case .right:
            edgeView.widthAnchor.constraint(equalToConstant: 1).isActive = true
            edgeView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            
            edgeView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            edgeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            edgeView.leadingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        case .top:
            edgeView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            edgeView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            
            edgeView.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
            edgeView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            edgeView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        case .bottom:
            edgeView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            edgeView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            
            edgeView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            edgeView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            edgeView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
        self.layoutSubviews()
        self.updateConstraints()
    }
}

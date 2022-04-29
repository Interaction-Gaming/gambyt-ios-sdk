//
//  DynamicHeightCollectionView.swift
//  mal-ios
//
//  Created by Aaron Rosenfeld (Work) on 1/21/21.
//  Copyright © 2021 Interaction Gaming. All rights reserved.
//

import UIKit

//from: https://github.com/pgpt10/DynamicHeightCollectionView/blob/master/DynamicHeightCollectionView/Example/DynamicHeightCollectionView.swift

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

//
//  BaseCollectionCell.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-04.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//
//  QueuesNavigationBar.swift
//  queuer
//
//  Created by Shoutem on 5/20/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit

class QueuesNavigationBar: UINavigationBar {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        barTintColor = UIConstants.navigationBarTintColor
        isTranslucent = false
        setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        shadowImage = UIImage()
        titleTextAttributes = [NSFontAttributeName: UIConstants.navigationItemTitleFont,
                               NSForegroundColorAttributeName: UIConstants.navigationItemTitleColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSFontAttributeName: UIConstants.navigationItemTitleFont,
             NSForegroundColorAttributeName: UIConstants.navigationItemButtonColor], for: .normal)
    } 
}

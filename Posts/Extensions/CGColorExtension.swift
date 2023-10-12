//
//  CGColorExtension.swift
//  Notes
//
//  Created by Luis Sergio Duran Arenas on 23/09/23.
//

import Foundation
import UIKit

public extension CGColor {
    var UIColor : UIKit.UIColor {
        return UIKit.UIColor(cgColor: self)
    }
}

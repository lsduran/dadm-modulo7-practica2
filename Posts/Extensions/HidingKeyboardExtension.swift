//
//  HidingKeyboardExtension.swift
//  Posts
//
//  Created by Luis Sergio Duran Arenas 12/10/23.
//

import Foundation
import UIKit

extension AddPostViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

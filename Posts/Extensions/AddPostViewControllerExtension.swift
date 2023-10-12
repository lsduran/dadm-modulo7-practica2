//
//  AddPostViewControllerExtension.swift
//  Posts
//
//  Created by Luis Sergio Duran Arenas on 12/10/23.
//

import Foundation
import UIKit

extension AddPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            textView.borderColor = .lightGray
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        print(textView.text(in: textView.selectedTextRange!)!)
    }
}

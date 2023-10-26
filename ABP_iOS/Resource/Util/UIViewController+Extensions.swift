//
//  ViewControllerExtension.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/27/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: 빈 화면 터치 시 키패드 사라지게 하기
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

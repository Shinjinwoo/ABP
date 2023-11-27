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
    
    func configureWeatherImage(SKY: String, PTY: String, fcstTime: String) -> UIImage {
        if SKY == Sky.Sunny.rawValue && PTY == Pty.Sunny.rawValue{
            if  fcstTime >= "0600" && fcstTime <= "1800" {
                return (UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal))!
            } else {
                return (UIImage(systemName: "moon.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.yellow))!
            }
        }
        
        if SKY == Sky.Foggy.rawValue || SKY == Sky.Cloudy.rawValue {
            switch PTY {
            case Pty.Sunny.rawValue :
                return (UIImage(systemName: "cloud.fill")?.withRenderingMode(.alwaysOriginal))!
                
            case Pty.Raniy.rawValue :
                return (UIImage(systemName: "cloud.rain.fill")?.withRenderingMode(.alwaysOriginal))!
                
            case Pty.RainyAndSnowy.rawValue :
                return (UIImage(systemName: "cloud.rain.fill")?.withRenderingMode(.alwaysOriginal))!
                
            case Pty.Snowy.rawValue :
                return (UIImage(systemName: "cloud.snow.fill")?.withRenderingMode(.alwaysOriginal))!
                
            default :
                break
            }
        }
        
        return UIImage(systemName: "sun.horizon.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage(systemName: "sun.horizon.fill")!
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

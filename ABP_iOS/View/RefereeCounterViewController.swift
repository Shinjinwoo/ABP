//
//  ViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/25/23.
//

import UIKit

class RefereeCounterViewController: UIViewController {

    @IBOutlet weak var homeTeamTF: UITextField!
    @IBOutlet weak var awayTeamTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        homeTeamTF.delegate = self
        awayTeamTF.delegate = self
        
        print("RefereeCounterViewController.viewDidLoad: ")
    }
    
    
}

extension RefereeCounterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        //해당 VC에서는 입력을 완료시에 저장하거나 포커스 이동기능이 불필요
        textField.resignFirstResponder()
        return true
    }
}

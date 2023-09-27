//
//  ViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/25/23.
//

import UIKit

class RefereeCounterViewController: UIViewController {

    @IBOutlet weak var homeTeamNameTF: UITextField!
    @IBOutlet weak var awayTeamNameTF: UITextField!
    
    @IBOutlet weak var homeTeamScoreTF: UITextField!
    @IBOutlet weak var awayTeamScoreTF: UITextField!
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var midStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        setupUI()
        
        
        print("RefereeCounterViewController.viewDidLoad: ")
    }
    
    
    private func setupUI() {
        homeTeamNameTF.delegate  = self
        awayTeamNameTF.delegate  = self
        homeTeamScoreTF.delegate = self
        awayTeamScoreTF.delegate = self
        
        midStackView.layer.borderWidth  = 1.0
        midStackView.layer.borderColor  = UIColor.gray.cgColor
        midStackView.layer.cornerRadius = 25
        
        topStackView.layer.borderWidth  = 1.0
        topStackView.layer.borderColor  = UIColor.gray.cgColor
        topStackView.layer.cornerRadius = 25
        
        bottomStackView.layer.borderWidth = 1.0
        bottomStackView.layer.borderColor = UIColor.gray.cgColor
        bottomStackView.layer.cornerRadius = 25
    }
    
    
}

extension RefereeCounterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //해당 VC에서는 입력을 완료시에 저장하거나 포커스 이동기능이 불필요
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
}

//
//  ViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/25/23.
//

import UIKit
import Combine

class RefereeCounterViewController: UIViewController {

    @IBOutlet weak var homeTeamNameTF: UITextField!
    @IBOutlet weak var awayTeamNameTF: UITextField!
    
    @IBOutlet weak var firstStrikeImage: UIImageView!
    @IBOutlet weak var secondStrikeImage: UIImageView!
    
    @IBOutlet weak var firstBallImage: UIImageView!
    @IBOutlet weak var secondBallImage: UIImageView!
    @IBOutlet weak var thirdBallImage: UIImageView!
    
    @IBOutlet weak var firstOutImage: UIImageView!
    @IBOutlet weak var secondOutImage: UIImageView!
    
    @IBOutlet weak var strikeCountStepper: UIStepper!
    @IBOutlet weak var ballCountStepper: UIStepper!
    @IBOutlet weak var outCountStepper: UIStepper!
    
    @IBOutlet weak var homeTeamScoreTF: UITextField!
    @IBOutlet weak var awayTeamScoreTF: UITextField!
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var midStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    var viewModel: RefereeCounterViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        viewModel = RefereeCounterViewModel(scoreboard: ScoreBoard.default)
        setupUI()
        bind()
        
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
    
    private func bind() {
        viewModel.$scoreboard
            .receive(on: RunLoop.main)
            .sink { scoreboard in
                
                self.configureScoreboard(scoreboard: scoreboard)
    
//                print("스트라이크 카운트 바인딩 값 : \(scoreboard.strikeCount)")
//                print("볼 카운트 바인딩 값 : \(scoreboard.ballCount)")
//                print("아웃 카운트 바인딩 값 : \(scoreboard.outCount)")
                
            }.store(in: &subscriptions)
    }
    
    
    private func configureScoreboard(scoreboard: ScoreBoard) {
        
        self.strikeCountStepper.value = Double(scoreboard.strikeCount)
        self.ballCountStepper.value = Double(scoreboard.ballCount)
        self.outCountStepper.value  = Double(scoreboard.outCount)
        
        
        configureStrikeImage(strikeCount: scoreboard.strikeCount)
        configureBallImage(ballCount: scoreboard.ballCount)
        configureOutImage(outCount: scoreboard.outCount)
        
    }
    
    private func configureStrikeImage(strikeCount:Int) {
        switch strikeCount  {
        case 0  :
            firstStrikeImage.image = UIImage(named: "circle_outline_yellow")
            secondStrikeImage.image = UIImage(named: "circle_outline_yellow")
        case 1  :
            firstStrikeImage.image = UIImage(named: "circle_yellow")
            secondStrikeImage.image = UIImage(named: "circle_outline_yellow")
        case 2  :
            secondStrikeImage.image = UIImage(named: "circle_yellow")
        default :
            break
        }
    }
    
    private func configureBallImage(ballCount:Int) {
        switch ballCount  {
        case 0  :
            firstBallImage.image = UIImage(named: "circle_outline_green")
            secondBallImage.image = UIImage(named: "circle_outline_green")
            thirdBallImage.image = UIImage(named: "circle_outline_green")
        case 1  :
            firstBallImage.image = UIImage(named: "circle_green")
            secondBallImage.image = UIImage(named: "circle_outline_green")
        case 2  :
            secondBallImage.image = UIImage(named: "circle_green")
            thirdBallImage.image = UIImage(named: "circle_outline_green")
        case 3  :
            thirdBallImage.image = UIImage(named: "circle_green")
        default :
            break
        }
    }
    
    private func configureOutImage(outCount:Int) {
        switch outCount  {
        case 0  :
            firstOutImage.image = UIImage(named: "circle_outline_red")
            secondOutImage.image = UIImage(named: "circle_outline_red")
        case 1  :
            firstOutImage.image = UIImage(named: "circle_red")
            secondOutImage.image = UIImage(named: "circle_outline_red")
        case 2  :
            secondOutImage.image = UIImage(named: "circle_red")
        default :
            break
        }
    }
    
    @IBAction func strikeStepperOnTabed(_ sender: UIStepper) {
        if ( sender.maximumValue == sender.value ) {
            viewModel.strikeOut()
        } else {
            viewModel.setStrikeCount(strikeCount:Int(sender.value))
        }
    }
    
    @IBAction func ballStepperOnTabed(_ sender: UIStepper) {
        if (sender.maximumValue == sender.value) {
            viewModel.baseOnBalls()
        } else {
            viewModel.setBallCount(ballCount: Int(sender.value))
        }
    }
    
    @IBAction func outStepperOnTabed(_ sender: UIStepper) {
        if ( sender.maximumValue == sender.value ) {
            viewModel.endOfTheInning()
        } else {
            viewModel.setOutCount(outCount: Int(sender.value))
        }
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



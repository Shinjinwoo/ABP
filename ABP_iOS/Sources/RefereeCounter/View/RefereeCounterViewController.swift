//
//  ViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/25/23.
//

import UIKit
import Combine
import CoreData

class RefereeCounterViewController: UIViewController {
    
    // 팀이름
    @IBOutlet weak var homeTeamNameTF: UITextField!
    @IBOutlet weak var awayTeamNameTF: UITextField!
    
    //팀뷰
    @IBOutlet var homeTeamView: UIView!
    @IBOutlet var awayTeamView: UIView!
    
    //스트라이크 이미지
    @IBOutlet weak var firstStrikeImage: UIImageView!
    @IBOutlet weak var secondStrikeImage: UIImageView!
    
    //볼 이미지
    @IBOutlet weak var firstBallImage: UIImageView!
    @IBOutlet weak var secondBallImage: UIImageView!
    @IBOutlet weak var thirdBallImage: UIImageView!
    
    //아웃카운트 이미지
    @IBOutlet weak var firstOutImage: UIImageView!
    @IBOutlet weak var secondOutImage: UIImageView!
    
    //이닝 라벨
    @IBOutlet weak var inningLabel: UILabel!
    
    //이닝,S,B,O 스탭퍼
    @IBOutlet weak var inningStepper: UIStepper!
    @IBOutlet weak var strikeCountStepper: UIStepper!
    @IBOutlet weak var ballCountStepper: UIStepper!
    @IBOutlet weak var outCountStepper: UIStepper!
    
    // 팀별 스코어
    @IBOutlet weak var homeTeamScore: UITextField!
    @IBOutlet weak var awayTeamScore: UITextField!
    
    // 스코어 스탭퍼
    @IBOutlet weak var homeTeamScoreStepper: UIStepper!
    @IBOutlet weak var awayTeamScoreStepper: UIStepper!
    
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
        
        print("RefereeCounterViewController : viewDidLoad: ")
    }
    
    
    private func setupUI() {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        
        homeTeamNameTF.delegate  = self
        awayTeamNameTF.delegate  = self
        homeTeamScore.delegate = self
        awayTeamScore.delegate = self
        
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
                
            }.store(in: &subscriptions)
    }
    
    
    private func configureScoreboard(scoreboard: ScoreBoard) {
        
        self.strikeCountStepper.value = Double(scoreboard.strikeCount)
        self.ballCountStepper.value = Double(scoreboard.ballCount)
        self.outCountStepper.value  = Double(scoreboard.outCount)
        self.inningStepper.value = Double(scoreboard.inning)
        self.homeTeamScoreStepper.value = Double(scoreboard.homeTeamScore)
        self.awayTeamScoreStepper.value = Double(scoreboard.awayTeamScore)
        
        configureScore(homeTeamScore: scoreboard.homeTeamScore, awayTeamScore: scoreboard.awayTeamScore)
        configureInning(inning: scoreboard.inning)
        configureStrikeImage(strikeCount: scoreboard.strikeCount)
        configureBallImage(ballCount: scoreboard.ballCount)
        configureOutImage(outCount: scoreboard.outCount)
    }
    
    private func configureScore(homeTeamScore:Int, awayTeamScore:Int) {
        
        self.homeTeamScore.text = "\(homeTeamScore)"
        self.awayTeamScore.text = "\(awayTeamScore)"
    }
    
    private func configureInning(inning: Int ) {
        if ( inning % 2 == 0 ) {
            inningLabel.text = "\(inning / 2 )회 초"
            
            awayTeamNameTF.layer.borderWidth  = 1.0
            awayTeamNameTF.layer.borderColor  = UIColor.systemBlue.cgColor
            
            homeTeamNameTF.layer.borderWidth = 0
            
        } else {
            inningLabel.text = "\(inning / 2 )회 말"
            
            homeTeamNameTF.layer.borderWidth  = 1.0
            homeTeamNameTF.layer.borderColor  = UIColor.systemBlue.cgColor
            
            awayTeamNameTF.layer.borderWidth = 0
        }
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
    
    @IBAction func strikeStepperOnTapped(_ sender: UIStepper) {
        if ( sender.maximumValue == sender.value ) {
            viewModel.strikeOut()
        } else {
            viewModel.setStrikeCount(strikeCount:Int(sender.value))
        }
    }
    
    @IBAction func ballStepperOnTapped(_ sender: UIStepper) {
        if ( sender.maximumValue == sender.value) {
            viewModel.baseOnBalls()
        } else {
            viewModel.setBallCount(ballCount: Int(sender.value))
        }
    }
    
    @IBAction func outStepperOnTapped(_ sender: UIStepper) {
        if ( sender.maximumValue == sender.value ) {
            viewModel.endOfTheInning()
        } else {
            viewModel.setOutCount(outCount: Int(sender.value))
        }
    }
    
    @IBAction func inningStepperOnTapped(_ sender: UIStepper) {
        viewModel.setInning(inning: Int(sender.value))
    }
    
    @IBAction func homeTeamStepperOnTapped(_ sender: UIStepper) {
        viewModel.setHomeTeamScore(score: Int(sender.value))
    }
    
    @IBAction func awayTeamStepperOnTapped(_ sender: UIStepper) {
        viewModel.setAwayTeamScore(score: Int(sender.value))
    }
    
    @IBAction func homeTeamScoreEditingChanged(_ sender: UITextField) {
        if sender.text != nil {
            if let intValue: Int = Int(sender.text!) {
                viewModel.setHomeTeamScore(score: Int(intValue))
            }
        }
    }
    
    @IBAction func awayTeamScoreEditingChanged(_ sender: UITextField) {
        if sender.text != nil {
            if let intValue: Int = Int(sender.text!) {
                viewModel.setAwayTeamScore(score: Int(intValue))
            }
        }
    }
    
    
    @IBAction func resetSBCounteOnTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "볼 카운트 리셋", message: "볼카운트를 리셋 하시겠습니까 ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "예", style: .destructive, handler: { _ in self.viewModel.resetSBCount() }))
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: { _ in  }))

        present(alert, animated: true)
    }
    
    @IBAction func resetScoreboardOnTapped(_ sender: UIButton) {
        
        let sheet = UIAlertController(title: "스코어보드 리셋", message: "스코어보드를 리셋 하시겠습니까 ?", preferredStyle: .actionSheet)
        
        let alert = UIAlertController(title: "홈,어웨이 팀명 리셋", message: "팀명도 리셋 하시겠습니까 ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "예", style: .destructive, handler: { _ in
            self.homeTeamNameTF.text = ""
            self.awayTeamNameTF.text = "" }))
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: { _ in  }))
        
        sheet.addAction(UIAlertAction(title: "예", style: .destructive, handler: { _ in
            self.viewModel.resetScoreBoard()
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: { _ in  }))

        present(sheet, animated: true)
        
    }
}

extension RefereeCounterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //해당 VC에서는 입력을 완료시에 저장하거나 포커스 이동기능이 불필요
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case homeTeamScore : presentInputAlert(for: homeTeamScore, with: homeTeamNameTF.text, placeholder: "홈팀",isTeamNameField: false)
        case awayTeamScore : presentInputAlert(for: awayTeamScore, with: awayTeamNameTF.text, placeholder: "어웨이팀",isTeamNameField: false)
        case homeTeamNameTF : presentInputAlert(for: homeTeamNameTF, with: homeTeamNameTF.text, placeholder: "홈팀",isTeamNameField: true)
        case awayTeamNameTF : presentInputAlert(for: awayTeamNameTF, with: awayTeamNameTF.text, placeholder: "어웨이팀",isTeamNameField: true)
        default : break
        }
    }
    
    func presentInputAlert(for parentTextField: UITextField, with alertTitle: String?, placeholder: String, isTeamNameField:Bool) {
        
        let tile = alertTitle == "" ? placeholder : alertTitle
        let message = isTeamNameField ? "팀명" : "스코어"
        let alertController = UIAlertController(title: tile,
                                                message: "\(message) 입력창", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            if let textField = alertController.textFields?.first, let strValue = textField.text {
                switch parentTextField {
                case self.homeTeamScore: if let intValue = Int(strValue) { self.viewModel.setHomeTeamScore(score: intValue) }
                case self.awayTeamScore: if let intValue = Int(strValue) { self.viewModel.setAwayTeamScore(score: intValue) }
                case self.homeTeamNameTF: self.homeTeamNameTF.text = strValue
                case self.awayTeamNameTF: self.awayTeamNameTF.text = strValue
                default: break
                }
            }
        }
        
        let noAction = UIAlertAction(title: "취소", style: .default)
        
        alertController.addAction(noAction)
        alertController.addAction(okAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "새로운 \(message) 입력"
            textField.keyboardType = isTeamNameField ? .default : .numberPad
        }
        self.present(alertController, animated: true, completion: nil)
    }
}


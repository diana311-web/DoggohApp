//
//  StatementViewController.swift
//  Doggoh-Starter

//


import UIKit


protocol QuizDelegate: class {
    func userDidAnswerQuestions(atIndex: Int, withCorrectAnswer answer: Bool)
}

class StatementViewController: UIViewController {
    
    var statement: Statement!
    var itemIndex: Int!
    var totalItems: Int!
    
    weak var delegate: QuizDelegate?
    
    var answerChosen: String!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var optionBtnA: StatementButton!
    @IBOutlet weak var optionBtnB: StatementButton!
    @IBOutlet weak var optionBtnC: StatementButton!
    @IBOutlet weak var optionBtnD: StatementButton!
    @IBOutlet weak var nextQuestionBtn: StatementButton!
    
    func evaluate(statement: Statement, answer: String) -> Bool {
        return statement.answer == answer ? true : false
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        delegate?.userDidAnswerQuestions(atIndex: itemIndex, withCorrectAnswer: evaluate(statement: statement, answer: answerChosen))
    }
    
    @IBAction func optionClicked(_ sender: UIButton) {
        nextQuestionBtn.isEnabled = true
        nextQuestionBtn.backgroundColor = UIColor.init(red: 241/255, green: 89/255, blue: 32/255, alpha: 1)
        
        let allButtons = [optionBtnA, optionBtnB, optionBtnC, optionBtnD]
        let dictButtons = [optionBtnA: "a", optionBtnB: "b", optionBtnC: "c", optionBtnD: "d",]
        
        for item in allButtons {
            if sender == item {
                item?.didSelect(type: .option)
                answerChosen = dictButtons[item]
            } else {
                item?.didDeselect(type: .option)
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupButtons()
        update(withStatement: statement, atIndex: itemIndex, inTotal: totalItems)
    }
    
    
    
    func update(withStatement statement: Statement, atIndex index: Int, inTotal total: Int) {
        questionLabel.text = statement.statementText
        progressLabel.text = "\(index+1)/\(total)"
        
        let allButtons = [optionBtnA, optionBtnB, optionBtnC, optionBtnD]
        var i = 0
        for item in allButtons {
            item?.setTitle(statement.options[i], for: .normal)
            i += 1
        }
        
        nextQuestionBtn.isEnabled = false
        nextQuestionBtn.backgroundColor = UIColor(displayP3Red: 237/255, green: 175/255, blue: 148/255, alpha: 0.8)
        
        if index == 9 {
            nextQuestionBtn.setTitle("FINISH", for: .normal)
        }
    }
    
    
    
    
    func setupButtons() {
        optionBtnA.configure(withButtonType: .option)
        optionBtnB.configure(withButtonType: .option)
        optionBtnC.configure(withButtonType: .option)
        optionBtnD.configure(withButtonType: .option)
        nextQuestionBtn.configure(withButtonType: .next)
    }
}


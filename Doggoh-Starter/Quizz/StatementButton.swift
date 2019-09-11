//
//  StatementButton.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 02/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

enum StatementButtonType {
    case option
    case profileOption
    case next, start, reset
    
    var width: CGFloat {
        switch self {
        case .option:
            return 152.5
        default:
            return 175
        }
    }
    
    var height: CGFloat {
        switch self {
        case .option:
            return 48
        case .profileOption:
            return 32
        default:
            return 50
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .option:
            return 2
        default:
            return 0
        }
    }
    
    var borderColor: CGColor {
        switch self {
        case .option:
            return UIColor.lightGray.cgColor
        default:
            return UIColor.red.cgColor
        }
    }
    
    var bgColor: UIColor {
        switch self {
        case .option:
            return UIColor.white
        case .profileOption:
            return UIColor(red: 229 / 255, green: 230 / 255, blue: 236 / 255, alpha: 1)
        default:
            return UIColor(red: 241 / 255, green: 89 / 255, blue: 32 / 255, alpha: 1)
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .option:
            return UIColor.black
        case .profileOption:
            return UIColor(red: 181 / 255, green: 184 / 255, blue: 199 / 255, alpha: 1)
        default:
            return UIColor.white
        }
    }
    
    var cornerRadius: CGFloat { return 5 }
    
}

class StatementButton: UIButton {

    func configure(withButtonType type: StatementButtonType) {
       
        switch type {
        case .option, .start:
            layer.cornerRadius = layer.frame.height / 2
            layer.frame.size = CGSize(width: type.width, height: type.height)
        default:
            layer.cornerRadius = 14
            layer.borderWidth = type.borderWidth
        }
        
        layer.borderColor = type.borderColor
        backgroundColor = type.bgColor
        setTitleColor(type.titleColor, for: .normal)
        titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        layer.cornerRadius = type.cornerRadius
        layer.borderWidth = type.borderWidth

        
    }
    
    func didSelect(type: StatementButtonType) {
        switch type {
        case .option:
            backgroundColor = .lightGray
            setTitleColor(UIColor(red: 241/255, green: 89/255, blue: 32/255, alpha: 1), for: .normal)
        default:
            backgroundColor = UIColor(red: 244 / 255, green: 112 / 255, blue: 62 / 255, alpha: 1)
            setTitleColor(.white, for: .normal)
        }
    }
    
    func didDeselect(type: StatementButtonType) {
        backgroundColor = type.bgColor
        setTitleColor(type.titleColor, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        var superSize = super.intrinsicContentSize
        superSize.width += 20
        return superSize
    }
    
}





//
//  WLCardKeyBoard.swift
//  JMTAPP
//
//  Created by 王垒 on 2017/4/27.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit


/************************  屏幕尺寸  ***************************/
// 屏幕宽度
let JMTWindowWidth = UIScreen.main.bounds.size.width

// 屏幕高度
let JMTWindowHeight = UIScreen.main.bounds.size.height

// iPhone 5
let isIphone5 = JMTWindowHeight  == 568 ? true : false

// iPhone 6
let isIphone6 = JMTWindowHeight  == 667 ? true : false

// iphone 6P
let isIphone6P = JMTWindowHeight == 736 ? true : false


/************************  颜色处理  ***************************/
// 获得RGB颜色
func JMTRGB(r:CGFloat,_ g:CGFloat,_ b: CGFloat) -> UIColor{
    
    return UIColor (red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}


/************************    字体处理  ***************************/
func JMTFont(s:CGFloat) -> UIFont{
    
    return UIFont.systemFont(ofSize: s)
}


/************************    图片处理  ***************************/
func JMTImage(name: String) -> UIImage {
    
    return UIImage(named: name)!
}


private let marginvalue = CGFloat(0.5)

private let defaultDoneColor = JMTRGB(r: 28, 171, 235)

public enum Style {

    case idCard
    
    case number
}

public class WLCardKeyBoard: UIInputView, UITextFieldDelegate {

    public static let defaule = WLCardKeyBoard(frame: CGRect(x: 0, y: 0, width: JMTWindowWidth, height: 224), inputViewStyle: .keyboard)
    
    public var style = Style.idCard{
    
        didSet {
        
            setKeyBoardButton(style: style)
        }
    }
    
    public var isSafety: Bool = false {
    
        didSet{
        
            if isSafety {
                
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotify(notifiction:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            }
        }
    }
    
    public var shouldHighlight = true {
    
        didSet{
        
            highlight(heghlight: shouldHighlight)
        }
    }
    
    public func customDoneButton(title: String, titleColor: UIColor = UIColor.white, theme: UIColor = defaultDoneColor, target: UIViewController? = nil, callback: Selector? = nil) {
        setDoneButton(title: title, titleColor: titleColor, theme: theme, target: target, callback: callback)
    }

    
    private var textFields = [UITextField]()
    
    private var superView: UIView?
    
    private var buttons: [UIButton] = []
    
    public convenience init (_ view: UIView, field: UITextField? = nil){
    
        self.init(frame: CGRect.zero, inputViewStyle: .keyboard)
        addKeyBoard(view, field: field)
    }
    
    private override init (frame _: CGRect, inputViewStyle: UIInputViewStyle) {
    
        var frameH = CGFloat(224)
        
        if isIphone5 {
            
            frameH = CGFloat(224)
            
        }else if isIphone6{
        
            frameH = CGFloat(258)
            
        }else if isIphone6P{
        
            frameH = CGFloat(271)
        }
        
        
        super.init(frame: CGRect(x: 0, y: 0, width: JMTWindowWidth, height: frameH), inputViewStyle: inputViewStyle)
        
        backgroundColor = .lightGray
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addKeyBoard(_ view: UIView, field: UITextField? = nil) {
    
        superView = view
        
        customSubView()
        if let textField = field {
            textFields.append(textField)
            textField.inputView = self
            textField.delegate = self
        } else {
            for view in (superView?.subviews)! {
                if view.isKind(of: UITextField.self) {
                    let textField = view as! UITextField
                    textField.delegate = self
                    textField.inputView = self
                    textFields.append(textField)
                }
            }
        }

    }
    
    private func customSubView() {
    
        var backSpace : UIImage?
        
        var dismiss   : UIImage?
        
        backSpace = JMTImage(name: "Keyboard_Backspace")
        
        dismiss   = JMTImage(name: "Keyboard_DismissKey")
        
        for idex in 0 ... 13 {
            
            let button = UIButton()
            
            button.titleLabel?.font = JMTFont(s: 28)
            
            button.backgroundColor = UIColor.white
            
            button.tag = idex
            
            highlight(heghlight: shouldHighlight)
            addSubview(button)
            button.setTitleColor(UIColor.black, for: .normal)
            switch idex {
            case 9:
                button.setTitle("", for: .normal)
                button.setImage(dismiss, for: .normal)
            case 10:
                button.setTitle("0", for: .normal)
                buttons.append(button)
            case 11:
                button.setTitle("X", for: .normal)
            case 12:
                button.setTitle("", for: .normal)
                button.setImage(backSpace, for: .normal)
            case 13:
                button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                button.backgroundColor = defaultDoneColor
                button.setTitleColor(UIColor.white, for: .normal)
                button.setBackgroundImage(nil, for: .normal)
                button.setBackgroundImage(nil, for: .highlighted)
                button.setTitle(LocalizedString(key: "Done"), for: .normal)
            default:
                button.setTitle("\(idex + 1)", for: .normal)
                buttons.append(button)
            }
            button.addTarget(self, action: #selector(tap), for: .touchUpInside)

        }
        
    }
    
    func tap(sender: UIButton) {
        guard let text = sender.currentTitle else {
            fatalError("not found the sender's currentTitle")
        }
        switch sender.tag {
        case 12:
            firstResponder()?.deleteBackward()
        case 13, 9:
            firstResponder()?.resignFirstResponder()
        default:
            firstResponder()?.insertText(text)
        }
    }
    
    func firstResponder() -> UITextField? {
        var firstResponder: UITextField?
        for field in textFields {
            if field.isFirstResponder {
                firstResponder = field
            }
        }
        return firstResponder
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews {
            if view.isKind(of: UIButton.self) {
                let width = frame.width / 4 * 3
                let idx = view.tag
                if idx >= 12 {
                    view.frame = CGRect(x: width + marginvalue, y: CGFloat((idx - 12) % 2) * (frame.height / 2.0 + marginvalue), width: frame.width / 4, height: (frame.height - marginvalue) / 2.0)
                } else {
                    view.frame = CGRect(x: CGFloat(idx % 3) * ((width - 2 * marginvalue) / 3 + marginvalue), y: CGFloat(idx / 3) * (frame.height / 4.0 + marginvalue), width: (width - 2 * marginvalue) / 3, height: frame.height / 4.0)
                }
            }
        }
    }
    
    func highlight(heghlight: Bool) {
        for view in subviews {
            if let button = view as? UIButton {
                if button.tag == 13 { return }
                if heghlight {
                    button.setBackgroundImage(UIImage.WL_image(with: .white), for: .normal)
                    button.setBackgroundImage(UIImage.WL_image(with: .lightGray), for: .highlighted)
                } else {
                    button.setBackgroundImage(UIImage.WL_image(with: .white), for: .normal)
                    button.setBackgroundImage(UIImage.WL_image(with: .white), for: .highlighted)
                }
            }
        }
    }
    
    func setKeyBoardButton(style: Style) {
        guard let button = findButton(by: 11) else {
            fatalError("not found the button with the tag")
        }
        switch style {
        case .idCard:
            button.setTitle("X", for: .normal)
        case .number:
            let locale = Locale.current
            let decimalSeparator = locale.decimalSeparator! as String
            button.setTitle(decimalSeparator, for: .normal)
        }
    }
    
    func findButton(by tag: Int) -> UIButton? {
        for button in subviews {
            if button.tag == tag {
                return button as? UIButton
            }
        }
        return nil
    }
    
    func LocalizedString(key: String) -> String {
        return (Bundle(identifier: "com.apple.UIKit")?.localizedString(forKey: key, value: nil, table: nil))!
    }
    
    func setDoneButton(title: String, titleColor: UIColor, theme: UIColor, target: UIViewController?, callback: Selector?) {
        guard let itemButton = findButton(by: 13) else {
            fatalError("not found the button with the tag")
        }
        if let selector = callback, let target = target {
            itemButton.addTarget(target, action: selector, for: .touchUpInside)
        }
        itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        itemButton.setTitle(title, for: .normal)
        itemButton.backgroundColor = theme
        itemButton.setTitleColor(titleColor, for: .normal)
    }
    
    func keyboardWillShowNotify(notifiction _: NSNotification) {
        titles = titles.sorted { _ in
            arc4random() < arc4random()
        }
        if !buttons.isEmpty {
            for (idx, item) in buttons.enumerated() {
                item.setTitle(titles[idx], for: .normal)
            }
        }
    }
    
    private lazy var titles = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

}

extension UIImage {
    public class func WL_image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.set()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}


// MARK: UIInputViewAudioFeedback
extension WLCardKeyBoard : UIInputViewAudioFeedback {
    open var enableInputClicksWhenVisible: Bool {
        return true
   }
}

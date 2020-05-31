//
//  AlerteableViewController.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import UIKit
import RxSwift
import SwiftMessages

protocol AlerteableViewController {
    
    func presentAlert(title: String?,
                      message: String?,
                      textField: AlertTextField?,
                      buttonTitle: String?,
                      cancelButtonTitle: String?,
                      alertClicked: ((AlertButtonClicked) -> Void)?)
    
}

extension AlerteableViewController where Self: UIViewController {
    
    func alert(_ info: String, theme: Theme = .info, title: String? = nil, iconImage: UIImage? = nil, iconText: String? = nil, buttonImage: UIImage? = nil, buttonTitle: String? =  nil, buttonTapHandle: ((_ button: UIButton) -> Void)? = nil) -> Void {
        DispatchQueue.main.async {
            // View setup
            let view: MessageView
            view = try! SwiftMessages.viewFromNib()
            
            view.configureContent(title: title, body: info, iconImage: iconImage, iconText: iconText, buttonImage: buttonImage, buttonTitle: buttonTitle, buttonTapHandler: buttonTapHandle)
            
            let iconStyle: IconStyle
            iconStyle = .light
            view.configureTheme(theme, iconStyle: iconStyle)
            view.configureDropShadow()
            
            view.button?.isHidden = true
            view.iconImageView?.isHidden = true
            view.iconLabel?.isHidden = true
            view.titleLabel?.isHidden = true
            view.bodyLabel?.isHidden = false
            
            // Config setup
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .bottom
            config.duration = .seconds(seconds: 2)
            config.dimMode = .gray(interactive: true)
            config.shouldAutorotate = true
            config.interactiveHide = true
            
            // Set status bar style unless using card view (since it doesn't
            // go behind the status bar).
            config.preferredStatusBarStyle = .lightContent
            
            
            // Show
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    func showAlertB() -> Void {
        
    }
    
    func presentAlert(title: String? = nil,
                      message: String? = nil,
                      textField: AlertTextField? = nil,
                      buttonTitle: String? = nil,
                      cancelButtonTitle: String? = nil,
                      alertClicked: ((AlertButtonClicked) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        
        if let cancelButtonTitle = cancelButtonTitle {
            let dismissAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
                alertClicked?(.Cancel)
            }
            alertController.addAction(dismissAction)
        }
        
        if let textFieldConfig = textField {
            alertController.addTextField { (textField) in
                textField.placeholder = textFieldConfig.placeholder
                textField.text = textFieldConfig.text
                
                if let buttonTitle = buttonTitle {
                    let buttonAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
                        alertClicked?(.ButtonWithText(textField.text))
                    }
                    alertController.addAction(buttonAction)
                }
            }
        } else {
            if let buttonTitle = buttonTitle {
                let buttonAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
                    alertClicked?(.Button)
                }
                alertController.addAction(buttonAction)
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

enum AlertButtonClicked {
    case Button
    case ButtonWithText(String?)
    case Cancel
}

func == (lhs: AlertButtonClicked, rhs: AlertButtonClicked) -> Bool {
    switch (lhs, rhs) {
    case (.Button, .Button):
        return true
    case (.ButtonWithText, .ButtonWithText):
        return true
    case (.Cancel, .Cancel):
        return true
    default:
        return false
    }
}

struct AlertTextField {
    let text: String?
    let placeholder: String?
    
    init(text: String?, placeholder: String?) {
        self.text = text
        self.placeholder = placeholder
    }
}

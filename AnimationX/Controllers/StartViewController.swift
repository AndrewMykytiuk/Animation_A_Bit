//
//  ViewController.swift
//  AnimationX
//
//  Created by User on 18/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

enum AccessType {
    case Password
    case Guest
}

class StartViewController: UIViewController, PopUpViewControllerDelegate {

    @IBOutlet weak var startImage: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var tenantTypeButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var centerAlignUsername: NSLayoutConstraint!
    @IBOutlet weak var centerAlignPassword: NSLayoutConstraint!
    @IBOutlet weak var centerAlignGuestLogin: NSLayoutConstraint!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginAsAGuestButton: UIButton!
    
    var isAlreadyAppear: Bool = false
    var changedSecurityType: Bool = false
    
    var numberOfChoosenInf: Int = 0
    var previousType: String = ""
    
    var names: [String] = []
    var securityType: [[String]] = []
    var accType = AccessType.Guest
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.layer.cornerRadius = 5
        
        NetworkManager.getData { (data, error) in
            self.names = data["name"]?[0] ?? []
            self.securityType = data["security_types"] ?? []
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tenantTypeButton.alpha = 0
        logInZeroAlphas()
        guestLogInZeroAlphas()
        
    }
    
    //MARK: - Animation and UI
    
    func logInZeroAlphas() {
    loginButton.alpha = 0
    usernameTextField.alpha = 0
    passwordTextField.alpha = 0
    }
    
    func guestLogInZeroAlphas() {
        loginAsAGuestButton.alpha = 0
    }
    
    func objectAppear(_ object: Any) {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseInOut, animations: {
            
            if object is UIButton {
                let button = object as! UIButton
                button.alpha = 1.0
            } else if object is UITextField {
                let textField = object as! UITextField
                textField.alpha = 1.0
            }
            
            self.view.layoutIfNeeded()
            
        })
    }
    
    func objectDisappear(_ constraint: NSLayoutConstraint, isGuestEnter: Bool) {
        
        UIView.animate(withDuration: 1.3, delay: 0.00, options: .curveEaseOut, animations: {
            
            constraint.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            
      }, completion: { finished  in
        
        if constraint.constant < 0 {
            
            if isGuestEnter {
                self.guestLogInZeroAlphas()
            } else {
                self.logInZeroAlphas()
            }
            
        }

            constraint.constant += self.view.bounds.width
        })
    }
    
    func setUpUI() {
        switch accType {
        case .Guest:
            if isAlreadyAppear {
                objectDisappear(centerAlignUsername, isGuestEnter: false)
                objectDisappear(centerAlignPassword, isGuestEnter: false)
            }
            
            objectAppear(loginAsAGuestButton)
            isAlreadyAppear = true
        case .Password:
            
            if isAlreadyAppear {
                objectDisappear(centerAlignGuestLogin, isGuestEnter: true)
            }
            
            objectAppear(usernameTextField)
            objectAppear(passwordTextField)
            objectAppear(loginButton)
            isAlreadyAppear = true
        }
    }
    
    func caseOfLogInType(_ info: String) {
        if info == "password" {
            accType = .Password
        } else {
            accType = .Guest
        }
    }
    
    //MARK: - Actions
    
    @IBAction func selectTenantButtonDidTouch(_ sender: Any) {
        
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController // 1
        
        popUpVC.data = names
        popUpVC.delegate = self
        
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        
        popUpVC.didMove(toParent: self)
        changedSecurityType = false
        
    }
    
    @IBAction func selectSecurityType(_ sender: Any) {
        
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController // 1
        
        popUpVC.data = securityType[numberOfChoosenInf]
        popUpVC.delegate = self
        
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        
        popUpVC.didMove(toParent: self)
        
        changedSecurityType = true
    }
    
    
    @IBAction func loginButtonDidTouch(_ sender: UIButton) {
        
        let bounds = sender.bounds
        
        //Animate
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveLinear, animations: {
            
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 40, height: bounds.size.height)
            sender.isEnabled = false
            
            
        }, completion: { finished in UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveLinear, animations: {
            
            sender.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
            sender.isEnabled = true
            
        }) })
    }
    
    //MARK: - PopUpViewControllerDelegate
    
    func getInfo(_ info: String, numberInArray: Int) {
        if changedSecurityType {
            tenantTypeButton.titleLabel?.text = info
            caseOfLogInType(info)
            setUpUI()
        } else {
            selectButton.titleLabel?.text = info
            numberOfChoosenInf = numberInArray
            objectAppear(tenantTypeButton)
        }
    }
    
}

extension StartViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

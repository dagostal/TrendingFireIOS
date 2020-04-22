//
//  LoginViewController.swift
//  TrendingFire
//
//  Created by alex on 11/29/19.
//  Copyright © 2019 Alex D'Agostino. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class SignupController: UIViewController {
    
    var emailTextInput = ""
    var passwordTextInput = ""
    var fireNameTextInput = ""
    var vSpinner:UIView?
    
    @objc func getUserNameText(sender:UITextField){
        emailTextInput = sender.text!
    }
    
    @objc func getPasswordText(sender:UITextField){
        passwordTextInput = sender.text!
    }
    
    @objc func getFireNameText(sender:UITextField){
        fireNameTextInput = sender.text!
    }   
    
    // MARK: Lifecycle

    override func loadView() {
        super.loadView()
        view.backgroundColor = .black
        view.addSubview(trendingFireLabelSignup)
        view.addSubview(userNameTextFieldSignup)
        view.addSubview(passwordTextFieldSignup)
        view.addSubview(fireNameTextField)
        view.addSubview(signupButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTrendingFireLabelSignup(v:self.view)
        setUpUserNameTextFieldSignup(v:self.view)
        setUpPasswordTextFieldSignup(v:self.view)
        setUpFireNameTextField(v:self.view)
        setUpSignUpButton(v:self.view)
        
        signupButton.addTarget(self, action: #selector(signupAttempt), for: .touchUpInside)
        userNameTextFieldSignup.addTarget(self, action: #selector(getUserNameText), for: .editingChanged)
        fireNameTextField.addTarget(self, action: #selector(getFireNameText), for: .editingChanged)
        passwordTextFieldSignup.addTarget(self, action: #selector(getPasswordText), for: .editingChanged)
        
        userNameTextFieldSignup.delegate = self
        fireNameTextField.delegate = self
        passwordTextFieldSignup.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        self.view.layer.borderColor = UIColor.white.cgColor
        self.view.layer.borderWidth = 2
        
    }
    
    @objc func handleLogin(){
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "signupToMain", sender: self)
    }

    @objc func signupAttempt() {
        if(passwordTextInput.count < 1 || emailTextInput.count < 1 || fireNameTextInput.count < 1 ) {
            let alert = UIAlertController(title: "Missing Info", message: "Please complete all boxes", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
            self.present(alert, animated: true)
            return;
        }
        attemptSignup()
    }

//
    func attemptSignup(){
        print("attempting signup")
        if(fireNameTextInput.count > 15) {
            self.present(trendingFireAlerts(alertName: "userNameTooLong",sender:self), animated: true)
            return;
        }
        showSpinner(onView: self.view)
    
        let params: [String: String] = [
            "email" : emailTextInput.lowercased(),
            "password" : passwordTextInput.lowercased(),
            "firename" : fireNameTextInput
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        if let url = URL(string:"https://agile-dusk-73308.herokuapp.com/register_login") {
            let session = URLSession.shared
             var request = URLRequest(url: url)
             request.httpMethod = "POST"
             request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                         
             let signUpReq = session.uploadTask(with: request, from: jsonData,completionHandler: handleSignup(data:response:error:))
            signUpReq.resume()
        }
    }
    
    func handleSignup(data:Data?,response: URLResponse?,error:Error?) {
        if error != nil {
            print("error in response")
            self.removeSpinner()
            print(error!)
            return
        }
        if let safeData = data {
            let responseData = JSON(safeData)
            if(responseData[0] == "success") {
                print("sign in success!")
                    //sign in user
                self.removeSpinner()
                let Userdefaults = UserDefaults.standard
                Userdefaults.set(true,forKey: "loggedIn")
                let userId = String(describing: responseData[1])
                let userRank = "0"
                Userdefaults.set(userId,forKey: "userID")
                Userdefaults.set(userRank,forKey: "userRank")
                DispatchQueue.main.async {
                    self.view.window!.rootViewController?.dismiss(animated:false, completion: nil)
                }
            } else {
                print("error logging in")
                self.removeSpinner()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Username already exists", message: "Please Login to Continue", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Fire", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                return;
            }
        }
    }


}

extension SignupController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}




//
    

    
//
//

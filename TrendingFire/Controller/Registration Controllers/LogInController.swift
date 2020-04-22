//
//  LoginViewController.swift
//  TrendingFire
//
//  Created by alex on 11/29/19.
//  Copyright © 2019 Alex D'Agostino. All rights reserved.
//


import UIKit
import Alamofire
import CoreData
import SwiftyJSON

class LoginController: UIViewController {
    
    var emailTextInput = ""
    var passwordTextInput = ""
    var vSpinner:UIView?
    
    
    @objc func getUserNameText(sender:UITextField){
        emailTextInput = sender.text!
    }

    @objc func getPasswordText(sender:UITextField){
        passwordTextInput = sender.text!
    }
    
    @objc func handleLogin(){
        DispatchQueue.main.async {
            self.view.window!.rootViewController?.dismiss(animated:false, completion: nil)
        }
    }
    
    @objc func signup(){
        self.performSegue(withIdentifier: "toSignup", sender: self)
    }
    
    // MARK: Lifecycle

    override func loadView() {
        super.loadView()
        view.backgroundColor = .black
        view.addSubview(trendingFireLabel)
        view.addSubview(userNameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.borderColor = UIColor.white.cgColor
        self.view.layer.borderWidth = 2
        setUpTrendingFireLabel(v:self.view)
        setUpUserNameTextField(v:self.view)
        setUpPasswordTextField(v:self.view)
        setUpLoginButton(v:self.view)
        
        loginButton.addTarget(self, action: #selector(attemptLogin), for: .touchUpInside)
        
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        
        userNameTextField.addTarget(self, action: #selector(getUserNameText), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(getPasswordText), for: .editingChanged)
        
        self.hideKeyboardWhenTappedAround() 
    }
    

    @objc func attemptLogin(){
        showSpinner(onView: self.view)
        let params: [String: String] = [
            "email" : emailTextInput.lowercased(),
            "password" : passwordTextInput.lowercased()
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        if let url = URL(string:"https://agile-dusk-73308.herokuapp.com/register_login") {
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let logInReq = session.uploadTask(with: request, from: jsonData,completionHandler: handleLogin(data:response:error:))
            logInReq.resume()
        }
    }
            
    func handleLogin(data:Data?,response: URLResponse?,error:Error?) {
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
                let alert = UIAlertController(title: "Username Or Password Incorrect", message: "Please Try Again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            return;
            }
        }
    }

}

extension LoginController: UITextFieldDelegate {

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


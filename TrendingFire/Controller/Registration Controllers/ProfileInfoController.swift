//
//  ProfileInfo.swift
//  TrendingFire

import UIKit
import Alamofire

class ProfileInfo: UIViewController {
    
    // MARK: Lifecycle
    
    @objc func logout(){
        let Userdefaults = UserDefaults.standard
        Userdefaults.set(false,forKey: "loggedIn")
        self.view.window!.rootViewController?.dismiss(animated:false, completion: nil)
                
    }
    
    @objc func createAccount(){
        self.performSegue(withIdentifier: "profiletosignup", sender: self)
      }
    @objc func login(){
           self.performSegue(withIdentifier: "profiletologin", sender: self)
    }
    
    let logOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font! = UIFont(name: "Herculanum",size: 20)!
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    let signupButton: UIButton = {
           let button = UIButton()
           button.backgroundColor = .black
           button.setTitle("Create Account", for: .normal)
           button.titleLabel?.font! = UIFont(name: "Herculanum",size: 20)!
           button.titleLabel?.textColor = .white
           button.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
           button.translatesAutoresizingMaskIntoConstraints = false
          return button
       }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font! = UIFont(name: "Herculanum",size: 20)!
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()

       
    override func loadView() {
        super.loadView()
        view.backgroundColor = .black
        
    }
    
    var userID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userID)
        if(userID.count < 5){
            view.addSubview(signupButton)
            view.addSubview(loginButton)
            setUpSignUpButton()
            setUpLoginButton()
        } else {
            view.addSubview(logOutButton)
            setUpLogOutButton()
        }
    }
    
    func setUpLogOutButton(){
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logOutButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        logOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        logOutButton.layer.borderWidth = 2.0
        logOutButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func setUpSignUpButton(){
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        signupButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        signupButton.layer.borderWidth = 2.0
        signupButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func setUpLoginButton(){
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.bottomAnchor.constraint(equalTo: signupButton.topAnchor,constant:-40).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.borderColor = UIColor.white.cgColor
    }
}

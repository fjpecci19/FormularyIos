//
//  ViewController.swift
//  Formulario
//
//  Created by Franco Pecci on 2023-08-16.
//

import UIKit

protocol ValidationDelegate: AnyObject {
    func isValidEmail(_ email: String) -> Bool
    func isValidPhoneNumber(_ phonenumber: String) -> Bool
    func isValidTin(_ tin: String) -> Bool
}

class ViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phonenumber: UITextField!
    @IBOutlet weak var tin: UITextField!
    @IBOutlet weak var sign: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        phonenumber.delegate = self
        tin.delegate = self
    }
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
        if let phone = phonenumber.text, !isValidPhoneNumber(phone) {
            showAlert(message: "Phone number must start with 09 and have 10 digits")
            return
        }
        
        if let gmail = email.text, !isValidEmail(gmail) {
            showAlert(message: "Enter a valid email")
            return
        }
        
        if let tinnumber = tin.text, !isValidTin(tinnumber) {
            showAlert(message: "The TIN must have 7 numbers, a hyphen and a number at the end")
            return
        }
        
        phonenumber.text = ""
        email.text = ""
        tin.text = ""
        showSucceed(message: "Successful registration")
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^09\\d{8}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    func isValidTin(_ tin: String) -> Bool {
        let tinRegex = #"^\d{7}-\d$"#
        let tinPredicate = NSPredicate(format: "SELF MATCHES %@", tinRegex)
        return tinPredicate.evaluate(with: tin)
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showSucceed(message: String) {
        let alertController = UIAlertController(title: "Registered", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

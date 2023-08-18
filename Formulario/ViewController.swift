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

class ViewController: UIViewController, ValidationDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var civilstatus: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phonenumber: UITextField!
    @IBOutlet weak var tin: UITextField!
    @IBOutlet weak var sign: UIButton!
    
    let defaultDate = Date()
    let genderOptions = ["Male", "Female"]
    let maritalStatusOptions = ["Single", "Married", "Divorced", "Widowed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView(for: sex, with: genderOptions)
        createPickerView(for: civilstatus, with: maritalStatusOptions)
        email.delegate = self
        phonenumber.delegate = self
        phonenumber.keyboardType = .numberPad
        tin.delegate = self
        tin.keyboardType = .numbersAndPunctuation
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
        showSucceed(message: "Successful registration")
        resetFields()
    }
    
    func createPickerView(for textField: UITextField, with options: [String]) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sex.inputView as? UIPickerView {
            return genderOptions.count
        } else if pickerView == civilstatus.inputView as? UIPickerView {
            return maritalStatusOptions.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == sex.inputView as? UIPickerView {
            return genderOptions[row]
        } else if pickerView == civilstatus.inputView as? UIPickerView {
            return maritalStatusOptions[row]
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sex.inputView as? UIPickerView {
            sex.text = genderOptions[row]
        } else if pickerView == civilstatus.inputView as? UIPickerView {
            civilstatus.text = maritalStatusOptions[row]
        }
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
    
    func resetFields() {
        date.setDate(defaultDate, animated: true)
        sex.text = ""
        civilstatus.text = ""
        phonenumber.text = ""
        email.text = ""
        tin.text = ""
    }
}

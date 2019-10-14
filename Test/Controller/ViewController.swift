//
//  ViewController.swift
//  Test
//
//  Created by MacBookPro on 10/7/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit
import Alamofire
import iOSDropDown
import SwiftyJSON
import RealmSwift
import SwiftValidator
import Parse

class ViewController: UIViewController,ValidationDelegate,UITextFieldDelegate {
    
    
    let realm = try? Realm()
    var citiesName: Results<WeatherDataModel>?
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let apiKey = "f9f89e3f8df9497aef7f3556f912f872"
    let validator = Validator()
    
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var cityDropDown: DropDown!
    
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var mobileError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var cityError: UILabel!
    @IBOutlet weak var passError: UILabel!
    @IBOutlet weak var confPassError: UILabel!
    
    @IBOutlet weak var touch: UIButton!
    
    @IBAction func register(_ sender: Any) {
        let name = self.name.text!
        let mobile = self.mobile.text!
        let email = self.email.text!
        let city = self.cityDropDown.text!
        let pass = self.password.text!
        let confPass = self.confirmPass.text!
        
        //check for empty fields
//        if(name.isEmpty || mobile.isEmpty || email.isEmpty || city.isEmpty || pass.isEmpty || confPass.isEmpty)
//        {
            print("Validating...")
         //   validator.validate(delegate: self)
            
            
            
        //}
        
        
        //Store Data
        let myUser = PFUser()
        
        myUser.username = name
        myUser.password = pass
        myUser.email = email
        myUser["confirmPassword"] = confPass
        myUser["phone"] = mobile
        myUser["address"] = city
        
        
        myUser.signUpInBackground{(success, error) in
            if success{
                self.validator.validate(delegate: self)
                print("user Added.........")
            }
            else{
                if let descripe = error?.localizedDescription{
                    self.errorMessage.text = descripe
                    
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let check = CheckBox()
        //
        //          self.touch.isEnabled = true
        
        
        
        let latitude = String(30.050000000000001)
        let longtude = String(31.239999999999998)
        let params : [String : String] = ["lat" : latitude , "lon" : longtude , "appId" : apiKey]
        
        getWeatherData(url: WEATHER_URL ,parameters: params)
        loadCities()
        
        //        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.hideKeyboard)))
        //
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            
            if let textField = validationRule.textField as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
            } else if let textField = validationRule.textField as? UITextView {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
            }
        }, error:{ (validationError) -> Void in
            print("error")
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.textField as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            } else if let textField = validationError.textField as? UITextView {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })
        
        validator.registerField(textField: name, errorLabel: nameError , rules: [RequiredRule(), FullNameRule()])
        validator.registerField(textField: email, errorLabel: emailError, rules: [RequiredRule(), EmailRule()])
        validator.registerField(textField: mobile, errorLabel: mobileError, rules: [RequiredRule(), MinLengthRule(length: 11)])
         validator.registerField(textField: cityDropDown, errorLabel: cityError, rules: [RequiredRule()])
        validator.registerField(textField: password, errorLabel: passError, rules: [RequiredRule(), PasswordRule()])
        validator.registerField(textField: confirmPass, errorLabel: confPassError, rules: [RequiredRule(), ConfirmationRule(confirmField: password)])
        
        
        
    }
    
    
    
    
    func getWeatherData(url: String , parameters: [String: String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                print("Success !! Got Weather Data")
                
                let weatherJSON : SwiftyJSON.JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                print("weather\(weatherJSON)")
                
            }else{
                print("Error \(String(describing: response.result.error))")
                self.cityDropDown.text = "Connection Lost 😢"
            }
        }
    }
    
    
    
    func save(city: WeatherDataModel){
        
        do{
            try realm?.write {
                realm?.add(city)
                print("Addeddddddddddddddddddd")
            }
        }catch{
            print("Error savingggggggggggg City\(error)")
        }
    }
    
    func updateWeatherData(json : SwiftyJSON.JSON){
        
        let city = json["name"].stringValue
        let newCountry = WeatherDataModel()
        newCountry.cityName = city
        self.save(city: newCountry)
        
    }
    
    func loadCities(){
        let citiesName = Set(realm?.objects(WeatherDataModel.self).value(forKey: "cityName") as! [String])
        var NewCities = [WeatherDataModel]()
        for returnedCity in citiesName {
            if let city = realm?.objects(WeatherDataModel.self).filter("cityName = '\(returnedCity)'").first {
                NewCities.append(city)
            }
            
            for i in NewCities{
                cityDropDown.optionArray.append(i.cityName)
            }
        }
    }
    
    
    
    
    
//    // MARK: ValidationDelegate Methods
//    
    func validationSuccessful() {
        print("Validation Success!")
        let alert = UIAlertController(title: "Success", message: "Hello \(name.text) you can LogIn!", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
     func validationFailed(errors: [UITextField : ValidationError]) {
         print("errorrrrrrrrrrr validation")
     }
    
        @objc func hideKeyboard(){
            self.view.endEditing(true)
        }
    
    // MARK: Validate single field
    // Don't forget to use UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validator.validateField(textField: textField){ error in
            if error == nil {
                // Field validation was successful
            } else {
                // Validation error occurred
            }
        }
        return true
    }
    
    
}


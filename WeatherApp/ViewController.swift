//
//  ViewController.swift
//  WeatherApp
//
//  Created by Grifus on 20.10.2021.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    let model = Model()
    let weatherLable = UILabel()
    
    var locationButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(startWeatherByLocation), for: .touchUpInside)
        return button
    }()
    
    var cityTextField: CustomSearchTextField = {
        let textField = CustomSearchTextField()
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //auth()
        
        [weatherLable, locationButton, cityTextField].forEach {
            view.addSubview($0)
        }

        cityTextField.delegate = self
        model.delegate = self
        print(FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask))
//        model.parseCitiesFromJsonToCoreData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        cityTextField.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLable()
        configureLocationButton()
        configureCityTextLable()
    }
    
    func configureCityTextLable() {
        cityTextField.borderStyle = .roundedRect
        cityTextField.layer.borderWidth = 3
        cityTextField.layer.borderColor = UIColor.systemBlue.cgColor
        cityTextField.layer.cornerRadius = cityTextField.bounds.height / 3
        
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: locationButton.topAnchor, constant: 30),
            cityTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            cityTextField.rightAnchor.constraint(equalTo: locationButton.leftAnchor, constant: -30),
            cityTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureLable() {
        weatherLable.frame = CGRect(x: 0, y: 0, width: 250, height: 100)
        weatherLable.numberOfLines = 0
        weatherLable.textAlignment = .center
        weatherLable.center = view.center
    }
    
    func configureLocationButton() {
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationButton.heightAnchor.constraint(equalToConstant: 100),
            locationButton.widthAnchor.constraint(equalToConstant: 100),
            locationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            locationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
        
    }
    
    func auth() {
        
        var error: NSError?
        
        let authContext = LAContext()
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "login") { (success, error) in
                print(success)
            }
        }
    }
    
    @objc func startWeatherByLocation() {
        model.getWeatherByLocation()
    }
    
}


extension ViewController: ModelDelegate {
    
    func setTemperature(city: String, degree: Double) {
        DispatchQueue.main.async {
            let tempCels = ((degree - 273.15) * 100).rounded() / 100
            self.weatherLable.text = String("Now in \(city) temperature is \(tempCels) celsius")
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("start editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityField = textField as? CustomSearchTextField {
            guard let id = cityField.currentItemId else { return }
            model.getWeatherBy(id: String(id))
            print("some")
        }
    }
}

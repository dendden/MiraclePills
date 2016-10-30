//
//  ViewController.swift
//  MiraclePills
//
//  Created by Денис Трясунов on 10/23/16.
//  Copyright © 2016 Денис Трясунов. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var successImage: UIImageView!
    
    @IBOutlet weak var statePickerButton: UIButton!
    @IBOutlet weak var statePicker: UIPickerView!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var zipText: UITextField!
    @IBOutlet weak var countryText: UITextField!
    
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    let KEYBOARD_MARGIN: CGFloat = 40.0
    var keyboardProps: (height: CGFloat, animationDuration: TimeInterval) = (0.0,0)
    var movingTextFields = [UITextField: CGFloat]()
    
    let states = ["AK - Alaska",
                  "AL - Alabama",
                  "AR - Arkansas",
                  "AS - American Samoa",
                  "AZ - Arizona",
                  "CA - California",
                  "CO - Colorado",
                  "CT - Connecticut",
                  "DC - District of Columbia",
                  "DE - Delaware",
                  "FL - Florida",
                  "GA - Georgia",
                  "GU - Guam",
                  "HI - Hawaii",
                  "IA - Iowa",
                  "ID - Idaho",
                  "IL - Illinois",
                  "IN - Indiana",
                  "KS - Kansas",
                  "KY - Kentucky",
                  "LA - Louisiana",
                  "MA - Massachusetts",
                  "MD - Maryland",
                  "ME - Maine",
                  "MI - Michigan",
                  "MN - Minnesota",
                  "MO - Missouri",
                  "MS - Mississippi",
                  "MT - Montana",
                  "NC - North Carolina",
                  "ND - North Dakota",
                  "NE - Nebraska",
                  "NH - New Hampshire",
                  "NJ - New Jersey",
                  "NM - New Mexico",
                  "NV - Nevada",
                  "NY - New York",
                  "OH - Ohio",
                  "OK - Oklahoma",
                  "OR - Oregon",
                  "PA - Pennsylvania",
                  "PR - Puerto Rico",
                  "RI - Rhode Island",
                  "SC - South Carolina",
                  "SD - South Dakota",
                  "TN - Tennessee",
                  "TX - Texas",
                  "UT - Utah",
                  "VA - Virginia",
                  "VI - Virgin Islands",
                  "VT - Vermont",
                  "WA - Washington",
                  "WI - Wisconsin",
                  "WV - West Virginia", 
                  "WY - Wyoming"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.dataSource = self
        statePicker.delegate = self
        
        nameText.delegate = self
        cityText.delegate = self
        addressText.delegate = self
        countryText.delegate = self
        zipText.delegate = self
        
        // code for moving textfields up when keyboard appears:
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardWithMargin = keyboardFrame.size.height + KEYBOARD_MARGIN
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        keyboardProps = (keyboardWithMargin, animationDuration)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardHeight = keyboardProps.height
        let animationDuration = keyboardProps.animationDuration
        let textFieldPosition = textFieldFromBottom(textField: textField)
        if textFieldPosition < keyboardHeight {
            let moveDistance =  keyboardHeight - textFieldPosition
            print("moving up \(moveDistance) px...")
            movingTextFields[textField] = moveDistance
            moveTextField(up: true, distance: moveDistance, duration: animationDuration)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let moveDistance = movingTextFields[textField] {
            print("moving down \(moveDistance) px...")
            moveTextField(up: false, distance: 10.0, duration: keyboardProps.animationDuration)
        }
    }
    
    func moveTextField(up: Bool, distance: CGFloat, duration: TimeInterval) {
        let moveDirection = distance * (up ? 1 : -1)
        let point = CGPoint(x: 0.0, y: moveDirection)
        
        UIView.animate(withDuration: duration, animations: {
            self.scrollView.setContentOffset(point, animated: true)
        })
    }
    
    func textFieldFromBottom(textField: UITextField) -> CGFloat {
        let textFieldBottomY = textField.frame.origin.y + textField.frame.size.height
        return view.frame.height - textFieldBottomY
    }
    
    // func for hiding keyboard after pressing 'return':
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text!)
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func statePickerButtonPressed(_ sender: AnyObject) {
        countryLabel.isHidden = true
        countryText.isHidden = true
        zipLabel.isHidden = true
        zipText.isHidden = true
        statePicker.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statePickerButton.setTitle(states[row], for: UIControlState.normal)
        statePicker.isHidden = true
        countryLabel.isHidden = false
        countryText.isHidden = false
        zipLabel.isHidden = false
        zipText.isHidden = false
    }
    
    @IBAction func buyNowButtonPressed(_ sender: Any) {
        scrollView.isHidden = true
        successImage.isHidden = false
    }
    
}


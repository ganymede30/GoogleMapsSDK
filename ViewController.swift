//
//  ViewController.swift
//  urlSessionPractice
//
//  Created by RaveBizz on 2/13/21.
//

import UIKit

struct UserModel {
    var user: String?
    var destination: String?
}

class ViewController: UIViewController {

    var storyboardCoordinator: StoryboardCoordinator?
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGesture()
        configureTextFields()
    }

    @IBAction func firstButton(_ sender: Any) {
        storyboardCoordinator?.pushSecondVC()
    }
    
    @IBAction func secondButton(_ sender: Any) {
        storyboardCoordinator?.pushThirdVC()
    }
    
    @IBAction func thirdButton(_ sender: Any) {
        storyboardCoordinator?.pushFourthVC()
    }
    
    @IBOutlet weak var mapImage: UIImageView!{
        didSet {
            mapImage.image = UIImage(named: "map")
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userDestinationLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    
    @objc func updateUserLabel(){
        let text = nameTextField.text
        userLabel.text = "User: \(text!)"
        nameTextField.text = ""
    }
    
    @objc func updateUserDestinationLabel(){
        let text = destinationTextField.text
        userDestinationLabel.text = text
        destinationTextField.text = ""
    }
    
    @IBAction func textFieldSubmit(_ sender: Any) {
        updateUserLabel()
        updateUserDestinationLabel()
        setupNotification()
        addToUserDefault()
        addToDestinationDefault()
        view.endEditing(true)
    }
    
    private func configureTextFields(){
        nameTextField.delegate = self
        destinationTextField.delegate = self
    }
    
    private func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
}

extension ViewController {
    
    func setupNotification() {
        let userNotification = Notification(name: Notification.Name("userLabel"))
        print("posting: ", userNotification.name)
        let destinationNotification = Notification(name: Notification.Name("destinationLabel"))
        print("posting: ", destinationNotification.name)
        NotificationCenter.default.post(userNotification)
        NotificationCenter.default.post(destinationNotification)
    }
    
    func addToUserDefault() {
        let user = userLabel.text ?? ""
        defaults.setValue(user, forKey: "userLabel")
        let savedUser = defaults.string(forKey: "userLabel")
        print("saving item size to user defaults:  \(savedUser!)")
    }
    
    func addToDestinationDefault() {
        let destination = userDestinationLabel.text ?? ""
        defaults.setValue(destination, forKey: "destinationLabel")
        let savedDestination = defaults.string(forKey: "destinationLabel")
        print("saving item size to user defaults:  \(savedDestination!)")
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

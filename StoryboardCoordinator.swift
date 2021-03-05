//
//  StoryboardCoordinator.swift
//  urlSessionPractice
//
//  Created by RaveBizz on 2/13/21.
//

import UIKit

class StoryboardCoordinator {
    
    var navCon: UINavigationController
    
    init() {
        navCon = UINavigationController()
    }
    
    func pushFirstVC() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "ViewController") as! ViewController
        vc.storyboardCoordinator = self
        navCon.pushViewController(vc, animated: true)
    }
    
    func pushSecondVC() {
        let vc = SecondVC.createSelf()
        navCon.pushViewController(vc, animated: true)
        vc.storyboardCoordinator = self
        vc.userModel = UserModel(user: UserDefaults.standard.string(forKey: "userLabel"), destination: UserDefaults.standard.string(forKey: "destinationLabel"))
    }
    
    func pushThirdVC() {
        let vc = ThirdVC.createSelf()
        navCon.pushViewController(vc, animated: true)
        vc.storyboardCoordinator = self
    }
    
    func pushFourthVC() {
        print("pushFourthVC() went off")
        let vc = FourthVC.createSelf()
        navCon.pushViewController(vc, animated: true)
        vc.storyboardCoordinator = self
    }
}

protocol CanCreateSelf {
    static func createSelf() -> Self
}

extension CanCreateSelf where Self: UIViewController {
    static func createSelf() -> Self {
        let id = String(describing: self)
        let sb = UIStoryboard(name: id, bundle: nil)
        let vc = sb.instantiateViewController(identifier: id) as! Self
        return vc
    }
}


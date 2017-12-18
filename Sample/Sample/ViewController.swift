//
//  ViewController.swift
//  Sample
//
//  Created by 李二狗 on 2017/12/18.
//  Copyright © 2017年 李二狗. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func authFaceID(_ sender: UIButton) {
        let next = BiometricController()
        next.biometricAuthType = .faceID
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func authTouchID(_ sender: UIButton) {
        let next = BiometricController()
        next.biometricAuthType = .touchID
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func authPasscode(_ sender: UIButton) {
        let next = PasscodeController()
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


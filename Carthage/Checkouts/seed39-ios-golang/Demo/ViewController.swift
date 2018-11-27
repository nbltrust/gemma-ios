//
//  ViewController.swift
//  Demo
//
//  Created by koofrank on 2018/11/7.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import seed39_ios_golang
import Seed39

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        Seed39Main()
        Seed39Main()

        let test = Seed39CheckMnemonic("")
    }


}


//
//  AddEditVC.swift
//  BeastListBelt
//
//  Created by Neil Sood on 9/21/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit

protocol AddEditVCDelegate: class {
    func cancelPressed()
    func savePressed(text: String, indexPath: IndexPath?)
}

class AddEditVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var indexPath: IndexPath?
    var delegate: AddEditVCDelegate?
    
    var textInField = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = textInField
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelPressed()
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        let text = textField.text
        delegate?.savePressed(text: text!, indexPath: indexPath)
    }
}

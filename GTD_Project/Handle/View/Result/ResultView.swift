//
//  ResultView.swift
//  GTD_Project
//
//  Created by MacBook on 03/01/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit

class ResultView: UIView {
    
    //@IBOutlet var result: UIView!
    //@IBOutlet var resultTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let resultView = Bundle.main.loadNibNamed("ResultView", owner: self, options: nil)?.first
        //let bundle = Bundle(for: type(of: self))
        //let nib = UINib(nibName: "ResultView", bundle: bundle)
//        let resultView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
//        resultView.translatesAutoresizingMaskIntoConstraints = false
//        resultView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        resultView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        resultView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        resultView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
//        resultTextField.isEnabled = true
//        resultTextField.isUserInteractionEnabled = true
        
        addSubview(resultView as! UIView)

    }
}

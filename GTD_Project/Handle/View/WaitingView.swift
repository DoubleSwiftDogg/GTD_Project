//
//  WaitingView.swift
//  GTD_Project
//
//  Created by MacBook on 03/02/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit

class WaitingView: UIView {

    @IBOutlet var waitingView: UIView!
    @IBOutlet weak var executorLabel: UILabel!
    @IBOutlet weak var executorTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var periodTextField: UITextField!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("WaitingView", owner: self, options: nil)
        addSubview(waitingView)
        waitingView.frame = self.bounds
        //waitingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        waitingView.translatesAutoresizingMaskIntoConstraints = false
        waitingView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        waitingView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        waitingView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        waitingView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bringSubviewToFront(waitingView)
    }
}

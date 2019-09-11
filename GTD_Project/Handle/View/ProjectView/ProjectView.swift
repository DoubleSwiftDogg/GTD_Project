//
//  ProjectView.swift
//  GTD_Project
//
//  Created by MacBook on 11/09/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit

class ProjectView: UIView {

    @IBOutlet var projectView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultTextField: UITextField!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ProjectView", owner: self, options: nil)
        addSubview(projectView)
        projectView.frame = self.bounds
        projectView.translatesAutoresizingMaskIntoConstraints = false
        projectView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        projectView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        projectView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        projectView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        resultTextField.autocapitalizationType = .sentences
        
        bringSubviewToFront(projectView)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//
//  CheckBox.swift
//  Test
//
//  Created by MacBookPro on 10/7/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    let vc = ViewController()
    //images
    let checkedImage = UIImage(named: "checked")
    let unCheckedImage = UIImage(named: "unChecked")

    //bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true{
                self.setImage(checkedImage, for: .normal)

            }else{
                self.setImage(unCheckedImage, for: .normal)
            }
        }
    }
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton){
        if(sender == self){
            if isChecked == true{
                isChecked = false
                
            }else{
                isChecked = true
            }
        }
        
    }
}

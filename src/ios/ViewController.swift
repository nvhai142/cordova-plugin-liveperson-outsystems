//
//  ViewController.swift
//  LinhTinhSwift
//
//  Created by Hoan Nguyen on 3/23/20.
//  Copyright © 2020 Hoan Nguyen. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }

    
    
    func configUI() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "CHAT"
        
    }
    
    @IBAction func cancelPressed(sender:Any) {
        print("cancel")
    }
    
    @IBAction func optionPressed(sender:Any) {
       // if let query = self.conversationQuery {
            

            
            
            let alertVC = UIAlertController(title: "Menu", message: "Chooose an option", preferredStyle: .actionSheet)
            
            
            let resolveAction = UIAlertAction(title: "Resolve the conversation", style: .default) { (alertAction) in
            }
            
            let clearHistoryAction = UIAlertAction(title: "Clear history", style: .default) { (alertAction) in
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertVC.addAction(resolveAction)
            alertVC.addAction(clearHistoryAction)
            alertVC.addAction(cancelAction)
            
            resolveAction.isEnabled = isChatActive;
            self.present(alertVC, animated: true, completion: nil)
      //  }
    }
}

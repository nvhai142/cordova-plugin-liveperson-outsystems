//
//  ConversationVC.swift
//  LinhTinhSwift
//
//  Created by Hoan Nguyen on 7/1/20.
//  Copyright © 2020 Hoan Nguyen. All rights reserved.
//

import UIKit
import LPMessagingSDK
import LPInfra

class ConversationVC: UIViewController {
    
    var conversationQuery:ConversationParamProtocol?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conversationQuery = LPMessagingSDK.instance.getConversationBrandQuery("2022139")
        self.configUI()
    }

    
    
    func configUI() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "CHAT"
        
    }
    
    @IBAction func cancelPressed(sender:Any) {
        print("cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func optionPressed(sender:Any) {
        if let query = self.conversationQuery {
            let isChatActive = LPMessagingSDK.instance.checkActiveConversation(query)
            
            func showResolveConfirmation(title:String, message:String){
                let confirmAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                confirmAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (alertAction) in
                    LPMessagingSDK.instance.resolveConversation(query)
                }))
                confirmAlert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
                self.present(confirmAlert, animated: true, completion: nil)
            }
            
            func showClearConfirmation(){
                let clearAlert = UIAlertController(title: "Clear history", message: "All of your existing conversation history will be lost. Are you sure?", preferredStyle: .alert)
                clearAlert.addAction(UIAlertAction(title: "CLEAR", style: .default, handler: { (alertAction) in
                    if isChatActive{
                        showResolveConfirmation(title: "Clear history", message: "Please resolve the conversation first")
                    }else {
                       try? LPMessagingSDK.instance.clearHistory(query)
                    }
                }))
                clearAlert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
                self.present(clearAlert, animated: true, completion: nil)
            }
            
            let st = UIStoryboard()
            st.instantiateInitialViewController()
            
            let alertVC = UIAlertController(title: "Menu", message: "Chooose an option", preferredStyle: .actionSheet)
            
            
            let resolveAction = UIAlertAction(title: "Resolve the conversation", style: .default) { (alertAction) in
                showResolveConfirmation(title: "Resolve the conversation", message: "Are you sure this topic is resolved?")
            }
            
            let clearHistoryAction = UIAlertAction(title: "Clear history", style: .default) { (alertAction) in
                showClearConfirmation()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertVC.addAction(resolveAction)
            alertVC.addAction(clearHistoryAction)
            alertVC.addAction(cancelAction)
            
            resolveAction.isEnabled = isChatActive;
            self.present(alertVC, animated: true, completion: nil)
        }
    }

}

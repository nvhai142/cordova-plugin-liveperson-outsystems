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

import UserNotifications


class ConversationVC: UIViewController, LPMessagingSDKdelegate {
    
    func LPMessagingSDKObseleteVersion(_ error: NSError) {
        
    }
    
    func LPMessagingSDKAuthenticationFailed(_ error: NSError) {
        DispatchQueue.main.async {
            self.alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func LPMessagingSDKTokenExpired(_ brandID: String) {
        DispatchQueue.main.async {
            self.alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func LPMessagingSDKError(_ error: NSError) {
        DispatchQueue.main.async {
            self.alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func LPMessagingSDKAgentDetails(_ agent: LPUser?) {
        if let user = agent{
            self.title = (user.nickName ?? "Visa Concierge")
        }
    }
    func LPMessagingSDKConnectionStateChanged(_ isReady: Bool, brandID: String) {
       // if(isReady){
            DispatchQueue.main.async {
                self.alert.dismiss(animated: true, completion: nil)
            }
        //}
    }
    var conversationQuery:ConversationParamProtocol?;
    var alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        LPMessagingSDK.instance.delegate = self
        self.configUI()

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        //loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loadingIndicator.color = .gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }

    
    
    func configUI() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.csatNavigationBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.title = "Visa Concierge"
        self.view.backgroundColor = UIColor.conversationBackgroundColor
        
        let configUI = LPConfig.defaultConfiguration

        configUI.fileSharingFromAgent = true
        configUI.fileSharingFromConsumer = true

        configUI.conversationBackgroundColor = UIColor.conversationBackgroundColor
        
        configUI.userBubbleBackgroundColor = UIColor.userBubbleBackgroundColor
        configUI.userBubbleBorderColor = UIColor.userBubbleBorderColor
        configUI.userBubbleLinkColor = UIColor.userBubbleLinkColor
        configUI.userBubbleTextColor = UIColor.userBubbleTextColor
        configUI.userBubbleTimestampColor =  UIColor.userBubbleTimestampColor
        configUI.userBubbleSendStatusTextColor = UIColor.userBubbleSendStatusTextColor
        configUI.userBubbleErrorTextColor = UIColor.userBubbleErrorTextColor
        configUI.userBubbleErrorBorderColor = UIColor.userBubbleErrorBorderColor
        configUI.userBubbleLongPressOverlayColor = UIColor.userBubbleLongPressOverlayColor

        configUI.remoteUserBubbleBackgroundColor = UIColor.remoteUserBubbleBackgroundColor
        configUI.remoteUserBubbleBorderColor = UIColor.remoteUserBubbleBorderColor
        configUI.remoteUserBubbleLinkColor = UIColor.remoteUserBubbleLinkColor
        configUI.remoteUserBubbleTextColor = UIColor.remoteUserBubbleTextColor
        configUI.remoteUserBubbleTimestampColor = UIColor.remoteUserBubbleTimestampColor
        configUI.remoteUserTypingTintColor = UIColor.remoteUserTypingTintColor
        configUI.remoteUserBubbleLongPressOverlayColor = UIColor.remoteUserBubbleLongPressOverlayColor

        configUI.linkPreviewBackgroundColor = UIColor.linkPreviewBackgroundColor
        configUI.linkPreviewTitleTextColor = UIColor.linkPreviewTitleTextColor
        configUI.linkPreviewDescriptionTextColor = UIColor.linkPreviewDescriptionTextColor
        configUI.linkPreviewSiteNameTextColor = UIColor.linkPreviewSiteNameTextColor
        configUI.urlRealTimePreviewBackgroundColor = UIColor.urlRealTimePreviewBackgroundColor
        configUI.urlRealTimePreviewBorderColor = UIColor.urlRealTimePreviewBorderColor
        configUI.urlRealTimePreviewTitleTextColor = UIColor.urlRealTimePreviewTitleTextColor
        configUI.urlRealTimePreviewDescriptionTextColor = UIColor.urlRealTimePreviewDescriptionTextColor

        configUI.inputTextViewContainerBackgroundColor = UIColor.inputTextViewContainerBackgroundColor

        configUI.photosharingMenuBackgroundColor = UIColor.photosharingMenuBackgroundColor
        configUI.photosharingMenuButtonsBackgroundColor = UIColor.photosharingMenuButtonsBackgroundColor
        configUI.photosharingMenuButtonsTintColor = UIColor.photosharingMenuButtonsTintColor
        configUI.photosharingMenuButtonsTextColor = UIColor.photosharingMenuButtonsTextColor
        configUI.cameraButtonEnabledColor = UIColor.cameraButtonEnabledColor
        configUI.cameraButtonDisabledColor = UIColor.cameraButtonDisabledColor
        configUI.fileCellLoaderFillColor = UIColor.fileCellLoaderFillColor
        configUI.fileCellLoaderRingProgressColor = UIColor.fileCellLoaderRingProgressColor
        configUI.fileCellLoaderRingBackgroundColor = UIColor.fileCellLoaderRingBackgroundColor
        configUI.isReadReceiptTextMode = false
        configUI.checkmarkVisibility = .sentOnly
        configUI.csatShowSurveyView = false 

        configUI.ttrBannerBackgroundColor = UIColor.ttrBannerBackgroundColor
        configUI.ttrBannerTextColor = UIColor.ttrBannerTextColor

        configUI.dateSeparatorBackgroundColor = UIColor.dateSeparatorBackgroundColor
        configUI.dateSeparatorTitleBackgroundColor = UIColor.dateSeparatorTitleBackgroundColor
        configUI.dateSeparatorTextColor = UIColor.dateSeparatorTextColor
        configUI.dateSeparatorLineBackgroundColor = UIColor.dateSeparatorLineBackgroundColor
    }
    
    @IBAction func cancelPressed(sender:Any) {
        if self.conversationQuery != nil {
            LPMessagingSDK.instance.removeConversation(self.conversationQuery!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

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
                let clearAlert = UIAlertController(title: "Clear Conversation", message: "All of your existing conversation history will be lost. Are you sure?", preferredStyle: .alert)
                clearAlert.addAction(UIAlertAction(title: "CLEAR", style: .default, handler: { (alertAction) in
                    if isChatActive{
                        showResolveConfirmation(title: "Clear Conversation", message: "Please resolve the conversation first")
                    }else {
                       try? LPMessagingSDK.instance.clearHistory(query)
                    }
                }))
                clearAlert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
                self.present(clearAlert, animated: true, completion: nil)
            }
            
            let st = UIStoryboard()
            st.instantiateInitialViewController()
            
            let alertVC = UIAlertController(title: "Menu", message: "Choose an option", preferredStyle: .actionSheet)
            
            
            let resolveAction = UIAlertAction(title: "Resolve the conversation", style: .default) { (alertAction) in
                showResolveConfirmation(title: "Resolve the conversation", message: "Are you sure this topic is resolved?")
            }
            
            let clearHistoryAction = UIAlertAction(title: "Clear Conversation", style: .default) { (alertAction) in
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

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
        DispatchQueue.main.async {
            self.alert.dismiss(animated: true, completion: nil)
        }
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
            self.title = (user.nickName ?? ChatTitleHeader)
        }
    }
    func LPMessagingSDKConnectionStateChanged(_ isReady: Bool, brandID: String) {
        if(isReady){
            DispatchQueue.main.async {
                self.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    var conversationQuery:ConversationParamProtocol?;
    var alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)

    var WelcomeMsg:String = "How can I help you today?"
    var ClearConversationMsg:String = "All of your existing conversation history will be lost. Are you sure?"
    var ClearConfirmMsg:String = "Please resolve the conversation first."
    var ChooseMsg:String = "Choose an option"
    var RevolvedTileMsg:String = "Resolve the conversation"
    var ResolvedConfirmMsg:String = "Are you sure this topic is resolved?"
    var ClearTitleMsg:String = "Clear Conversation"
    var YesMsg:String = "Yes"
    var CancelMsg:String = "Cancel"
    var ClearMsg:String = "Clear"
    var MenuMsg:String = "Menu"
    var ChatTitleHeader:String = "Visa Concierge"

    override func viewDidLoad() {
        super.viewDidLoad()
        LPMessagingSDK.instance.delegate = self
        self.configUI()

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        //loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        //loadingIndicator.color = .gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }

    
    
    func configUI() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.csatNavigationBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.title = ChatTitleHeader
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
        configUI.conversationSeparatorTextColor = UIColor.conversationSeparatorTextColor
        configUI.conversationSeparatorFontName = "HelveticaNeue-Bold"
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
                confirmAlert.addAction(UIAlertAction(title: YesMsg, style: .default, handler: { (alertAction) in
                    LPMessagingSDK.instance.resolveConversation(query)
                }))
                confirmAlert.addAction(UIAlertAction(title: CancelMsg, style: .cancel, handler: nil))
                self.present(confirmAlert, animated: true, completion: nil)
            }
            
            func showClearConfirmation(){
                let clearAlert = UIAlertController(title: ClearTitleMsg, message: ClearConversationMsg, preferredStyle: .alert)
                clearAlert.addAction(UIAlertAction(title: ClearMsg, style: .default, handler: { (alertAction) in
                    if isChatActive{
                        showResolveConfirmation(title: self.ClearTitleMsg, message: self.ClearConfirmMsg)
                    }else {
                       try? LPMessagingSDK.instance.clearHistory(query)
                    }
                }))
                clearAlert.addAction(UIAlertAction(title: CancelMsg, style: .cancel, handler: nil))
                self.present(clearAlert, animated: true, completion: nil)
            }
            
            let st = UIStoryboard()
            st.instantiateInitialViewController()
            
            let alertVC = UIAlertController(title: MenuMsg, message: ChooseMsg, preferredStyle: .actionSheet)
            
            
            let resolveAction = UIAlertAction(title: RevolvedTileMsg, style: .default) { (alertAction) in
                showResolveConfirmation(title: self.RevolvedTileMsg, message: self.ResolvedConfirmMsg)
            }
            
            let clearHistoryAction = UIAlertAction(title: ClearTitleMsg, style: .default) { (alertAction) in
                showClearConfirmation()
            }
            
            let cancelAction = UIAlertAction(title: CancelMsg, style: .cancel, handler: nil)
            
            alertVC.addAction(resolveAction)
            alertVC.addAction(clearHistoryAction)
            alertVC.addAction(cancelAction)
            
            resolveAction.isEnabled = isChatActive;
            self.present(alertVC, animated: true, completion: nil)
        }
    }

}

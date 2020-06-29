
#import "ConversationViewController.h"

@interface ConversationViewController()

@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation ConversationViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    // init live person
    [LPMessagingSDK instance].delegate = self;
    [self setupView];
}

- (void)setupView {
    //self.view.backgroundColor = [AppColor backgroundColor];
    [self setTitleAgentChat:@"Chat"];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)setTitleAgentChat:(NSString *)nameAgent {
    [self setNavigationBarWithDefaultColorAndTitle:nameAgent];
}

- (void)handlePopRecognizer:(UIPanGestureRecognizer*)recognizer {

}

-(void) setNavigationBarWithDefaultColorAndTitle:(NSString*)title{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width, 50)];
    
   // NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
    //                             NSFontAttributeName: [UIFont fontWithName:FONT_MarkForMC_MED size:[AppSize headerTextSize]],
    //                             NSKernAttributeName: @1.6};
   // titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title.uppercaseString attributes:attributes];
    titleLabel.numberOfLines = 0;
//    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}

- (IBAction)backButtonPressed:(id)sender {
    [[self navigationController] popViewControllerAnimated:true];
}

- (IBAction)menuButtonPressed:(id)sender {
    
  //  bool isChatActive = [[LPMessagingSDK instance] checkActiveConversation:self.conversationQuery];
    
    self.alertController = [UIAlertController
                                          alertControllerWithTitle:@"Menu"
                                          message:@"Choose an option"
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    /**
     This is how to resolve a conversation
     */
    UIAlertAction *resolveAction = [UIAlertAction actionWithTitle:@"Resolve the conversation" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
       // [self showResolveConfirmation:@"Resolve the conversation" message:@"Are you sure this topic is resolved?"];
    }];
    
    
    NSString *urgentTitle = [[LPMessagingSDK instance] isUrgent:self.conversationQuery] ? @"Dismiss urgency" : @"Mark as urgent";
    
    /**
     This is how to manage the urgency state of the conversation
     */
    UIAlertAction *urgentAction = [UIAlertAction actionWithTitle:urgentTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // bool isUrgent = [[LPMessagingSDK instance] isUrgent:self.conversationQuery];
        // NSString* title = (isUrgent)? @"Dismiss urgency" : @"Mark as urgent";
        // NSString* message = (isUrgent)? @"Are you sure you want to mark this conversation as not urgent?" : @"Are you sure you want to mark this conversation as urgent?";
        
        // [self showUrgentConfirmation:title message:message];
        
    }];
    
    UIAlertAction *clearHistoryAction = [UIAlertAction actionWithTitle:@"Clear history" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
       // [self showClearConfirmation:@"Clear history" message:@"All of your existing conversation history will be lost. Are you sure?"];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [_alertController addAction:urgentAction];
    [_alertController addAction:clearHistoryAction];
    [_alertController addAction:resolveAction];
    [_alertController addAction:cancelAction];
    
    [urgentAction setEnabled:isChatActive];
    [resolveAction setEnabled:isChatActive];
    
    [self presentViewController:_alertController animated:true completion:^{
        
    }];
}

-(void) showResolveConfirmation:(NSString*)title message:(NSString*)message
{
    self.alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    [_alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       // [[LPMessagingSDK instance] resolveConversation:self.conversationQuery];
    }]];
    
    [_alertController addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:_alertController animated:true completion:^{
        
    }];
}

-(void) showUrgentConfirmation:(NSString*)title message:(NSString*)message
{
    self.alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // if ([[LPMessagingSDK instance] isUrgent:self.conversationQuery]) {
        //     [[LPMessagingSDK instance] dismissUrgent:self.conversationQuery];
        // } else {
        //     [[LPMessagingSDK instance] markAsUrgent:self.conversationQuery];
        // }
        
    }]];
    
    [_alertController addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:_alertController animated:true completion:^{
        
    }];
}

-(void) showClearConfirmation:(NSString*)title message:(NSString*)message
{
    self.alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [_alertController addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [_alertController addAction:[UIAlertAction actionWithTitle:@"CLEAR" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // bool isChatActive = [[LPMessagingSDK instance] checkActiveConversation:self.conversationQuery];
        // if(isChatActive)
        // {
        //     //Show alert to resolve first
        //     [self showResolveAlert:@"Clear history" message:@"Please resolve the conversation first"];
        // }
        // else
        // {
        //     //Clear the conversation
        //     NSError* error;
        //     [[LPMessagingSDK instance] clearHistory:self.conversationQuery error:&error];
        // }
    }]];
    
    [self presentViewController:_alertController animated:true completion:^{
        
    }];
}

-(void) showResolveAlert:(NSString*)title message:(NSString*)message
{
    self.alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [_alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok_button", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
//    [_alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }]];
    
    [self presentViewController:_alertController animated:true completion:^{
        
    }];
}

-(void) dismissAlert
{
    [self.alertController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)LPMessagingSDKAgentDetails:(LPUser *)agent {
    if (agent != nil) {
        [self setTitleAgentChat:agent.nickName];
    }
}

@end

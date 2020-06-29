
#import <UIKit/UIKit.h>
#import <LPMessagingSDK/LPMessagingSDK.h>


@interface ConversationViewController : UIViewController <LPMessagingSDKdelegate>


- (void) dismissAlert;
- (void)setTitleAgentChat:(NSString *)nameAgent;

@end

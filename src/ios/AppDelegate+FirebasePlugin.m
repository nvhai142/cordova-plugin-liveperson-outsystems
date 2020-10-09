#import "AppDelegate+FirebasePlugin.h"
#import <objc/runtime.h>
#import <LPMessagingSDK/LPMessagingSDK.h>

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
  @import UserNotifications;

  // Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
  // running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
  // devices running iOS 10 and above.
  @interface AppDelegate () <UNUserNotificationCenterDelegate>
  @end
#endif

#define kApplicationInBackgroundKey @"applicationInBackground"
#define kDelegateKey @"delegate"

@implementation AppDelegate (FirebasePlugin)


- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"FirebasePlugin - Disconnected from FCM");
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"FirebasePlugin - deviceToken1 = %@", deviceToken);
    [[LPMessagingSDK instance] registerPushNotificationsWithToken:deviceToken notificationDelegate:nil alternateBundleID:nil authenticationParams:nil];
        
        DispatchQueue.main.async {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
                }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
 
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"FirebasePlugin - Unable to register for remote notifications: %@", error);
}


@end

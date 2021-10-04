#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <BrightcovePlayerSDK/BrightcovePlayerSDK.h>

@interface RCT_EXTERN_MODULE(ViewController, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(accountId, NSString)
RCT_EXPORT_VIEW_PROPERTY(videoId, NSString)
RCT_EXPORT_VIEW_PROPERTY(policyKey, NSString)

@end

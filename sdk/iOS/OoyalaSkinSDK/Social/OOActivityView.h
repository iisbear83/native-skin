//
//  OOActivityView.h
//  OoyalaSkinSDK
//
//  Created by Eric Vargas on 12/29/15.
//  Copyright © 2015 ooyala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTBridgeModule.h"

@interface OOActivityView : NSObject <RCTBridgeModule>

+ (void)setPresentingController:(UIViewController *)controller;
+ (void)removePresentingController:(UIViewController *)controller;

@end

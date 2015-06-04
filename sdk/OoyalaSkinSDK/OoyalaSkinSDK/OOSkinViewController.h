//
//  OOSkinViewController.h
//  OoyalaSkin
//
//  Created by Zhihui Chen on 4/16/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OOOoyalaPlayer;
@class OODiscoveryOptions;

@interface OOSkinViewController : UIViewController

@property OODiscoveryOptions *discoveryOptions;

- (instancetype)initWithPlayer:(OOOoyalaPlayer *)player
                          view:(UIView *)view
              discoveryOptions:(OODiscoveryOptions *)discoveryOptions
                 launchOptions:(NSDictionary *)options;

- (void)loadStartScreenConfigureFile;

@end

/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"
#import <OoyalaSkinSDK/OOSkinViewController.h>
#import <OoyalaSDK/OOOoyalaPlayer.h>
#import <OoyalaSDK/OOPlayerDomain.h>

@implementation AppDelegate

NSString * const PCODE = @"f34784cb010846369c31af0bdd0ec83e";
NSString * const PLAYERDOMAIN = @"http://www.ooyala.com";
NSString * const EMBEDCODE = @"JyanIxdDoj9MhKbVEmTJEG8O4QF5xExb";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  OOOoyalaPlayer *ooyalaPlayer = [[OOOoyalaPlayer alloc] initWithPcode:PCODE domain:[[OOPlayerDomain alloc] initWithString:PLAYERDOMAIN]];
  UIViewController *rootViewController = [[OOSkinViewController alloc] initWithPlayer:ooyalaPlayer rect:self.window.frame launchOptions:launchOptions];
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  [ooyalaPlayer setEmbedCode:EMBEDCODE];
  return YES;
}

@end
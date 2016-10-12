//
//  OOVASTNonLinear.h
//  OoyalaSDK
//
//  Copyright © 2016 Ooyala, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTBXML.h"
#import "OOVASTResource.h"

@interface OOVASTNonLinear : NSObject

@property (readonly, nonatomic, strong) NSString *id;
@property (readonly, nonatomic) NSInteger width;
@property (readonly, nonatomic) NSInteger height;
@property (readonly, nonatomic) NSInteger expandedWidth;
@property (readonly, nonatomic) NSInteger expandedHeight;
@property (readonly, nonatomic) BOOL scalable;
@property (readonly, nonatomic) BOOL maintainAspectRatio;

@property (readonly, nonatomic) NSInteger minSuggestedDuration;
@property (readonly, nonatomic, strong) NSString *apiFramework;
@property (readonly, nonatomic, strong) OOVASTResource *resource;
@property (readonly, nonatomic, strong) NSMutableArray *clickTrackings;
@property (readonly, nonatomic, strong) NSString *clickThrough;
@property (readonly, nonatomic) OOTBXMLElement *creativeExtensions;
@property (readonly, nonatomic, strong) NSString *parameters;

- (id)initWithElement:(OOTBXMLElement *)element;

@end

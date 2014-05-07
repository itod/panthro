//
//  XPSingletonNodeSet.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPSingletonNodeSet.h"
#import <XPath/XPNodeInfo.h>

@interface XPSingletonNodeSet ()
@property (nonatomic, retain) id <XPNodeInfo>node;
@end

@implementation XPSingletonNodeSet

- (instancetype)initWithNode:(id <XPNodeInfo>)node {
    self = [super init];
    if (self) {
        self.node = node;
        self.generalUseAllowed = YES;
    }
    return self;
}


- (void)dealloc {
    self.node = nil;
    [super dealloc];
}

@end

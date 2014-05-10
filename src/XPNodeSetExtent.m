//
//  XPNodeSetExtent.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeSetExtent.h"
#import "XPNodeEnumeration.h"
#import "XPController.h"

@implementation XPNodeSetExtent

+ (XPNodeSetExtent *)extentWithNodeEnumeration:(id <XPNodeEnumeration>)e controller:(XPController *)c {
    return [[[self alloc] initWithNodeEnumeration:e controller:c] autorelease];
}


- (instancetype)initWithNodeEnumeration:(id <XPNodeEnumeration>)e controller:(XPController *)c {
    if (self = [super init]) {
        
    }
    return self;
}


- (void)dealloc {
    
    [super dealloc];
}

@end

//
//  XPNodeSetExtent.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPNodeSetExtent.h>
#import <XPath/XPNodeEnumeration.h>
#import <XPath/XPController.h>

@implementation XPNodeSetExtent

+ (XPNodeSetExtent *)extentWithNodeEnumeration:(XPNodeEnumeration *)e controller:(XPController *)c {
    return [[[self alloc] initWithNodeEnumeration:e controller:c] autorelease];
}


- (id)initWithNodeEnumeration:(XPNodeEnumeration *)e controller:(XPController *)c {
    if (self = [super init]) {
        
    }
    return self;
}


- (void)dealloc {
    
    [super dealloc];
}

@end

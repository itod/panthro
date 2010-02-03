//
//  XPNodeSetExtent.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPNodeSetExtent.h>
#import <Exedore/XPNodeEnumerator.h>
#import <Exedore/XPController.h>

@implementation XPNodeSetExtent

+ (id)extentWithNodeEnumerator:(XPNodeEnumerator *)e controller:(XPController *)c {
    return [[[self alloc] initWithNodeEnumerator:e controller:c] autorelease];
}


- (id)initWithNodeEnumerator:(XPNodeEnumerator *)e controller:(XPController *)c {
    if (self = [super init]) {
        
    }
    return self;
}


- (void)dealloc {
    
    [super dealloc];
}

@end

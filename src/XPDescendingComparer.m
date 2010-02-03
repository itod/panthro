//
//  XPDescendingComparer.m
//  Exedore
//
//  Created by Todd Ditchendorf on 8/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPDescendingComparer.h>

@implementation XPDescendingComparer

+ (id)descendingComparerWithComparer:(XPComparer *)c {
    return [[[self alloc] init] autorelease];
}

@end

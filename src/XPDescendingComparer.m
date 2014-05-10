//
//  XPDescendingComparer.m
//  Panthro
//
//  Created by Todd Ditchendorf on 8/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPDescendingComparer.h"

@implementation XPDescendingComparer

+ (XPDescendingComparer *)descendingComparerWithComparer:(XPComparer *)c {
    return [[[self alloc] init] autorelease];
}

@end

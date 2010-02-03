//
//  XPController.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPController.h>
#import <Exedore/XPNodeInfo.h>

@implementation XPController

- (NSComparisonResult)compare:(id)nodeA to:(id)nodeB {
    return [nodeA compareOrderTo:nodeB];
}

@end

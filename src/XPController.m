//
//  XPController.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPController.h>
#import <XPath/XPNodeInfo.h>

@implementation XPController

- (NSComparisonResult)compare:(id)nodeA to:(id)nodeB {
    return [nodeA compareOrderTo:nodeB];
}

@end

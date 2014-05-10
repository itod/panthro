//
//  XPNodeSetExtent.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPNodeSetValue.h>

@protocol XPNodeEnumeration;
@class XPController;

@interface XPNodeSetExtent : XPNodeSetValue

+ (XPNodeSetExtent *)extentWithNodeEnumeration:(id <XPNodeEnumeration>)e controller:(XPController *)c;

- (instancetype)initWithNodeEnumeration:(id <XPNodeEnumeration>)e controller:(XPController *)c;
@end

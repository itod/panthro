//
//  XPNodeSetExtent.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPNodeSetValue.h>

@class XPNodeEnumeration;
@class XPController;

@interface XPNodeSetExtent : XPNodeSetValue

+ (XPNodeSetExtent *)extentWithNodeEnumeration:(XPNodeEnumeration *)e controller:(XPController *)c;

- (id)initWithNodeEnumeration:(XPNodeEnumeration *)e controller:(XPController *)c;
@end

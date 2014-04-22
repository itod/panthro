//
//  XPNodeSetExtent.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPNodeSetValue.h>

@class XPNodeEnumerator;
@class XPController;

@interface XPNodeSetExtent : XPNodeSetValue

+ (XPNodeSetExtent *)extentWithNodeEnumerator:(XPNodeEnumerator *)e controller:(XPController *)c;

- (id)initWithNodeEnumerator:(XPNodeEnumerator *)e controller:(XPController *)c;
@end

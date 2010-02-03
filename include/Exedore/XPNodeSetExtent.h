//
//  XPNodeSetExtent.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPNodeSetValue.h>

@class XPNodeEnumerator;
@class XPController;

@interface XPNodeSetExtent : XPNodeSetValue {

}

+ (id)extentWithNodeEnumerator:(XPNodeEnumerator *)e controller:(XPController *)c;

- (id)initWithNodeEnumerator:(XPNodeEnumerator *)e controller:(XPController *)c;
@end

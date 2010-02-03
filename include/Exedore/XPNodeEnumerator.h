//
//  XPNodeEnumeration.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPNodeEnumerator : NSEnumerator {

}

- (BOOL)isSorted;
- (BOOL)isReverseSorted;
- (BOOL)isPeer;
@end

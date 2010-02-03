//
//  XPDescendingComparer.h
//  Exedore
//
//  Created by Todd Ditchendorf on 8/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Exedore/XPComparer.h>

@class XPComparer;

@interface XPDescendingComparer : XPComparer {

}

+ (id)descendingComparerWithComparer:(XPComparer *)c;
@end

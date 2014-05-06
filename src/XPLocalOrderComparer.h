//
//  XPLocalOrderComparer.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/5/14.
//
//

#import "XPNodeOrderComparer.h"

@interface XPLocalOrderComparer : NSObject <XPNodeOrderComparer>
+ (instancetype)instance;
@end

//
//  XPBaseNodeInfo.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/12/14.
//
//

#import "XPNodeInfo.h"

@interface XPBaseNodeInfo : NSObject <XPNodeInfo>

+ (void)incrementInstanceCount;
+ (NSUInteger)instanceCount;

@property (nonatomic, retain) id node;
@end

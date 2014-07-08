//
//  XPNodeSetValue.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/8/14.
//
//

#import "XPSequenceValue.h"

@interface XPNodeSetValue : XPSequenceValue
- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;
- (id <XPNodeInfo>)firstNode;
@end

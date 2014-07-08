//
//  XPNodeSetValue.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/8/14.
//
//

#import <Panthro/XPSequenceValue.h>

@protocol XPNodeInfo;

@interface XPNodeSetValue : XPSequenceValue

- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;
- (id <XPNodeInfo>)firstNode;

- (XPNodeSetValue *)sort;
@property (nonatomic, assign, getter=isSorted) BOOL sorted;
@property (nonatomic, assign, getter=isReverseSorted) BOOL reverseSorted;
@end

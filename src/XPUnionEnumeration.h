//
//  XPUnionEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/9/14.
//
//

#import "XPAbstractNodeEnumeration.h"

@protocol XPNodeOrderComparer;

@interface XPUnionEnumeration : XPAbstractNodeEnumeration

- (instancetype)initWithLhs:(id <XPSequenceEnumeration>)lhs rhs:(id <XPSequenceEnumeration>)rhs comparer:(id <XPNodeOrderComparer>)comparer;

- (id <XPNodeInfo>)nextNodeFromLhs;
- (id <XPNodeInfo>)nextNodeFromRhs;

@property (nonatomic, retain) id <XPSequenceEnumeration>p1;
@property (nonatomic, retain) id <XPSequenceEnumeration>p2;
@property (nonatomic, retain) id <XPSequenceEnumeration>e1;
@property (nonatomic, retain) id <XPSequenceEnumeration>e2;

@property (nonatomic, retain, readonly) NSString *operator;
@end

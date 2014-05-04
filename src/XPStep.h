//
//  XPStep.h
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import <Foundation/Foundation.h>
#import "XPAxis.h"

@class XPExpression;
@class XPNodeTest;
@class XPContext;

@protocol XPNodeEnumeration;
@protocol XPNodeInfo;

@interface XPStep : NSObject

- (instancetype)initWithAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest;

- (XPStep *)addFilter:(XPExpression *)expr;
- (XPStep *)simplify;
- (id <XPNodeEnumeration>)enumerate:(id <XPNodeInfo>)node inContext:(XPContext *)ctx;

@property (nonatomic, retain) NSMutableArray *filters;
@end

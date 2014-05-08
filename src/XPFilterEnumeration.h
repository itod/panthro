//
//  XPFilterEnumeration.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/8/14.
//
//

#import "XPBaseFastEnumeration.h"
#import "XPNodeEnumeration.h"

@class XPExpression;
@class XPContext;

@interface XPFilterEnumeration : XPBaseFastEnumeration <XPNodeEnumeration>

- (instancetype)initWithBase:(id <XPNodeEnumeration>)base filter:(XPExpression *)filter context:(XPContext *)ctx finishAfterReject:(BOOL)finishAfterReject;
@end

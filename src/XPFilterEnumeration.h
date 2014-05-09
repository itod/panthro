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

/**
 * A FilterEnumerator filters an input NodeEnumeration using a filter expression.
 * The complication is that on request, it must determine the value of the last() position,
 * which requires a lookahead.
 */

@interface XPFilterEnumeration : XPBaseFastEnumeration <XPNodeEnumeration>

- (instancetype)initWithBase:(id <XPNodeEnumeration>)base filter:(XPExpression *)filter context:(XPContext *)ctx finishAfterReject:(BOOL)finishAfterReject;
@end

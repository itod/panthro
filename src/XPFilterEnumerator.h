//
//  XPFilterEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/8/14.
//
//

#import "XPBaseEnumeration.h"
#import "XPSequenceEnumeration.h"
#import "XPPauseHandler.h"

@class XPExpression;
@class XPContext;

/**
 * A FilterEnumerator filters an input NodeEnumeration using a filter expression.
 * The complication is that on request, it must determine the value of the last() position,
 * which requires a lookahead.
 */

@interface XPFilterEnumerator : XPBaseEnumeration <XPPauseHandler>

- (instancetype)initWithBase:(id <XPSequenceEnumeration>)base filter:(XPExpression *)filter context:(XPContext *)ctx finishAfterReject:(BOOL)finishAfterReject;

@property (nonatomic, retain) XPContext *filterContext;
@end

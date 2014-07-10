//
//  XPNodeSetExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeSetExpression.h"
#import "XPContext.h"
#import "XPSequenceEnumeration.h"
#import "XPNodeSetExtent.h"
//#import "XPNodeSetIntent.h"
#import "XPLocalOrderComparer.h"
#import "XPException.h"
#import "XPEmptyNodeSet.h"

#import "XPStaticContext.h"
#import "XPException.h"
#import "XPSync.h"
#import "XPContext.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPLocalOrderComparer.h"

#if PAUSE_ENABLED
#import "XPPathExpression.h"
#import "XPStep.h"
#import "XPPauseState.h"
#endif


@implementation XPNodeSetExpression

- (XPDataType)dataType {
    return XPDataTypeSequence;
}


- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *result = nil;
    XPExpression *expr = [self reduceDependencies:XPDependenciesAll inContext:ctx];
    
    if ([expr isKindOfClass:[XPSequenceValue class]]) {
        result = (XPValue *)expr;

    } else if ([expr isKindOfClass:[XPNodeSetExpression class]]) {
        
        id <XPSequenceEnumeration>enm = [(XPNodeSetExpression *)expr enumerateInContext:ctx sorted:YES];
        
        if (enm) {
            XPNodeSetValue *nodeSet = [[[XPNodeSetExtent alloc] initWithEnumeration:enm comparer:nil] autorelease];
            nodeSet.range = self.range;
            result = nodeSet;
        } else {
            result = [XPEmptyNodeSet instance];
        }
        
#if PAUSE_ENABLED
        if (ctx.staticContext.debug && [expr isKindOfClass:[XPPathExpression class]]) {
            XPPathExpression *pathExpr = (XPPathExpression *)expr;
            XPStep *step = [pathExpr step];
            
            XPAssert(step.pauseState);
            if (step.pauseState) {
                [self pause:step.pauseState context:ctx parent:expr range:step.subRange];
                
                for (XPPauseState *state in step.filterPauseStates) {
                    if ([[state contextNodes] count]) {
                        [self pause:state context:ctx parent:state.expression range:state.expression.range];
                    }
                }
            }
        }
#endif

//        XPNodeSetIntent *nsi = [[[XPNodeSetIntent alloc] initWithNodeSetExpression:(XPNodeSetExpression *)expr comparer:nil] autorelease];
//        result = nsi;

    } else {
        result = [expr evaluateInContext:ctx];
        if (![result isKindOfClass:[XPSequenceValue class]]) {
            [XPException raiseIn:self format:@"Value must be a node-set. it is a %@", [expr class]];
        }
    }
    
    result.staticContext = self.staticContext;
    result.range = self.range;
    return result;
}


#if PAUSE_ENABLED
- (void)pause:(XPPauseState *)state context:(XPContext *)ctx parent:(XPExpression *)expr range:(NSRange)range {
    XPAssert(state);
    
    XPNodeSetValue *contextNodeSet = [[[XPNodeSetExtent alloc] initWithNodes:[state contextNodes] comparer:nil] autorelease];
    [contextNodeSet sort];
    
    XPNodeSetValue *resultNodeSet = [[[XPNodeSetExtent alloc] initWithNodes:[state resultNodes] comparer:nil] autorelease];
    [resultNodeSet sort];
    
    [ctx.staticContext pauseFrom:expr withContextNodes:contextNodeSet result:resultNodeSet range:range done:NO];
}
#endif


@end

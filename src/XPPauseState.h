//
//  XPPauseState.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/10/14.
//
//

#import <Foundation/Foundation.h>

@protocol XPItem;
@class XPExpression;

@interface XPPauseState : NSObject

- (void)addContextNode:(id <XPItem>)node;
- (void)addContextNodes:(NSArray *)nodes;

- (void)addResultNode:(id <XPItem>)node;
- (void)addResultNodes:(NSArray *)nodes;

- (void)addPauseState:(XPPauseState *)state;

@property (nonatomic, retain, readonly) NSArray *contextNodes;
@property (nonatomic, retain, readonly) NSArray *resultNodes;

@property (nonatomic, retain) XPExpression *expression;
@property (nonatomic, assign) NSRange range;
@end

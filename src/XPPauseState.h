//
//  XPPauseState.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/10/14.
//
//

#import <Foundation/Foundation.h>

@protocol XPNodeInfo;
@class XPExpression;

@interface XPPauseState : NSObject

- (void)addContextNode:(id <XPNodeInfo>)node;
- (void)addContextNodes:(NSArray *)nodes;
- (void)addResultNodes:(NSArray *)nodes;

@property (nonatomic, retain, readonly) NSArray *contextNodes;
@property (nonatomic, retain, readonly) NSArray *resultNodes;

@property (nonatomic, retain) XPExpression *expression;
@end

//
//  XPContext.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Panthro/XPLastPositionFinder.h>
#import <Panthro/XPScope.h>

@protocol XPStaticContext;
@protocol XPLastPositionFinder;
@protocol XPNodeInfo;

@interface XPContext : NSObject <NSCopying, XPLastPositionFinder, XPScope>

- (instancetype)initWithStaticContext:(id <XPStaticContext>)env;

@property (nonatomic, assign, readonly) id <XPStaticContext>staticContext; // weakref

// focus
@property (nonatomic, retain) id <XPNodeInfo>contextNode;
@property (nonatomic, assign) NSUInteger last;
@property (nonatomic, assign) NSUInteger position;

@property (nonatomic, retain) id <XPNodeInfo>currentNode;
@property (nonatomic, assign) id <XPLastPositionFinder>lastPositionFinder; // weakref

- (NSUInteger)contextPosition;
- (NSUInteger)contextSize;

- (void)push:(id <XPScope>)scope;
- (id <XPScope>)pop;
@property (nonatomic, retain, readonly) id <XPScope>currentScope;
@end

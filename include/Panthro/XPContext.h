//
//  XPContext.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPLastPositionFinder.h"

@protocol XPStaticContext;
@protocol XPLastPositionFinder;
@protocol XPNodeInfo;

@interface XPContext : NSObject <NSCopying, XPLastPositionFinder>

- (instancetype)initWithStaticContext:(id <XPStaticContext>)env;

@property (nonatomic, assign, readonly) id <XPStaticContext>staticContext; // weakref

// focus
@property (nonatomic, retain) id <XPNodeInfo>contextNode;
@property (nonatomic, assign) NSUInteger last;
@property (nonatomic, assign) NSUInteger position;

@property (nonatomic, retain) id <XPNodeInfo>currentNode;
@property (nonatomic, assign) id <XPLastPositionFinder>lastPositionFinder; // weakref

@property (nonatomic, retain) id <XPNodeInfo>stepContextNode;

- (NSUInteger)contextPosition;
- (NSUInteger)contextSize;
@end

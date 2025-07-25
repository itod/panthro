//
//  XPAssembler.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/16/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Panthro/XPAxis.h>

@class PKParser;
@class PKToken;

@class XPExpression;
@class XPFunction;
@protocol XPStaticContext;

@interface XPAssembler : NSObject

- (instancetype)initWithContext:(id <XPStaticContext>)env;

- (XPAxis)defaultAxis;
- (XPAxis)defaultRecursiveAxis;
@end

//
//  XPAssembler.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/16/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKParser;
@class PKToken;

@class XPExpression;
@class XPFunction;
@protocol XPStaticContext;

@interface XPAssembler : NSObject

- (XPFunction *)makeSystemFunction:(NSString *)name;

@end

//
//  XPParser.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/16/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKParser;
@class PKToken;

@class XPExpression;
@protocol XPStaticContext;

@interface XPParser : NSObject {
    PKParser *parser;
    PKToken *paren;
}

- (XPExpression *)parseExpression:(NSString *)s inContext:(id <XPStaticContext>)ctx;
@end

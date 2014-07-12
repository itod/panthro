//
//  XPStaticContext.h
//  Panthro
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Panthro/XPScope.h>

@class XPExpression;
@class XPValue;
@class XPFunction;
@class XPNameTest;
@class XPNamespaceTest;

@protocol XPItem;

#if PAUSE_ENABLED
@class XPPauseState;
#endif

#define XPNamespaceXML @"http://www.w3.org/XML/1998/namespace"
#define XPNamespaceXSLT @"http://www.w3.org/1999/XSL/Transform"

@protocol XPStaticContext <XPScope>

- (NSString *)systemId;
- (NSUInteger)lineNumber;
- (NSString *)baseURI;

- (NSString *)namespaceURIForPrefix:(NSString *)prefix error:(NSError **)outErr;
- (void)declareNamespaceURI:(NSString *)uri forPrefix:(NSString *)prefix;

- (XPFunction *)makeSystemFunction:(NSString *)name error:(NSError **)outErr;
- (void)declareSystemFunction:(Class)cls forName:(NSString *)name;

- (BOOL)isElementAvailable:(NSString *)qname;
- (BOOL)isFunctionAvailable:(NSString *)qname;

- (NSString *)version;

#if PAUSE_ENABLED
// Debugging
- (void)pauseFrom:(XPPauseState *)state done:(BOOL)isDone;
@property (nonatomic, assign) BOOL debug;
#endif
@end

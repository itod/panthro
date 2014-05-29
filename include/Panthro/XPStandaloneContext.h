//
//  XPStandaloneContext.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPStaticContext.h"
#import <libxml/parser.h>

@protocol XPNodeInfo;
@class XPExpression;
@class XPSynchronousChannel;
@class XPFunction;

/**
 * A StandaloneContext provides a context for parsing an expression or pattern appearing
 * in a context other than a stylesheet.
 */

extern NSString * const XPNamespaceXML;
extern NSString * const XPNamespaceXSL;

@interface XPStandaloneContext : NSObject <XPStaticContext>

+ (instancetype)standaloneContext;

- (XPExpression *)compile:(NSString *)xpathStr withContextNode:(id <XPNodeInfo>)ctxNode error:(NSError **)outErr;
- (id)evaluate:(XPExpression *)expr withContextNode:(id <XPNodeInfo>)ctxNode error:(NSError **)outErr;

- (id)execute:(NSString *)xpathStr withContextNode:(id <XPNodeInfo>)ctxNode error:(NSError **)outErr;

@property (nonatomic, retain) NSMutableDictionary *namespaces;

@property (retain) XPSync *debugSync;
@property (assign) BOOL debug;
@end

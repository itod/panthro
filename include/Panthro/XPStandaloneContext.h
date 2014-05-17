//
//  XPStandaloneContext.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPStaticContext.h"

@protocol XPNodeInfo;

/**
 * A StandaloneContext provides a context for parsing an expression or pattern appearing
 * in a context other than a stylesheet.
 */

@interface XPStandaloneContext : NSObject <XPStaticContext>

+ (instancetype)standaloneContext;

- (id)evalutate:(NSString *)xpathStr withNSXMLContextNode:(NSXMLNode *)nsxmlCtxNode error:(NSError **)outErr;
- (id)evalutate:(NSString *)xpathStr withLibxmlContextNode:(void *)nsxmlCtxNode error:(NSError **)outErr;

- (id)evalutate:(NSString *)xpathStr withContextNode:(id <XPNodeInfo>)ctxNode error:(NSError **)outErr;

- (void)declareNamespaceURI:(NSString *)uri forPrefix:(NSString *)prefix;

@property (nonatomic, retain) NSMutableDictionary *namespaces;
@end

//
//  XPStandaloneContext.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPStaticContext.h"

/**
 * A StandaloneContext provides a context for parsing an expression or pattern appearing
 * in a context other than a stylesheet.
 */

@interface XPStandaloneContext : NSObject <XPStaticContext>

- (void)declareNamespaceURI:(NSString *)uri forPrefix:(NSString *)prefix;

@property (nonatomic, retain) NSMutableDictionary *namespaces;
@end

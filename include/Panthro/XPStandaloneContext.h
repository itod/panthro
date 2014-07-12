//
//  XPStandaloneContext.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import <Panthro/XPStaticContext.h>

@class XPExpression;
@class XPFunction;
@class XPSync;

@protocol XPNodeInfo;

/**
 * A StandaloneContext provides a context for parsing an expression or pattern appearing
 * in a context other than a stylesheet.
 */

@interface XPStandaloneContext : NSObject <XPStaticContext>

+ (instancetype)standaloneContext;

- (XPExpression *)compile:(NSString *)xpathStr error:(NSError **)outErr;
- (id)evaluate:(XPExpression *)expr withContextNode:(id <XPNodeInfo>)ctxNode error:(NSError **)outErr;

- (id)execute:(NSString *)xpathStr withContextNode:(id <XPNodeInfo>)ctxNode error:(NSError **)outErr;

#if PAUSE_ENABLED
// Debugging
@property (nonatomic, retain) XPSync *debugSync;
@property (nonatomic, assign) BOOL debug;
#endif
@end

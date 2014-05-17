//
//  XPLibxmlNodeImpl.h
//  Panthro
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import <Panthro/XPNodeInfo.h>
#import <libxml/parser.h>

@interface XPLibxmlNodeImpl : NSObject <XPNodeInfo>

+ (id <XPNodeInfo>)nodeInfoWithNode:(void *)node parserContext:(xmlParserCtxtPtr)parserCtx;
- (id <XPNodeInfo>)initWithNode:(void *)node parserContext:(xmlParserCtxtPtr)parserCtx;

@end

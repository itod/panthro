//
//  XPLibxmlNodeImpl.h
//  Panthro
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import "XPAbstractNodeWrapper.h"
#import <libxml/parser.h>

@interface XPLibxmlNodeImpl : XPAbstractNodeWrapper

+ (id <XPNodeInfo>)nodeInfoWithNode:(void *)node parserContext:(xmlParserCtxtPtr)parserCtx;
- (id <XPNodeInfo>)initWithNode:(void *)node parserContext:(xmlParserCtxtPtr)parserCtx;

@property (nonatomic, assign) xmlNodePtr node;
@property (nonatomic, assign) xmlParserCtxtPtr parserCtx;

@property (nonatomic, retain) id <XPNodeInfo>parent;
@end

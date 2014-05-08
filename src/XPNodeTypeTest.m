//
//  XPNodeTypeTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPNodeTypeTest.h"
#import <XPath/XPNodeInfo.h>

@interface XPNodeTypeTest ()

@end

@implementation XPNodeTypeTest

- (instancetype)initWithNodeType:(XPNodeType)type {
    self = [super init];
    if (self) {
        self.type = type;
        
        switch (_type) {
            case XPNodeTypeRoot:
                self.originalText = @"/";
                break;
            case XPNodeTypeElement:
            case XPNodeTypeAttribute:
                self.originalText = @"*";
                break;
            case XPNodeTypeComment:
                self.originalText = @"comment()";
                break;
            case XPNodeTypeText:
                self.originalText = @"text()";
                break;
            case XPNodeTypePI:
                self.originalText = @"processing-instruction()";
                break;
            case XPNodeTypeNamespace:
                self.originalText = @"namespace()";
                break;
            case XPNodeTypeNode:
                self.originalText = @"node()";
                break;
            default:
                self.originalText = nil;
                break;
        }
        
    }
    return self;
}


- (void)dealloc {
    
    [super dealloc];
}


- (NSString *)description {
    return self.originalText;
}


/**
 * Test whether this node test is satisfied by a given node
 */

- (BOOL)matches:(id <XPNodeInfo>)node {
    BOOL matches = NO;
    if (XPNodeTypeNode == _type || _type == node.nodeType) {
        matches = YES;
    }
    return matches;
}


/**
 * Test whether this node test is satisfied by a given node
 * @param nodeType The type of node to be matched
 * @param fingerprint identifies the expanded name of the node to be matched
 */

- (BOOL)matches:(XPNodeType)nodeType name:(NSString *)nodeName {
    return (_type == nodeType);
}


/**
 * Determine the default priority of this node test when used on its own as a Pattern
 */

- (double)defaultPriority {
    return -0.5;
}

@end

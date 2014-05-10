//
//  XPNodeTypeTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPNodeTypeTest.h"
#import "XPNodeInfo.h"

@interface XPNodeTypeTest ()

@end

@implementation XPNodeTypeTest

- (instancetype)initWithNodeType:(XPNodeType)type {
    self = [super init];
    if (self) {
        self.nodeType = type;
        
        switch (type) {
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


- (BOOL)matches:(XPNodeType)nodeType name:(NSString *)name {
    BOOL matches = NO;
    if (XPNodeTypeNode == self.nodeType || nodeType == self.nodeType) {
        matches = YES;
    }
    return matches;
}


/**
 * Determine the default priority of this node test when used on its own as a Pattern
 */

- (double)defaultPriority {
    return -0.5;
}

@end

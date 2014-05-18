//
//  FNId.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNId.h"
#import "XPNodeInfo.h"
#import "XPDocumentInfo.h"
#import "XPContext.h"
#import "XPNodeSetValue.h"
#import "XPNodeEnumeration.h"
#import "XPLocalOrderComparer.h"
#import "XPEmptyNodeSet.h"
#import "XPSingletonNodeSet.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNId

+ (NSString *)name {
    return @"id";
}


- (void)dealloc {
    self.boundDocument = nil;
    [super dealloc];
}


- (XPDataType)dataType {
    return XPDataTypeNodeSet;
}


/**
 * Determine, in the case of an expression whose data type is XPDataTypeNodeSet,
 * whether all the nodes in the node-set are guaranteed to come from the same
 * document as the context node. Used for optimization.
 */

- (BOOL)isContextDocumentNodeSet {
    return YES;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:1 max:1];
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    return self;
}


- (XPNodeSetValue *)evaluateAsNodeSetInContext:(XPContext *)ctx {
    id arg = [self.args[0] evaluateInContext:ctx];
    return [self findId:arg inContext:ctx];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [self evaluateAsNodeSetInContext:ctx];
}


- (XPDependencies)dependencies {
    XPDependencies dep = [(XPExpression *)self.args[0] dependencies];
    if (_boundDocument) {
        return dep;
    } else {
        return dep | XPDependenciesContextNode | XPDependenciesContextDocument;
    }
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNId *idFn = [[[FNId alloc] init] autorelease];
    [idFn addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    idFn.staticContext = self.staticContext;
    idFn.boundDocument = _boundDocument;
    
    if (!_boundDocument && ((dep & (XPDependenciesContextNode | XPDependenciesContextDocument)) != 0)) {
        idFn.boundDocument = ctx.contextNode.documentRoot;
    }
    return idFn;
}


/**
 * This method actually evaluates the function
 */

- (XPNodeSetValue *)findId:(XPValue *)arg0 inContext:(XPContext *)ctx {
    NSMutableArray *idrefresult = nil;
    id <XPDocumentInfo>doc = nil;
    
    if (_boundDocument) {
        doc = _boundDocument;
    } else {
        doc = ctx.contextNode.documentRoot;
    }
    
    if ([arg0 isNodeSetValue] /* && ![arg0 isKindOfClass:[XPFragmentValue class]]*/) {
        
        id <XPNodeEnumeration>enm = [(XPNodeSetValue *)arg0 enumerate];
        while ([enm hasMoreObjects]) {
            id <XPNodeInfo>node = [enm nextObject];
            NSString *s = node.stringValue;
            NSArray *comps = [s componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            for (NSString *comp in comps) {
                id <XPNodeInfo>el = [doc selectID:comp];
                if (el) {
                    if (!idrefresult) {
                        idrefresult = [NSMutableArray arrayWithCapacity:2];
                    }
                    [idrefresult addObject:el];
                }
            }
        }
        
    } else {
        
        NSString *s = [arg0 asString];
        NSArray *comps = [s componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        for (NSString *comp in comps) {
            id <XPNodeInfo>el = [doc selectID:comp];
            if (el) {
                if (!idrefresult) {
                    idrefresult = [NSMutableArray arrayWithCapacity:2];
                }
                [idrefresult addObject:el];
            }
        }
    }
    
    if (!idrefresult) {
        return [XPEmptyNodeSet emptyNodeSet];
    }
    if (1 == [idrefresult count]) {
        return [XPSingletonNodeSet singletonNodeSetWithNode:idrefresult[0]];
    }
    XPNodeSetValue *nodeSet = [[[XPNodeSetValue alloc] initWithNodes:idrefresult comparer:[XPLocalOrderComparer instance]] autorelease];
    [nodeSet sort];
    return nodeSet;
}

@end

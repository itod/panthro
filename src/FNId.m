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
#import "XPNodeSetExtent.h"
#import "XPSequenceEnumeration.h"
#import "XPEmptyNodeSet.h"
#import "XPSingletonNodeSet.h"

@interface XPExpression ()
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
    return XPDataTypeSequence;
}


/**
 * Determine, in the case of an expression whose data type is XPDataTypeSequence,
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


- (XPSequenceValue *)evaluateAsNodeSetInContext:(XPContext *)ctx {
    id arg = [self.args[0] evaluateInContext:ctx];
    XPSequenceValue *nodeSet = [self findId:arg inContext:ctx];
    nodeSet.range = self.range;
    return nodeSet;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *val = [self evaluateAsNodeSetInContext:ctx];
    val.range = self.range;
    return val;
}


- (XPDependencies)dependencies {
    XPDependencies dep = [(XPExpression *)self.args[0] dependencies];
    if (_boundDocument) {
        return dep;
    } else {
        return dep | XPDependenciesContextNode | XPDependenciesContextDocument;
    }
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNId *idFn = [[[FNId alloc] init] autorelease];
    [idFn addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    idFn.staticContext = self.staticContext;
    idFn.range = self.range;
    idFn.boundDocument = _boundDocument;
    
    if (!_boundDocument && ((dep & (XPDependenciesContextNode | XPDependenciesContextDocument)) != 0)) {
        idFn.boundDocument = ctx.contextNode.documentRoot;
    }
    return idFn;
}


/**
 * This method actually evaluates the function
 */

- (XPSequenceValue *)findId:(XPValue *)arg0 inContext:(XPContext *)ctx {
    NSMutableArray *idrefresult = nil;
    id <XPDocumentInfo>doc = nil;
    
    if (_boundDocument) {
        doc = _boundDocument;
    } else {
        doc = ctx.contextNode.documentRoot;
    }
    
    if ([arg0 isSequenceValue] /* && ![arg0 isKindOfClass:[XPFragmentValue class]]*/) {
        
        id <XPSequenceEnumeration>enm = [(XPSequenceValue *)arg0 enumerate];
        while ([enm hasMoreItems]) {
            id <XPNodeInfo>node = [enm nextNodeInfo];
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
    XPSequenceValue *nodeSet = [[[XPNodeSetExtent alloc] initWithNodes:idrefresult comparer:nil] autorelease];
    [nodeSet sort];
    return nodeSet;
}

@end

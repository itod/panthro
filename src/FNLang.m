//
//  FNLang.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNLang.h"
#import "XPStaticContext.h"
#import "XPContext.h"
#import "XPNodeInfo.h"
#import "XPValue.h"
#import "XPBooleanValue.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNLang

+ (NSString *)name {
    return @"lang";
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:1 max:1];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;

    return result;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    NSString *arglang = [self.args[0] evaluateAsStringInContext:ctx];

    id <XPNodeInfo>node = ctx.contextNode;
    
    NSString *doclang = nil;;
    
    while (node) {
        doclang = [node attributeValueForURI:XPNamespaceXML localName:@"lang"];
        if ([doclang length]) break;
        
        node = node.parent;
    }
    
    if (![doclang length]) return NO;
    
    if (NSOrderedSame == [arglang caseInsensitiveCompare:doclang]) return YES;
    
    NSUInteger hyphen = [doclang rangeOfString:@"-"].location;
    if (NSNotFound == hyphen) return NO;

    doclang = [doclang substringToIndex:hyphen];
    if (NSOrderedSame == [arglang caseInsensitiveCompare:doclang]) return YES;
    
    return NO;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    BOOL b = [self evaluateAsBooleanInContext:ctx];
    XPValue *val = [XPBooleanValue booleanValueWithBoolean:b];
    val.range = self.range;
    return val;
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNLang *f = [[[FNLang alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end

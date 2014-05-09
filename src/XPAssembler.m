//
//  XPAssembler.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/16/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPAssembler.h>
#import <XPath/XPath.h>
#import <PEGKit/PEGKit.h>

#import "XPPathExpression.h"
#import "XPRootExpression.h"
#import "XPContextNodeExpression.h"
#import "XPStep.h"
#import "XPAxis.h"
#import "XPNodeTypeTest.h"
#import "XPNameTest.h"

@interface XPAssembler ()
@property (nonatomic, retain) NSDictionary *funcTab;
@property (nonatomic, retain) NSDictionary *nodeTypeTab;
@property (nonatomic, retain) PKToken *paren;
@property (nonatomic, retain) PKToken *slash;
@property (nonatomic, retain) PKToken *doubleSlash;
@property (nonatomic, retain) PKToken *dotDotDot;
@property (nonatomic, retain) PKToken *closeBracket;
@property (nonatomic, retain) NSCharacterSet *singleQuoteCharSet;
@property (nonatomic, retain) NSCharacterSet *doubleQuoteCharSet;
@end

@implementation XPAssembler

- (id)init {
    if (self = [super init]) {
        self.paren = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
        self.slash = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"/" doubleValue:0.0];
        self.doubleSlash = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"//" doubleValue:0.0];
        self.dotDotDot = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"…" doubleValue:0.0];
        self.closeBracket = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"]" doubleValue:0.0];
        self.singleQuoteCharSet = [NSCharacterSet characterSetWithCharactersInString:@"'"];
        self.doubleQuoteCharSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
        
        self.funcTab = @{
             @"boolean": [FNBoolean class],
             @"ceiling": [FNCeiling class],
             @"concat": [FNConcat class],
             @"contains": [FNContains class],
             @"count": [FNCount class],
             @"ends-with": [FNEndsWith class],
             @"floor": [FNFloor class],
             @"last": [FNLast class],
             @"not": [FNNot class],
             @"number": [FNNumber class],
             @"position": [FNPosition class],
             @"round": [FNRound class],
             @"starts-with": [FNStartsWith class],
             @"string": [FNString class],
             @"string-length": [FNStringLength class],
             @"substring": [FNSubstring class],
             @"substring-after": [FNSubstringAfter class],
             @"substring-before": [FNSubstringBefore class],
             @"sum": [FNSum class],
             };

        self.nodeTypeTab = @{
            @"node": @(XPNodeTypeNode),
            @"element": @(XPNodeTypeElement),
            @"attribute": @(XPNodeTypeAttribute),
            @"text": @(XPNodeTypeText),
            @"processing-instruction": @(XPNodeTypePI),
            @"comment": @(XPNodeTypeComment),
            @"root": @(XPNodeTypeRoot),
            @"namespace": @(XPNodeTypeNamespace),
            @"number-of-types": @(XPNodeTypeNumberOfTypes),
            @"none": @(XPNodeTypeNone),
            };
}
    return self;
}


- (void)dealloc {
    self.paren = nil;
    self.slash = nil;
    self.doubleSlash = nil;
    self.dotDotDot = nil;
    self.closeBracket = nil;
    self.singleQuoteCharSet = nil;
    self.doubleQuoteCharSet = nil;
    self.funcTab = nil;
    self.nodeTypeTab = nil;
    [super dealloc];
}


- (XPFunction *)makeSystemFunction:(NSString *)name {
    XPAssert(_funcTab);

    Class cls = [_funcTab objectForKey:name];
    NSAssert1(cls, @"unknown function %@", name);
    
    XPFunction *fn = [[[cls alloc] init] autorelease];
    XPAssert(fn);
    
    return fn;
}


- (void)parser:(PKParser *)p didMatchOrAndExpr:(PKAssembly *)a { [self parser:p didMatchAnyBooleanExpr:a]; }
- (void)parser:(PKParser *)p didMatchAndEqualityExpr:(PKAssembly *)a { [self parser:p didMatchAnyBooleanExpr:a]; }

- (void)parser:(PKParser *)p didMatchAnyBooleanExpr:(PKAssembly *)a {
    XPValue *v2 = [a pop];
    PKToken *opTok = [a pop];
    XPValue *v1 = [a pop];

    NSInteger op = XPTokenTypeAnd;

    if ([@"or" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeOr;
    }

    [a push:[XPBooleanExpression booleanExpressionWithOperand:v1 operator:op operand:v2]];
}


- (void)parser:(PKParser *)p didMatchCompareAdditiveExpr:(PKAssembly *)a { [self parser:p didMatchAnyRelationalExpr:a]; }
- (void)parser:(PKParser *)p didMatchEqRelationalExpr:(PKAssembly *)a { [self parser:p didMatchAnyRelationalExpr:a]; }

- (void)parser:(PKParser *)p didMatchAnyRelationalExpr:(PKAssembly *)a {
    XPExpression *p2 = [a pop];
    XPAssertExpr(p2);
    PKToken *opTok = [a pop];
    XPAssertToken(opTok);
    XPExpression *p1 = [a pop];
    XPAssertExpr(p1);
    
    NSInteger op = XPTokenTypeEquals;
    NSString *opStr = opTok.stringValue;

    if ([@"!=" isEqualToString:opStr]) {
        op = XPTokenTypeNE;
    } else if ([@"<" isEqualToString:opStr]) {
        op = XPTokenTypeLT;
    } else if ([@">" isEqualToString:opStr]) {
        op = XPTokenTypeGT;
    } else if ([@"<=" isEqualToString:opStr]) {
        op = XPTokenTypeLE;
    } else if ([@">=" isEqualToString:opStr]) {
        op = XPTokenTypeGE;
    }
    
    [a push:[XPRelationalExpression relationalExpressionWithOperand:p1 operator:op operand:p2]];
}


- (void)parser:(PKParser *)p didMatchPlusOrMinusMultiExpr:(PKAssembly *)a { [self parser:p didMatchAnyArithmeticExpr:a]; }
- (void)parser:(PKParser *)p didMatchMultDivOrModUnaryExpr:(PKAssembly *)a { [self parser:p didMatchAnyArithmeticExpr:a]; }

- (void)parser:(PKParser *)p didMatchAnyArithmeticExpr:(PKAssembly *)a {
    XPValue *v2 = [a pop];
    PKToken *opTok = [a pop];
    XPValue *v1 = [a pop];
    
    NSInteger op = XPTokenTypePlus;
    
    if ([@"-" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeMinus;
    } else if ([@"div" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeDiv;
    } else if ([@"*" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeMult;
    } else if ([@"mod" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeMod;
    }
    
    [a push:[XPArithmeticExpression arithmeticExpressionWithOperand:v1 operator:op operand:v2]];
}


- (void)parser:(PKParser *)p didMatchBooleanLiteralFunctionCall:(PKAssembly *)a {
    PKToken *nameTok = [a pop];
    
    BOOL b = NO;
    
    if ([nameTok.stringValue isEqualToString:@"true"]) {
        b = YES;
    }

    [a push:[XPBooleanValue booleanValueWithBoolean:b]];
}


- (void)parser:(PKParser *)p didMatchActualFunctionCall:(PKAssembly *)a {
    NSArray *args = [a objectsAbove:_paren];
    [a pop]; // '('
    
    NSString *name = [[a pop] stringValue];

    XPFunction *fn = [self makeSystemFunction:name];
    
    for (id arg in [args reverseObjectEnumerator]) {
        [fn addArgument:arg];
    }
    [a push:fn];
}


- (void)parser:(PKParser *)p didMatchLocationPath:(PKAssembly *)a {
    
    NSArray *pathParts = [a objectsAbove:_dotDotDot];
    [a pop]; // pop …
    
    XPExpression *pathExpr = [a pop]; // either context-node() or root() expr
    XPAssertExpr(pathExpr);
    
    for (id part in [pathParts reverseObjectEnumerator]) {
        XPStep *step = nil;
        if ([_slash isEqualTo:part]) {
            continue;
        } else if ([_doubleSlash isEqualTo:part]) {
            XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
            step = [[[XPStep alloc] initWithAxis:XPAxisDescendantOrSelf nodeTest:nodeTest] autorelease];
        } else {
            XPAssert([part isKindOfClass:[XPStep class]]);
            step = (id)part;
        }
        pathExpr = [[[XPPathExpression alloc] initWithStart:pathExpr step:step] autorelease];
    }
    
    [a push:pathExpr];
}


- (void)parser:(PKParser *)p didMatchAbsoluteLocationPath:(PKAssembly *)a {
    
}


- (void)parser:(PKParser *)p didMatchRelativeLocationPath:(PKAssembly *)a {
    
}


- (void)parser:(PKParser *)p didMatchFirstRelativeStep:(PKAssembly *)a {
    XPStep *step = [a pop];
    XPAssert([step isKindOfClass:[XPStep class]]);
    
    XPExpression *cxtNodeExpr = [[[XPContextNodeExpression alloc] init] autorelease];
    [a push:cxtNodeExpr];
    [a push:_dotDotDot];
    [a push:step];
}


- (void)parser:(PKParser *)p didMatchRootSlash:(PKAssembly *)a {
    XPExpression *rootExpr = [[[XPRootExpression alloc] init] autorelease];
    [a push:rootExpr];
    [a push:_dotDotDot];
}


- (void)parser:(PKParser *)p didMatchRootDoubleSlash:(PKAssembly *)a {
    XPExpression *rootExpr = [[[XPRootExpression alloc] init] autorelease];
    [a push:rootExpr];
    [a push:_dotDotDot];

    XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
    XPStep *step = [[[XPStep alloc] initWithAxis:XPAxisDescendantOrSelf nodeTest:nodeTest] autorelease];
    [a push:step];
    [a push:_slash];
}


- (NSArray *)filtersFrom:(PKAssembly *)a {
    NSMutableArray *filters = nil;
    
    id peek = [a pop];
    while (peek == _closeBracket) {
        XPExpression *f = [a pop];
        XPAssertExpr(f);
        
        if (!filters) {
            filters = [NSMutableArray arrayWithCapacity:2];
        }
        [filters insertObject:f atIndex:0];
        
        peek = [a pop];
    }
    [a push:peek];
    
    return filters;
}


- (XPStep *)stepWithAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest filters:(NSArray *)filters {
    XPStep *step = [[[XPStep alloc] initWithAxis:axis nodeTest:nodeTest] autorelease];
    for (XPExpression *f in filters) {
        [step addFilter:f];
    }
    return step;
}


- (void)parser:(PKParser *)p didMatchExplicitAxisStep:(PKAssembly *)a {
    
    NSArray *filters = [self filtersFrom:a];

    XPNodeTest *nodeTest = [a pop];
    XPAssert([nodeTest isKindOfClass:[XPNodeTest class]]);
    
    NSNumber *axisNum = [a pop];
    XPAssert([axisNum isKindOfClass:[NSNumber class]]);
    XPAxis axis = [axisNum unsignedIntegerValue];
    
    if ([nodeTest isKindOfClass:[XPNameTest class]]) {
        nodeTest.nodeType = XPAxisPrincipalNodeType[axis];
    }
    
    XPStep *step = [self stepWithAxis:axis nodeTest:nodeTest filters:filters];
    [a push:step];
}


- (void)parser:(PKParser *)p didMatchImplicitAxisStep:(PKAssembly *)a {

    NSArray *filters = [self filtersFrom:a];
    
    XPNodeTest *nodeTest = [a pop];
    XPAssert([nodeTest isKindOfClass:[XPNodeTest class]]);

    XPAxis axis = XPAxisChild;
    
    if ([nodeTest isKindOfClass:[XPNameTest class]]) {
        nodeTest.nodeType = XPAxisPrincipalNodeType[axis];
    }

    XPStep *step = [self stepWithAxis:axis nodeTest:nodeTest filters:filters];
    [a push:step];
}


- (void)parser:(PKParser *)p didMatchAbbreviatedStep:(PKAssembly *)a {
    PKToken *tok = [a pop];
    
    XPAxis axis;
    if ([tok.stringValue isEqualToString:@"."]) {
        axis = XPAxisSelf;
    } else {
        XPAssert([tok.stringValue isEqualToString:@".."])
        axis = XPAxisParent;
    }
    
    XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
    XPStep *step = [[[XPStep alloc] initWithAxis:axis nodeTest:nodeTest] autorelease];
    [a push:step];
}


- (void)parser:(PKParser *)p didMatchAxisName:(PKAssembly *)a {
    PKToken *tok = [a pop];
    XPAssertToken(tok);
    
    XPAxis axis = XPAxisForName(tok.stringValue);
    [a push:@(axis)];
}


- (void)parser:(PKParser *)p didMatchAbbreviatedAxis:(PKAssembly *)a {
    [a push:@(XPAxisAttribute)];
}


- (void)parser:(PKParser *)p didMatchTypeTest:(PKAssembly *)a {
    PKToken *tok = [a pop];
    XPAssertToken(tok);
    XPAssert(_nodeTypeTab);
    XPNodeType type = [_nodeTypeTab[tok.stringValue] unsignedIntegerValue];
    XPAssert(XPNodeTypeNone != type);
    XPNodeTypeTest *typeTest = [[[XPNodeTypeTest alloc] initWithNodeType:type] autorelease];
    
    [a push:typeTest];
}


- (void)parser:(PKParser *)p didMatchNameTest:(PKAssembly *)a {
    PKToken *tok = [a pop];
    XPAssertToken(tok);
    XPNameTest *nameTest = [[[XPNameTest alloc] initWithName:tok.stringValue] autorelease];
    [a push:nameTest];
}


- (void)parser:(PKParser *)p didMatchPredicate:(PKAssembly *)a {
    XPExpression *expr = [a pop];
    XPAssertExpr(expr);
    [a push:expr];
    [a push:_closeBracket];
}


- (void)parser:(PKParser *)p didMatchMinusUnionExpr:(PKAssembly *)a {
    XPValue *val = [a pop];
    PKToken *tok = [a pop];
    XPAssert([tok.stringValue isEqualToString:@"-"]);

    BOOL isNegative = NO;
    while ([tok.stringValue isEqualToString:@"-"]) {
        isNegative = !isNegative;
        tok = [a pop];
    }
    [a push:tok]; // put that last one back, fool
    
    double d = [val asNumber];
    if (isNegative) d = -d;
    [a push:[XPNumericValue numericValueWithNumber:d]];
}


- (void)parser:(PKParser *)p didMatchNumber:(PKAssembly *)a {
    PKToken *tok = [a pop];
    [a push:[XPNumericValue numericValueWithNumber:tok.doubleValue]];
}


- (void)parser:(PKParser *)p didMatchLiteral:(PKAssembly *)a {
    PKToken *tok = [a pop];
    NSString *s = tok.stringValue;
    
    if ([s length]) {
        unichar c = [s characterAtIndex:0];
        NSCharacterSet *set = _singleQuoteCharSet;
        if ('"' == c) {
            set = _doubleQuoteCharSet;
        }
        s = [s stringByTrimmingCharactersInSet:set];
    }
    
    [a push:[XPStringValue stringValueWithString:s]];
}

@end

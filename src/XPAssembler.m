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

#import "XPStep.h"
#import "XPAxis.h"
#import "XPNodeTypeTest.h"
#import "XPNameTest.h"

@interface XPAssembler ()
@property (nonatomic, retain) NSDictionary *funcTab;
@property (nonatomic, retain) NSDictionary *nodeTypeTab;
@property (nonatomic, retain) PKToken *paren;
@property (nonatomic, retain) NSCharacterSet *singleQuoteCharSet;
@property (nonatomic, retain) NSCharacterSet *doubleQuoteCharSet;
@end

@implementation XPAssembler

- (id)init {
    if (self = [super init]) {
        self.paren = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
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
             @"not": [FNNot class],
             @"number": [FNNumber class],
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
    XPValue *v2 = [a pop];
    PKToken *opTok = [a pop];
    XPValue *v1 = [a pop];
    
    NSInteger op = XPTokenTypeEquals;

    if ([@"!=" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeNE;
    } else if ([@"<" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeLT;
    } else if ([@">" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeGT;
    } else if ([@"<=" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeLE;
    } else if ([@">=" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeGE;
    }
    
    [a push:[XPRelationalExpression relationalExpressionWithOperand:v1 operator:op operand:v2]];
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


- (void)parser:(PKParser *)p didMatchStep:(PKAssembly *)a {
    XPNodeTest *nodeTest = [a pop];
    XPAssert([nodeTest isKindOfClass:[XPNodeTest class]]);
    
    NSNumber *axisNum = [a pop];
    XPAssert([axisNum isKindOfClass:[NSNumber class]]);
    XPAxis axis = [axisNum unsignedIntegerValue];
    
    XPStep *step = [[[XPStep alloc] initWithAxis:axis nodeTest:nodeTest] autorelease];
    
    [a push:step];
}


- (void)parser:(PKParser *)p didMatchAxisName:(PKAssembly *)a {
    PKToken *tok = [a pop];
    
    // TODO
    XPAxis axis = @(XPAxisForName(tok.stringValue));
    [a push:@(axis)];
}


- (void)parser:(PKParser *)p didMatchImplicitAxisStep:(PKAssembly *)a {
    id obj = [a pop];
    [a push:@(XPAxisChild)];
    [a push:obj];
}


- (void)parser:(PKParser *)p didMatchTypeTest:(PKAssembly *)a {
    PKToken *tok = [a pop];
    XPAssert(_nodeTypeTab);
    XPNodeType type = [_nodeTypeTab[tok.stringValue] unsignedIntegerValue];
    XPAssert(XPNodeTypeNone != type);
    XPNodeTypeTest *typeTest = [[[XPNodeTypeTest alloc] initWithNodeType:type] autorelease];
    
    [a push:typeTest];
}


- (void)parser:(PKParser *)p didMatchNameTest:(PKAssembly *)a {
    PKToken *tok = [a pop];
    
    // TODO
    [a push:[XPBooleanValue booleanValueWithBoolean:tok.doubleValue]]; // this is a place holder. add a node later when ready
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

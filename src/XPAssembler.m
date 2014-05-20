//
//  XPAssembler.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/16/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPAssembler.h"
#import <Panthro/Panthro.h>
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>

#import "XPBooleanExpression.h"
#import "XPRelationalExpression.h"
#import "XPArithmeticExpression.h"

#import "XPStep.h"
#import "XPAxis.h"
#import "XPNodeTypeTest.h"
#import "XPNameTest.h"

#import "XPPathExpression.h"

#import "XPRootExpression.h"
#import "XPContextNodeExpression.h"
#import "XPFilterExpression.h"
#import "XPUnionExpression.h"

#import "XPVariableReference.h"

#import "XPFunction.h"
#import "FNAbs.h"
#import "FNBoolean.h"
#import "FNCeiling.h"
#import "FNConcat.h"
#import "FNCompare.h"
#import "FNContains.h"
#import "FNCount.h"
#import "FNEndsWith.h"
#import "FNFloor.h"
#import "FNId.h"
#import "FNLast.h"
#import "FNLocalName.h"
#import "FNLowerCase.h"
#import "FNMatches.h"
#import "FNName.h"
#import "FNNamespaceURI.h"
#import "FNNormalizeSpace.h"
#import "FNNormalizeUnicode.h"
#import "FNNot.h"
#import "FNNumber.h"
#import "FNPosition.h"
#import "FNRound.h"
#import "FNReplace.h"
#import "FNStartsWith.h"
#import "FNString.h"
#import "FNStringLength.h"
#import "FNSubstring.h"
#import "FNSubstringAfter.h"
#import "FNSubstringBefore.h"
#import "FNSum.h"
#import "FNTranslate.h"
#import "FNTrimSpace.h"
#import "FNTitleCase.h"
#import "FNUpperCase.h"

@interface XPAssembler ()
@property (nonatomic, retain) NSDictionary *funcTab;
@property (nonatomic, retain) NSDictionary *nodeTypeTab;
@property (nonatomic, retain) PKToken *openParen;
@property (nonatomic, retain) PKToken *slash;
@property (nonatomic, retain) PKToken *doubleSlash;
@property (nonatomic, retain) PKToken *dotDotDot;
@property (nonatomic, retain) PKToken *pipe;
@property (nonatomic, retain) PKToken *closeBracket;
@property (nonatomic, retain) PKToken *atAxis;
@property (nonatomic, retain) NSCharacterSet *singleQuoteCharSet;
@property (nonatomic, retain) NSCharacterSet *doubleQuoteCharSet;
@end

@implementation XPAssembler

- (instancetype)init {
    if (self = [super init]) {
        self.openParen = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
        self.slash = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"/" doubleValue:0.0];
        self.doubleSlash = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"//" doubleValue:0.0];
        self.dotDotDot = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"…" doubleValue:0.0];
        self.pipe = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"|" doubleValue:0.0];
        self.closeBracket = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"]" doubleValue:0.0];
        self.atAxis = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"@" doubleValue:0.0];
        self.singleQuoteCharSet = [NSCharacterSet characterSetWithCharactersInString:@"'"];
        self.doubleQuoteCharSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
        
        self.funcTab = @{
             [FNAbs name] : [FNAbs class],
             [FNBoolean name] : [FNBoolean class],
             [FNCeiling name] : [FNCeiling class],
             [FNConcat name] : [FNConcat class],
             [FNCompare name] : [FNCompare class],
             [FNContains name] : [FNContains class],
             [FNCount name] : [FNCount class],
             [FNEndsWith name] : [FNEndsWith class],
             [FNFloor name] : [FNFloor class],
             [FNId name] : [FNId class],
             [FNLast name] : [FNLast class],
             [FNLocalName name] : [FNLocalName class],
             [FNLowerCase name] : [FNLowerCase class],
             [FNMatches name] : [FNMatches class],
             [FNName name] : [FNName class],
             [FNNamespaceURI name] : [FNNamespaceURI class],
             [FNNormalizeSpace name] : [FNNormalizeSpace class],
             [FNNormalizeUnicode name] : [FNNormalizeUnicode class],
             [FNNot name] : [FNNot class],
             [FNNumber name] : [FNNumber class],
             [FNPosition name] : [FNPosition class],
             [FNRound name] : [FNRound class],
             [FNReplace name] : [FNReplace class],
             [FNStartsWith name] : [FNStartsWith class],
             [FNString name] : [FNString class],
             [FNStringLength name] : [FNStringLength class],
             [FNSubstring name] : [FNSubstring class],
             [FNSubstringAfter name] : [FNSubstringAfter class],
             [FNSubstringBefore name] : [FNSubstringBefore class],
             [FNSum name] : [FNSum class],
             [FNTranslate name] : [FNTranslate class],
             [FNTrimSpace name] : [FNTrimSpace class],
             [FNUpperCase name] : [FNUpperCase class],
             [FNTitleCase name] : [FNTitleCase class],
             };

        self.nodeTypeTab = @{
            XPNodeTypeName[XPNodeTypeNode] : @(XPNodeTypeNode),
            XPNodeTypeName[XPNodeTypeElement] : @(XPNodeTypeElement),
            XPNodeTypeName[XPNodeTypeAttribute] : @(XPNodeTypeAttribute),
            XPNodeTypeName[XPNodeTypeText] : @(XPNodeTypeText),
            XPNodeTypeName[XPNodeTypePI] : @(XPNodeTypePI),
            XPNodeTypeName[XPNodeTypeComment] : @(XPNodeTypeComment),
            XPNodeTypeName[XPNodeTypeRoot] : @(XPNodeTypeRoot),
            XPNodeTypeName[XPNodeTypeNamespace] : @(XPNodeTypeNamespace),
            XPNodeTypeName[XPNodeTypeNumberOfTypes] : @(XPNodeTypeNumberOfTypes),
            XPNodeTypeName[XPNodeTypeNone] : @(XPNodeTypeNone),
            };
}
    return self;
}


- (void)dealloc {
    self.funcTab = nil;
    self.nodeTypeTab = nil;
    self.openParen = nil;
    self.slash = nil;
    self.doubleSlash = nil;
    self.dotDotDot = nil;
    self.pipe = nil;
    self.closeBracket = nil;
    self.atAxis = nil;
    self.singleQuoteCharSet = nil;
    self.doubleQuoteCharSet = nil;
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

    XPExpression *boolExpr = [XPBooleanExpression booleanExpressionWithOperand:v1 operator:op operand:v2];
    boolExpr.range = NSMakeRange(v1.range.location, NSMaxRange(v2.range));
    [a push:boolExpr];
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
    
    XPExpression *relExpr = [XPRelationalExpression relationalExpressionWithOperand:p1 operator:op operand:p2];
    relExpr.range = NSMakeRange(p1.range.location, NSMaxRange(p2.range));
    [a push:relExpr];
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
    
    XPExpression *mathExpr = [XPArithmeticExpression arithmeticExpressionWithOperand:v1 operator:op operand:v2];
    mathExpr.range = NSMakeRange(v1.range.location, NSMaxRange(v2.range));
    [a push:mathExpr];
}


- (void)parser:(PKParser *)p didMatchBooleanLiteralFunctionCall:(PKAssembly *)a {
    PKToken *closeParenTok = [a pop];
    XPAssert([closeParenTok.stringValue isEqualToString:@")"]);
    PKToken *nameTok = [a pop];
    
    BOOL b = NO;
    
    if ([nameTok.stringValue isEqualToString:@"true"]) {
        b = YES;
    }

    XPExpression *boolExpr = [XPBooleanValue booleanValueWithBoolean:b];
    NSUInteger offset = nameTok.offset;
    boolExpr.range = NSMakeRange(offset, (closeParenTok.offset+1) - offset);
    [a push:boolExpr];
}


- (void)parser:(PKParser *)p didMatchActualFunctionCall:(PKAssembly *)a {
    PKToken *closeParenTok = [a pop];
    XPAssert([closeParenTok.stringValue isEqualToString:@")"]);

    NSArray *args = [a objectsAbove:_openParen];
    [a pop]; // '('
    
    PKToken *nameTok = [a pop];
    NSString *name = [nameTok stringValue];

    XPFunction *fn = [self makeSystemFunction:name];
    
    for (id arg in [args reverseObjectEnumerator]) {
        [fn addArgument:arg];
    }
    
    NSUInteger offset = nameTok.offset;
    fn.range = NSMakeRange(offset, (closeParenTok.offset+1) - offset);
    [a push:fn];
}


- (void)parser:(PKParser *)p didMatchVariableReference:(PKAssembly *)a {
    PKToken *nameTok = [a pop];
    XPAssertToken(nameTok);
    
    PKToken *dollarTok = [a pop];
    XPAssertToken(dollarTok);
    XPAssert([dollarTok.stringValue isEqualToString:@"$"]);

    NSString *name = nameTok.stringValue;
    XPVariableReference *ref = [[[XPVariableReference alloc] initWithName:name] autorelease];
    NSUInteger offset = dollarTok.offset;
    ref.range = NSMakeRange(offset, (nameTok.offset+name.length) - offset);
    [a push:ref];
}


- (void)parser:(PKParser *)p didMatchFilterExpr:(PKAssembly *)a {
    NSArray *filters = [self filtersFrom:a];
    
    if ([filters count]) {
        XPFilterExpression *filterExpr = [a pop];
        for (XPExpression *f in filters) {
            filterExpr = [[[XPFilterExpression alloc] initWithStart:filterExpr filter:f] autorelease];
        }
        
        [a push:filterExpr];
    }
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
            step = [self stepWithAxis:XPAxisDescendantOrSelf nodeTest:nodeTest filters:nil];
        } else {
            XPAssert([part isKindOfClass:[XPStep class]]);
            step = (id)part;
        }
        pathExpr = [[[XPPathExpression alloc] initWithStart:pathExpr step:step] autorelease];
    }
    
    [a push:pathExpr];
}

    
- (void)parser:(PKParser *)p didMatchComplexFilterPathStartExpr:(PKAssembly *)a {
    [a push:_dotDotDot];
}


- (void)parser:(PKParser *)p didMatchComplexFilterPath:(PKAssembly *)a {
    [self parser:p didMatchLocationPath:a];
}


- (void)parser:(PKParser *)p didMatchUnionTail:(PKAssembly *)a {
    XPExpression *rhs = [a pop];
    id peek = [a pop];
    
    if ([peek isEqualTo:_pipe]) {
        XPExpression *lhs = [a pop];
        
        XPExpression *unionExpr = [[[XPUnionExpression alloc] initWithLhs:lhs rhs:rhs] autorelease];
        unionExpr.range = NSMakeRange(lhs.range.location, NSMaxRange(rhs.range));
        [a push:unionExpr];
    } else {
        [a push:peek];
        [a push:rhs];
    }
}


- (void)parser:(PKParser *)p didMatchFirstRelativeStep:(PKAssembly *)a {
    XPStep *step = [a pop];
    XPAssert([step isKindOfClass:[XPStep class]]);
    
    XPExpression *cxtNodeExpr = [[[XPContextNodeExpression alloc] init] autorelease];
    [a push:cxtNodeExpr];
    [a push:_dotDotDot];
    
    if (XPAxisSelf == step.axis && XPNodeTypeNode == step.nodeTest.nodeType) {
        // drop redundant self::node() step
    } else {
        [a push:step];
    }
}


- (void)parser:(PKParser *)p didMatchRootSlash:(PKAssembly *)a {
    PKToken *slashTok = [a pop];
    XPAssertToken(slashTok);
    XPExpression *rootExpr = [[[XPRootExpression alloc] init] autorelease];
    rootExpr.range = NSMakeRange(slashTok.offset, 1);
    [a push:rootExpr];
    [a push:_dotDotDot];
}


- (void)parser:(PKParser *)p didMatchRootDoubleSlash:(PKAssembly *)a {
    PKToken *slashTok = [a pop];
    XPAssertToken(slashTok);
    XPExpression *rootExpr = [[[XPRootExpression alloc] init] autorelease];
    rootExpr.range = NSMakeRange(slashTok.offset, 2);
    [a push:rootExpr];
    [a push:_dotDotDot];

    XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
    XPStep *step = [self stepWithAxis:XPAxisDescendantOrSelf nodeTest:nodeTest filters:nil];
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
    
    PKToken *axisTok = [a pop];
    XPAssertToken(axisTok);
    
    XPAxis axis;
    if ([axisTok isEqualTo:_atAxis]) {
        axis = XPAxisAttribute;
    } else {
        axis = XPAxisForName(axisTok.stringValue);
    }
    
    if ([nodeTest isKindOfClass:[XPNameTest class]] && XPNodeTypePI != nodeTest.nodeType) {
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
    
    if ([nodeTest isKindOfClass:[XPNameTest class]] && XPNodeTypePI != nodeTest.nodeType) {
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
    XPStep *step = [self stepWithAxis:axis nodeTest:nodeTest filters:nil];
    [a push:step];
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


- (void)parser:(PKParser *)p didMatchSpecificPITest:(PKAssembly *)a {
    NSString *name = [p popQuotedString];
    XPAssert([name isKindOfClass:[NSString class]]);
    XPNameTest *nameTest = [[[XPNameTest alloc] initWithName:name] autorelease];
    nameTest.nodeType = XPNodeTypePI;
    
    [a push:nameTest];
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
    NSUInteger offset = NSNotFound;
    while ([tok.stringValue isEqualToString:@"-"]) {
        offset = tok.offset;
        isNegative = !isNegative;
        tok = [a pop];
    }
    [a push:tok]; // put that last one back, fool
    
    double d = [val asNumber];
    if (isNegative) d = -d;
    
    XPExpression *numExpr = [XPNumericValue numericValueWithNumber:d];
    XPAssert(NSNotFound != offset);
    numExpr.range = NSMakeRange(offset, NSMaxRange(val.range));
    [a push:numExpr];
}


- (void)parser:(PKParser *)p didMatchNumber:(PKAssembly *)a {
    PKToken *tok = [a pop];
    XPExpression *numExpr = [XPNumericValue numericValueWithNumber:tok.doubleValue];
    numExpr.range = NSMakeRange(tok.offset, [tok.stringValue length]);
    [a push:numExpr];
}


- (void)parser:(PKParser *)p didMatchLiteral:(PKAssembly *)a {
    PKToken *tok = [a pop];
    NSString *s = tok.stringValue;
    NSUInteger len = [s length];
    
    if (len) {
        unichar c = [s characterAtIndex:0];
        NSCharacterSet *set = _singleQuoteCharSet;
        if ('"' == c) {
            set = _doubleQuoteCharSet;
        }
        s = [s stringByTrimmingCharactersInSet:set];
    }

    XPExpression *strExpr = [XPStringValue stringValueWithString:s];
    strExpr.range = NSMakeRange(tok.offset, len);
    [a push:strExpr];
}

@end

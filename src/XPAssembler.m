//
//  XPAssembler.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/16/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPAssembler.h"
#import "XPEGParser.h"
#import <Panthro/Panthro.h>
#import <PEGKit/PEGKit.h>
#import <PEGKit/PKParser+Subclass.h>

#import "XPSequenceExpression.h"
#import "XPRangeExpression.h"
#import "XPForExpression.h"
#import "XPEmptySequence.h"

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
#import "XPParentNodeExpression.h"

#import "XPFilterExpression.h"
#import "XPUnionExpression.h"
#import "XPIntersectExpression.h"
#import "XPExceptExpression.h"

#import "XPVariableReference.h"

@interface XPAssembler ()
@property (nonatomic, retain) id <XPStaticContext>env;
@property (nonatomic, retain) NSDictionary *nodeTypeTab;
@property (nonatomic, retain) PKToken *openParen;
@property (nonatomic, retain) PKToken *comma;
@property (nonatomic, retain) PKToken *slash;
@property (nonatomic, retain) PKToken *colon;
@property (nonatomic, retain) PKToken *doubleSlash;
@property (nonatomic, retain) PKToken *dotDotDot;
@property (nonatomic, retain) PKToken *pipe;
@property (nonatomic, retain) PKToken *unionSym;
@property (nonatomic, retain) PKToken *intersectSym;
@property (nonatomic, retain) PKToken *exceptSym;
@property (nonatomic, retain) PKToken *closeBracket;
@property (nonatomic, retain) PKToken *atAxis;
@property (nonatomic, retain) NSCharacterSet *singleQuoteCharSet;
@property (nonatomic, retain) NSCharacterSet *doubleQuoteCharSet;
@end

@implementation XPAssembler

- (instancetype)initWithContext:(id <XPStaticContext>)env {
    XPAssert(env);
    if (self = [super init]) {
        self.env = env;
        self.openParen = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
        self.comma = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"," doubleValue:0.0];
        self.slash = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"/" doubleValue:0.0];
        self.colon = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@":" doubleValue:0.0];
        self.doubleSlash = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"//" doubleValue:0.0];
        self.dotDotDot = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"…" doubleValue:0.0];
        self.pipe = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"|" doubleValue:0.0];
        self.unionSym = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"union" doubleValue:0.0];
        self.intersectSym = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"intersect" doubleValue:0.0];
        self.exceptSym = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"except" doubleValue:0.0];
        self.closeBracket = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"]" doubleValue:0.0];
        self.atAxis = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"@" doubleValue:0.0];
        self.singleQuoteCharSet = [NSCharacterSet characterSetWithCharactersInString:@"'"];
        self.doubleQuoteCharSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
        
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
    self.env = nil;
    self.nodeTypeTab = nil;
    self.openParen = nil;
    self.comma = nil;
    self.slash = nil;
    self.colon = nil;
    self.doubleSlash = nil;
    self.dotDotDot = nil;
    self.pipe = nil;
    self.unionSym = nil;
    self.intersectSym = nil;
    self.exceptSym = nil;
    self.closeBracket = nil;
    self.atAxis = nil;
    self.singleQuoteCharSet = nil;
    self.doubleQuoteCharSet = nil;
    [super dealloc];
}


- (void)parser:(PKParser *)p didMatchExprSingleTail:(PKAssembly *)a {
    XPExpression *p2 = [a pop];
    XPAssertExpr(p2);
    XPExpression *p1 = [a pop];
    XPAssertExpr(p1);
    
    XPExpression *seqExpr = [[[XPSequenceExpression alloc] initWithOperand:p1 operator:XPEG_TOKEN_KIND_COMMA operand:p2] autorelease];
    seqExpr.range = NSMakeRange(p1.range.location, NSMaxRange(p2.range) - p1.range.location);
    seqExpr.staticContext = _env;
    [a push:seqExpr];
}


- (void)parser:(PKParser *)p didMatchForExpr:(PKAssembly *)a {
    XPExpression *bodyExpr = [a pop];
    XPAssertExpr(bodyExpr);
    
    NSMutableArray *varNames = [NSMutableArray array];
    NSMutableArray *sequences = [NSMutableArray array];
    
    PKToken *peek = nil;
    do {
        XPExpression *seqExpr = [a pop];
        XPAssertExpr(seqExpr);
        PKToken *varNameTok = [a pop];
        XPAssertToken(varNameTok);
        
        [varNames insertObject:varNameTok.stringValue atIndex:0];
        [sequences insertObject:seqExpr atIndex:0];
        
        peek = [a pop];
        
    } while ([peek isEqual:_comma]);
    
    // discard 'for'
    XPAssert([peek.stringValue isEqualToString:@"for"]);
    NSUInteger offset = peek.offset;
    
    XPExpression *forExpr = [[[XPForExpression alloc] initWithVarNames:varNames sequences:sequences body:bodyExpr] autorelease];
    forExpr.range = NSMakeRange(offset, NSMaxRange(bodyExpr.range) - offset);
    forExpr.staticContext = _env;
    [a push:forExpr];
}


- (void)parser:(PKParser *)p didMatchOrAndExpr:(PKAssembly *)a { [self parser:p didMatchAnyBooleanExpr:a]; }
- (void)parser:(PKParser *)p didMatchAndRangeExpr:(PKAssembly *)a { [self parser:p didMatchAnyBooleanExpr:a]; }

- (void)parser:(PKParser *)p didMatchAnyBooleanExpr:(PKAssembly *)a {
    XPValue *p2 = [a pop];
    PKToken *opTok = [a pop];
    XPValue *p1 = [a pop];
    
    NSInteger op = XPEG_TOKEN_KIND_AND;
    
    if ([@"or" isEqualToString:opTok.stringValue]) {
        op = XPEG_TOKEN_KIND_OR;
    }
    
    XPExpression *boolExpr = [XPBooleanExpression booleanExpressionWithOperand:p1 operator:op operand:p2];
    boolExpr.range = NSMakeRange(p1.range.location, NSMaxRange(p2.range) - p1.range.location);
    boolExpr.staticContext = _env;
    [a push:boolExpr];
}


- (void)parser:(PKParser *)p didMatchToEqualityExpr:(PKAssembly *)a {
    XPValue *p2 = [a pop];
    XPValue *p1 = [a pop];
    
    NSInteger op = XPEG_TOKEN_KIND_TO;
    
    XPExpression *rangeExpr = [XPRangeExpression rangeExpressionWithOperand:p1 operator:op operand:p2];
    rangeExpr.range = NSMakeRange(p1.range.location, NSMaxRange(p2.range) - p1.range.location);
    rangeExpr.staticContext = _env;
    [a push:rangeExpr];
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
    
    NSInteger op = XPEG_TOKEN_KIND_EQUALS;
    NSString *opStr = opTok.stringValue;

    if ([@"!=" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_NOT_EQUAL;
    } else if ([@"<" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_LT_SYM;
    } else if ([@">" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_GT_SYM;
    } else if ([@"<=" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_LE_SYM;
    } else if ([@">=" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_GE_SYM;
    }
    
    XPExpression *relExpr = [XPRelationalExpression relationalExpressionWithOperand:p1 operator:op operand:p2];
    relExpr.range = NSMakeRange(p1.range.location, NSMaxRange(p2.range) - p1.range.location);
    relExpr.staticContext = _env;
    [a push:relExpr];
}


- (void)parser:(PKParser *)p didMatchPlusOrMinusMultiExpr:(PKAssembly *)a { [self parser:p didMatchAnyArithmeticExpr:a]; }
- (void)parser:(PKParser *)p didMatchMultDivOrModUnaryExpr:(PKAssembly *)a { [self parser:p didMatchAnyArithmeticExpr:a]; }

- (void)parser:(PKParser *)p didMatchAnyArithmeticExpr:(PKAssembly *)a {
    XPValue *p2 = [a pop];
    PKToken *opTok = [a pop];
    XPValue *p1 = [a pop];
    
    NSInteger op = XPEG_TOKEN_KIND_PLUS;
    
    if ([@"-" isEqualToString:opTok.stringValue]) {
        op = XPEG_TOKEN_KIND_MINUS;
    } else if ([@"div" isEqualToString:opTok.stringValue]) {
        op = XPEG_TOKEN_KIND_DIV;
    } else if ([@"*" isEqualToString:opTok.stringValue]) {
        op = XPEG_TOKEN_KIND_MULTIPLYOPERATOR;
    } else if ([@"mod" isEqualToString:opTok.stringValue]) {
        op = XPEG_TOKEN_KIND_MOD;
    }
    
    XPExpression *mathExpr = [XPArithmeticExpression arithmeticExpressionWithOperand:p1 operator:op operand:p2];
    mathExpr.range = NSMakeRange(p1.range.location, NSMaxRange(p2.range) - p1.range.location);
    mathExpr.staticContext = _env;
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
    boolExpr.staticContext = _env;
    [a push:boolExpr];
}


- (void)parser:(PKParser *)p didMatchActualFunctionCall:(PKAssembly *)a {
    PKToken *closeParenTok = [a pop];
    XPAssert([closeParenTok.stringValue isEqualToString:@")"]);

    NSArray *args = [a objectsAbove:_openParen];
    [a pop]; // '('
    
    PKToken *nameTok = [a pop];
    NSString *name = [nameTok stringValue];

    XPAssert(_env);
    NSError *err = nil;
    XPFunction *fn = [_env makeSystemFunction:name error:&err];
    if (!fn) {
        if (err) {
            PKRecognitionException *rex = [[[PKRecognitionException alloc] init] autorelease];
            rex.range = NSMakeRange(nameTok.offset, [name length]);
            rex.currentName = @"Unknown XPath function";
            rex.currentReason = [err localizedFailureReason];
            [rex raise];
        }
    }
    
    for (id arg in [args reverseObjectEnumerator]) {
        [fn addArgument:arg];
    }
    
    NSUInteger offset = nameTok.offset;
    fn.range = NSMakeRange(offset, (closeParenTok.offset+1) - offset);
    fn.staticContext = _env;
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
    ref.staticContext = _env;
    [a push:ref];
}


- (void)parser:(PKParser *)p didMatchParenthesizedExpr:(PKAssembly *)a {
    id peek = [a pop];
    if ([_openParen isEqual:peek]) {
        [a push:[XPEmptySequence instance]];
    } else {
        [a pop]; // discard '('
        [a push:peek];
    }
}


- (void)parser:(PKParser *)p didMatchFilterExpr:(PKAssembly *)a {
    NSArray *filters = [self filtersFrom:a];
    NSUInteger lastBracketMaxOffset = [[a pop] unsignedIntegerValue];
    
    if ([filters count]) {
        XPFilterExpression *filterExpr = [a pop];
        for (XPExpression *f in filters) {
            NSUInteger offset = filterExpr.range.location;
            filterExpr = [[[XPFilterExpression alloc] initWithStart:filterExpr filter:f] autorelease];
            filterExpr.range = NSMakeRange(offset, NSMaxRange(f.range) - offset);
            filterExpr.staticContext = _env;
            XPAssert(NSNotFound != filterExpr.range.location);
            XPAssert(NSNotFound != filterExpr.range.length);
            XPAssert(filterExpr.range.length);
        }
        
        filterExpr.range = NSMakeRange(filterExpr.range.location, lastBracketMaxOffset - filterExpr.range.location);
        filterExpr.staticContext = _env;
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
        if ([_slash isEqual:part]) {
            continue;
        } else if ([_doubleSlash isEqual:part]) {
            XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
            NSUInteger offset = [part offset];
            nodeTest.range = NSMakeRange(offset+2, 0);
            step = [self stepWithStartOffset:offset maxOffset:NSNotFound axis:XPAxisDescendantOrSelf nodeTest:nodeTest filters:nil];
        } else {
            XPAssert([part isKindOfClass:[XPStep class]]);
            step = (id)part;
        }
        NSUInteger offset = pathExpr.range.location;
        pathExpr = [[[XPPathExpression alloc] initWithStart:pathExpr step:step] autorelease];
        pathExpr.range = NSMakeRange(offset, NSMaxRange(step.range) - offset);
        pathExpr.staticContext = _env;
        XPAssert(NSNotFound != pathExpr.range.location);
        XPAssert(NSNotFound != pathExpr.range.length);
        XPAssert(pathExpr.range.length);
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
    
    if ([peek isEqual:_pipe] || [peek isEqual:_unionSym]) {
        XPExpression *lhs = [a pop];
        
        XPExpression *unionExpr = [[[XPUnionExpression alloc] initWithLhs:lhs rhs:rhs] autorelease];
        unionExpr.range = NSMakeRange(lhs.range.location, NSMaxRange(rhs.range) - lhs.range.location);
        unionExpr.staticContext = _env;
        [a push:unionExpr];
    } else {
        [a push:peek];
        [a push:rhs];
    }
}


- (void)parser:(PKParser *)p didMatchIntersectExceptTail:(PKAssembly *)a {
    XPExpression *rhs = [a pop];
    id peek = [a pop];
    
    if ([peek isEqual:_intersectSym]) {
        XPExpression *lhs = [a pop];
        
        XPExpression *intersectExpr = [[[XPIntersectExpression alloc] initWithLhs:lhs rhs:rhs] autorelease];
        intersectExpr.range = NSMakeRange(lhs.range.location, NSMaxRange(rhs.range) - lhs.range.location);
        intersectExpr.staticContext = _env;
        [a push:intersectExpr];
    } else if ([peek isEqual:_exceptSym]) {
        XPExpression *lhs = [a pop];
        
        XPExpression *exceptExpr = [[[XPExceptExpression alloc] initWithLhs:lhs rhs:rhs] autorelease];
        exceptExpr.range = NSMakeRange(lhs.range.location, NSMaxRange(rhs.range) - lhs.range.location);
        exceptExpr.staticContext = _env;
        [a push:exceptExpr];
    } else {
        [a push:peek];
        [a push:rhs];
    }
}


- (void)parser:(PKParser *)p didMatchFirstRelativeStep:(PKAssembly *)a {
    id obj = [a pop];
    
    XPStep *step = (id)obj;
    XPAssert([step isKindOfClass:[XPStep class]]);
    
    XPExpression *startNodeExpr = nil;
    BOOL skipStep = NO;

    // ok, let's produce a `context-node()`, `parent-node()`, or a `context-node()/step`.

    BOOL isAnyNodeTypeTest = [step.nodeTest isKindOfClass:[XPNodeTypeTest class]] && XPNodeTypeNode == step.nodeTest.nodeType;
    if (isAnyNodeTypeTest && XPAxisSelf == step.axis) {
        startNodeExpr = [[[XPContextNodeExpression alloc] init] autorelease];
        skipStep = YES; // drop redundant self::node() step
    } else if (isAnyNodeTypeTest && XPAxisParent == step.axis) {
        startNodeExpr = [[[XPParentNodeExpression alloc] init] autorelease];
        skipStep = YES; // drop redundant parent::node() step
    } else {
        startNodeExpr = [[[XPContextNodeExpression alloc] init] autorelease];
    }

    startNodeExpr.range = step.range;
    startNodeExpr.staticContext = _env;
    
    [a push:startNodeExpr];
    [a push:_dotDotDot];
    
    if (!skipStep) {
        [a push:step];
    }
}


- (void)parser:(PKParser *)p didMatchRootSlash:(PKAssembly *)a {
    PKToken *slashTok = [a pop];
    XPAssertToken(slashTok);
    
    XPExpression *rootExpr = [[[XPRootExpression alloc] init] autorelease];
    rootExpr.range = NSMakeRange(slashTok.offset, 1);
    rootExpr.staticContext = _env;
    
    [a push:rootExpr];
    [a push:_dotDotDot];
}


- (void)parser:(PKParser *)p didMatchRootDoubleSlash:(PKAssembly *)a {
    PKToken *slashTok = [a pop];
    XPAssertToken(slashTok);
    
    XPExpression *rootExpr = [[[XPRootExpression alloc] init] autorelease];
    rootExpr.range = NSMakeRange(slashTok.offset, 2);
    rootExpr.staticContext = _env;

    [a push:rootExpr];
    [a push:_dotDotDot];

    XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
    NSUInteger offset = slashTok.offset;
    nodeTest.range = NSMakeRange(offset+2, 0);
    XPStep *step = [self stepWithStartOffset:offset maxOffset:NSNotFound axis:XPAxisDescendantOrSelf nodeTest:nodeTest filters:nil];
    [a push:step];
    [a push:_slash];
}


- (NSArray *)filtersFrom:(PKAssembly *)a {
    NSMutableArray *filters = nil;
    
    NSUInteger lastBracketMaxOffset = NSNotFound;
    
    id peek = [a pop];
    while ([peek isEqual:_closeBracket]) {
        XPExpression *f = [a pop];
        XPAssertExpr(f);
        
        if (!filters) {
            filters = [NSMutableArray arrayWithCapacity:2];
        }
        [filters insertObject:f atIndex:0];

        if (NSNotFound == lastBracketMaxOffset) {
            lastBracketMaxOffset = [(PKToken *)peek offset] + 1;
        }
        
        peek = [a pop];
    }
    [a push:peek];
    [a push:@(lastBracketMaxOffset)];
    
    return filters;
}


- (XPStep *)stepWithStartOffset:(NSUInteger)startOffset maxOffset:(NSUInteger)maxOffset axis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest filters:(NSArray *)filters {
    XPStep *step = [[[XPStep alloc] initWithAxis:axis nodeTest:nodeTest] autorelease];
    for (XPExpression *f in filters) {
        [step addFilter:f];
    }

    if (NSNotFound == maxOffset) {
        maxOffset = NSMaxRange(nodeTest.range);
    }

    step.range = NSMakeRange(startOffset, maxOffset - startOffset);
    XPAssert(NSNotFound != step.range.location);
    XPAssert(NSNotFound != step.range.length);
    XPAssert(step.range.length);
    return step;
}


- (void)parser:(PKParser *)p didMatchExplicitAxisStep:(PKAssembly *)a {
    
    NSArray *filters = [self filtersFrom:a];
    NSUInteger maxOffset = [[a pop] unsignedIntegerValue];

    XPNodeTest *nodeTest = [a pop];
    XPAssert([nodeTest isKindOfClass:[XPNodeTest class]]);
    
    PKToken *axisTok = [a pop];
    XPAssertToken(axisTok);
    
    XPAxis axis;
    if ([axisTok isEqual:_atAxis]) {
        axis = XPAxisAttribute;
    } else {
        axis = XPAxisForName(axisTok.stringValue);
    }
    
    if ([nodeTest isKindOfClass:[XPNameTest class]] && XPNodeTypePI != nodeTest.nodeType) {
        nodeTest.nodeType = XPAxisPrincipalNodeType[axis];
    }
    
    XPStep *step = [self stepWithStartOffset:axisTok.offset maxOffset:maxOffset axis:axis nodeTest:nodeTest filters:filters];
    [a push:step];
}


- (void)parser:(PKParser *)p didMatchImplicitAxisStep:(PKAssembly *)a {

    NSArray *filters = [self filtersFrom:a];
    NSUInteger maxOffset = [[a pop] unsignedIntegerValue];

    XPNodeTest *nodeTest = [a pop];
    XPAssert([nodeTest isKindOfClass:[XPNodeTest class]]);

    XPAxis axis = XPAxisChild;
    
    if ([nodeTest isKindOfClass:[XPNameTest class]] && XPNodeTypePI != nodeTest.nodeType) {
        nodeTest.nodeType = XPAxisPrincipalNodeType[axis];
    }

    XPStep *step = [self stepWithStartOffset:nodeTest.range.location maxOffset:maxOffset axis:axis nodeTest:nodeTest filters:filters];
    [a push:step];
}


- (void)parser:(PKParser *)p didMatchAbbreviatedStep:(PKAssembly *)a {
    PKToken *dotTok = [a pop];
    
    XPAxis axis;
    NSUInteger len;
    if ([dotTok.stringValue isEqualToString:@"."]) {
        axis = XPAxisSelf;
        len = 1;
    } else {
        XPAssert([dotTok.stringValue isEqualToString:@".."])
        axis = XPAxisParent;
        len = 2;
    }
    
    XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
    nodeTest.range = NSMakeRange(dotTok.offset, len);
    XPStep *step = [self stepWithStartOffset:dotTok.offset maxOffset:NSNotFound axis:axis nodeTest:nodeTest filters:nil];
    [a push:step];
}


- (void)parser:(PKParser *)p didMatchTypeTest:(PKAssembly *)a {
    PKToken *closeParenTok = [a pop];
    XPAssert([closeParenTok.stringValue isEqualToString:@")"]);
    
    PKToken *typeTok = [a pop];
    XPAssertToken(typeTok);
    XPAssert(_nodeTypeTab);
    XPNodeType type = [_nodeTypeTab[typeTok.stringValue] unsignedIntegerValue];
    XPAssert(XPNodeTypeNone != type);
    XPNodeTypeTest *typeTest = [[[XPNodeTypeTest alloc] initWithNodeType:type] autorelease];

    NSUInteger offset = typeTok.offset;
    typeTest.range = NSMakeRange(offset, (closeParenTok.offset+1) - offset);

    [a push:typeTest];
}


- (void)parser:(PKParser *)p didMatchSpecificPITest:(PKAssembly *)a {
    PKToken *closeParenTok = [a pop];
    XPAssert([closeParenTok.stringValue isEqualToString:@")"]);
    
    NSString *localName = [p popQuotedString];
    XPAssert([localName isKindOfClass:[NSString class]]);
    
    PKToken *typeTok = [a pop];
    XPAssert([typeTok.stringValue isEqualToString:@"processing-instruction"]);
    
    XPNameTest *nameTest = [[[XPNameTest alloc] initWithNamespaceURI:@"" localName:localName] autorelease];
    nameTest.nodeType = XPNodeTypePI;
    
    NSUInteger offset = typeTok.offset;
    nameTest.range = NSMakeRange(offset, (closeParenTok.offset+1) - offset);
    
    [a push:nameTest];
}


- (void)parser:(PKParser *)p didMatchNameTest:(PKAssembly *)a {
    PKToken *nameTok = [a pop];
    XPAssertToken(nameTok);
    
    NSString *localName = nameTok.stringValue;
    NSRange localRange = NSMakeRange(nameTok.offset, [localName length]);
    NSRange range = localRange;
    
    NSString *nsURI = @"";
    id peek = [a pop];
    if ([_colon isEqual:peek]) {
        PKToken *prefixTok = [a pop];
        XPAssertToken(prefixTok);
        NSString *prefix = prefixTok.stringValue;
        
        if ([prefix isEqualToString:@"*"]) {
            nsURI = prefix;
        } else {
            NSError *err = nil;
            nsURI = [_env namespaceURIForPrefix:prefix error:&err];
            if (err) {
                PKRecognitionException *rex = [[[PKRecognitionException alloc] init] autorelease];
                rex.range = NSMakeRange(prefixTok.offset, [prefix length]);
                rex.currentName = @"Missing XPath namespace";
                rex.currentReason = [err localizedFailureReason];
                [rex raise];
            }
        }
        
        NSRange prefixRange = NSMakeRange(prefixTok.offset, [prefixTok.stringValue length]);
        NSUInteger offset = prefixRange.location;
        range = NSMakeRange(offset, NSMaxRange(localRange) - offset);
    } else {
        [a push:peek];
    }
    XPNameTest *nameTest = [[[XPNameTest alloc] initWithNamespaceURI:nsURI localName:localName] autorelease];
    
    XPAssert(NSNotFound != range.location);
    XPAssert(NSNotFound != range.length);
    XPAssert(range.length);
    nameTest.range = range;
    [a push:nameTest];
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
    numExpr.range = NSMakeRange(offset, NSMaxRange(val.range) - offset);
    numExpr.staticContext = _env;
    [a push:numExpr];
}


- (void)parser:(PKParser *)p didMatchNumber:(PKAssembly *)a {
    PKToken *tok = [a pop];
    XPExpression *numExpr = [XPNumericValue numericValueWithNumber:tok.doubleValue];
    numExpr.range = NSMakeRange(tok.offset, [tok.stringValue length]);
    numExpr.staticContext = _env;
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
    strExpr.staticContext = _env;
    [a push:strExpr];
}

@end

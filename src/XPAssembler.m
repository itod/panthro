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

#import "XPUserFunction.h"
#import "XPCallable.h"
#import "XPFunctionCall.h"

#import "XPSequenceExpression.h"
#import "XPRangeExpression.h"

#import "XPFlworExpression.h"
#import "XPForClause.h"
#import "XPLetClause.h"
#import "XPGroupClause.h"
#import "XPOrderClause.h"

#import "XPSwitchExpression.h"
#import "XPCaseClause.h"

#import "XPQuantifiedExpression.h"
#import "XPIfExpression.h"
#import "XPEmptySequence.h"

#import "XPBooleanExpression.h"
#import "XPRelationalExpression.h"
#import "XPNodeComparisonExpression.h"
#import "XPArithmeticExpression.h"
#import "XPStringConcatExpression.h"
#import "XPSimpleMapExpression.h"

#import "XPAxisStep.h"
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

#define KEYWORD_ASCENDING @"ascending"
#define KEYWORD_DESCENDING @"descending"

@interface XPAssembler ()
@property (nonatomic, retain) id <XPStaticContext>env;
@property (nonatomic, retain) NSDictionary *nodeTypeTab;
@property (nonatomic, retain) PKToken *minus;
@property (nonatomic, retain) PKToken *openParen;
@property (nonatomic, retain) PKToken *comma;
@property (nonatomic, retain) PKToken *at;
@property (nonatomic, retain) PKToken *forTok;
@property (nonatomic, retain) PKToken *caseTok;
@property (nonatomic, retain) PKToken *let;
@property (nonatomic, retain) PKToken *where;
@property (nonatomic, retain) PKToken *group;
@property (nonatomic, retain) PKToken *eq;
@property (nonatomic, retain) PKToken *dollar;
@property (nonatomic, retain) PKToken *order;
@property (nonatomic, retain) PKToken *then;
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
        self.minus = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"-" doubleValue:0.0];
        self.openParen = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
        self.comma = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"," doubleValue:0.0];
        self.at = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"at" doubleValue:0.0];
        self.forTok = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"for" doubleValue:0.0];
        self.caseTok = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"case" doubleValue:0.0];
        self.let = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"let" doubleValue:0.0];
        self.where = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"where" doubleValue:0.0];
        self.group = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"group" doubleValue:0.0];
        self.eq = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@":=" doubleValue:0.0];
        self.dollar = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"$" doubleValue:0.0];
        self.order = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"order" doubleValue:0.0];
        self.then = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"then" doubleValue:0.0];
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
    self.minus = nil;
    self.openParen = nil;
    self.comma = nil;
    self.at = nil;
    self.forTok = nil;
    self.caseTok = nil;
    self.let = nil;
    self.where = nil;
    self.group = nil;
    self.eq = nil;
    self.dollar = nil;
    self.order = nil;
    self.then = nil;
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


- (XPAxis)defaultAxis {
    return _env.reversed ? XPAxisParent : XPAxisChild;
}


- (XPAxis)defaultRecursiveAxis {
    return _env.reversed ? XPAxisAncestorOrSelf : XPAxisDescendantOrSelf;
}


- (void)parser:(PKParser *)p didMatchVarDecl:(PKAssembly *)a {
    XPExpression *expr = [a pop];
    XPAssertExpr(expr);
    
    PKToken *varNameTok = [a pop];
    XPAssertToken(varNameTok);
    NSString *varName = varNameTok.stringValue;
    
    PKToken *dollarTok = [a pop];
    XPAssertToken(dollarTok);
    XPAssert([dollarTok isEqual:_dollar]);
    
    XPValue *val = [expr evaluateInContext:nil];
    NSUInteger offset = dollarTok.offset;
    val.range = NSMakeRange(offset, (varNameTok.offset + [varName length]) - offset);
    
    XPAssert(_env);
    [_env setItem:val forVariable:varName];
}


- (void)parser:(PKParser *)p didMatchFunctionDecl:(PKAssembly *)a {

    [a pop]; // discard '}'

    XPExpression *bodyExpr = [a pop];
    XPAssertExpr(bodyExpr);
    
    NSArray *paramToks = [a objectsAbove:_openParen];
    
    [a pop]; // discard '('
    
    PKToken *fnNameTok = [a pop];
    XPAssertToken(fnNameTok);
    NSString *fnName = fnNameTok.stringValue;
    
    XPUserFunction *fn = [[[XPUserFunction alloc] initWithName:fnName] autorelease];
    fn.bodyExpression = bodyExpr;
    
    for (PKToken *paramTok in [paramToks reverseObjectEnumerator]) {
        XPAssertToken(paramTok);
        NSString *paramName = paramTok.stringValue;
        [fn addParameter:paramName];
    }
    
    NSError *err = nil;
    XPAssert(_env);
    if (![_env defineUserFunction:fn error:&err]) {
        if (err) {
            PKRecognitionException *rex = [[[PKRecognitionException alloc] init] autorelease];
            rex.range = NSMakeRange(fnNameTok.offset, [fnName length]);
            rex.currentName = @"Unknown XPath function";
            rex.currentReason = [err localizedFailureReason];
            [rex raise];
        }
    }
}


- (void)parser:(PKParser *)p didMatchFunctionExpr:(PKAssembly *)a {
    
    PKToken *closeCurly = [a pop];
    XPAssertToken(closeCurly);
    XPAssert([closeCurly.stringValue isEqualToString:@"}"]);
    
    XPExpression *bodyExpr = [a pop];
    XPAssertExpr(bodyExpr);
    
    NSArray *paramToks = [a objectsAbove:_openParen];
    
    [a pop]; // discard '('
    
    XPUserFunction *fn = [[[XPUserFunction alloc] initWithName:nil] autorelease];
    fn.bodyExpression = bodyExpr;
    
    for (PKToken *paramTok in [paramToks reverseObjectEnumerator]) {
        XPAssertToken(paramTok);
        NSString *paramName = paramTok.stringValue;
        [fn addParameter:paramName];
    }
    
    PKToken *funcTok = [a pop];
    XPAssertToken(funcTok);

    NSUInteger offset = funcTok.offset;
    
    fn.range = NSMakeRange(offset, (closeCurly.offset + [closeCurly.stringValue length]) - offset);
    [a push:fn];
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
    
    NSUInteger offset = NSNotFound;

    NSMutableArray *forClauses = [NSMutableArray array];
    NSMutableArray *orderClauses = [NSMutableArray array];
    
    XPExpression *whereExpr = nil;
    id peek = [a pop];
    do {
        NSMutableArray *letClauses = nil;
        NSMutableArray *groupClauses = nil;

        while (peek == _order) {

            NSComparisonResult mod = NSOrderedAscending;
            peek = [a pop];
            if ([peek isKindOfClass:[PKToken class]]) {
                XPAssert([[peek stringValue] isEqualToString:KEYWORD_ASCENDING] || [[peek stringValue] isEqualToString:KEYWORD_DESCENDING]);
                if ([[peek stringValue] isEqualToString:KEYWORD_DESCENDING]) {
                    mod = NSOrderedDescending;
                }
                peek = [a pop];
            }
            
            XPExpression *orderExpr = peek;
            XPAssertExpr(orderExpr);
            
            XPOrderClause *orderClause = [XPOrderClause orderClauseExpression:orderExpr modifier:mod];
            [orderClauses insertObject:orderClause atIndex:0];
            
            peek = [a pop];
        }
        
        if (peek == _where) {
            whereExpr = [a pop];
            XPAssertExpr(whereExpr);
            peek = [a pop];
        }
        
        if (peek == _group) {
            groupClauses = [NSMutableArray array];
            
            do {
                id groupExpr = [a pop];
                PKToken *groupVarTok = nil;

                peek = [a pop];
                if ([peek isEqual:_eq]) {
                    groupVarTok = [a pop];
                    peek = [a pop];
                } else {
                    groupVarTok = groupExpr;
                    groupExpr = nil;
                }
                
                NSAssert(!groupExpr || [groupExpr isKindOfClass:[XPExpression class]], @"");
                XPAssertToken(groupVarTok);
                
                XPGroupClause *groupClause = [XPGroupClause groupClauseWithVariableName:groupVarTok.stringValue expression:groupExpr];
                [groupClauses insertObject:groupClause atIndex:0];
                
            } while (peek == _group);
        }

        if (peek == _let) {
            letClauses = [NSMutableArray array];
            
            do {
                XPExpression *letExpr = [a pop];
                XPAssertExpr(letExpr);
                PKToken *letVarNameTok = [a pop];
                XPAssertToken(letVarNameTok);
                
                XPLetClause *letClause = [XPLetClause letClauseWithVariableName:letVarNameTok.stringValue expression:letExpr];
                [letClauses insertObject:letClause atIndex:0];

                peek = [a pop];
            } while (peek == _let);
            
            // discard 'let'
            XPAssert([peek isEqual:_let]);
            offset = [peek offset];
            
            peek = [a pop];
        }
        
        XPForClause *forClause = nil;
        
        if (peek == _forTok) {
            peek = [a pop];
            
            XPExpression *collExpr = peek;
            XPAssertExpr(collExpr);
            
            PKToken *posNameTok = nil;
            PKToken *varNameTok = nil;
            
            peek = [a pop];
            if (peek == _at) {
                posNameTok = [a pop];
                varNameTok = [a pop];
                XPAssertToken(posNameTok);
            } else {
                varNameTok = peek;
            }
            XPAssertToken(varNameTok);
            
            forClause = [XPForClause forClauseWithVariableName:varNameTok.stringValue positionName:posNameTok.stringValue expression:collExpr];
            peek = [a pop];
        } else {
            forClause = [XPForClause emptyForClause];
        }
        
        // discard 'for'
        if (peek != _forTok && [peek isEqual:_forTok]) {
            offset = [peek offset];
            peek = [a pop];
        }

        XPAssert(forClause);
        forClause.letClauses = letClauses;
        [forClauses insertObject:forClause atIndex:0];
        
    } while (peek == _forTok || peek == _let);
    
    [a push:peek];
    
    XPExpression *forExpr = [[[XPFlworExpression alloc] initWithForClauses:forClauses
                                                                     where:whereExpr
                                                              groupClauses:nil
                                                              orderClauses:orderClauses
                                                                      body:bodyExpr] autorelease];
    
    forExpr.range = NSMakeRange(offset, NSMaxRange(bodyExpr.range) - offset);
    forExpr.staticContext = _env;
    [a push:forExpr];
}


- (void)parser:(PKParser *)p didMatchPositionalVar:(PKAssembly *)a { [a push:_at]; }
- (void)parser:(PKParser *)p didMatchSingleForClause:(PKAssembly *)a { [a push:_forTok]; }
- (void)parser:(PKParser *)p didMatchSingleLetClause:(PKAssembly *)a { [a push:_let]; }
- (void)parser:(PKParser *)p didMatchWhereClause:(PKAssembly *)a { [a push:_where]; }
- (void)parser:(PKParser *)p didMatchSingleGroupClause:(PKAssembly *)a { [a push:_group]; }
- (void)parser:(PKParser *)p didMatchOrderSpec:(PKAssembly *)a { [a push:_order]; }


- (void)parser:(PKParser *)p didMatchQuantifiedExpr:(PKAssembly *)a {
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
    
    // discard 'some'|'every'
    XPAssert([peek.stringValue isEqualToString:@"some"] || [peek.stringValue isEqualToString:@"every"]);
    NSUInteger offset = peek.offset;
    
    BOOL isEvery = [peek.stringValue isEqualToString:@"every"];
    XPExpression *forExpr = [[[XPQuantifiedExpression alloc] initWithEvery:isEvery varNames:varNames sequences:sequences body:bodyExpr] autorelease];
    forExpr.range = NSMakeRange(offset, NSMaxRange(bodyExpr.range) - offset);
    forExpr.staticContext = _env;
    [a push:forExpr];
}


- (void)parser:(PKParser *)p didMatchIfExpr:(PKAssembly *)a {
    XPExpression *lastExpr = [a pop];
    XPAssertExpr(lastExpr);

    XPExpression *thenExpr = nil;
    XPExpression *elseExpr = nil;

    PKToken *peek = [a pop];
    XPAssert([peek.stringValue isEqualToString:@"then"] || [peek.stringValue isEqualToString:@"else"]);
    if ([peek isEqual:_then]) {
        thenExpr = lastExpr;
    } else {
        elseExpr = lastExpr;
        thenExpr = [a pop];
        XPAssertExpr(thenExpr);
        [a pop]; // discard 'then'
    }
    
    XPExpression *testExpr = [a pop];
    XPAssertExpr(testExpr);
    
    peek = [a pop];
    XPAssert([peek.stringValue isEqualToString:@"if"]);

    NSUInteger offset = peek.offset;
    
    XPExpression *ifExpr = [[[XPIfExpression alloc] initWithTest:testExpr then:thenExpr else:elseExpr] autorelease];
    ifExpr.range = NSMakeRange(offset, NSMaxRange(lastExpr.range) - offset);
    ifExpr.staticContext = _env;
    [a push:ifExpr];
}


- (void)parser:(PKParser *)p didMatchSwitchCaseOperand:(PKAssembly *)a {
    [a push:_caseTok];
}


- (void)parser:(PKParser *)p didMatchSwitchCaseClause:(PKAssembly *)a {
    XPExpression *bodyExpr = [a pop];
    XPAssertExpr(bodyExpr);
    
    id peek = [a pop];
    XPAssertToken(peek);
    
    BOOL copyBody = NO;
    NSMutableArray *caseClauses = [NSMutableArray array];
    
    do {
        XPAssert([_caseTok isEqual:peek]);

        XPExpression *testExpr = [a pop];
        XPAssertExpr(testExpr);
    
        bodyExpr = copyBody ? [[bodyExpr copy] autorelease] : bodyExpr;
        XPCaseClause *caseClause = [[[XPCaseClause alloc] initWithTest:testExpr body:bodyExpr] autorelease];
    
        [caseClauses addObject:caseClause];

        peek = [a pop];
        copyBody = YES;
    } while ([_caseTok isEqual:peek]);

    [a push:peek];
    
    for (XPCaseClause *caseClause in [caseClauses reverseObjectEnumerator]) {
        [a push:caseClause];
    }
}


- (void)parser:(PKParser *)p didMatchSwitchExpr:(PKAssembly *)a {
    XPExpression *defaultExpr = [a pop];
    XPAssertExpr(defaultExpr);

    id peek = [a pop];
    
    NSMutableArray *caseClauses = [NSMutableArray array];
    while ([peek isKindOfClass:[XPCaseClause class]]) {
        [caseClauses addObject:peek];
        peek = [a pop];
    }
    
    XPExpression *testExpr = peek;
    XPAssertExpr(testExpr);
    
    XPSwitchExpression *switchExpr = [[[XPSwitchExpression alloc] initWithTest:testExpr defaultExpression:defaultExpr caseClauses:caseClauses] autorelease];
    [a push:switchExpr];
}


- (void)parser:(PKParser *)p didMatchOrAndExpr:(PKAssembly *)a { [self parser:p didMatchAnyBooleanExpr:a]; }
- (void)parser:(PKParser *)p didMatchAndStringConcatExpr:(PKAssembly *)a { [self parser:p didMatchAnyBooleanExpr:a]; }

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


- (void)parser:(PKParser *)p didMatchConcatRangeExpr:(PKAssembly *)a {
    XPExpression *p2 = [a pop];
    XPExpression *p1 = [a pop];
    
    XPAssertExpr(p1);
    XPAssertExpr(p2);
    
    XPExpression *concatExpr = [XPStringConcatExpression stringConcatExpressionWithOperand:p1 operator:0 operand:p2];
    concatExpr.range = NSMakeRange(p1.range.location, NSMaxRange(p2.range) - p1.range.location);
    concatExpr.staticContext = _env;
    [a push:concatExpr];
}


- (void)parser:(PKParser *)p didMatchBangPathExpr:(PKAssembly *)a {
    XPExpression *p2 = [a pop];
    XPExpression *p1 = [a pop];
    
    XPAssertExpr(p1);
    XPAssertExpr(p2);
    
    XPSimpleMapExpression *mapExpr = [XPSimpleMapExpression simpleMapExpressionWithOperand:p1 operator:0 operand:p2];
    mapExpr.range = NSMakeRange(p1.range.location, NSMaxRange(p2.range) - p1.range.location);
    mapExpr.staticContext = _env;
    [a push:mapExpr];
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
    
    Class cls = nil;

    if ([@"=" isEqualToString:opStr] || [@"eq" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_EQUALS;
        cls = [XPRelationalExpression class];
    } else if ([@"!=" isEqualToString:opStr] || [@"ne" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_NOT_EQUAL;
        cls = [XPRelationalExpression class];
    } else if ([@"<" isEqualToString:opStr] || [@"lt" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_LT_SYM;
        cls = [XPRelationalExpression class];
    } else if ([@">" isEqualToString:opStr] || [@"gt" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_GT_SYM;
        cls = [XPRelationalExpression class];
    } else if ([@"<=" isEqualToString:opStr] || [@"le" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_LE_SYM;
        cls = [XPRelationalExpression class];
    } else if ([@">=" isEqualToString:opStr] || [@"ge" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_GE_SYM;
        cls = [XPRelationalExpression class];
    } else if ([@"is" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_IS;
        cls = [XPNodeComparisonExpression class];
    } else if ([@"<<" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_SHIFT_LEFT;
        cls = [XPNodeComparisonExpression class];
    } else if ([@">>" isEqualToString:opStr]) {
        op = XPEG_TOKEN_KIND_SHIFT_RIGHT;
        cls = [XPNodeComparisonExpression class];
    } else {
        XPAssert(0);
    }
    
    XPAssert(cls);
    XPExpression *relExpr = [cls relationalExpressionWithOperand:p1 operator:op operand:p2];
    relExpr.range = NSMakeRange(p1.range.location, NSMaxRange(p2.range) - p1.range.location);
    relExpr.staticContext = _env;
    [a push:relExpr];
}


- (void)parser:(PKParser *)p didMatchPlusMultiExpr:(PKAssembly *)a { [self parser:p didMatchAnyArithmeticExpr:a operator:XPEG_TOKEN_KIND_PLUS]; }
- (void)parser:(PKParser *)p didMatchMinusMultiExpr:(PKAssembly *)a { [self parser:p didMatchAnyArithmeticExpr:a operator:XPEG_TOKEN_KIND_MINUS]; }
- (void)parser:(PKParser *)p didMatchTimesUnionExpr:(PKAssembly *)a { [self parser:p didMatchAnyArithmeticExpr:a operator:XPEG_TOKEN_KIND_TIMES]; }
- (void)parser:(PKParser *)p didMatchDivUnionExpr:(PKAssembly *)a { [self parser:p didMatchAnyArithmeticExpr:a operator:XPEG_TOKEN_KIND_DIVIDE]; }
- (void)parser:(PKParser *)p didMatchModUnionExpr:(PKAssembly *)a { [self parser:p didMatchAnyArithmeticExpr:a operator:XPEG_TOKEN_KIND_MODULO]; }

- (void)parser:(PKParser *)p didMatchAnyArithmeticExpr:(PKAssembly *)a operator:(NSUInteger)op {
    XPValue *p2 = [a pop];
    XPValue *p1 = [a pop];
    
    XPAssertExpr(p1);
    XPAssertExpr(p2);

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


- (void)parser:(PKParser *)p didMatchStaticFunctionCall:(PKAssembly *)a {
    PKToken *closeParenTok = [a pop];
    XPAssert([closeParenTok.stringValue isEqualToString:@")"]);
    
    NSArray *args = [a objectsAbove:_openParen];
    [a pop]; // '('
    
    PKToken *nameTok = [a pop];
    XPAssertToken(nameTok);
    NSString *name = nameTok.stringValue;
    
    XPAssert(_env);
    NSError *err = nil;
    XPExpression <XPCallable>*fn = [_env makeSystemFunction:name error:&err];
    if (!fn) {
        fn = [[[XPFunctionCall alloc] initWithName:name] autorelease];
    }
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
        [(id <XPCallable>)fn addArgument:arg];
    }
    
    NSUInteger offset = nameTok.offset;
    fn.range = NSMakeRange(offset, (closeParenTok.offset+1) - offset);
    fn.staticContext = _env;
    [a push:fn];
}


- (void)parser:(PKParser *)p didMatchVariableFunctionCall:(PKAssembly *)a {
    [self parser:p didMatchAnonFunctionCall:a];
}


- (void)parser:(PKParser *)p didMatchAnonFunctionCall:(PKAssembly *)a {
    PKToken *closeParenTok = [a pop];
    XPAssert([closeParenTok.stringValue isEqualToString:@")"]);
    
    NSArray *args = [a objectsAbove:_openParen];
    [a pop]; // '('
    
    XPExpression *expr = [a pop];
    XPAssertExpr(expr);
    
    XPExpression <XPCallable>*fn = [[[XPFunctionCall alloc] initWithExpression:expr] autorelease];
    
    for (id arg in [args reverseObjectEnumerator]) {
        [(id <XPCallable>)fn addArgument:arg];
    }
    
    NSUInteger offset = expr.range.location;
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


- (void)parser:(PKParser *)p didMatchSimpleFilterExpr:(PKAssembly *)a {
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
        XPAxisStep *step = nil;
        if ([_slash isEqual:part]) {
            continue;
        } else if ([_doubleSlash isEqual:part]) {
            XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
            NSUInteger offset = [part offset];
            nodeTest.range = NSMakeRange(offset+2, 0);
            XPAxis axis = _env.reversed ? XPAxisAncestorOrSelf : XPAxisDescendantOrSelf;
            step = [self stepWithStartOffset:offset maxOffset:NSNotFound axis:axis nodeTest:nodeTest filters:nil];
        } else {
            XPAssertExpr(part);
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
    
    XPAxisStep *step = (id)obj;
    XPAssert([step isKindOfClass:[XPAxisStep class]]);
    
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
    XPAxisStep *step = [self stepWithStartOffset:offset maxOffset:NSNotFound axis:XPAxisDescendantOrSelf nodeTest:nodeTest filters:nil];
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


- (XPAxisStep *)stepWithStartOffset:(NSUInteger)startOffset maxOffset:(NSUInteger)maxOffset axis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest filters:(NSArray *)filters {
    XPAxisStep *step = [[[XPAxisStep alloc] initWithAxis:axis nodeTest:nodeTest] autorelease];
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

    step.baseRange = NSMakeRange(startOffset, NSMaxRange(nodeTest.range) - startOffset);
    XPAssert(NSNotFound != step.baseRange.location);
    XPAssert(NSNotFound != step.baseRange.length);
    XPAssert(step.baseRange.length);
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
    
    XPAxisStep *step = [self stepWithStartOffset:axisTok.offset maxOffset:maxOffset axis:axis nodeTest:nodeTest filters:filters];
    [a push:step];
}


- (void)parser:(PKParser *)p didMatchImplicitAxisStep:(PKAssembly *)a {

    NSArray *filters = [self filtersFrom:a];
    NSUInteger maxOffset = [[a pop] unsignedIntegerValue];

    XPNodeTest *nodeTest = [a pop];
    XPAssert([nodeTest isKindOfClass:[XPNodeTest class]]);

    XPAxis axis = self.defaultAxis;
    
    if ([nodeTest isKindOfClass:[XPNameTest class]] && XPNodeTypePI != nodeTest.nodeType) {
        nodeTest.nodeType = XPAxisPrincipalNodeType[axis];
    }

    XPAxisStep *step = [self stepWithStartOffset:nodeTest.range.location maxOffset:maxOffset axis:axis nodeTest:nodeTest filters:filters];
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
        XPAssert([dotTok.stringValue isEqualToString:@".."]);
        axis = _env.reversed ? XPAxisChild : XPAxisParent;
        len = 2;
    }
    
    XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
    nodeTest.range = NSMakeRange(dotTok.offset, len);
    XPAxisStep *step = [self stepWithStartOffset:dotTok.offset maxOffset:NSNotFound axis:axis nodeTest:nodeTest filters:nil];
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


- (void)parser:(PKParser *)p didMatchPrefixedUnaryExpr:(PKAssembly *)a {
    XPValue *val = [a pop];
    id tok = [a pop];

    BOOL isNegative = NO;
    NSUInteger offset = NSNotFound;
    while ([tok isEqual:_minus]) {
        XPAssertToken(tok);
        XPAssert([[tok stringValue] isEqualToString:@"-"]);
        offset = [tok offset];
        isNegative = !isNegative;
        tok = [a pop];
    }
    
    [a push:tok]; // put that last one back, fool
    
    if (NSNotFound == offset) {
        [a push:val];
    } else {
        double d = [val asNumber];
        if (isNegative) d = -d;
        
        XPExpression *numExpr = [XPNumericValue numericValueWithNumber:d];
        XPAssert(NSNotFound != offset);
        numExpr.range = NSMakeRange(offset, NSMaxRange(val.range) - offset);
        numExpr.staticContext = _env;
        [a push:numExpr];
    }
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

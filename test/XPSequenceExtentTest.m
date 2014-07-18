//
//  XPSequenceExtentTest
//  Panthro
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPTestScaffold.h"
#import "XPNodeTypeTest.h"
#import "XPLibxmlDocumentImpl.h"
#import "XPLibxmlNodeImpl.h"
#import "XPPathExpression.h"
#import "XPNodeInfo.h"
#import "XPItem.h"
#import "XPStandaloneContext.h"

#import <libxml/tree.h>

@interface XPSequenceExtentTest : XCTestCase
@property (nonatomic, retain) XPStandaloneContext *env;
@property (nonatomic, assign) xmlNodePtr contextNode;
@property (nonatomic, assign) xmlParserCtxtPtr parserCtx;
@property (nonatomic, retain) XPSequenceValue *res;
@property (nonatomic, retain) NSArray *ids;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSArray *paras;
@property (nonatomic, retain) NSArray *comments;
@property (nonatomic, retain) NSArray *pis;
@end

@implementation XPSequenceExtentTest

- (void)setUp {
    [super setUp];
    
    self.ids = @[@"c1", @"c2", @"c3"];
    self.titles = @[@"Chapter 1", @"Chapter 2", @"Chapter 3"];
    self.paras = @[@"Chapter 1 content. ", @"Chapter 2 content.", @"Chapter 3 content."];
    self.comments = @[@" some comment  text "];
    self.pis = @[@"bar='baz'"];
    
    //NSString *str = XPContentsOfFile(@"book.xml");
    NSString *path = XPPathOfFile(@"book.xml");
    
    
    self.parserCtx = xmlNewParserCtxt();
    
    xmlLineNumbersDefault(1);
    
    int record_info = 1;
    xmlSetFeature(_parserCtx, "gather line info", &record_info);
    //    int validate = 1;
    //    xmlSetFeature(_parserCtx, "validate", &validate);
    //XML_PARSE_DTDVALID
    xmlDocPtr doc = xmlCtxtReadFile(_parserCtx, [path UTF8String], NULL, XML_PARSE_NOENT);
    //xmlDocPtr doc = xmlCtxtReadMemory(_parserCtx, [str UTF8String], [str length], NULL, "utf-8", XML_PARSE_NOENT|);
    TDTrue(NULL != doc);
    
    //
    // NOTE: the <book> outermost element is the context node in all tests!!!
    //
    
    xmlNodePtr docEl = xmlFirstElementChild((void *)doc);
    TDTrue(NULL != docEl);
    TDTrue(0 == strcmp((char *)docEl->name, "book"));
    
    self.env = [XPStandaloneContext standaloneContext];
    [_env setItem:[XPStringValue stringValueWithString:@"hello"] forVariable:@"foo"];
    [_env setItem:[XPStringValue stringValueWithString:@"bye"] forVariable:@"bar"];
    
    self.contextNode = docEl;
}


- (void)eval:(NSString *)xpathStr {
    TDNotNil(_env);
    NSError *err = nil;
    
    id <XPNodeInfo>ctxNode = [XPLibxmlNodeImpl nodeInfoWithNode:_contextNode parserContext:_parserCtx];
    self.res = [_env execute:xpathStr withContextNode:ctxNode error:&err];
    if (err) {
        NSLog(@"%@", err);
    }
    //TDNil(err);
    TDNotNil(_res);
}


- (void)tearDown {
    self.ids = nil;
    self.titles = nil;
    self.paras = nil;
    self.comments = nil;
    self.pis = nil;
    [super tearDown];
}


- (void)testOpen1Comma2Close {
    [self eval:@"(1, 2)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpen1Comma2ClosePredicate1 {
    [self eval:@"(1, 2)[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpen1Comma2ClosePredicate2 {
    [self eval:@"(1, 2)[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpen1Comma2Comma3Close {
    [self eval:@"(1, 2, 3)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpen1Comma2Comma3ClosePredicate2{
    [self eval:@"(1, 2, 3)[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenChapterCommaChapterSlashTitleClose {
    [self eval:@"(chapter, chapter/title)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenChapterCommaChapterClose {
    [self eval:@"(chapter, chapter)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testRange1to3 {
    [self eval:@"1 to 3"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenClose {
    [self eval:@"()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenCloseEqOpenClose {
    [self eval:@"()=()"];
    
    BOOL yn = [_res asBoolean];
    TDFalse(yn);
}


- (void)testOpenCloseNeOpenClose {
    [self eval:@"()!=()"];
    
    BOOL yn = [_res asBoolean];
    TDFalse(yn);
}


- (void)testForXInOpen1Comma2Comma3CloseReturnX {
    [self eval:@"for $x in (1, 2, 3) return $x"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testForXInOpen1Comma2Comma3CloseORderByXAscendingReturnX {
    [self eval:@"for $x in (2, 1, 3) order by $x ascending return $x"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testForXInOpen1Comma2Comma3CloseORderByXDescendingReturnX {
    [self eval:@"for $x in (2, 1, 3) order by $x descending return $x"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testLetXEqOpen1Comma2Comma3CloseReturnX {
    [self eval:@"let $x := (1, 2, 3) return $x"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testForXInOpen1Comma2Comma3CloseLetYEqXTimesXReturnX {
    [self eval:@"for $x in (1, 2, 3) let $y := $x*$x return $y"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"4", val.stringValue);
    TDEquals(4.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"9", val.stringValue);
    TDEquals(9.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testForXInOpen1Comma2Comma3CloseWhereXGt1ReturnX {
    [self eval:@"for $x in (1, 2, 3) where $x > 1 return $x"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testForXAtIInOpen1Comma2Comma3CloseReturnOpenXCommaIClose {
    [self eval:@"for $x at $i in ('a', 'b', 'c') return ($x, $i)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"a", val.stringValue);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);

    val = (id)[enm nextItem];
    TDEqualObjects(@"b", val.stringValue);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"c", val.stringValue);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    TDFalse([enm hasMoreItems]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testForXInOpen1Comma2CloseCommaYInOpen3Comma4CloseReturnOpenXCommaYClose {
    [self eval:@"for $x in (1, 2), $y in (3, 4) return ($x, $y)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"4", val.stringValue);
    TDEquals(4.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"4", val.stringValue);
    TDEquals(4.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testForXInOpen1Comma2CloseCommaLetAEqXYInOpen3Comma4CloseLetBEqYReturnOpenXCommaYClose {
    [self eval:@"for $x in (1, 2) let $a := $x for $y in (3, 4) let $b := $y return ($a, $b)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"4", val.stringValue);
    TDEquals(4.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"4", val.stringValue);
    TDEquals(4.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testForXInOpen1Comma2CloseCommaLetAEqXYInOpen3Comma4CloseLetBEqYWhereAGt1ReturnOpenACommaBClose {
    [self eval:@"for $x in (1, 2) let $a := $x for $y in (3, 4) let $b := $y where $a > 1 return ($a, $b)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"4", val.stringValue);
    TDEquals(4.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testForXInOpen1Comma2CloseCommaLetAEqXYInOpen3Comma4CloseLetBEqYWhereAGt1ReturnForFooInOpenACommaBCloseReturnB {
    [self eval:@"for $x in (1, 2) let $a := $x for $y in (3, 4) let $b := $y where $a > 1 return for $foo in ($a, $b) return $b"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"4", val.stringValue);
    TDEquals(4.0, [val asNumber]);
    
    val = (id)[enm nextItem];
    TDEqualObjects(@"4", val.stringValue);
    TDEquals(4.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testEveryNInChapterSatisfiesNSlashTitle {
    [self eval:@"every $n in chapter satisfies $n/title"];
    
    BOOL yn = [_res asBoolean];
    TDTrue(yn);
}


- (void)testSomeXInOpen1Comma2Comma3CloseSatisfiesXEq2 {
    [self eval:@"some $x in (1, 2, 3) satisfies $x = 2"];
    
    BOOL yn = [_res asBoolean];
    TDTrue(yn);
}


- (void)testSomeXInOpen1Comma2Comma3CloseSatisfiesXEq0 {
    [self eval:@"some $x in (1, 2, 3) satisfies $x = 0"];
    
    BOOL yn = [_res asBoolean];
    TDFalse(yn);
}


- (void)testEveryXInOpen2Comma2Comma2CloseSatisfiesXEq2 {
    [self eval:@"every $x in (2, 2, 2) satisfies $x = 2"];
    
    BOOL yn = [_res asBoolean];
    TDTrue(yn);
}


- (void)testEveryXInOpen1Comma2Comma3CloseSatisfiesXEq0 {
    [self eval:@"every $x in (1, 2, 3) satisfies $x = 0"];
    
    BOOL yn = [_res asBoolean];
    TDFalse(yn);
}


- (void)testEveryXInOpen0Comma0Comma0CloseSatisfiesXEq0 {
    [self eval:@"every $x in (0, 0, 0) satisfies $x = 0"];
    
    BOOL yn = [_res asBoolean];
    TDTrue(yn);
}


- (void)testEveryXInOpen1Comma2Comma3CloseSatisfiesXEq2 {
    [self eval:@"every $x in (1, 2, 3) satisfies $x = 2"];
    
    BOOL yn = [_res asBoolean];
    TDFalse(yn);
}


- (void)testIfOpenTrueCloseThen1Else2 {
    [self eval:@"if (true()) then 1 else 2"];
    
    double d = [_res asNumber];
    TDEquals(1.0, d);
}


- (void)testIfOpenFalseCloseThen1Else2 {
    [self eval:@"if (false()) then 1 else 2"];
    
    double d = [_res asNumber];
    TDEquals(2.0, d);
}


- (void)testIfOpenEveryXInOpen0Comma0Comma0CloseSatisfiesXEq0CloseThen1Else2 {
    [self eval:@"if (every $x in (0, 0, 0) satisfies $x = 0) then 1 else 2"];
    
    double d = [_res asNumber];
    TDEquals(1.0, d);
}


- (void)testIfOpenEveryXInOpen0Comma0Comma0CloseSatisfiesXEq2CloseThen1Else2 {
    [self eval:@"if (every $x in (0, 0, 0) satisfies $x = 2) then 1 else 2"];
    
    double d = [_res asNumber];
    TDEquals(2.0, d);
}


- (void)testIfOpenSomeFooInOpen1CloseSatisfiesFooEq1CloseThenFooElseBar {
    [self eval:@"if (some $foo in (1) satisfies $foo = 1) then $foo else $bar"];
    
    NSString *s = [_res asString];
    TDEqualObjects(@"hello", s);
}


- (void)testChapterPredicate1IsChapterPredicate1 {
    [self eval:@"chapter[1] is chapter[1]"];
    
    BOOL yn = [_res asBoolean];
    TDTrue(yn);
}


- (void)testChapterPredicate1IsChapterPredicate2 {
    [self eval:@"chapter[1] is chapter[2]"];
    
    BOOL yn = [_res asBoolean];
    TDFalse(yn);
}


- (void)testChapterPredicate1ShiftLeftChapterPredicate1 {
    [self eval:@"chapter[1] << chapter[1]"];
    
    BOOL yn = [_res asBoolean];
    TDFalse(yn);
}


- (void)testChapterPredicate1ShiftRightChapterPredicate1 {
    [self eval:@"chapter[1] >> chapter[1]"];
    
    BOOL yn = [_res asBoolean];
    TDFalse(yn);
}


- (void)testChapterPredicate1ShiftLeftChapterPredicate2 {
    [self eval:@"chapter[1] << chapter[2]"];
    
    BOOL yn = [_res asBoolean];
    TDTrue(yn);
}


- (void)testChapterPredicate1ShiftRightChapterPredicate2 {
    [self eval:@"chapter[1] >> chapter[2]"];
    
    BOOL yn = [_res asBoolean];
    TDFalse(yn);
}


- (void)testChapterPredicate2ShiftLeftChapterPredicate1 {
    [self eval:@"chapter[2] << chapter[1]"];
    
    BOOL yn = [_res asBoolean];
    TDFalse(yn);
}


- (void)testChapterPredicate2ShiftRightChapterPredicate1 {
    [self eval:@"chapter[2] >> chapter[1]"];
    
    BOOL yn = [_res asBoolean];
    TDTrue(yn);
}

@end

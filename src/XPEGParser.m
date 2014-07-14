#import "XPEGParser.h"
#import <PEGKit/PEGKit.h>


@interface XPEGParser ()

@property (nonatomic, retain) NSMutableDictionary *xpath_memo;
@property (nonatomic, retain) NSMutableDictionary *prologue_memo;
@property (nonatomic, retain) NSMutableDictionary *varDecl_memo;
@property (nonatomic, retain) NSMutableDictionary *functionDecl_memo;
@property (nonatomic, retain) NSMutableDictionary *paramList_memo;
@property (nonatomic, retain) NSMutableDictionary *enclosedExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *exprSingleTail_memo;
@property (nonatomic, retain) NSMutableDictionary *exprSingle_memo;
@property (nonatomic, retain) NSMutableDictionary *forExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *forClause_memo;
@property (nonatomic, retain) NSMutableDictionary *singleForClause_memo;
@property (nonatomic, retain) NSMutableDictionary *positionalVar_memo;
@property (nonatomic, retain) NSMutableDictionary *letClause_memo;
@property (nonatomic, retain) NSMutableDictionary *singleLetClause_memo;
@property (nonatomic, retain) NSMutableDictionary *whereClause_memo;
@property (nonatomic, retain) NSMutableDictionary *groupClause_memo;
@property (nonatomic, retain) NSMutableDictionary *singleGroupClause_memo;
@property (nonatomic, retain) NSMutableDictionary *orderByClause_memo;
@property (nonatomic, retain) NSMutableDictionary *orderSpecList_memo;
@property (nonatomic, retain) NSMutableDictionary *orderSpec_memo;
@property (nonatomic, retain) NSMutableDictionary *orderModifier_memo;
@property (nonatomic, retain) NSMutableDictionary *quantifiedExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *inClause_memo;
@property (nonatomic, retain) NSMutableDictionary *singleInClause_memo;
@property (nonatomic, retain) NSMutableDictionary *ifExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *orExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *orAndExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *andExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *andRangeExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *rangeExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *toEqualityExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *equalityExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *eqRelationalExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *relationalExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *compareAdditiveExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *additiveExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *plusOrMinusMultiExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *multiplicativeExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *multDivOrModUnaryExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *multiplyOperator_memo;
@property (nonatomic, retain) NSMutableDictionary *unaryExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *minusUnionExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *unionExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *unionTail_memo;
@property (nonatomic, retain) NSMutableDictionary *intersectExceptExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *intersectExceptTail_memo;
@property (nonatomic, retain) NSMutableDictionary *pathExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *filterPath_memo;
@property (nonatomic, retain) NSMutableDictionary *complexFilterPath_memo;
@property (nonatomic, retain) NSMutableDictionary *complexFilterPathStartExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *locationPath_memo;
@property (nonatomic, retain) NSMutableDictionary *relativeLocationPath_memo;
@property (nonatomic, retain) NSMutableDictionary *pathBody_memo;
@property (nonatomic, retain) NSMutableDictionary *pathTail_memo;
@property (nonatomic, retain) NSMutableDictionary *slashStep_memo;
@property (nonatomic, retain) NSMutableDictionary *absoluteLocationPath_memo;
@property (nonatomic, retain) NSMutableDictionary *abbreviatedAbsoluteLocationPath_memo;
@property (nonatomic, retain) NSMutableDictionary *rootSlash_memo;
@property (nonatomic, retain) NSMutableDictionary *rootDoubleSlash_memo;
@property (nonatomic, retain) NSMutableDictionary *firstRelativeStep_memo;
@property (nonatomic, retain) NSMutableDictionary *filterExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *primaryExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *variableReference_memo;
@property (nonatomic, retain) NSMutableDictionary *literal_memo;
@property (nonatomic, retain) NSMutableDictionary *number_memo;
@property (nonatomic, retain) NSMutableDictionary *parenthesizedExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *functionCall_memo;
@property (nonatomic, retain) NSMutableDictionary *actualFunctionCall_memo;
@property (nonatomic, retain) NSMutableDictionary *argList_memo;
@property (nonatomic, retain) NSMutableDictionary *booleanLiteralFunctionCall_memo;
@property (nonatomic, retain) NSMutableDictionary *functionName_memo;
@property (nonatomic, retain) NSMutableDictionary *booleanLiteral_memo;
@property (nonatomic, retain) NSMutableDictionary *qName_memo;
@property (nonatomic, retain) NSMutableDictionary *prefix_memo;
@property (nonatomic, retain) NSMutableDictionary *localPart_memo;
@property (nonatomic, retain) NSMutableDictionary *ncName_memo;
@property (nonatomic, retain) NSMutableDictionary *argument_memo;
@property (nonatomic, retain) NSMutableDictionary *predicate_memo;
@property (nonatomic, retain) NSMutableDictionary *predicateExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *step_memo;
@property (nonatomic, retain) NSMutableDictionary *explicitAxisStep_memo;
@property (nonatomic, retain) NSMutableDictionary *implicitAxisStep_memo;
@property (nonatomic, retain) NSMutableDictionary *axis_memo;
@property (nonatomic, retain) NSMutableDictionary *axisName_memo;
@property (nonatomic, retain) NSMutableDictionary *abbreviatedAxis_memo;
@property (nonatomic, retain) NSMutableDictionary *stepBody_memo;
@property (nonatomic, retain) NSMutableDictionary *nodeTest_memo;
@property (nonatomic, retain) NSMutableDictionary *nameTest_memo;
@property (nonatomic, retain) NSMutableDictionary *typeTest_memo;
@property (nonatomic, retain) NSMutableDictionary *nodeType_memo;
@property (nonatomic, retain) NSMutableDictionary *specificPITest_memo;
@property (nonatomic, retain) NSMutableDictionary *abbreviatedStep_memo;
@property (nonatomic, retain) NSMutableDictionary *ancestor_memo;
@property (nonatomic, retain) NSMutableDictionary *ancestorOrSelf_memo;
@property (nonatomic, retain) NSMutableDictionary *attr_memo;
@property (nonatomic, retain) NSMutableDictionary *child_memo;
@property (nonatomic, retain) NSMutableDictionary *descendant_memo;
@property (nonatomic, retain) NSMutableDictionary *descendantOrSelf_memo;
@property (nonatomic, retain) NSMutableDictionary *following_memo;
@property (nonatomic, retain) NSMutableDictionary *followingSibling_memo;
@property (nonatomic, retain) NSMutableDictionary *namespace_memo;
@property (nonatomic, retain) NSMutableDictionary *parent_memo;
@property (nonatomic, retain) NSMutableDictionary *preceding_memo;
@property (nonatomic, retain) NSMutableDictionary *precedingSibling_memo;
@property (nonatomic, retain) NSMutableDictionary *self_memo;
@property (nonatomic, retain) NSMutableDictionary *div_memo;
@property (nonatomic, retain) NSMutableDictionary *mod_memo;
@property (nonatomic, retain) NSMutableDictionary *to_memo;
@property (nonatomic, retain) NSMutableDictionary *for_memo;
@property (nonatomic, retain) NSMutableDictionary *let_memo;
@property (nonatomic, retain) NSMutableDictionary *in_memo;
@property (nonatomic, retain) NSMutableDictionary *return_memo;
@property (nonatomic, retain) NSMutableDictionary *satisfies_memo;
@property (nonatomic, retain) NSMutableDictionary *or_memo;
@property (nonatomic, retain) NSMutableDictionary *and_memo;
@property (nonatomic, retain) NSMutableDictionary *true_memo;
@property (nonatomic, retain) NSMutableDictionary *false_memo;
@property (nonatomic, retain) NSMutableDictionary *comment_memo;
@property (nonatomic, retain) NSMutableDictionary *text_memo;
@property (nonatomic, retain) NSMutableDictionary *processingInstruction_memo;
@property (nonatomic, retain) NSMutableDictionary *node_memo;
@property (nonatomic, retain) NSMutableDictionary *valEq_memo;
@property (nonatomic, retain) NSMutableDictionary *valNe_memo;
@property (nonatomic, retain) NSMutableDictionary *valLt_memo;
@property (nonatomic, retain) NSMutableDictionary *valGt_memo;
@property (nonatomic, retain) NSMutableDictionary *valLe_memo;
@property (nonatomic, retain) NSMutableDictionary *valGe_memo;
@property (nonatomic, retain) NSMutableDictionary *declare_memo;
@property (nonatomic, retain) NSMutableDictionary *variable_memo;
@property (nonatomic, retain) NSMutableDictionary *function_memo;
@property (nonatomic, retain) NSMutableDictionary *keyword_memo;
@end

@implementation XPEGParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"xpath";
        self.tokenKindTab[@"|"] = @(XPEG_TOKEN_KIND_PIPE);
        self.tokenKindTab[@"!="] = @(XPEG_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"("] = @(XPEG_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"}"] = @(XPEG_TOKEN_KIND_CLOSE_CURLY);
        self.tokenKindTab[@"ancestor-or-self"] = @(XPEG_TOKEN_KIND_ANCESTORORSELF);
        self.tokenKindTab[@")"] = @(XPEG_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"by"] = @(XPEG_TOKEN_KIND_BY);
        self.tokenKindTab[@"descendant-or-self"] = @(XPEG_TOKEN_KIND_DESCENDANTORSELF);
        self.tokenKindTab[@"*"] = @(XPEG_TOKEN_KIND_MULTIPLYOPERATOR);
        self.tokenKindTab[@"parent"] = @(XPEG_TOKEN_KIND_PARENT);
        self.tokenKindTab[@"return"] = @(XPEG_TOKEN_KIND_RETURN);
        self.tokenKindTab[@"+"] = @(XPEG_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"satisfies"] = @(XPEG_TOKEN_KIND_SATISFIES);
        self.tokenKindTab[@"and"] = @(XPEG_TOKEN_KIND_AND);
        self.tokenKindTab[@"//"] = @(XPEG_TOKEN_KIND_DOUBLE_SLASH);
        self.tokenKindTab[@","] = @(XPEG_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"if"] = @(XPEG_TOKEN_KIND_IF);
        self.tokenKindTab[@"-"] = @(XPEG_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"self"] = @(XPEG_TOKEN_KIND_SELF);
        self.tokenKindTab[@"descendant"] = @(XPEG_TOKEN_KIND_DESCENDANT);
        self.tokenKindTab[@"."] = @(XPEG_TOKEN_KIND_DOT);
        self.tokenKindTab[@"<<"] = @(XPEG_TOKEN_KIND_SHIFT_LEFT);
        self.tokenKindTab[@"ascending"] = @(XPEG_TOKEN_KIND_ASCENDING);
        self.tokenKindTab[@"/"] = @(XPEG_TOKEN_KIND_FORWARD_SLASH);
        self.tokenKindTab[@"preceding-sibling"] = @(XPEG_TOKEN_KIND_PRECEDINGSIBLING);
        self.tokenKindTab[@"<="] = @(XPEG_TOKEN_KIND_LE_SYM);
        self.tokenKindTab[@"div"] = @(XPEG_TOKEN_KIND_DIV);
        self.tokenKindTab[@"false"] = @(XPEG_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"["] = @(XPEG_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@"eq"] = @(XPEG_TOKEN_KIND_VALEQ);
        self.tokenKindTab[@"lt"] = @(XPEG_TOKEN_KIND_VALLT);
        self.tokenKindTab[@"function"] = @(XPEG_TOKEN_KIND_FUNCTION);
        self.tokenKindTab[@"]"] = @(XPEG_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"union"] = @(XPEG_TOKEN_KIND_UNION);
        self.tokenKindTab[@"except"] = @(XPEG_TOKEN_KIND_EXCEPT);
        self.tokenKindTab[@"namespace"] = @(XPEG_TOKEN_KIND_NAMESPACE);
        self.tokenKindTab[@"or"] = @(XPEG_TOKEN_KIND_OR);
        self.tokenKindTab[@"let"] = @(XPEG_TOKEN_KIND_LET);
        self.tokenKindTab[@"descending"] = @(XPEG_TOKEN_KIND_DESCENDING);
        self.tokenKindTab[@"child"] = @(XPEG_TOKEN_KIND_CHILD);
        self.tokenKindTab[@"attribute"] = @(XPEG_TOKEN_KIND_ATTR);
        self.tokenKindTab[@"preceding"] = @(XPEG_TOKEN_KIND_PRECEDING);
        self.tokenKindTab[@">="] = @(XPEG_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@":"] = @(XPEG_TOKEN_KIND_COLON);
        self.tokenKindTab[@"some"] = @(XPEG_TOKEN_KIND_SOME);
        self.tokenKindTab[@"ancestor"] = @(XPEG_TOKEN_KIND_ANCESTOR);
        self.tokenKindTab[@";"] = @(XPEG_TOKEN_KIND_SEMI_COLON);
        self.tokenKindTab[@">>"] = @(XPEG_TOKEN_KIND_SHIFT_RIGHT);
        self.tokenKindTab[@"every"] = @(XPEG_TOKEN_KIND_EVERY);
        self.tokenKindTab[@"<"] = @(XPEG_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"for"] = @(XPEG_TOKEN_KIND_FOR);
        self.tokenKindTab[@"in"] = @(XPEG_TOKEN_KIND_IN);
        self.tokenKindTab[@"="] = @(XPEG_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"comment"] = @(XPEG_TOKEN_KIND_COMMENT);
        self.tokenKindTab[@"text"] = @(XPEG_TOKEN_KIND_TEXT);
        self.tokenKindTab[@">"] = @(XPEG_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"gt"] = @(XPEG_TOKEN_KIND_VALGT);
        self.tokenKindTab[@"le"] = @(XPEG_TOKEN_KIND_VALLE);
        self.tokenKindTab[@"@"] = @(XPEG_TOKEN_KIND_ABBREVIATEDAXIS);
        self.tokenKindTab[@"order"] = @(XPEG_TOKEN_KIND_ORDER);
        self.tokenKindTab[@"then"] = @(XPEG_TOKEN_KIND_THEN);
        self.tokenKindTab[@"is"] = @(XPEG_TOKEN_KIND_IS);
        self.tokenKindTab[@"else"] = @(XPEG_TOKEN_KIND_ELSE);
        self.tokenKindTab[@"ne"] = @(XPEG_TOKEN_KIND_VALNE);
        self.tokenKindTab[@"at"] = @(XPEG_TOKEN_KIND_AT);
        self.tokenKindTab[@"node"] = @(XPEG_TOKEN_KIND_NODE);
        self.tokenKindTab[@"to"] = @(XPEG_TOKEN_KIND_TO);
        self.tokenKindTab[@"variable"] = @(XPEG_TOKEN_KIND_VARIABLE);
        self.tokenKindTab[@"::"] = @(XPEG_TOKEN_KIND_DOUBLE_COLON);
        self.tokenKindTab[@"ge"] = @(XPEG_TOKEN_KIND_VALGE);
        self.tokenKindTab[@"true"] = @(XPEG_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"group"] = @(XPEG_TOKEN_KIND_GROUP);
        self.tokenKindTab[@"processing-instruction"] = @(XPEG_TOKEN_KIND_PROCESSINGINSTRUCTION);
        self.tokenKindTab[@"where"] = @(XPEG_TOKEN_KIND_WHERE);
        self.tokenKindTab[@"$"] = @(XPEG_TOKEN_KIND_DOLLAR);
        self.tokenKindTab[@"declare"] = @(XPEG_TOKEN_KIND_DECLARE);
        self.tokenKindTab[@"following-sibling"] = @(XPEG_TOKEN_KIND_FOLLOWINGSIBLING);
        self.tokenKindTab[@"mod"] = @(XPEG_TOKEN_KIND_MOD);
        self.tokenKindTab[@".."] = @(XPEG_TOKEN_KIND_DOT_DOT);
        self.tokenKindTab[@":="] = @(XPEG_TOKEN_KIND_ASSIGN);
        self.tokenKindTab[@"{"] = @(XPEG_TOKEN_KIND_OPEN_CURLY);
        self.tokenKindTab[@"intersect"] = @(XPEG_TOKEN_KIND_INTERSECT);
        self.tokenKindTab[@"following"] = @(XPEG_TOKEN_KIND_FOLLOWING);

        self.tokenKindNameTab[XPEG_TOKEN_KIND_PIPE] = @"|";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ANCESTORORSELF] = @"ancestor-or-self";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_BY] = @"by";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DESCENDANTORSELF] = @"descendant-or-self";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_MULTIPLYOPERATOR] = @"*";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_PARENT] = @"parent";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_RETURN] = @"return";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_SATISFIES] = @"satisfies";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DOUBLE_SLASH] = @"//";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_IF] = @"if";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_SELF] = @"self";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DESCENDANT] = @"descendant";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_SHIFT_LEFT] = @"<<";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ASCENDING] = @"ascending";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_FORWARD_SLASH] = @"/";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_PRECEDINGSIBLING] = @"preceding-sibling";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_LE_SYM] = @"<=";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DIV] = @"div";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_VALEQ] = @"eq";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_VALLT] = @"lt";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_FUNCTION] = @"function";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_UNION] = @"union";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_EXCEPT] = @"except";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_NAMESPACE] = @"namespace";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_LET] = @"let";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DESCENDING] = @"descending";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_CHILD] = @"child";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ATTR] = @"attribute";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_PRECEDING] = @"preceding";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_COLON] = @":";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_SOME] = @"some";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ANCESTOR] = @"ancestor";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_SEMI_COLON] = @";";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_SHIFT_RIGHT] = @">>";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_EVERY] = @"every";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_FOR] = @"for";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_IN] = @"in";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_COMMENT] = @"comment";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_TEXT] = @"text";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_VALGT] = @"gt";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_VALLE] = @"le";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ABBREVIATEDAXIS] = @"@";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ORDER] = @"order";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_THEN] = @"then";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_IS] = @"is";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ELSE] = @"else";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_VALNE] = @"ne";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_AT] = @"at";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_NODE] = @"node";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_TO] = @"to";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_VARIABLE] = @"variable";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DOUBLE_COLON] = @"::";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_VALGE] = @"ge";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_GROUP] = @"group";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_PROCESSINGINSTRUCTION] = @"processing-instruction";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_WHERE] = @"where";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DOLLAR] = @"$";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DECLARE] = @"declare";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_FOLLOWINGSIBLING] = @"following-sibling";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_MOD] = @"mod";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DOT_DOT] = @"..";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ASSIGN] = @":=";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_OPEN_CURLY] = @"{";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_INTERSECT] = @"intersect";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_FOLLOWING] = @"following";

        self.xpath_memo = [NSMutableDictionary dictionary];
        self.prologue_memo = [NSMutableDictionary dictionary];
        self.varDecl_memo = [NSMutableDictionary dictionary];
        self.functionDecl_memo = [NSMutableDictionary dictionary];
        self.paramList_memo = [NSMutableDictionary dictionary];
        self.enclosedExpr_memo = [NSMutableDictionary dictionary];
        self.expr_memo = [NSMutableDictionary dictionary];
        self.exprSingleTail_memo = [NSMutableDictionary dictionary];
        self.exprSingle_memo = [NSMutableDictionary dictionary];
        self.forExpr_memo = [NSMutableDictionary dictionary];
        self.forClause_memo = [NSMutableDictionary dictionary];
        self.singleForClause_memo = [NSMutableDictionary dictionary];
        self.positionalVar_memo = [NSMutableDictionary dictionary];
        self.letClause_memo = [NSMutableDictionary dictionary];
        self.singleLetClause_memo = [NSMutableDictionary dictionary];
        self.whereClause_memo = [NSMutableDictionary dictionary];
        self.groupClause_memo = [NSMutableDictionary dictionary];
        self.singleGroupClause_memo = [NSMutableDictionary dictionary];
        self.orderByClause_memo = [NSMutableDictionary dictionary];
        self.orderSpecList_memo = [NSMutableDictionary dictionary];
        self.orderSpec_memo = [NSMutableDictionary dictionary];
        self.orderModifier_memo = [NSMutableDictionary dictionary];
        self.quantifiedExpr_memo = [NSMutableDictionary dictionary];
        self.inClause_memo = [NSMutableDictionary dictionary];
        self.singleInClause_memo = [NSMutableDictionary dictionary];
        self.ifExpr_memo = [NSMutableDictionary dictionary];
        self.orExpr_memo = [NSMutableDictionary dictionary];
        self.orAndExpr_memo = [NSMutableDictionary dictionary];
        self.andExpr_memo = [NSMutableDictionary dictionary];
        self.andRangeExpr_memo = [NSMutableDictionary dictionary];
        self.rangeExpr_memo = [NSMutableDictionary dictionary];
        self.toEqualityExpr_memo = [NSMutableDictionary dictionary];
        self.equalityExpr_memo = [NSMutableDictionary dictionary];
        self.eqRelationalExpr_memo = [NSMutableDictionary dictionary];
        self.relationalExpr_memo = [NSMutableDictionary dictionary];
        self.compareAdditiveExpr_memo = [NSMutableDictionary dictionary];
        self.additiveExpr_memo = [NSMutableDictionary dictionary];
        self.plusOrMinusMultiExpr_memo = [NSMutableDictionary dictionary];
        self.multiplicativeExpr_memo = [NSMutableDictionary dictionary];
        self.multDivOrModUnaryExpr_memo = [NSMutableDictionary dictionary];
        self.multiplyOperator_memo = [NSMutableDictionary dictionary];
        self.unaryExpr_memo = [NSMutableDictionary dictionary];
        self.minusUnionExpr_memo = [NSMutableDictionary dictionary];
        self.unionExpr_memo = [NSMutableDictionary dictionary];
        self.unionTail_memo = [NSMutableDictionary dictionary];
        self.intersectExceptExpr_memo = [NSMutableDictionary dictionary];
        self.intersectExceptTail_memo = [NSMutableDictionary dictionary];
        self.pathExpr_memo = [NSMutableDictionary dictionary];
        self.filterPath_memo = [NSMutableDictionary dictionary];
        self.complexFilterPath_memo = [NSMutableDictionary dictionary];
        self.complexFilterPathStartExpr_memo = [NSMutableDictionary dictionary];
        self.locationPath_memo = [NSMutableDictionary dictionary];
        self.relativeLocationPath_memo = [NSMutableDictionary dictionary];
        self.pathBody_memo = [NSMutableDictionary dictionary];
        self.pathTail_memo = [NSMutableDictionary dictionary];
        self.slashStep_memo = [NSMutableDictionary dictionary];
        self.absoluteLocationPath_memo = [NSMutableDictionary dictionary];
        self.abbreviatedAbsoluteLocationPath_memo = [NSMutableDictionary dictionary];
        self.rootSlash_memo = [NSMutableDictionary dictionary];
        self.rootDoubleSlash_memo = [NSMutableDictionary dictionary];
        self.firstRelativeStep_memo = [NSMutableDictionary dictionary];
        self.filterExpr_memo = [NSMutableDictionary dictionary];
        self.primaryExpr_memo = [NSMutableDictionary dictionary];
        self.variableReference_memo = [NSMutableDictionary dictionary];
        self.literal_memo = [NSMutableDictionary dictionary];
        self.number_memo = [NSMutableDictionary dictionary];
        self.parenthesizedExpr_memo = [NSMutableDictionary dictionary];
        self.functionCall_memo = [NSMutableDictionary dictionary];
        self.actualFunctionCall_memo = [NSMutableDictionary dictionary];
        self.argList_memo = [NSMutableDictionary dictionary];
        self.booleanLiteralFunctionCall_memo = [NSMutableDictionary dictionary];
        self.functionName_memo = [NSMutableDictionary dictionary];
        self.booleanLiteral_memo = [NSMutableDictionary dictionary];
        self.qName_memo = [NSMutableDictionary dictionary];
        self.prefix_memo = [NSMutableDictionary dictionary];
        self.localPart_memo = [NSMutableDictionary dictionary];
        self.ncName_memo = [NSMutableDictionary dictionary];
        self.argument_memo = [NSMutableDictionary dictionary];
        self.predicate_memo = [NSMutableDictionary dictionary];
        self.predicateExpr_memo = [NSMutableDictionary dictionary];
        self.step_memo = [NSMutableDictionary dictionary];
        self.explicitAxisStep_memo = [NSMutableDictionary dictionary];
        self.implicitAxisStep_memo = [NSMutableDictionary dictionary];
        self.axis_memo = [NSMutableDictionary dictionary];
        self.axisName_memo = [NSMutableDictionary dictionary];
        self.abbreviatedAxis_memo = [NSMutableDictionary dictionary];
        self.stepBody_memo = [NSMutableDictionary dictionary];
        self.nodeTest_memo = [NSMutableDictionary dictionary];
        self.nameTest_memo = [NSMutableDictionary dictionary];
        self.typeTest_memo = [NSMutableDictionary dictionary];
        self.nodeType_memo = [NSMutableDictionary dictionary];
        self.specificPITest_memo = [NSMutableDictionary dictionary];
        self.abbreviatedStep_memo = [NSMutableDictionary dictionary];
        self.ancestor_memo = [NSMutableDictionary dictionary];
        self.ancestorOrSelf_memo = [NSMutableDictionary dictionary];
        self.attr_memo = [NSMutableDictionary dictionary];
        self.child_memo = [NSMutableDictionary dictionary];
        self.descendant_memo = [NSMutableDictionary dictionary];
        self.descendantOrSelf_memo = [NSMutableDictionary dictionary];
        self.following_memo = [NSMutableDictionary dictionary];
        self.followingSibling_memo = [NSMutableDictionary dictionary];
        self.namespace_memo = [NSMutableDictionary dictionary];
        self.parent_memo = [NSMutableDictionary dictionary];
        self.preceding_memo = [NSMutableDictionary dictionary];
        self.precedingSibling_memo = [NSMutableDictionary dictionary];
        self.self_memo = [NSMutableDictionary dictionary];
        self.div_memo = [NSMutableDictionary dictionary];
        self.mod_memo = [NSMutableDictionary dictionary];
        self.to_memo = [NSMutableDictionary dictionary];
        self.for_memo = [NSMutableDictionary dictionary];
        self.let_memo = [NSMutableDictionary dictionary];
        self.in_memo = [NSMutableDictionary dictionary];
        self.return_memo = [NSMutableDictionary dictionary];
        self.satisfies_memo = [NSMutableDictionary dictionary];
        self.or_memo = [NSMutableDictionary dictionary];
        self.and_memo = [NSMutableDictionary dictionary];
        self.true_memo = [NSMutableDictionary dictionary];
        self.false_memo = [NSMutableDictionary dictionary];
        self.comment_memo = [NSMutableDictionary dictionary];
        self.text_memo = [NSMutableDictionary dictionary];
        self.processingInstruction_memo = [NSMutableDictionary dictionary];
        self.node_memo = [NSMutableDictionary dictionary];
        self.valEq_memo = [NSMutableDictionary dictionary];
        self.valNe_memo = [NSMutableDictionary dictionary];
        self.valLt_memo = [NSMutableDictionary dictionary];
        self.valGt_memo = [NSMutableDictionary dictionary];
        self.valLe_memo = [NSMutableDictionary dictionary];
        self.valGe_memo = [NSMutableDictionary dictionary];
        self.declare_memo = [NSMutableDictionary dictionary];
        self.variable_memo = [NSMutableDictionary dictionary];
        self.function_memo = [NSMutableDictionary dictionary];
        self.keyword_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
    self.xpath_memo = nil;
    self.prologue_memo = nil;
    self.varDecl_memo = nil;
    self.functionDecl_memo = nil;
    self.paramList_memo = nil;
    self.enclosedExpr_memo = nil;
    self.expr_memo = nil;
    self.exprSingleTail_memo = nil;
    self.exprSingle_memo = nil;
    self.forExpr_memo = nil;
    self.forClause_memo = nil;
    self.singleForClause_memo = nil;
    self.positionalVar_memo = nil;
    self.letClause_memo = nil;
    self.singleLetClause_memo = nil;
    self.whereClause_memo = nil;
    self.groupClause_memo = nil;
    self.singleGroupClause_memo = nil;
    self.orderByClause_memo = nil;
    self.orderSpecList_memo = nil;
    self.orderSpec_memo = nil;
    self.orderModifier_memo = nil;
    self.quantifiedExpr_memo = nil;
    self.inClause_memo = nil;
    self.singleInClause_memo = nil;
    self.ifExpr_memo = nil;
    self.orExpr_memo = nil;
    self.orAndExpr_memo = nil;
    self.andExpr_memo = nil;
    self.andRangeExpr_memo = nil;
    self.rangeExpr_memo = nil;
    self.toEqualityExpr_memo = nil;
    self.equalityExpr_memo = nil;
    self.eqRelationalExpr_memo = nil;
    self.relationalExpr_memo = nil;
    self.compareAdditiveExpr_memo = nil;
    self.additiveExpr_memo = nil;
    self.plusOrMinusMultiExpr_memo = nil;
    self.multiplicativeExpr_memo = nil;
    self.multDivOrModUnaryExpr_memo = nil;
    self.multiplyOperator_memo = nil;
    self.unaryExpr_memo = nil;
    self.minusUnionExpr_memo = nil;
    self.unionExpr_memo = nil;
    self.unionTail_memo = nil;
    self.intersectExceptExpr_memo = nil;
    self.intersectExceptTail_memo = nil;
    self.pathExpr_memo = nil;
    self.filterPath_memo = nil;
    self.complexFilterPath_memo = nil;
    self.complexFilterPathStartExpr_memo = nil;
    self.locationPath_memo = nil;
    self.relativeLocationPath_memo = nil;
    self.pathBody_memo = nil;
    self.pathTail_memo = nil;
    self.slashStep_memo = nil;
    self.absoluteLocationPath_memo = nil;
    self.abbreviatedAbsoluteLocationPath_memo = nil;
    self.rootSlash_memo = nil;
    self.rootDoubleSlash_memo = nil;
    self.firstRelativeStep_memo = nil;
    self.filterExpr_memo = nil;
    self.primaryExpr_memo = nil;
    self.variableReference_memo = nil;
    self.literal_memo = nil;
    self.number_memo = nil;
    self.parenthesizedExpr_memo = nil;
    self.functionCall_memo = nil;
    self.actualFunctionCall_memo = nil;
    self.argList_memo = nil;
    self.booleanLiteralFunctionCall_memo = nil;
    self.functionName_memo = nil;
    self.booleanLiteral_memo = nil;
    self.qName_memo = nil;
    self.prefix_memo = nil;
    self.localPart_memo = nil;
    self.ncName_memo = nil;
    self.argument_memo = nil;
    self.predicate_memo = nil;
    self.predicateExpr_memo = nil;
    self.step_memo = nil;
    self.explicitAxisStep_memo = nil;
    self.implicitAxisStep_memo = nil;
    self.axis_memo = nil;
    self.axisName_memo = nil;
    self.abbreviatedAxis_memo = nil;
    self.stepBody_memo = nil;
    self.nodeTest_memo = nil;
    self.nameTest_memo = nil;
    self.typeTest_memo = nil;
    self.nodeType_memo = nil;
    self.specificPITest_memo = nil;
    self.abbreviatedStep_memo = nil;
    self.ancestor_memo = nil;
    self.ancestorOrSelf_memo = nil;
    self.attr_memo = nil;
    self.child_memo = nil;
    self.descendant_memo = nil;
    self.descendantOrSelf_memo = nil;
    self.following_memo = nil;
    self.followingSibling_memo = nil;
    self.namespace_memo = nil;
    self.parent_memo = nil;
    self.preceding_memo = nil;
    self.precedingSibling_memo = nil;
    self.self_memo = nil;
    self.div_memo = nil;
    self.mod_memo = nil;
    self.to_memo = nil;
    self.for_memo = nil;
    self.let_memo = nil;
    self.in_memo = nil;
    self.return_memo = nil;
    self.satisfies_memo = nil;
    self.or_memo = nil;
    self.and_memo = nil;
    self.true_memo = nil;
    self.false_memo = nil;
    self.comment_memo = nil;
    self.text_memo = nil;
    self.processingInstruction_memo = nil;
    self.node_memo = nil;
    self.valEq_memo = nil;
    self.valNe_memo = nil;
    self.valLt_memo = nil;
    self.valGt_memo = nil;
    self.valLe_memo = nil;
    self.valGe_memo = nil;
    self.declare_memo = nil;
    self.variable_memo = nil;
    self.function_memo = nil;
    self.keyword_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_xpath_memo removeAllObjects];
    [_prologue_memo removeAllObjects];
    [_varDecl_memo removeAllObjects];
    [_functionDecl_memo removeAllObjects];
    [_paramList_memo removeAllObjects];
    [_enclosedExpr_memo removeAllObjects];
    [_expr_memo removeAllObjects];
    [_exprSingleTail_memo removeAllObjects];
    [_exprSingle_memo removeAllObjects];
    [_forExpr_memo removeAllObjects];
    [_forClause_memo removeAllObjects];
    [_singleForClause_memo removeAllObjects];
    [_positionalVar_memo removeAllObjects];
    [_letClause_memo removeAllObjects];
    [_singleLetClause_memo removeAllObjects];
    [_whereClause_memo removeAllObjects];
    [_groupClause_memo removeAllObjects];
    [_singleGroupClause_memo removeAllObjects];
    [_orderByClause_memo removeAllObjects];
    [_orderSpecList_memo removeAllObjects];
    [_orderSpec_memo removeAllObjects];
    [_orderModifier_memo removeAllObjects];
    [_quantifiedExpr_memo removeAllObjects];
    [_inClause_memo removeAllObjects];
    [_singleInClause_memo removeAllObjects];
    [_ifExpr_memo removeAllObjects];
    [_orExpr_memo removeAllObjects];
    [_orAndExpr_memo removeAllObjects];
    [_andExpr_memo removeAllObjects];
    [_andRangeExpr_memo removeAllObjects];
    [_rangeExpr_memo removeAllObjects];
    [_toEqualityExpr_memo removeAllObjects];
    [_equalityExpr_memo removeAllObjects];
    [_eqRelationalExpr_memo removeAllObjects];
    [_relationalExpr_memo removeAllObjects];
    [_compareAdditiveExpr_memo removeAllObjects];
    [_additiveExpr_memo removeAllObjects];
    [_plusOrMinusMultiExpr_memo removeAllObjects];
    [_multiplicativeExpr_memo removeAllObjects];
    [_multDivOrModUnaryExpr_memo removeAllObjects];
    [_multiplyOperator_memo removeAllObjects];
    [_unaryExpr_memo removeAllObjects];
    [_minusUnionExpr_memo removeAllObjects];
    [_unionExpr_memo removeAllObjects];
    [_unionTail_memo removeAllObjects];
    [_intersectExceptExpr_memo removeAllObjects];
    [_intersectExceptTail_memo removeAllObjects];
    [_pathExpr_memo removeAllObjects];
    [_filterPath_memo removeAllObjects];
    [_complexFilterPath_memo removeAllObjects];
    [_complexFilterPathStartExpr_memo removeAllObjects];
    [_locationPath_memo removeAllObjects];
    [_relativeLocationPath_memo removeAllObjects];
    [_pathBody_memo removeAllObjects];
    [_pathTail_memo removeAllObjects];
    [_slashStep_memo removeAllObjects];
    [_absoluteLocationPath_memo removeAllObjects];
    [_abbreviatedAbsoluteLocationPath_memo removeAllObjects];
    [_rootSlash_memo removeAllObjects];
    [_rootDoubleSlash_memo removeAllObjects];
    [_firstRelativeStep_memo removeAllObjects];
    [_filterExpr_memo removeAllObjects];
    [_primaryExpr_memo removeAllObjects];
    [_variableReference_memo removeAllObjects];
    [_literal_memo removeAllObjects];
    [_number_memo removeAllObjects];
    [_parenthesizedExpr_memo removeAllObjects];
    [_functionCall_memo removeAllObjects];
    [_actualFunctionCall_memo removeAllObjects];
    [_argList_memo removeAllObjects];
    [_booleanLiteralFunctionCall_memo removeAllObjects];
    [_functionName_memo removeAllObjects];
    [_booleanLiteral_memo removeAllObjects];
    [_qName_memo removeAllObjects];
    [_prefix_memo removeAllObjects];
    [_localPart_memo removeAllObjects];
    [_ncName_memo removeAllObjects];
    [_argument_memo removeAllObjects];
    [_predicate_memo removeAllObjects];
    [_predicateExpr_memo removeAllObjects];
    [_step_memo removeAllObjects];
    [_explicitAxisStep_memo removeAllObjects];
    [_implicitAxisStep_memo removeAllObjects];
    [_axis_memo removeAllObjects];
    [_axisName_memo removeAllObjects];
    [_abbreviatedAxis_memo removeAllObjects];
    [_stepBody_memo removeAllObjects];
    [_nodeTest_memo removeAllObjects];
    [_nameTest_memo removeAllObjects];
    [_typeTest_memo removeAllObjects];
    [_nodeType_memo removeAllObjects];
    [_specificPITest_memo removeAllObjects];
    [_abbreviatedStep_memo removeAllObjects];
    [_ancestor_memo removeAllObjects];
    [_ancestorOrSelf_memo removeAllObjects];
    [_attr_memo removeAllObjects];
    [_child_memo removeAllObjects];
    [_descendant_memo removeAllObjects];
    [_descendantOrSelf_memo removeAllObjects];
    [_following_memo removeAllObjects];
    [_followingSibling_memo removeAllObjects];
    [_namespace_memo removeAllObjects];
    [_parent_memo removeAllObjects];
    [_preceding_memo removeAllObjects];
    [_precedingSibling_memo removeAllObjects];
    [_self_memo removeAllObjects];
    [_div_memo removeAllObjects];
    [_mod_memo removeAllObjects];
    [_to_memo removeAllObjects];
    [_for_memo removeAllObjects];
    [_let_memo removeAllObjects];
    [_in_memo removeAllObjects];
    [_return_memo removeAllObjects];
    [_satisfies_memo removeAllObjects];
    [_or_memo removeAllObjects];
    [_and_memo removeAllObjects];
    [_true_memo removeAllObjects];
    [_false_memo removeAllObjects];
    [_comment_memo removeAllObjects];
    [_text_memo removeAllObjects];
    [_processingInstruction_memo removeAllObjects];
    [_node_memo removeAllObjects];
    [_valEq_memo removeAllObjects];
    [_valNe_memo removeAllObjects];
    [_valLt_memo removeAllObjects];
    [_valGt_memo removeAllObjects];
    [_valLe_memo removeAllObjects];
    [_valGe_memo removeAllObjects];
    [_declare_memo removeAllObjects];
    [_variable_memo removeAllObjects];
    [_function_memo removeAllObjects];
    [_keyword_memo removeAllObjects];
}

- (void)start {
    [self execute:^{
    
        // TODO `$`

        PKTokenizer *t = self.tokenizer;
        [t.symbolState add:@"//"];
        [t.symbolState add:@".."];
        [t.symbolState add:@":="];
        [t.symbolState add:@"!="];
        [t.symbolState add:@"::"];
        [t.symbolState add:@"<="];
        [t.symbolState add:@"=>"];
        [t.symbolState add:@"<<"];
        [t.symbolState add:@">>"];
        [t.symbolState add:@"(:"];
        [t.symbolState add:@":)"];

        [t setTokenizerState:t.wordState from:'_' to:'_'];
        [t.wordState setWordChars:YES from:'-' to:'-'];
        [t.wordState setWordChars:YES from:'_' to:'_'];
        [t.wordState setWordChars:YES from:'.' to:'.'];
        [t.wordState setWordChars:NO from:'\'' to:'\''];

        [t setTokenizerState:t.numberState from:'.' to:'.'];

        [t setTokenizerState:t.numberState from:'#' to:'#'];
        t.numberState.allowsScientificNotation = YES;

        [t setTokenizerState:t.symbolState from:'/' to:'/'];

        [t.commentState addMultiLineStartMarker:@"(:" endMarker:@":)"];
        [t setTokenizerState:t.commentState from:'(' to:'('];
        [t setTokenizerState:t.commentState from:':' to:':'];
        [t.commentState setFallbackState:t.symbolState from:'(' to:'('];
        [t.commentState setFallbackState:t.symbolState from:':' to:':'];

    }];

    [self xpath_]; 
    [self matchEOF:YES]; 

}

- (void)__xpath {
    
    [self prologue_]; 
    [self expr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchXpath:)];
}

- (void)xpath_ {
    [self parseRule:@selector(__xpath) withMemo:_xpath_memo];
}

- (void)__prologue {
    
    while ([self speculate:^{ if ([self speculate:^{ [self varDecl_]; }]) {[self varDecl_]; } else if ([self speculate:^{ [self functionDecl_]; }]) {[self functionDecl_]; } else {[self raise:@"No viable alternative found in rule 'prologue'."];}[self match:XPEG_TOKEN_KIND_SEMI_COLON discard:YES]; }]) {
        if ([self speculate:^{ [self varDecl_]; }]) {
            [self varDecl_]; 
        } else if ([self speculate:^{ [self functionDecl_]; }]) {
            [self functionDecl_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'prologue'."];
        }
        [self match:XPEG_TOKEN_KIND_SEMI_COLON discard:YES]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrologue:)];
}

- (void)prologue_ {
    [self parseRule:@selector(__prologue) withMemo:_prologue_memo];
}

- (void)__varDecl {
    
    [self declare_]; 
    [self variable_]; 
    [self match:XPEG_TOKEN_KIND_DOLLAR discard:NO]; 
    [self qName_]; 
    [self match:XPEG_TOKEN_KIND_ASSIGN discard:YES]; 
    [self exprSingle_]; 

    [self fireDelegateSelector:@selector(parser:didMatchVarDecl:)];
}

- (void)varDecl_ {
    [self parseRule:@selector(__varDecl) withMemo:_varDecl_memo];
}

- (void)__functionDecl {
    
    [self declare_]; 
    [self function_]; 
    [self qName_]; 
    [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    if ([self speculate:^{ [self paramList_]; }]) {
        [self paramList_]; 
    }
    [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self enclosedExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFunctionDecl:)];
}

- (void)functionDecl_ {
    [self parseRule:@selector(__functionDecl) withMemo:_functionDecl_memo];
}

- (void)__paramList {
    
    [self match:XPEG_TOKEN_KIND_DOLLAR discard:YES]; 
    [self qName_]; 
    while ([self speculate:^{ [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; [self match:XPEG_TOKEN_KIND_DOLLAR discard:YES]; [self qName_]; }]) {
        [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; 
        [self match:XPEG_TOKEN_KIND_DOLLAR discard:YES]; 
        [self qName_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchParamList:)];
}

- (void)paramList_ {
    [self parseRule:@selector(__paramList) withMemo:_paramList_memo];
}

- (void)__enclosedExpr {
    
    [self match:XPEG_TOKEN_KIND_OPEN_CURLY discard:YES]; 
    [self expr_]; 
    [self match:XPEG_TOKEN_KIND_CLOSE_CURLY discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchEnclosedExpr:)];
}

- (void)enclosedExpr_ {
    [self parseRule:@selector(__enclosedExpr) withMemo:_enclosedExpr_memo];
}

- (void)__expr {
    
    [self exprSingle_]; 
    while ([self speculate:^{ [self exprSingleTail_]; }]) {
        [self exprSingleTail_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__exprSingleTail {
    
    [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; 
    [self exprSingle_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExprSingleTail:)];
}

- (void)exprSingleTail_ {
    [self parseRule:@selector(__exprSingleTail) withMemo:_exprSingleTail_memo];
}

- (void)__exprSingle {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XPEG_TOKEN_KIND_ABBREVIATEDAXIS, XPEG_TOKEN_KIND_ANCESTOR, XPEG_TOKEN_KIND_ANCESTORORSELF, XPEG_TOKEN_KIND_AND, XPEG_TOKEN_KIND_ATTR, XPEG_TOKEN_KIND_CHILD, XPEG_TOKEN_KIND_COMMENT, XPEG_TOKEN_KIND_DESCENDANT, XPEG_TOKEN_KIND_DESCENDANTORSELF, XPEG_TOKEN_KIND_DIV, XPEG_TOKEN_KIND_DOLLAR, XPEG_TOKEN_KIND_DOT, XPEG_TOKEN_KIND_DOT_DOT, XPEG_TOKEN_KIND_DOUBLE_SLASH, XPEG_TOKEN_KIND_FALSE, XPEG_TOKEN_KIND_FOLLOWING, XPEG_TOKEN_KIND_FOLLOWINGSIBLING, XPEG_TOKEN_KIND_FORWARD_SLASH, XPEG_TOKEN_KIND_MINUS, XPEG_TOKEN_KIND_MOD, XPEG_TOKEN_KIND_MULTIPLYOPERATOR, XPEG_TOKEN_KIND_NAMESPACE, XPEG_TOKEN_KIND_NODE, XPEG_TOKEN_KIND_OPEN_PAREN, XPEG_TOKEN_KIND_OR, XPEG_TOKEN_KIND_PARENT, XPEG_TOKEN_KIND_PRECEDING, XPEG_TOKEN_KIND_PRECEDINGSIBLING, XPEG_TOKEN_KIND_PROCESSINGINSTRUCTION, XPEG_TOKEN_KIND_SELF, XPEG_TOKEN_KIND_TEXT, XPEG_TOKEN_KIND_TRUE, 0]) {
        [self orExpr_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_FOR, XPEG_TOKEN_KIND_LET, 0]) {
        [self forExpr_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_EVERY, XPEG_TOKEN_KIND_SOME, 0]) {
        [self quantifiedExpr_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_IF, 0]) {
        [self ifExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'exprSingle'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExprSingle:)];
}

- (void)exprSingle_ {
    [self parseRule:@selector(__exprSingle) withMemo:_exprSingle_memo];
}

- (void)__forExpr {
    
    do {
        if ([self predicts:XPEG_TOKEN_KIND_FOR, 0]) {
            [self for_]; 
            [self forClause_]; 
        } else if ([self predicts:XPEG_TOKEN_KIND_LET, 0]) {
            [self let_]; 
            [self letClause_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'forExpr'."];
        }
    } while ([self speculate:^{ if ([self predicts:XPEG_TOKEN_KIND_FOR, 0]) {[self for_]; [self forClause_]; } else if ([self predicts:XPEG_TOKEN_KIND_LET, 0]) {[self let_]; [self letClause_]; } else {[self raise:@"No viable alternative found in rule 'forExpr'."];}}]);
    if ([self speculate:^{ [self whereClause_]; }]) {
        [self whereClause_]; 
    }
    if ([self speculate:^{ [self orderByClause_]; }]) {
        [self orderByClause_]; 
    }
    [self return_]; 
    [self exprSingle_]; 

    [self fireDelegateSelector:@selector(parser:didMatchForExpr:)];
}

- (void)forExpr_ {
    [self parseRule:@selector(__forExpr) withMemo:_forExpr_memo];
}

- (void)__forClause {
    
    [self singleForClause_]; 
    while ([self speculate:^{ [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; [self singleForClause_]; }]) {
        [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; 
        [self singleForClause_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchForClause:)];
}

- (void)forClause_ {
    [self parseRule:@selector(__forClause) withMemo:_forClause_memo];
}

- (void)__singleForClause {
    
    [self match:XPEG_TOKEN_KIND_DOLLAR discard:YES]; 
    [self qName_]; 
    if ([self speculate:^{ [self positionalVar_]; }]) {
        [self positionalVar_]; 
    }
    [self in_]; 
    [self exprSingle_]; 

    [self fireDelegateSelector:@selector(parser:didMatchSingleForClause:)];
}

- (void)singleForClause_ {
    [self parseRule:@selector(__singleForClause) withMemo:_singleForClause_memo];
}

- (void)__positionalVar {
    
    [self match:XPEG_TOKEN_KIND_AT discard:YES]; 
    [self match:XPEG_TOKEN_KIND_DOLLAR discard:YES]; 
    [self qName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPositionalVar:)];
}

- (void)positionalVar_ {
    [self parseRule:@selector(__positionalVar) withMemo:_positionalVar_memo];
}

- (void)__letClause {
    
    [self singleLetClause_]; 
    while ([self speculate:^{ [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; [self singleLetClause_]; }]) {
        [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; 
        [self singleLetClause_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchLetClause:)];
}

- (void)letClause_ {
    [self parseRule:@selector(__letClause) withMemo:_letClause_memo];
}

- (void)__singleLetClause {
    
    [self match:XPEG_TOKEN_KIND_DOLLAR discard:YES]; 
    [self qName_]; 
    [self match:XPEG_TOKEN_KIND_ASSIGN discard:YES]; 
    [self exprSingle_]; 

    [self fireDelegateSelector:@selector(parser:didMatchSingleLetClause:)];
}

- (void)singleLetClause_ {
    [self parseRule:@selector(__singleLetClause) withMemo:_singleLetClause_memo];
}

- (void)__whereClause {
    
    [self match:XPEG_TOKEN_KIND_WHERE discard:YES]; 
    [self exprSingle_]; 

    [self fireDelegateSelector:@selector(parser:didMatchWhereClause:)];
}

- (void)whereClause_ {
    [self parseRule:@selector(__whereClause) withMemo:_whereClause_memo];
}

- (void)__groupClause {
    
    [self match:XPEG_TOKEN_KIND_GROUP discard:YES]; 
    [self match:XPEG_TOKEN_KIND_BY discard:YES]; 
    [self singleGroupClause_]; 
    while ([self speculate:^{ [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; [self singleGroupClause_]; }]) {
        [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; 
        [self singleGroupClause_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchGroupClause:)];
}

- (void)groupClause_ {
    [self parseRule:@selector(__groupClause) withMemo:_groupClause_memo];
}

- (void)__singleGroupClause {
    
    [self match:XPEG_TOKEN_KIND_DOLLAR discard:YES]; 
    [self qName_]; 
    if ([self speculate:^{ [self match:XPEG_TOKEN_KIND_ASSIGN discard:NO]; [self exprSingle_]; }]) {
        [self match:XPEG_TOKEN_KIND_ASSIGN discard:NO]; 
        [self exprSingle_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchSingleGroupClause:)];
}

- (void)singleGroupClause_ {
    [self parseRule:@selector(__singleGroupClause) withMemo:_singleGroupClause_memo];
}

- (void)__orderByClause {
    
    [self match:XPEG_TOKEN_KIND_ORDER discard:YES]; 
    [self match:XPEG_TOKEN_KIND_BY discard:YES]; 
    [self orderSpecList_]; 

    [self fireDelegateSelector:@selector(parser:didMatchOrderByClause:)];
}

- (void)orderByClause_ {
    [self parseRule:@selector(__orderByClause) withMemo:_orderByClause_memo];
}

- (void)__orderSpecList {
    
    [self orderSpec_]; 
    while ([self speculate:^{ [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; [self orderSpec_]; }]) {
        [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; 
        [self orderSpec_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrderSpecList:)];
}

- (void)orderSpecList_ {
    [self parseRule:@selector(__orderSpecList) withMemo:_orderSpecList_memo];
}

- (void)__orderSpec {
    
    [self exprSingle_]; 
    [self orderModifier_]; 

    [self fireDelegateSelector:@selector(parser:didMatchOrderSpec:)];
}

- (void)orderSpec_ {
    [self parseRule:@selector(__orderSpec) withMemo:_orderSpec_memo];
}

- (void)__orderModifier {
    
    if ([self predicts:XPEG_TOKEN_KIND_ASCENDING, XPEG_TOKEN_KIND_DESCENDING, 0]) {
        if ([self predicts:XPEG_TOKEN_KIND_ASCENDING, 0]) {
            [self match:XPEG_TOKEN_KIND_ASCENDING discard:NO]; 
        } else if ([self predicts:XPEG_TOKEN_KIND_DESCENDING, 0]) {
            [self match:XPEG_TOKEN_KIND_DESCENDING discard:NO]; 
        } else {
            [self raise:@"No viable alternative found in rule 'orderModifier'."];
        }
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrderModifier:)];
}

- (void)orderModifier_ {
    [self parseRule:@selector(__orderModifier) withMemo:_orderModifier_memo];
}

- (void)__quantifiedExpr {
    
    if ([self predicts:XPEG_TOKEN_KIND_SOME, 0]) {
        [self match:XPEG_TOKEN_KIND_SOME discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_EVERY, 0]) {
        [self match:XPEG_TOKEN_KIND_EVERY discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'quantifiedExpr'."];
    }
    [self inClause_]; 
    [self satisfies_]; 
    [self exprSingle_]; 

    [self fireDelegateSelector:@selector(parser:didMatchQuantifiedExpr:)];
}

- (void)quantifiedExpr_ {
    [self parseRule:@selector(__quantifiedExpr) withMemo:_quantifiedExpr_memo];
}

- (void)__inClause {
    
    [self singleInClause_]; 
    while ([self speculate:^{ [self match:XPEG_TOKEN_KIND_COMMA discard:NO]; [self singleInClause_]; }]) {
        [self match:XPEG_TOKEN_KIND_COMMA discard:NO]; 
        [self singleInClause_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchInClause:)];
}

- (void)inClause_ {
    [self parseRule:@selector(__inClause) withMemo:_inClause_memo];
}

- (void)__singleInClause {
    
    [self match:XPEG_TOKEN_KIND_DOLLAR discard:YES]; 
    [self qName_]; 
    if ([self speculate:^{ [self positionalVar_]; }]) {
        [self positionalVar_]; 
    }
    [self in_]; 
    [self exprSingle_]; 

    [self fireDelegateSelector:@selector(parser:didMatchSingleInClause:)];
}

- (void)singleInClause_ {
    [self parseRule:@selector(__singleInClause) withMemo:_singleInClause_memo];
}

- (void)__ifExpr {
    
    [self match:XPEG_TOKEN_KIND_IF discard:NO]; 
    [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self match:XPEG_TOKEN_KIND_THEN discard:NO]; 
    [self exprSingle_]; 
    [self match:XPEG_TOKEN_KIND_ELSE discard:NO]; 
    [self exprSingle_]; 

    [self fireDelegateSelector:@selector(parser:didMatchIfExpr:)];
}

- (void)ifExpr_ {
    [self parseRule:@selector(__ifExpr) withMemo:_ifExpr_memo];
}

- (void)__orExpr {
    
    [self andExpr_]; 
    while ([self speculate:^{ [self orAndExpr_]; }]) {
        [self orAndExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)orExpr_ {
    [self parseRule:@selector(__orExpr) withMemo:_orExpr_memo];
}

- (void)__orAndExpr {
    
    [self or_]; 
    [self andExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchOrAndExpr:)];
}

- (void)orAndExpr_ {
    [self parseRule:@selector(__orAndExpr) withMemo:_orAndExpr_memo];
}

- (void)__andExpr {
    
    [self rangeExpr_]; 
    while ([self speculate:^{ [self andRangeExpr_]; }]) {
        [self andRangeExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
}

- (void)andExpr_ {
    [self parseRule:@selector(__andExpr) withMemo:_andExpr_memo];
}

- (void)__andRangeExpr {
    
    [self and_]; 
    [self rangeExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAndRangeExpr:)];
}

- (void)andRangeExpr_ {
    [self parseRule:@selector(__andRangeExpr) withMemo:_andRangeExpr_memo];
}

- (void)__rangeExpr {
    
    [self equalityExpr_]; 
    if ([self speculate:^{ [self toEqualityExpr_]; }]) {
        [self toEqualityExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchRangeExpr:)];
}

- (void)rangeExpr_ {
    [self parseRule:@selector(__rangeExpr) withMemo:_rangeExpr_memo];
}

- (void)__toEqualityExpr {
    
    [self to_]; 
    [self equalityExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchToEqualityExpr:)];
}

- (void)toEqualityExpr_ {
    [self parseRule:@selector(__toEqualityExpr) withMemo:_toEqualityExpr_memo];
}

- (void)__equalityExpr {
    
    [self relationalExpr_]; 
    while ([self speculate:^{ [self eqRelationalExpr_]; }]) {
        [self eqRelationalExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchEqualityExpr:)];
}

- (void)equalityExpr_ {
    [self parseRule:@selector(__equalityExpr) withMemo:_equalityExpr_memo];
}

- (void)__eqRelationalExpr {
    
    if ([self predicts:XPEG_TOKEN_KIND_EQUALS, 0]) {
        [self match:XPEG_TOKEN_KIND_EQUALS discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_NOT_EQUAL, 0]) {
        [self match:XPEG_TOKEN_KIND_NOT_EQUAL discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_IS, 0]) {
        [self match:XPEG_TOKEN_KIND_IS discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_VALEQ, 0]) {
        [self valEq_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_VALNE, 0]) {
        [self valNe_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'eqRelationalExpr'."];
    }
    [self relationalExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchEqRelationalExpr:)];
}

- (void)eqRelationalExpr_ {
    [self parseRule:@selector(__eqRelationalExpr) withMemo:_eqRelationalExpr_memo];
}

- (void)__relationalExpr {
    
    [self additiveExpr_]; 
    while ([self speculate:^{ [self compareAdditiveExpr_]; }]) {
        [self compareAdditiveExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelationalExpr:)];
}

- (void)relationalExpr_ {
    [self parseRule:@selector(__relationalExpr) withMemo:_relationalExpr_memo];
}

- (void)__compareAdditiveExpr {
    
    if ([self predicts:XPEG_TOKEN_KIND_LT_SYM, 0]) {
        [self match:XPEG_TOKEN_KIND_LT_SYM discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_GT_SYM, 0]) {
        [self match:XPEG_TOKEN_KIND_GT_SYM discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_LE_SYM, 0]) {
        [self match:XPEG_TOKEN_KIND_LE_SYM discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_GE_SYM, 0]) {
        [self match:XPEG_TOKEN_KIND_GE_SYM discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_VALLT, 0]) {
        [self valLt_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_VALGT, 0]) {
        [self valGt_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_VALLE, 0]) {
        [self valLe_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_VALGE, 0]) {
        [self valGe_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_SHIFT_LEFT, 0]) {
        [self match:XPEG_TOKEN_KIND_SHIFT_LEFT discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_SHIFT_RIGHT, 0]) {
        [self match:XPEG_TOKEN_KIND_SHIFT_RIGHT discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'compareAdditiveExpr'."];
    }
    [self additiveExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchCompareAdditiveExpr:)];
}

- (void)compareAdditiveExpr_ {
    [self parseRule:@selector(__compareAdditiveExpr) withMemo:_compareAdditiveExpr_memo];
}

- (void)__additiveExpr {
    
    [self multiplicativeExpr_]; 
    while ([self speculate:^{ [self plusOrMinusMultiExpr_]; }]) {
        [self plusOrMinusMultiExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAdditiveExpr:)];
}

- (void)additiveExpr_ {
    [self parseRule:@selector(__additiveExpr) withMemo:_additiveExpr_memo];
}

- (void)__plusOrMinusMultiExpr {
    
    if ([self predicts:XPEG_TOKEN_KIND_PLUS, 0]) {
        [self match:XPEG_TOKEN_KIND_PLUS discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_MINUS, 0]) {
        [self match:XPEG_TOKEN_KIND_MINUS discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'plusOrMinusMultiExpr'."];
    }
    [self multiplicativeExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPlusOrMinusMultiExpr:)];
}

- (void)plusOrMinusMultiExpr_ {
    [self parseRule:@selector(__plusOrMinusMultiExpr) withMemo:_plusOrMinusMultiExpr_memo];
}

- (void)__multiplicativeExpr {
    
    [self unaryExpr_]; 
    while ([self speculate:^{ [self multDivOrModUnaryExpr_]; }]) {
        [self multDivOrModUnaryExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchMultiplicativeExpr:)];
}

- (void)multiplicativeExpr_ {
    [self parseRule:@selector(__multiplicativeExpr) withMemo:_multiplicativeExpr_memo];
}

- (void)__multDivOrModUnaryExpr {
    
    if ([self predicts:XPEG_TOKEN_KIND_MULTIPLYOPERATOR, 0]) {
        [self multiplyOperator_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DIV, 0]) {
        [self div_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_MOD, 0]) {
        [self mod_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'multDivOrModUnaryExpr'."];
    }
    [self unaryExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMultDivOrModUnaryExpr:)];
}

- (void)multDivOrModUnaryExpr_ {
    [self parseRule:@selector(__multDivOrModUnaryExpr) withMemo:_multDivOrModUnaryExpr_memo];
}

- (void)__multiplyOperator {
    
    [self match:XPEG_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchMultiplyOperator:)];
}

- (void)multiplyOperator_ {
    [self parseRule:@selector(__multiplyOperator) withMemo:_multiplyOperator_memo];
}

- (void)__unaryExpr {
    
    if ([self predicts:XPEG_TOKEN_KIND_MINUS, 0]) {
        [self minusUnionExpr_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XPEG_TOKEN_KIND_ABBREVIATEDAXIS, XPEG_TOKEN_KIND_ANCESTOR, XPEG_TOKEN_KIND_ANCESTORORSELF, XPEG_TOKEN_KIND_AND, XPEG_TOKEN_KIND_ATTR, XPEG_TOKEN_KIND_CHILD, XPEG_TOKEN_KIND_COMMENT, XPEG_TOKEN_KIND_DESCENDANT, XPEG_TOKEN_KIND_DESCENDANTORSELF, XPEG_TOKEN_KIND_DIV, XPEG_TOKEN_KIND_DOLLAR, XPEG_TOKEN_KIND_DOT, XPEG_TOKEN_KIND_DOT_DOT, XPEG_TOKEN_KIND_DOUBLE_SLASH, XPEG_TOKEN_KIND_FALSE, XPEG_TOKEN_KIND_FOLLOWING, XPEG_TOKEN_KIND_FOLLOWINGSIBLING, XPEG_TOKEN_KIND_FORWARD_SLASH, XPEG_TOKEN_KIND_MOD, XPEG_TOKEN_KIND_MULTIPLYOPERATOR, XPEG_TOKEN_KIND_NAMESPACE, XPEG_TOKEN_KIND_NODE, XPEG_TOKEN_KIND_OPEN_PAREN, XPEG_TOKEN_KIND_OR, XPEG_TOKEN_KIND_PARENT, XPEG_TOKEN_KIND_PRECEDING, XPEG_TOKEN_KIND_PRECEDINGSIBLING, XPEG_TOKEN_KIND_PROCESSINGINSTRUCTION, XPEG_TOKEN_KIND_SELF, XPEG_TOKEN_KIND_TEXT, XPEG_TOKEN_KIND_TRUE, 0]) {
        [self unionExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr:)];
}

- (void)unaryExpr_ {
    [self parseRule:@selector(__unaryExpr) withMemo:_unaryExpr_memo];
}

- (void)__minusUnionExpr {
    
    do {
        [self match:XPEG_TOKEN_KIND_MINUS discard:NO]; 
    } while ([self predicts:XPEG_TOKEN_KIND_MINUS, 0]);
    [self unionExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMinusUnionExpr:)];
}

- (void)minusUnionExpr_ {
    [self parseRule:@selector(__minusUnionExpr) withMemo:_minusUnionExpr_memo];
}

- (void)__unionExpr {
    
    [self intersectExceptExpr_]; 
    while ([self speculate:^{ [self unionTail_]; }]) {
        [self unionTail_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnionExpr:)];
}

- (void)unionExpr_ {
    [self parseRule:@selector(__unionExpr) withMemo:_unionExpr_memo];
}

- (void)__unionTail {
    
    if ([self predicts:XPEG_TOKEN_KIND_PIPE, 0]) {
        [self match:XPEG_TOKEN_KIND_PIPE discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_UNION, 0]) {
        [self match:XPEG_TOKEN_KIND_UNION discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unionTail'."];
    }
    [self intersectExceptExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchUnionTail:)];
}

- (void)unionTail_ {
    [self parseRule:@selector(__unionTail) withMemo:_unionTail_memo];
}

- (void)__intersectExceptExpr {
    
    [self pathExpr_]; 
    while ([self speculate:^{ [self intersectExceptTail_]; }]) {
        [self intersectExceptTail_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchIntersectExceptExpr:)];
}

- (void)intersectExceptExpr_ {
    [self parseRule:@selector(__intersectExceptExpr) withMemo:_intersectExceptExpr_memo];
}

- (void)__intersectExceptTail {
    
    if ([self predicts:XPEG_TOKEN_KIND_INTERSECT, 0]) {
        [self match:XPEG_TOKEN_KIND_INTERSECT discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_EXCEPT, 0]) {
        [self match:XPEG_TOKEN_KIND_EXCEPT discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'intersectExceptTail'."];
    }
    [self pathExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchIntersectExceptTail:)];
}

- (void)intersectExceptTail_ {
    [self parseRule:@selector(__intersectExceptTail) withMemo:_intersectExceptTail_memo];
}

- (void)__pathExpr {
    
    if ([self speculate:^{ [self filterPath_]; }]) {
        [self filterPath_]; 
    } else if ([self speculate:^{ [self locationPath_]; }]) {
        [self locationPath_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'pathExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPathExpr:)];
}

- (void)pathExpr_ {
    [self parseRule:@selector(__pathExpr) withMemo:_pathExpr_memo];
}

- (void)__filterPath {
    
    if ([self speculate:^{ [self complexFilterPath_]; }]) {
        [self complexFilterPath_]; 
    } else if ([self speculate:^{ [self filterExpr_]; }]) {
        [self filterExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'filterPath'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchFilterPath:)];
}

- (void)filterPath_ {
    [self parseRule:@selector(__filterPath) withMemo:_filterPath_memo];
}

- (void)__complexFilterPath {
    
    [self complexFilterPathStartExpr_]; 
    [self slashStep_]; 
    [self pathTail_]; 

    [self fireDelegateSelector:@selector(parser:didMatchComplexFilterPath:)];
}

- (void)complexFilterPath_ {
    [self parseRule:@selector(__complexFilterPath) withMemo:_complexFilterPath_memo];
}

- (void)__complexFilterPathStartExpr {
    
    [self filterExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchComplexFilterPathStartExpr:)];
}

- (void)complexFilterPathStartExpr_ {
    [self parseRule:@selector(__complexFilterPathStartExpr) withMemo:_complexFilterPathStartExpr_memo];
}

- (void)__locationPath {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, XPEG_TOKEN_KIND_ABBREVIATEDAXIS, XPEG_TOKEN_KIND_ANCESTOR, XPEG_TOKEN_KIND_ANCESTORORSELF, XPEG_TOKEN_KIND_AND, XPEG_TOKEN_KIND_ATTR, XPEG_TOKEN_KIND_CHILD, XPEG_TOKEN_KIND_COMMENT, XPEG_TOKEN_KIND_DESCENDANT, XPEG_TOKEN_KIND_DESCENDANTORSELF, XPEG_TOKEN_KIND_DIV, XPEG_TOKEN_KIND_DOT, XPEG_TOKEN_KIND_DOT_DOT, XPEG_TOKEN_KIND_FALSE, XPEG_TOKEN_KIND_FOLLOWING, XPEG_TOKEN_KIND_FOLLOWINGSIBLING, XPEG_TOKEN_KIND_MOD, XPEG_TOKEN_KIND_MULTIPLYOPERATOR, XPEG_TOKEN_KIND_NAMESPACE, XPEG_TOKEN_KIND_NODE, XPEG_TOKEN_KIND_OR, XPEG_TOKEN_KIND_PARENT, XPEG_TOKEN_KIND_PRECEDING, XPEG_TOKEN_KIND_PRECEDINGSIBLING, XPEG_TOKEN_KIND_PROCESSINGINSTRUCTION, XPEG_TOKEN_KIND_SELF, XPEG_TOKEN_KIND_TEXT, XPEG_TOKEN_KIND_TRUE, 0]) {
        [self relativeLocationPath_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DOUBLE_SLASH, XPEG_TOKEN_KIND_FORWARD_SLASH, 0]) {
        [self absoluteLocationPath_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'locationPath'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLocationPath:)];
}

- (void)locationPath_ {
    [self parseRule:@selector(__locationPath) withMemo:_locationPath_memo];
}

- (void)__relativeLocationPath {
    
    [self firstRelativeStep_]; 
    [self pathTail_]; 

    [self fireDelegateSelector:@selector(parser:didMatchRelativeLocationPath:)];
}

- (void)relativeLocationPath_ {
    [self parseRule:@selector(__relativeLocationPath) withMemo:_relativeLocationPath_memo];
}

- (void)__pathBody {
    
    [self step_]; 
    [self pathTail_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPathBody:)];
}

- (void)pathBody_ {
    [self parseRule:@selector(__pathBody) withMemo:_pathBody_memo];
}

- (void)__pathTail {
    
    while ([self speculate:^{ [self slashStep_]; }]) {
        [self slashStep_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchPathTail:)];
}

- (void)pathTail_ {
    [self parseRule:@selector(__pathTail) withMemo:_pathTail_memo];
}

- (void)__slashStep {
    
    if ([self predicts:XPEG_TOKEN_KIND_FORWARD_SLASH, 0]) {
        [self match:XPEG_TOKEN_KIND_FORWARD_SLASH discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DOUBLE_SLASH, 0]) {
        [self match:XPEG_TOKEN_KIND_DOUBLE_SLASH discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'slashStep'."];
    }
    [self step_]; 

    [self fireDelegateSelector:@selector(parser:didMatchSlashStep:)];
}

- (void)slashStep_ {
    [self parseRule:@selector(__slashStep) withMemo:_slashStep_memo];
}

- (void)__absoluteLocationPath {
    
    if ([self predicts:XPEG_TOKEN_KIND_FORWARD_SLASH, 0]) {
        [self rootSlash_]; 
        if ([self speculate:^{ [self pathBody_]; }]) {
            [self pathBody_]; 
        }
    } else if ([self predicts:XPEG_TOKEN_KIND_DOUBLE_SLASH, 0]) {
        [self abbreviatedAbsoluteLocationPath_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'absoluteLocationPath'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAbsoluteLocationPath:)];
}

- (void)absoluteLocationPath_ {
    [self parseRule:@selector(__absoluteLocationPath) withMemo:_absoluteLocationPath_memo];
}

- (void)__abbreviatedAbsoluteLocationPath {
    
    [self rootDoubleSlash_]; 
    [self pathBody_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAbbreviatedAbsoluteLocationPath:)];
}

- (void)abbreviatedAbsoluteLocationPath_ {
    [self parseRule:@selector(__abbreviatedAbsoluteLocationPath) withMemo:_abbreviatedAbsoluteLocationPath_memo];
}

- (void)__rootSlash {
    
    [self match:XPEG_TOKEN_KIND_FORWARD_SLASH discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchRootSlash:)];
}

- (void)rootSlash_ {
    [self parseRule:@selector(__rootSlash) withMemo:_rootSlash_memo];
}

- (void)__rootDoubleSlash {
    
    [self match:XPEG_TOKEN_KIND_DOUBLE_SLASH discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchRootDoubleSlash:)];
}

- (void)rootDoubleSlash_ {
    [self parseRule:@selector(__rootDoubleSlash) withMemo:_rootDoubleSlash_memo];
}

- (void)__firstRelativeStep {
    
    [self step_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFirstRelativeStep:)];
}

- (void)firstRelativeStep_ {
    [self parseRule:@selector(__firstRelativeStep) withMemo:_firstRelativeStep_memo];
}

- (void)__filterExpr {
    
    [self primaryExpr_]; 
    while ([self speculate:^{ [self predicate_]; }]) {
        [self predicate_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchFilterExpr:)];
}

- (void)filterExpr_ {
    [self parseRule:@selector(__filterExpr) withMemo:_filterExpr_memo];
}

- (void)__primaryExpr {
    
    if ([self predicts:XPEG_TOKEN_KIND_DOLLAR, 0]) {
        [self variableReference_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self literal_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self number_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, XPEG_TOKEN_KIND_ANCESTOR, XPEG_TOKEN_KIND_ANCESTORORSELF, XPEG_TOKEN_KIND_AND, XPEG_TOKEN_KIND_ATTR, XPEG_TOKEN_KIND_CHILD, XPEG_TOKEN_KIND_COMMENT, XPEG_TOKEN_KIND_DESCENDANT, XPEG_TOKEN_KIND_DESCENDANTORSELF, XPEG_TOKEN_KIND_DIV, XPEG_TOKEN_KIND_FALSE, XPEG_TOKEN_KIND_FOLLOWING, XPEG_TOKEN_KIND_FOLLOWINGSIBLING, XPEG_TOKEN_KIND_MOD, XPEG_TOKEN_KIND_NAMESPACE, XPEG_TOKEN_KIND_NODE, XPEG_TOKEN_KIND_OR, XPEG_TOKEN_KIND_PARENT, XPEG_TOKEN_KIND_PRECEDING, XPEG_TOKEN_KIND_PRECEDINGSIBLING, XPEG_TOKEN_KIND_PROCESSINGINSTRUCTION, XPEG_TOKEN_KIND_SELF, XPEG_TOKEN_KIND_TEXT, XPEG_TOKEN_KIND_TRUE, 0]) {
        [self functionCall_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self parenthesizedExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimaryExpr:)];
}

- (void)primaryExpr_ {
    [self parseRule:@selector(__primaryExpr) withMemo:_primaryExpr_memo];
}

- (void)__variableReference {
    
    [self match:XPEG_TOKEN_KIND_DOLLAR discard:NO]; 
    [self qName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchVariableReference:)];
}

- (void)variableReference_ {
    [self parseRule:@selector(__variableReference) withMemo:_variableReference_memo];
}

- (void)__literal {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)literal_ {
    [self parseRule:@selector(__literal) withMemo:_literal_memo];
}

- (void)__number {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNumber:)];
}

- (void)number_ {
    [self parseRule:@selector(__number) withMemo:_number_memo];
}

- (void)__parenthesizedExpr {
    
    [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    if ([self speculate:^{ [self expr_]; }]) {
        [self expr_]; 
    }
    [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchParenthesizedExpr:)];
}

- (void)parenthesizedExpr_ {
    [self parseRule:@selector(__parenthesizedExpr) withMemo:_parenthesizedExpr_memo];
}

- (void)__functionCall {
    
    if ([self speculate:^{ [self actualFunctionCall_]; }]) {
        [self actualFunctionCall_]; 
    } else if ([self speculate:^{ [self booleanLiteralFunctionCall_]; }]) {
        [self booleanLiteralFunctionCall_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'functionCall'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchFunctionCall:)];
}

- (void)functionCall_ {
    [self parseRule:@selector(__functionCall) withMemo:_functionCall_memo];
}

- (void)__actualFunctionCall {
    
    [self functionName_]; 
    [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    if ([self speculate:^{ [self argList_]; }]) {
        [self argList_]; 
    }
    [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchActualFunctionCall:)];
}

- (void)actualFunctionCall_ {
    [self parseRule:@selector(__actualFunctionCall) withMemo:_actualFunctionCall_memo];
}

- (void)__argList {
    
    [self argument_]; 
    while ([self speculate:^{ [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; [self argument_]; }]) {
        [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; 
        [self argument_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchArgList:)];
}

- (void)argList_ {
    [self parseRule:@selector(__argList) withMemo:_argList_memo];
}

- (void)__booleanLiteralFunctionCall {
    
    [self booleanLiteral_]; 
    [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchBooleanLiteralFunctionCall:)];
}

- (void)booleanLiteralFunctionCall_ {
    [self parseRule:@selector(__booleanLiteralFunctionCall) withMemo:_booleanLiteralFunctionCall_memo];
}

- (void)__functionName {
    
    [self testAndThrow:(id)^{ return NE(LS(1), @"true") && NE(LS(1), @"false") && NE(LS(1), @"comment") && NE(LS(1), @"text") && NE(LS(1), @"processing-instruction") && NE(LS(1), @"node"); }]; 
    [self qName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFunctionName:)];
}

- (void)functionName_ {
    [self parseRule:@selector(__functionName) withMemo:_functionName_memo];
}

- (void)__booleanLiteral {
    
    if ([self predicts:XPEG_TOKEN_KIND_TRUE, 0]) {
        [self true_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_FALSE, 0]) {
        [self false_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'booleanLiteral'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBooleanLiteral:)];
}

- (void)booleanLiteral_ {
    [self parseRule:@selector(__booleanLiteral) withMemo:_booleanLiteral_memo];
}

- (void)__qName {
    
    if ([self speculate:^{ [self prefix_]; [self match:XPEG_TOKEN_KIND_COLON discard:NO]; }]) {
        [self prefix_]; 
        [self match:XPEG_TOKEN_KIND_COLON discard:NO]; 
    }
    [self localPart_]; 

    [self fireDelegateSelector:@selector(parser:didMatchQName:)];
}

- (void)qName_ {
    [self parseRule:@selector(__qName) withMemo:_qName_memo];
}

- (void)__prefix {
    
    [self ncName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPrefix:)];
}

- (void)prefix_ {
    [self parseRule:@selector(__prefix) withMemo:_prefix_memo];
}

- (void)__localPart {
    
    [self ncName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchLocalPart:)];
}

- (void)localPart_ {
    [self parseRule:@selector(__localPart) withMemo:_localPart_memo];
}

- (void)__ncName {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self matchWord:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_ANCESTOR, XPEG_TOKEN_KIND_ANCESTORORSELF, XPEG_TOKEN_KIND_AND, XPEG_TOKEN_KIND_ATTR, XPEG_TOKEN_KIND_CHILD, XPEG_TOKEN_KIND_COMMENT, XPEG_TOKEN_KIND_DESCENDANT, XPEG_TOKEN_KIND_DESCENDANTORSELF, XPEG_TOKEN_KIND_DIV, XPEG_TOKEN_KIND_FALSE, XPEG_TOKEN_KIND_FOLLOWING, XPEG_TOKEN_KIND_FOLLOWINGSIBLING, XPEG_TOKEN_KIND_MOD, XPEG_TOKEN_KIND_NAMESPACE, XPEG_TOKEN_KIND_NODE, XPEG_TOKEN_KIND_OR, XPEG_TOKEN_KIND_PARENT, XPEG_TOKEN_KIND_PRECEDING, XPEG_TOKEN_KIND_PRECEDINGSIBLING, XPEG_TOKEN_KIND_PROCESSINGINSTRUCTION, XPEG_TOKEN_KIND_SELF, XPEG_TOKEN_KIND_TEXT, XPEG_TOKEN_KIND_TRUE, 0]) {
        [self keyword_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'ncName'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNcName:)];
}

- (void)ncName_ {
    [self parseRule:@selector(__ncName) withMemo:_ncName_memo];
}

- (void)__argument {
    
    [self exprSingle_]; 

    [self fireDelegateSelector:@selector(parser:didMatchArgument:)];
}

- (void)argument_ {
    [self parseRule:@selector(__argument) withMemo:_argument_memo];
}

- (void)__predicate {
    
    [self match:XPEG_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self predicateExpr_]; 
    [self match:XPEG_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPredicate:)];
}

- (void)predicate_ {
    [self parseRule:@selector(__predicate) withMemo:_predicate_memo];
}

- (void)__predicateExpr {
    
    [self expr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPredicateExpr:)];
}

- (void)predicateExpr_ {
    [self parseRule:@selector(__predicateExpr) withMemo:_predicateExpr_memo];
}

- (void)__step {
    
    if ([self speculate:^{ [self explicitAxisStep_]; }]) {
        [self explicitAxisStep_]; 
    } else if ([self speculate:^{ [self abbreviatedStep_]; }]) {
        [self abbreviatedStep_]; 
    } else if ([self speculate:^{ [self implicitAxisStep_]; }]) {
        [self implicitAxisStep_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'step'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStep:)];
}

- (void)step_ {
    [self parseRule:@selector(__step) withMemo:_step_memo];
}

- (void)__explicitAxisStep {
    
    [self axis_]; 
    [self stepBody_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExplicitAxisStep:)];
}

- (void)explicitAxisStep_ {
    [self parseRule:@selector(__explicitAxisStep) withMemo:_explicitAxisStep_memo];
}

- (void)__implicitAxisStep {
    
    [self stepBody_]; 

    [self fireDelegateSelector:@selector(parser:didMatchImplicitAxisStep:)];
}

- (void)implicitAxisStep_ {
    [self parseRule:@selector(__implicitAxisStep) withMemo:_implicitAxisStep_memo];
}

- (void)__axis {
    
    if ([self predicts:XPEG_TOKEN_KIND_ANCESTOR, XPEG_TOKEN_KIND_ANCESTORORSELF, XPEG_TOKEN_KIND_ATTR, XPEG_TOKEN_KIND_CHILD, XPEG_TOKEN_KIND_DESCENDANT, XPEG_TOKEN_KIND_DESCENDANTORSELF, XPEG_TOKEN_KIND_FOLLOWING, XPEG_TOKEN_KIND_FOLLOWINGSIBLING, XPEG_TOKEN_KIND_NAMESPACE, XPEG_TOKEN_KIND_PARENT, XPEG_TOKEN_KIND_PRECEDING, XPEG_TOKEN_KIND_PRECEDINGSIBLING, XPEG_TOKEN_KIND_SELF, 0]) {
        [self axisName_]; 
        [self match:XPEG_TOKEN_KIND_DOUBLE_COLON discard:YES]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_ABBREVIATEDAXIS, 0]) {
        [self abbreviatedAxis_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'axis'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAxis:)];
}

- (void)axis_ {
    [self parseRule:@selector(__axis) withMemo:_axis_memo];
}

- (void)__axisName {
    
    if ([self predicts:XPEG_TOKEN_KIND_ANCESTOR, 0]) {
        [self ancestor_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_ANCESTORORSELF, 0]) {
        [self ancestorOrSelf_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_ATTR, 0]) {
        [self attr_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_CHILD, 0]) {
        [self child_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DESCENDANT, 0]) {
        [self descendant_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DESCENDANTORSELF, 0]) {
        [self descendantOrSelf_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_FOLLOWING, 0]) {
        [self following_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_FOLLOWINGSIBLING, 0]) {
        [self followingSibling_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_NAMESPACE, 0]) {
        [self namespace_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PARENT, 0]) {
        [self parent_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PRECEDING, 0]) {
        [self preceding_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PRECEDINGSIBLING, 0]) {
        [self precedingSibling_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_SELF, 0]) {
        [self self_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'axisName'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAxisName:)];
}

- (void)axisName_ {
    [self parseRule:@selector(__axisName) withMemo:_axisName_memo];
}

- (void)__abbreviatedAxis {
    
    [self match:XPEG_TOKEN_KIND_ABBREVIATEDAXIS discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAbbreviatedAxis:)];
}

- (void)abbreviatedAxis_ {
    [self parseRule:@selector(__abbreviatedAxis) withMemo:_abbreviatedAxis_memo];
}

- (void)__stepBody {
    
    [self nodeTest_]; 
    while ([self speculate:^{ [self predicate_]; }]) {
        [self predicate_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchStepBody:)];
}

- (void)stepBody_ {
    [self parseRule:@selector(__stepBody) withMemo:_stepBody_memo];
}

- (void)__nodeTest {
    
    if ([self speculate:^{ [self typeTest_]; }]) {
        [self typeTest_]; 
    } else if ([self speculate:^{ [self specificPITest_]; }]) {
        [self specificPITest_]; 
    } else if ([self speculate:^{ [self nameTest_]; }]) {
        [self nameTest_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'nodeTest'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNodeTest:)];
}

- (void)nodeTest_ {
    [self parseRule:@selector(__nodeTest) withMemo:_nodeTest_memo];
}

- (void)__nameTest {
    
    if ([self speculate:^{ [self match:XPEG_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; [self match:XPEG_TOKEN_KIND_COLON discard:NO]; [self ncName_]; }]) {
        [self match:XPEG_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; 
        [self match:XPEG_TOKEN_KIND_COLON discard:NO]; 
        [self ncName_]; 
    } else if ([self speculate:^{ [self match:XPEG_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; }]) {
        [self match:XPEG_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; 
    } else if ([self speculate:^{ [self ncName_]; [self match:XPEG_TOKEN_KIND_COLON discard:NO]; [self match:XPEG_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; }]) {
        [self ncName_]; 
        [self match:XPEG_TOKEN_KIND_COLON discard:NO]; 
        [self match:XPEG_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; 
    } else if ([self speculate:^{ [self qName_]; }]) {
        [self qName_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'nameTest'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNameTest:)];
}

- (void)nameTest_ {
    [self parseRule:@selector(__nameTest) withMemo:_nameTest_memo];
}

- (void)__typeTest {
    
    [self nodeType_]; 
    [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchTypeTest:)];
}

- (void)typeTest_ {
    [self parseRule:@selector(__typeTest) withMemo:_typeTest_memo];
}

- (void)__nodeType {
    
    if ([self predicts:XPEG_TOKEN_KIND_COMMENT, 0]) {
        [self comment_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_TEXT, 0]) {
        [self text_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PROCESSINGINSTRUCTION, 0]) {
        [self processingInstruction_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_NODE, 0]) {
        [self node_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'nodeType'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNodeType:)];
}

- (void)nodeType_ {
    [self parseRule:@selector(__nodeType) withMemo:_nodeType_memo];
}

- (void)__specificPITest {
    
    [self processingInstruction_]; 
    [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self literal_]; 
    [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchSpecificPITest:)];
}

- (void)specificPITest_ {
    [self parseRule:@selector(__specificPITest) withMemo:_specificPITest_memo];
}

- (void)__abbreviatedStep {
    
    if ([self predicts:XPEG_TOKEN_KIND_DOT, 0]) {
        [self match:XPEG_TOKEN_KIND_DOT discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DOT_DOT, 0]) {
        [self match:XPEG_TOKEN_KIND_DOT_DOT discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'abbreviatedStep'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAbbreviatedStep:)];
}

- (void)abbreviatedStep_ {
    [self parseRule:@selector(__abbreviatedStep) withMemo:_abbreviatedStep_memo];
}

- (void)__ancestor {
    
    [self match:XPEG_TOKEN_KIND_ANCESTOR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAncestor:)];
}

- (void)ancestor_ {
    [self parseRule:@selector(__ancestor) withMemo:_ancestor_memo];
}

- (void)__ancestorOrSelf {
    
    [self match:XPEG_TOKEN_KIND_ANCESTORORSELF discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAncestorOrSelf:)];
}

- (void)ancestorOrSelf_ {
    [self parseRule:@selector(__ancestorOrSelf) withMemo:_ancestorOrSelf_memo];
}

- (void)__attr {
    
    [self match:XPEG_TOKEN_KIND_ATTR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAttr:)];
}

- (void)attr_ {
    [self parseRule:@selector(__attr) withMemo:_attr_memo];
}

- (void)__child {
    
    [self match:XPEG_TOKEN_KIND_CHILD discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchChild:)];
}

- (void)child_ {
    [self parseRule:@selector(__child) withMemo:_child_memo];
}

- (void)__descendant {
    
    [self match:XPEG_TOKEN_KIND_DESCENDANT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDescendant:)];
}

- (void)descendant_ {
    [self parseRule:@selector(__descendant) withMemo:_descendant_memo];
}

- (void)__descendantOrSelf {
    
    [self match:XPEG_TOKEN_KIND_DESCENDANTORSELF discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDescendantOrSelf:)];
}

- (void)descendantOrSelf_ {
    [self parseRule:@selector(__descendantOrSelf) withMemo:_descendantOrSelf_memo];
}

- (void)__following {
    
    [self match:XPEG_TOKEN_KIND_FOLLOWING discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchFollowing:)];
}

- (void)following_ {
    [self parseRule:@selector(__following) withMemo:_following_memo];
}

- (void)__followingSibling {
    
    [self match:XPEG_TOKEN_KIND_FOLLOWINGSIBLING discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchFollowingSibling:)];
}

- (void)followingSibling_ {
    [self parseRule:@selector(__followingSibling) withMemo:_followingSibling_memo];
}

- (void)__namespace {
    
    [self match:XPEG_TOKEN_KIND_NAMESPACE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNamespace:)];
}

- (void)namespace_ {
    [self parseRule:@selector(__namespace) withMemo:_namespace_memo];
}

- (void)__parent {
    
    [self match:XPEG_TOKEN_KIND_PARENT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchParent:)];
}

- (void)parent_ {
    [self parseRule:@selector(__parent) withMemo:_parent_memo];
}

- (void)__preceding {
    
    [self match:XPEG_TOKEN_KIND_PRECEDING discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPreceding:)];
}

- (void)preceding_ {
    [self parseRule:@selector(__preceding) withMemo:_preceding_memo];
}

- (void)__precedingSibling {
    
    [self match:XPEG_TOKEN_KIND_PRECEDINGSIBLING discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPrecedingSibling:)];
}

- (void)precedingSibling_ {
    [self parseRule:@selector(__precedingSibling) withMemo:_precedingSibling_memo];
}

- (void)__self {
    
    [self match:XPEG_TOKEN_KIND_SELF discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchSelf:)];
}

- (void)self_ {
    [self parseRule:@selector(__self) withMemo:_self_memo];
}

- (void)__div {
    
    [self match:XPEG_TOKEN_KIND_DIV discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDiv:)];
}

- (void)div_ {
    [self parseRule:@selector(__div) withMemo:_div_memo];
}

- (void)__mod {
    
    [self match:XPEG_TOKEN_KIND_MOD discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchMod:)];
}

- (void)mod_ {
    [self parseRule:@selector(__mod) withMemo:_mod_memo];
}

- (void)__to {
    
    [self match:XPEG_TOKEN_KIND_TO discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchTo:)];
}

- (void)to_ {
    [self parseRule:@selector(__to) withMemo:_to_memo];
}

- (void)__for {
    
    [self match:XPEG_TOKEN_KIND_FOR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchFor:)];
}

- (void)for_ {
    [self parseRule:@selector(__for) withMemo:_for_memo];
}

- (void)__let {
    
    [self match:XPEG_TOKEN_KIND_LET discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLet:)];
}

- (void)let_ {
    [self parseRule:@selector(__let) withMemo:_let_memo];
}

- (void)__in {
    
    [self match:XPEG_TOKEN_KIND_IN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchIn:)];
}

- (void)in_ {
    [self parseRule:@selector(__in) withMemo:_in_memo];
}

- (void)__return {
    
    [self match:XPEG_TOKEN_KIND_RETURN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchReturn:)];
}

- (void)return_ {
    [self parseRule:@selector(__return) withMemo:_return_memo];
}

- (void)__satisfies {
    
    [self match:XPEG_TOKEN_KIND_SATISFIES discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchSatisfies:)];
}

- (void)satisfies_ {
    [self parseRule:@selector(__satisfies) withMemo:_satisfies_memo];
}

- (void)__or {
    
    [self match:XPEG_TOKEN_KIND_OR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchOr:)];
}

- (void)or_ {
    [self parseRule:@selector(__or) withMemo:_or_memo];
}

- (void)__and {
    
    [self match:XPEG_TOKEN_KIND_AND discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAnd:)];
}

- (void)and_ {
    [self parseRule:@selector(__and) withMemo:_and_memo];
}

- (void)__true {
    
    [self match:XPEG_TOKEN_KIND_TRUE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchTrue:)];
}

- (void)true_ {
    [self parseRule:@selector(__true) withMemo:_true_memo];
}

- (void)__false {
    
    [self match:XPEG_TOKEN_KIND_FALSE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchFalse:)];
}

- (void)false_ {
    [self parseRule:@selector(__false) withMemo:_false_memo];
}

- (void)__comment {
    
    [self match:XPEG_TOKEN_KIND_COMMENT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchComment:)];
}

- (void)comment_ {
    [self parseRule:@selector(__comment) withMemo:_comment_memo];
}

- (void)__text {
    
    [self match:XPEG_TOKEN_KIND_TEXT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchText:)];
}

- (void)text_ {
    [self parseRule:@selector(__text) withMemo:_text_memo];
}

- (void)__processingInstruction {
    
    [self match:XPEG_TOKEN_KIND_PROCESSINGINSTRUCTION discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchProcessingInstruction:)];
}

- (void)processingInstruction_ {
    [self parseRule:@selector(__processingInstruction) withMemo:_processingInstruction_memo];
}

- (void)__node {
    
    [self match:XPEG_TOKEN_KIND_NODE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNode:)];
}

- (void)node_ {
    [self parseRule:@selector(__node) withMemo:_node_memo];
}

- (void)__valEq {
    
    [self match:XPEG_TOKEN_KIND_VALEQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchValEq:)];
}

- (void)valEq_ {
    [self parseRule:@selector(__valEq) withMemo:_valEq_memo];
}

- (void)__valNe {
    
    [self match:XPEG_TOKEN_KIND_VALNE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchValNe:)];
}

- (void)valNe_ {
    [self parseRule:@selector(__valNe) withMemo:_valNe_memo];
}

- (void)__valLt {
    
    [self match:XPEG_TOKEN_KIND_VALLT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchValLt:)];
}

- (void)valLt_ {
    [self parseRule:@selector(__valLt) withMemo:_valLt_memo];
}

- (void)__valGt {
    
    [self match:XPEG_TOKEN_KIND_VALGT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchValGt:)];
}

- (void)valGt_ {
    [self parseRule:@selector(__valGt) withMemo:_valGt_memo];
}

- (void)__valLe {
    
    [self match:XPEG_TOKEN_KIND_VALLE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchValLe:)];
}

- (void)valLe_ {
    [self parseRule:@selector(__valLe) withMemo:_valLe_memo];
}

- (void)__valGe {
    
    [self match:XPEG_TOKEN_KIND_VALGE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchValGe:)];
}

- (void)valGe_ {
    [self parseRule:@selector(__valGe) withMemo:_valGe_memo];
}

- (void)__declare {
    
    [self match:XPEG_TOKEN_KIND_DECLARE discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchDeclare:)];
}

- (void)declare_ {
    [self parseRule:@selector(__declare) withMemo:_declare_memo];
}

- (void)__variable {
    
    [self match:XPEG_TOKEN_KIND_VARIABLE discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchVariable:)];
}

- (void)variable_ {
    [self parseRule:@selector(__variable) withMemo:_variable_memo];
}

- (void)__function {
    
    [self match:XPEG_TOKEN_KIND_FUNCTION discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchFunction:)];
}

- (void)function_ {
    [self parseRule:@selector(__function) withMemo:_function_memo];
}

- (void)__keyword {
    
    if ([self predicts:XPEG_TOKEN_KIND_ANCESTOR, 0]) {
        [self ancestor_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_ANCESTORORSELF, 0]) {
        [self ancestorOrSelf_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_ATTR, 0]) {
        [self attr_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_CHILD, 0]) {
        [self child_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DESCENDANT, 0]) {
        [self descendant_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DESCENDANTORSELF, 0]) {
        [self descendantOrSelf_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_FOLLOWING, 0]) {
        [self following_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_FOLLOWINGSIBLING, 0]) {
        [self followingSibling_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_NAMESPACE, 0]) {
        [self namespace_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PARENT, 0]) {
        [self parent_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PRECEDING, 0]) {
        [self preceding_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PRECEDINGSIBLING, 0]) {
        [self precedingSibling_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_SELF, 0]) {
        [self self_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DIV, 0]) {
        [self div_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_MOD, 0]) {
        [self mod_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_OR, 0]) {
        [self or_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_AND, 0]) {
        [self and_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_TRUE, 0]) {
        [self true_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_FALSE, 0]) {
        [self false_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_COMMENT, 0]) {
        [self comment_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_TEXT, 0]) {
        [self text_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PROCESSINGINSTRUCTION, 0]) {
        [self processingInstruction_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_NODE, 0]) {
        [self node_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'keyword'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchKeyword:)];
}

- (void)keyword_ {
    [self parseRule:@selector(__keyword) withMemo:_keyword_memo];
}

@end
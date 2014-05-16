#import "XPEGParser.h"
#import <PEGKit/PEGKit.h>


@interface XPEGParser ()

@end

@implementation XPEGParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"stmt";
        self.tokenKindTab[@">="] = @(XPEG_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@"|"] = @(XPEG_TOKEN_KIND_PIPE);
        self.tokenKindTab[@"preceding-sibling"] = @(XPEG_TOKEN_KIND_PRECEDING_SIBLING);
        self.tokenKindTab[@"true"] = @(XPEG_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"parent"] = @(XPEG_TOKEN_KIND_PARENT);
        self.tokenKindTab[@"attribute"] = @(XPEG_TOKEN_KIND_ATTRIBUTE);
        self.tokenKindTab[@"mod"] = @(XPEG_TOKEN_KIND_MOD);
        self.tokenKindTab[@"!="] = @(XPEG_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"text"] = @(XPEG_TOKEN_KIND_TEXT);
        self.tokenKindTab[@"self"] = @(XPEG_TOKEN_KIND_SELF);
        self.tokenKindTab[@"comment"] = @(XPEG_TOKEN_KIND_COMMENT);
        self.tokenKindTab[@":"] = @(XPEG_TOKEN_KIND_COLON);
        self.tokenKindTab[@"child"] = @(XPEG_TOKEN_KIND_CHILD);
        self.tokenKindTab[@"div"] = @(XPEG_TOKEN_KIND_DIV);
        self.tokenKindTab[@"preceding"] = @(XPEG_TOKEN_KIND_PRECEDING);
        self.tokenKindTab[@"$"] = @(XPEG_TOKEN_KIND_DOLLAR);
        self.tokenKindTab[@"<"] = @(XPEG_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"following"] = @(XPEG_TOKEN_KIND_FOLLOWING);
        self.tokenKindTab[@"descendant"] = @(XPEG_TOKEN_KIND_DESCENDANT);
        self.tokenKindTab[@"="] = @(XPEG_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"following-sibling"] = @(XPEG_TOKEN_KIND_FOLLOWING_SIBLING);
        self.tokenKindTab[@"node"] = @(XPEG_TOKEN_KIND_NODE);
        self.tokenKindTab[@">"] = @(XPEG_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"::"] = @(XPEG_TOKEN_KIND_DOUBLE_COLON);
        self.tokenKindTab[@"namespace"] = @(XPEG_TOKEN_KIND_NAMESPACE);
        self.tokenKindTab[@".."] = @(XPEG_TOKEN_KIND_DOT_DOT);
        self.tokenKindTab[@"("] = @(XPEG_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"@"] = @(XPEG_TOKEN_KIND_ABBREVIATEDAXIS);
        self.tokenKindTab[@")"] = @(XPEG_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"//"] = @(XPEG_TOKEN_KIND_DOUBLE_SLASH);
        self.tokenKindTab[@"*"] = @(XPEG_TOKEN_KIND_MULTIPLYOPERATOR);
        self.tokenKindTab[@"or"] = @(XPEG_TOKEN_KIND_OR);
        self.tokenKindTab[@"+"] = @(XPEG_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"processing-instruction"] = @(XPEG_TOKEN_KIND_PROCESSING_INSTRUCTION);
        self.tokenKindTab[@"["] = @(XPEG_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@","] = @(XPEG_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"and"] = @(XPEG_TOKEN_KIND_AND);
        self.tokenKindTab[@"-"] = @(XPEG_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"ancestor"] = @(XPEG_TOKEN_KIND_ANCESTOR);
        self.tokenKindTab[@"]"] = @(XPEG_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"descendant-or-self"] = @(XPEG_TOKEN_KIND_DESCENDANT_OR_SELF);
        self.tokenKindTab[@"."] = @(XPEG_TOKEN_KIND_DOT);
        self.tokenKindTab[@"/"] = @(XPEG_TOKEN_KIND_FORWARD_SLASH);
        self.tokenKindTab[@"false"] = @(XPEG_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"<="] = @(XPEG_TOKEN_KIND_LE_SYM);
        self.tokenKindTab[@"ancestor-or-self"] = @(XPEG_TOKEN_KIND_ANCESTOR_OR_SELF);

        self.tokenKindNameTab[XPEG_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_PIPE] = @"|";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_PRECEDING_SIBLING] = @"preceding-sibling";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_PARENT] = @"parent";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ATTRIBUTE] = @"attribute";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_MOD] = @"mod";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_TEXT] = @"text";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_SELF] = @"self";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_COMMENT] = @"comment";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_COLON] = @":";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_CHILD] = @"child";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DIV] = @"div";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_PRECEDING] = @"preceding";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DOLLAR] = @"$";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_FOLLOWING] = @"following";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DESCENDANT] = @"descendant";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_FOLLOWING_SIBLING] = @"following-sibling";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_NODE] = @"node";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DOUBLE_COLON] = @"::";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_NAMESPACE] = @"namespace";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DOT_DOT] = @"..";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ABBREVIATEDAXIS] = @"@";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DOUBLE_SLASH] = @"//";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_MULTIPLYOPERATOR] = @"*";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_PROCESSING_INSTRUCTION] = @"processing-instruction";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ANCESTOR] = @"ancestor";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DESCENDANT_OR_SELF] = @"descendant-or-self";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_FORWARD_SLASH] = @"/";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_LE_SYM] = @"<=";
        self.tokenKindNameTab[XPEG_TOKEN_KIND_ANCESTOR_OR_SELF] = @"ancestor-or-self";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {
    [self execute:^{
    
        // TODO `$`

        PKTokenizer *t = self.tokenizer;
        [t.symbolState add:@"//"];
        [t.symbolState add:@".."];
        [t.symbolState add:@"!="];
        [t.symbolState add:@"::"];
        [t.symbolState add:@"<="];
        [t.symbolState add:@"=>"];
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

    [self stmt_]; 
    [self matchEOF:YES]; 

}

- (void)stmt_ {
    
    [self expr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchStmt:)];
}

- (void)expr_ {
    
    [self orExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)orExpr_ {
    
    [self andExpr_]; 
    while ([self speculate:^{ [self orAndExpr_]; }]) {
        [self orAndExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)orAndExpr_ {
    
    [self match:XPEG_TOKEN_KIND_OR discard:NO]; 
    [self andExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchOrAndExpr:)];
}

- (void)andExpr_ {
    
    [self equalityExpr_]; 
    while ([self speculate:^{ [self andEqualityExpr_]; }]) {
        [self andEqualityExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
}

- (void)andEqualityExpr_ {
    
    [self match:XPEG_TOKEN_KIND_AND discard:NO]; 
    [self equalityExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAndEqualityExpr:)];
}

- (void)equalityExpr_ {
    
    [self relationalExpr_]; 
    while ([self speculate:^{ [self eqRelationalExpr_]; }]) {
        [self eqRelationalExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchEqualityExpr:)];
}

- (void)eqRelationalExpr_ {
    
    if ([self predicts:XPEG_TOKEN_KIND_EQUALS, 0]) {
        [self match:XPEG_TOKEN_KIND_EQUALS discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_NOT_EQUAL, 0]) {
        [self match:XPEG_TOKEN_KIND_NOT_EQUAL discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'eqRelationalExpr'."];
    }
    [self relationalExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchEqRelationalExpr:)];
}

- (void)relationalExpr_ {
    
    [self additiveExpr_]; 
    while ([self speculate:^{ [self compareAdditiveExpr_]; }]) {
        [self compareAdditiveExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelationalExpr:)];
}

- (void)compareAdditiveExpr_ {
    
    if ([self predicts:XPEG_TOKEN_KIND_LT_SYM, 0]) {
        [self match:XPEG_TOKEN_KIND_LT_SYM discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_GT_SYM, 0]) {
        [self match:XPEG_TOKEN_KIND_GT_SYM discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_LE_SYM, 0]) {
        [self match:XPEG_TOKEN_KIND_LE_SYM discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_GE_SYM, 0]) {
        [self match:XPEG_TOKEN_KIND_GE_SYM discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'compareAdditiveExpr'."];
    }
    [self additiveExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchCompareAdditiveExpr:)];
}

- (void)additiveExpr_ {
    
    [self multiplicativeExpr_]; 
    while ([self speculate:^{ [self plusOrMinusMultiExpr_]; }]) {
        [self plusOrMinusMultiExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAdditiveExpr:)];
}

- (void)plusOrMinusMultiExpr_ {
    
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

- (void)multiplicativeExpr_ {
    
    [self unaryExpr_]; 
    while ([self speculate:^{ [self multDivOrModUnaryExpr_]; }]) {
        [self multDivOrModUnaryExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchMultiplicativeExpr:)];
}

- (void)multDivOrModUnaryExpr_ {
    
    if ([self predicts:XPEG_TOKEN_KIND_MULTIPLYOPERATOR, 0]) {
        [self multiplyOperator_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DIV, 0]) {
        [self match:XPEG_TOKEN_KIND_DIV discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_MOD, 0]) {
        [self match:XPEG_TOKEN_KIND_MOD discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'multDivOrModUnaryExpr'."];
    }
    [self unaryExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMultDivOrModUnaryExpr:)];
}

- (void)multiplyOperator_ {
    
    [self match:XPEG_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchMultiplyOperator:)];
}

- (void)unaryExpr_ {
    
    if ([self predicts:XPEG_TOKEN_KIND_MINUS, 0]) {
        [self minusUnionExpr_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XPEG_TOKEN_KIND_ABBREVIATEDAXIS, XPEG_TOKEN_KIND_ANCESTOR, XPEG_TOKEN_KIND_ANCESTOR_OR_SELF, XPEG_TOKEN_KIND_ATTRIBUTE, XPEG_TOKEN_KIND_CHILD, XPEG_TOKEN_KIND_COMMENT, XPEG_TOKEN_KIND_DESCENDANT, XPEG_TOKEN_KIND_DESCENDANT_OR_SELF, XPEG_TOKEN_KIND_DOLLAR, XPEG_TOKEN_KIND_DOT, XPEG_TOKEN_KIND_DOT_DOT, XPEG_TOKEN_KIND_DOUBLE_SLASH, XPEG_TOKEN_KIND_FALSE, XPEG_TOKEN_KIND_FOLLOWING, XPEG_TOKEN_KIND_FOLLOWING_SIBLING, XPEG_TOKEN_KIND_FORWARD_SLASH, XPEG_TOKEN_KIND_MULTIPLYOPERATOR, XPEG_TOKEN_KIND_NAMESPACE, XPEG_TOKEN_KIND_NODE, XPEG_TOKEN_KIND_OPEN_PAREN, XPEG_TOKEN_KIND_PARENT, XPEG_TOKEN_KIND_PRECEDING, XPEG_TOKEN_KIND_PRECEDING_SIBLING, XPEG_TOKEN_KIND_PROCESSING_INSTRUCTION, XPEG_TOKEN_KIND_SELF, XPEG_TOKEN_KIND_TEXT, XPEG_TOKEN_KIND_TRUE, 0]) {
        [self unionExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr:)];
}

- (void)minusUnionExpr_ {
    
    do {
        [self match:XPEG_TOKEN_KIND_MINUS discard:NO]; 
    } while ([self predicts:XPEG_TOKEN_KIND_MINUS, 0]);
    [self unionExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMinusUnionExpr:)];
}

- (void)unionExpr_ {
    
    [self pathExpr_]; 
    while ([self speculate:^{ [self unionTail_]; }]) {
        [self unionTail_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnionExpr:)];
}

- (void)unionTail_ {
    
    [self match:XPEG_TOKEN_KIND_PIPE discard:NO]; 
    [self pathExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchUnionTail:)];
}

- (void)pathExpr_ {
    
    if ([self speculate:^{ [self filterPath_]; }]) {
        [self filterPath_]; 
    } else if ([self speculate:^{ [self locationPath_]; }]) {
        [self locationPath_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'pathExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPathExpr:)];
}

- (void)filterPath_ {
    
    [self filterExpr_]; 
    [self pathTail_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFilterPath:)];
}

- (void)locationPath_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, XPEG_TOKEN_KIND_ABBREVIATEDAXIS, XPEG_TOKEN_KIND_ANCESTOR, XPEG_TOKEN_KIND_ANCESTOR_OR_SELF, XPEG_TOKEN_KIND_ATTRIBUTE, XPEG_TOKEN_KIND_CHILD, XPEG_TOKEN_KIND_COMMENT, XPEG_TOKEN_KIND_DESCENDANT, XPEG_TOKEN_KIND_DESCENDANT_OR_SELF, XPEG_TOKEN_KIND_DOT, XPEG_TOKEN_KIND_DOT_DOT, XPEG_TOKEN_KIND_FOLLOWING, XPEG_TOKEN_KIND_FOLLOWING_SIBLING, XPEG_TOKEN_KIND_MULTIPLYOPERATOR, XPEG_TOKEN_KIND_NAMESPACE, XPEG_TOKEN_KIND_NODE, XPEG_TOKEN_KIND_PARENT, XPEG_TOKEN_KIND_PRECEDING, XPEG_TOKEN_KIND_PRECEDING_SIBLING, XPEG_TOKEN_KIND_PROCESSING_INSTRUCTION, XPEG_TOKEN_KIND_SELF, XPEG_TOKEN_KIND_TEXT, 0]) {
        [self relativeLocationPath_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DOUBLE_SLASH, XPEG_TOKEN_KIND_FORWARD_SLASH, 0]) {
        [self absoluteLocationPath_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'locationPath'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLocationPath:)];
}

- (void)relativeLocationPath_ {
    
    [self firstRelativeStep_]; 
    [self pathTail_]; 

    [self fireDelegateSelector:@selector(parser:didMatchRelativeLocationPath:)];
}

- (void)pathBody_ {
    
    [self step_]; 
    [self pathTail_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPathBody:)];
}

- (void)pathTail_ {
    
    while ([self speculate:^{ if ([self predicts:XPEG_TOKEN_KIND_FORWARD_SLASH, 0]) {[self match:XPEG_TOKEN_KIND_FORWARD_SLASH discard:NO]; } else if ([self predicts:XPEG_TOKEN_KIND_DOUBLE_SLASH, 0]) {[self match:XPEG_TOKEN_KIND_DOUBLE_SLASH discard:NO]; } else {[self raise:@"No viable alternative found in rule 'pathTail'."];}[self step_]; }]) {
        if ([self predicts:XPEG_TOKEN_KIND_FORWARD_SLASH, 0]) {
            [self match:XPEG_TOKEN_KIND_FORWARD_SLASH discard:NO]; 
        } else if ([self predicts:XPEG_TOKEN_KIND_DOUBLE_SLASH, 0]) {
            [self match:XPEG_TOKEN_KIND_DOUBLE_SLASH discard:NO]; 
        } else {
            [self raise:@"No viable alternative found in rule 'pathTail'."];
        }
        [self step_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchPathTail:)];
}

- (void)absoluteLocationPath_ {
    
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

- (void)abbreviatedAbsoluteLocationPath_ {
    
    [self rootDoubleSlash_]; 
    [self pathBody_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAbbreviatedAbsoluteLocationPath:)];
}

- (void)rootSlash_ {
    
    [self match:XPEG_TOKEN_KIND_FORWARD_SLASH discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchRootSlash:)];
}

- (void)rootDoubleSlash_ {
    
    [self match:XPEG_TOKEN_KIND_DOUBLE_SLASH discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchRootDoubleSlash:)];
}

- (void)firstRelativeStep_ {
    
    [self step_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFirstRelativeStep:)];
}

- (void)filterExpr_ {
    
    [self primaryExpr_]; 
    while ([self speculate:^{ [self predicate_]; }]) {
        [self predicate_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchFilterExpr:)];
}

- (void)primaryExpr_ {
    
    if ([self predicts:XPEG_TOKEN_KIND_DOLLAR, 0]) {
        [self variableReference_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self literal_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self number_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, XPEG_TOKEN_KIND_FALSE, XPEG_TOKEN_KIND_TRUE, 0]) {
        [self functionCall_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:YES]; 
        [self expr_]; 
        [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimaryExpr:)];
}

- (void)variableReference_ {
    
    [self match:XPEG_TOKEN_KIND_DOLLAR discard:YES]; 
    [self qName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchVariableReference:)];
}

- (void)literal_ {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)number_ {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNumber:)];
}

- (void)functionCall_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self actualFunctionCall_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_FALSE, XPEG_TOKEN_KIND_TRUE, 0]) {
        [self booleanLiteralFunctionCall_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'functionCall'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchFunctionCall:)];
}

- (void)actualFunctionCall_ {
    
    [self functionName_]; 
    [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    if ([self speculate:^{ [self argument_]; while ([self speculate:^{ [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; [self argument_]; }]) {[self match:XPEG_TOKEN_KIND_COMMA discard:YES]; [self argument_]; }}]) {
        [self argument_]; 
        while ([self speculate:^{ [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; [self argument_]; }]) {
            [self match:XPEG_TOKEN_KIND_COMMA discard:YES]; 
            [self argument_]; 
        }
    }
    [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchActualFunctionCall:)];
}

- (void)booleanLiteralFunctionCall_ {
    
    [self booleanLiteral_]; 
    [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchBooleanLiteralFunctionCall:)];
}

- (void)functionName_ {
    
    [self testAndThrow:(id)^{ return NE(LS(1), @"true") && NE(LS(1), @"false") && NE(LS(1), @"comment") && NE(LS(1), @"text") && NE(LS(1), @"processing-instruction") && NE(LS(1), @"node"); }]; 
    [self qName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFunctionName:)];
}

- (void)booleanLiteral_ {
    
    if ([self predicts:XPEG_TOKEN_KIND_TRUE, 0]) {
        [self match:XPEG_TOKEN_KIND_TRUE discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_FALSE, 0]) {
        [self match:XPEG_TOKEN_KIND_FALSE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'booleanLiteral'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBooleanLiteral:)];
}

- (void)qName_ {
    
    if ([self speculate:^{ [self prefix_]; [self match:XPEG_TOKEN_KIND_COLON discard:NO]; }]) {
        [self prefix_]; 
        [self match:XPEG_TOKEN_KIND_COLON discard:NO]; 
    }
    [self localPart_]; 

    [self fireDelegateSelector:@selector(parser:didMatchQName:)];
}

- (void)prefix_ {
    
    [self ncName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPrefix:)];
}

- (void)localPart_ {
    
    [self ncName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchLocalPart:)];
}

- (void)ncName_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNcName:)];
}

- (void)argument_ {
    
    [self expr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchArgument:)];
}

- (void)predicate_ {
    
    [self match:XPEG_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self predicateExpr_]; 
    [self match:XPEG_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchPredicate:)];
}

- (void)predicateExpr_ {
    
    [self expr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPredicateExpr:)];
}

- (void)step_ {
    
    if ([self predicts:XPEG_TOKEN_KIND_ABBREVIATEDAXIS, XPEG_TOKEN_KIND_ANCESTOR, XPEG_TOKEN_KIND_ANCESTOR_OR_SELF, XPEG_TOKEN_KIND_ATTRIBUTE, XPEG_TOKEN_KIND_CHILD, XPEG_TOKEN_KIND_DESCENDANT, XPEG_TOKEN_KIND_DESCENDANT_OR_SELF, XPEG_TOKEN_KIND_FOLLOWING, XPEG_TOKEN_KIND_FOLLOWING_SIBLING, XPEG_TOKEN_KIND_NAMESPACE, XPEG_TOKEN_KIND_PARENT, XPEG_TOKEN_KIND_PRECEDING, XPEG_TOKEN_KIND_PRECEDING_SIBLING, XPEG_TOKEN_KIND_SELF, 0]) {
        [self explicitAxisStep_]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DOT, XPEG_TOKEN_KIND_DOT_DOT, 0]) {
        [self abbreviatedStep_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, XPEG_TOKEN_KIND_COMMENT, XPEG_TOKEN_KIND_MULTIPLYOPERATOR, XPEG_TOKEN_KIND_NODE, XPEG_TOKEN_KIND_PROCESSING_INSTRUCTION, XPEG_TOKEN_KIND_TEXT, 0]) {
        [self implicitAxisStep_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'step'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStep:)];
}

- (void)explicitAxisStep_ {
    
    [self axis_]; 
    [self stepBody_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExplicitAxisStep:)];
}

- (void)implicitAxisStep_ {
    
    [self stepBody_]; 

    [self fireDelegateSelector:@selector(parser:didMatchImplicitAxisStep:)];
}

- (void)axis_ {
    
    if ([self predicts:XPEG_TOKEN_KIND_ANCESTOR, XPEG_TOKEN_KIND_ANCESTOR_OR_SELF, XPEG_TOKEN_KIND_ATTRIBUTE, XPEG_TOKEN_KIND_CHILD, XPEG_TOKEN_KIND_DESCENDANT, XPEG_TOKEN_KIND_DESCENDANT_OR_SELF, XPEG_TOKEN_KIND_FOLLOWING, XPEG_TOKEN_KIND_FOLLOWING_SIBLING, XPEG_TOKEN_KIND_NAMESPACE, XPEG_TOKEN_KIND_PARENT, XPEG_TOKEN_KIND_PRECEDING, XPEG_TOKEN_KIND_PRECEDING_SIBLING, XPEG_TOKEN_KIND_SELF, 0]) {
        [self axisName_]; 
        [self match:XPEG_TOKEN_KIND_DOUBLE_COLON discard:YES]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_ABBREVIATEDAXIS, 0]) {
        [self abbreviatedAxis_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'axis'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAxis:)];
}

- (void)axisName_ {
    
    if ([self predicts:XPEG_TOKEN_KIND_ANCESTOR, 0]) {
        [self match:XPEG_TOKEN_KIND_ANCESTOR discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_ANCESTOR_OR_SELF, 0]) {
        [self match:XPEG_TOKEN_KIND_ANCESTOR_OR_SELF discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_ATTRIBUTE, 0]) {
        [self match:XPEG_TOKEN_KIND_ATTRIBUTE discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_CHILD, 0]) {
        [self match:XPEG_TOKEN_KIND_CHILD discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DESCENDANT, 0]) {
        [self match:XPEG_TOKEN_KIND_DESCENDANT discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DESCENDANT_OR_SELF, 0]) {
        [self match:XPEG_TOKEN_KIND_DESCENDANT_OR_SELF discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_FOLLOWING, 0]) {
        [self match:XPEG_TOKEN_KIND_FOLLOWING discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_FOLLOWING_SIBLING, 0]) {
        [self match:XPEG_TOKEN_KIND_FOLLOWING_SIBLING discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_NAMESPACE, 0]) {
        [self match:XPEG_TOKEN_KIND_NAMESPACE discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PARENT, 0]) {
        [self match:XPEG_TOKEN_KIND_PARENT discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PRECEDING, 0]) {
        [self match:XPEG_TOKEN_KIND_PRECEDING discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PRECEDING_SIBLING, 0]) {
        [self match:XPEG_TOKEN_KIND_PRECEDING_SIBLING discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_SELF, 0]) {
        [self match:XPEG_TOKEN_KIND_SELF discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'axisName'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAxisName:)];
}

- (void)abbreviatedAxis_ {
    
    [self match:XPEG_TOKEN_KIND_ABBREVIATEDAXIS discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchAbbreviatedAxis:)];
}

- (void)stepBody_ {
    
    [self nodeTest_]; 
    while ([self speculate:^{ [self predicate_]; }]) {
        [self predicate_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchStepBody:)];
}

- (void)nodeTest_ {
    
    if ([self speculate:^{ [self nameTest_]; }]) {
        [self nameTest_]; 
    } else if ([self speculate:^{ [self typeTest_]; }]) {
        [self typeTest_]; 
    } else if ([self speculate:^{ [self match:XPEG_TOKEN_KIND_PROCESSING_INSTRUCTION discard:NO]; [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:NO]; [self literal_]; [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:NO]; }]) {
        [self match:XPEG_TOKEN_KIND_PROCESSING_INSTRUCTION discard:NO]; 
        [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        [self literal_]; 
        [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'nodeTest'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNodeTest:)];
}

- (void)nameTest_ {
    
    if ([self speculate:^{ [self match:XPEG_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; }]) {
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

- (void)typeTest_ {
    
    [self nodeType_]; 
    [self match:XPEG_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self match:XPEG_TOKEN_KIND_CLOSE_PAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchTypeTest:)];
}

- (void)nodeType_ {
    
    if ([self predicts:XPEG_TOKEN_KIND_COMMENT, 0]) {
        [self match:XPEG_TOKEN_KIND_COMMENT discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_TEXT, 0]) {
        [self match:XPEG_TOKEN_KIND_TEXT discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_PROCESSING_INSTRUCTION, 0]) {
        [self match:XPEG_TOKEN_KIND_PROCESSING_INSTRUCTION discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_NODE, 0]) {
        [self match:XPEG_TOKEN_KIND_NODE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'nodeType'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNodeType:)];
}

- (void)abbreviatedStep_ {
    
    if ([self predicts:XPEG_TOKEN_KIND_DOT, 0]) {
        [self match:XPEG_TOKEN_KIND_DOT discard:NO]; 
    } else if ([self predicts:XPEG_TOKEN_KIND_DOT_DOT, 0]) {
        [self match:XPEG_TOKEN_KIND_DOT_DOT discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'abbreviatedStep'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAbbreviatedStep:)];
}

@end
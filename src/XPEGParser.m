#import "XPEGParser.h"
#import <PEGKit/PEGKit.h>


@interface XPEGParser ()

@end

@implementation XPEGParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"stmt";
        self.tokenKindTab[@">="] = @(XPEGPARSER_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@"|"] = @(XPEGPARSER_TOKEN_KIND_PIPE);
        self.tokenKindTab[@"preceding-sibling"] = @(XPEGPARSER_TOKEN_KIND_PRECEDING_SIBLING);
        self.tokenKindTab[@"true"] = @(XPEGPARSER_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"parent"] = @(XPEGPARSER_TOKEN_KIND_PARENT);
        self.tokenKindTab[@"attribute"] = @(XPEGPARSER_TOKEN_KIND_ATTRIBUTE);
        self.tokenKindTab[@"mod"] = @(XPEGPARSER_TOKEN_KIND_MOD);
        self.tokenKindTab[@"!="] = @(XPEGPARSER_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"text"] = @(XPEGPARSER_TOKEN_KIND_TEXT);
        self.tokenKindTab[@"self"] = @(XPEGPARSER_TOKEN_KIND_SELF);
        self.tokenKindTab[@"comment"] = @(XPEGPARSER_TOKEN_KIND_COMMENT);
        self.tokenKindTab[@":"] = @(XPEGPARSER_TOKEN_KIND_COLON);
        self.tokenKindTab[@"child"] = @(XPEGPARSER_TOKEN_KIND_CHILD);
        self.tokenKindTab[@"div"] = @(XPEGPARSER_TOKEN_KIND_DIV);
        self.tokenKindTab[@"preceding"] = @(XPEGPARSER_TOKEN_KIND_PRECEDING);
        self.tokenKindTab[@"$"] = @(XPEGPARSER_TOKEN_KIND_DOLLAR);
        self.tokenKindTab[@"<"] = @(XPEGPARSER_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"following"] = @(XPEGPARSER_TOKEN_KIND_FOLLOWING);
        self.tokenKindTab[@"descendant"] = @(XPEGPARSER_TOKEN_KIND_DESCENDANT);
        self.tokenKindTab[@"="] = @(XPEGPARSER_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"following-sibling"] = @(XPEGPARSER_TOKEN_KIND_FOLLOWING_SIBLING);
        self.tokenKindTab[@"node"] = @(XPEGPARSER_TOKEN_KIND_NODE);
        self.tokenKindTab[@">"] = @(XPEGPARSER_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"::"] = @(XPEGPARSER_TOKEN_KIND_DOUBLE_COLON);
        self.tokenKindTab[@"namespace"] = @(XPEGPARSER_TOKEN_KIND_NAMESPACE);
        self.tokenKindTab[@".."] = @(XPEGPARSER_TOKEN_KIND_DOT_DOT);
        self.tokenKindTab[@"("] = @(XPEGPARSER_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"@"] = @(XPEGPARSER_TOKEN_KIND_ABBREVIATEDAXIS);
        self.tokenKindTab[@")"] = @(XPEGPARSER_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"//"] = @(XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH);
        self.tokenKindTab[@"*"] = @(XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR);
        self.tokenKindTab[@"or"] = @(XPEGPARSER_TOKEN_KIND_OR);
        self.tokenKindTab[@"+"] = @(XPEGPARSER_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"processing-instruction"] = @(XPEGPARSER_TOKEN_KIND_PROCESSING_INSTRUCTION);
        self.tokenKindTab[@"["] = @(XPEGPARSER_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@","] = @(XPEGPARSER_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"and"] = @(XPEGPARSER_TOKEN_KIND_AND);
        self.tokenKindTab[@"-"] = @(XPEGPARSER_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"ancestor"] = @(XPEGPARSER_TOKEN_KIND_ANCESTOR);
        self.tokenKindTab[@"]"] = @(XPEGPARSER_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"descendant-or-self"] = @(XPEGPARSER_TOKEN_KIND_DESCENDANT_OR_SELF);
        self.tokenKindTab[@"."] = @(XPEGPARSER_TOKEN_KIND_DOT);
        self.tokenKindTab[@"/"] = @(XPEGPARSER_TOKEN_KIND_FORWARD_SLASH);
        self.tokenKindTab[@"false"] = @(XPEGPARSER_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"<="] = @(XPEGPARSER_TOKEN_KIND_LE_SYM);
        self.tokenKindTab[@"ancestor-or-self"] = @(XPEGPARSER_TOKEN_KIND_ANCESTOR_OR_SELF);

        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_PIPE] = @"|";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_PRECEDING_SIBLING] = @"preceding-sibling";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_PARENT] = @"parent";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_ATTRIBUTE] = @"attribute";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_MOD] = @"mod";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_TEXT] = @"text";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_SELF] = @"self";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_COMMENT] = @"comment";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_COLON] = @":";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_CHILD] = @"child";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_DIV] = @"div";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_PRECEDING] = @"preceding";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_DOLLAR] = @"$";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_FOLLOWING] = @"following";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_DESCENDANT] = @"descendant";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_FOLLOWING_SIBLING] = @"following-sibling";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_NODE] = @"node";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_DOUBLE_COLON] = @"::";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_NAMESPACE] = @"namespace";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_DOT_DOT] = @"..";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_ABBREVIATEDAXIS] = @"@";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH] = @"//";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR] = @"*";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_PROCESSING_INSTRUCTION] = @"processing-instruction";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_ANCESTOR] = @"ancestor";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_DESCENDANT_OR_SELF] = @"descendant-or-self";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_FORWARD_SLASH] = @"/";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_LE_SYM] = @"<=";
        self.tokenKindNameTab[XPEGPARSER_TOKEN_KIND_ANCESTOR_OR_SELF] = @"ancestor-or-self";

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

		[t setTokenizerState:t.wordState from:'_' to:'_'];
        [t.wordState setWordChars:YES from:'-' to:'-'];
        [t.wordState setWordChars:YES from:'_' to:'_'];

		[t setTokenizerState:t.numberState from:'.' to:'.'];

		[t setTokenizerState:t.numberState from:'#' to:'#'];
		t.numberState.allowsScientificNotation = NO;

		[t setTokenizerState:t.symbolState from:'/' to:'/'];

    }];

    [self stmt_]; 
    [self matchEOF:YES]; 

}

- (void)stmt_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchStmt:)];

    [self expr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchStmt:)];
}

- (void)expr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchExpr:)];

    [self orExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)orExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchOrExpr:)];

    [self andExpr_]; 
    while ([self speculate:^{ [self orAndExpr_]; }]) {
        [self orAndExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)orAndExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchOrAndExpr:)];

    [self match:XPEGPARSER_TOKEN_KIND_OR discard:NO]; 
    [self andExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchOrAndExpr:)];
}

- (void)andExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchAndExpr:)];

    [self equalityExpr_]; 
    while ([self speculate:^{ [self andEqualityExpr_]; }]) {
        [self andEqualityExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
}

- (void)andEqualityExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchAndEqualityExpr:)];

    [self match:XPEGPARSER_TOKEN_KIND_AND discard:NO]; 
    [self equalityExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAndEqualityExpr:)];
}

- (void)equalityExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchEqualityExpr:)];

    [self relationalExpr_]; 
    while ([self speculate:^{ [self eqRelationalExpr_]; }]) {
        [self eqRelationalExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchEqualityExpr:)];
}

- (void)eqRelationalExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchEqRelationalExpr:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_EQUALS, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_EQUALS discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_NOT_EQUAL, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_NOT_EQUAL discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'eqRelationalExpr'."];
    }
    [self relationalExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchEqRelationalExpr:)];
}

- (void)relationalExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchRelationalExpr:)];

    [self additiveExpr_]; 
    while ([self speculate:^{ [self compareAdditiveExpr_]; }]) {
        [self compareAdditiveExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelationalExpr:)];
}

- (void)compareAdditiveExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchCompareAdditiveExpr:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_LT_SYM, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_LT_SYM discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_GT_SYM, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_GT_SYM discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_LE_SYM, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_LE_SYM discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_GE_SYM, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_GE_SYM discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'compareAdditiveExpr'."];
    }
    [self additiveExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchCompareAdditiveExpr:)];
}

- (void)additiveExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchAdditiveExpr:)];

    [self multiplicativeExpr_]; 
    while ([self speculate:^{ [self plusOrMinusMultiExpr_]; }]) {
        [self plusOrMinusMultiExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAdditiveExpr:)];
}

- (void)plusOrMinusMultiExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchPlusOrMinusMultiExpr:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_PLUS, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_PLUS discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_MINUS, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_MINUS discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'plusOrMinusMultiExpr'."];
    }
    [self multiplicativeExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPlusOrMinusMultiExpr:)];
}

- (void)multiplicativeExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchMultiplicativeExpr:)];

    [self unaryExpr_]; 
    while ([self speculate:^{ [self multDivOrModUnaryExpr_]; }]) {
        [self multDivOrModUnaryExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchMultiplicativeExpr:)];
}

- (void)multDivOrModUnaryExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchMultDivOrModUnaryExpr:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR, 0]) {
        [self multiplyOperator_]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DIV, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_DIV discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_MOD, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_MOD discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'multDivOrModUnaryExpr'."];
    }
    [self unaryExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMultDivOrModUnaryExpr:)];
}

- (void)multiplyOperator_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchMultiplyOperator:)];

    [self match:XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchMultiplyOperator:)];
}

- (void)unaryExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchUnaryExpr:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_MINUS, 0]) {
        [self minusUnionExpr_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XPEGPARSER_TOKEN_KIND_ABBREVIATEDAXIS, XPEGPARSER_TOKEN_KIND_ANCESTOR, XPEGPARSER_TOKEN_KIND_ANCESTOR_OR_SELF, XPEGPARSER_TOKEN_KIND_ATTRIBUTE, XPEGPARSER_TOKEN_KIND_CHILD, XPEGPARSER_TOKEN_KIND_COMMENT, XPEGPARSER_TOKEN_KIND_DESCENDANT, XPEGPARSER_TOKEN_KIND_DESCENDANT_OR_SELF, XPEGPARSER_TOKEN_KIND_DOLLAR, XPEGPARSER_TOKEN_KIND_DOT, XPEGPARSER_TOKEN_KIND_DOT_DOT, XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH, XPEGPARSER_TOKEN_KIND_FALSE, XPEGPARSER_TOKEN_KIND_FOLLOWING, XPEGPARSER_TOKEN_KIND_FOLLOWING_SIBLING, XPEGPARSER_TOKEN_KIND_FORWARD_SLASH, XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR, XPEGPARSER_TOKEN_KIND_NAMESPACE, XPEGPARSER_TOKEN_KIND_NODE, XPEGPARSER_TOKEN_KIND_OPEN_PAREN, XPEGPARSER_TOKEN_KIND_PARENT, XPEGPARSER_TOKEN_KIND_PRECEDING, XPEGPARSER_TOKEN_KIND_PRECEDING_SIBLING, XPEGPARSER_TOKEN_KIND_PROCESSING_INSTRUCTION, XPEGPARSER_TOKEN_KIND_SELF, XPEGPARSER_TOKEN_KIND_TEXT, XPEGPARSER_TOKEN_KIND_TRUE, 0]) {
        [self unionExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr:)];
}

- (void)minusUnionExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchMinusUnionExpr:)];

    do {
        [self match:XPEGPARSER_TOKEN_KIND_MINUS discard:NO]; 
    } while ([self predicts:XPEGPARSER_TOKEN_KIND_MINUS, 0]);
    [self unionExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchMinusUnionExpr:)];
}

- (void)unionExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchUnionExpr:)];

    [self pathExpr_]; 
    while ([self speculate:^{ [self match:XPEGPARSER_TOKEN_KIND_PIPE discard:NO]; [self pathExpr_]; }]) {
        [self match:XPEGPARSER_TOKEN_KIND_PIPE discard:NO]; 
        [self pathExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnionExpr:)];
}

- (void)pathExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchPathExpr:)];

    if ([self speculate:^{ [self filterExpr_]; if ([self speculate:^{ if ([self predicts:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH, 0]) {[self match:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH discard:NO]; } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH, 0]) {[self match:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH discard:NO]; } else {[self raise:@"No viable alternative found in rule 'pathExpr'."];}[self relativeLocationPath_]; }]) {if ([self predicts:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH, 0]) {[self match:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH discard:NO]; } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH, 0]) {[self match:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH discard:NO]; } else {[self raise:@"No viable alternative found in rule 'pathExpr'."];}[self relativeLocationPath_]; }}]) {
        [self filterExpr_]; 
        if ([self speculate:^{ if ([self predicts:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH, 0]) {[self match:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH discard:NO]; } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH, 0]) {[self match:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH discard:NO]; } else {[self raise:@"No viable alternative found in rule 'pathExpr'."];}[self relativeLocationPath_]; }]) {
            if ([self predicts:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH, 0]) {
                [self match:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH discard:NO]; 
            } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH, 0]) {
                [self match:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH discard:NO]; 
            } else {
                [self raise:@"No viable alternative found in rule 'pathExpr'."];
            }
            [self relativeLocationPath_]; 
        }
    } else if ([self speculate:^{ [self locationPath_]; }]) {
        [self locationPath_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'pathExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPathExpr:)];
}

- (void)locationPath_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchLocationPath:)];

    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, XPEGPARSER_TOKEN_KIND_ABBREVIATEDAXIS, XPEGPARSER_TOKEN_KIND_ANCESTOR, XPEGPARSER_TOKEN_KIND_ANCESTOR_OR_SELF, XPEGPARSER_TOKEN_KIND_ATTRIBUTE, XPEGPARSER_TOKEN_KIND_CHILD, XPEGPARSER_TOKEN_KIND_COMMENT, XPEGPARSER_TOKEN_KIND_DESCENDANT, XPEGPARSER_TOKEN_KIND_DESCENDANT_OR_SELF, XPEGPARSER_TOKEN_KIND_DOT, XPEGPARSER_TOKEN_KIND_DOT_DOT, XPEGPARSER_TOKEN_KIND_FOLLOWING, XPEGPARSER_TOKEN_KIND_FOLLOWING_SIBLING, XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR, XPEGPARSER_TOKEN_KIND_NAMESPACE, XPEGPARSER_TOKEN_KIND_NODE, XPEGPARSER_TOKEN_KIND_PARENT, XPEGPARSER_TOKEN_KIND_PRECEDING, XPEGPARSER_TOKEN_KIND_PRECEDING_SIBLING, XPEGPARSER_TOKEN_KIND_PROCESSING_INSTRUCTION, XPEGPARSER_TOKEN_KIND_SELF, XPEGPARSER_TOKEN_KIND_TEXT, 0]) {
        [self relativeLocationPath_]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH, XPEGPARSER_TOKEN_KIND_FORWARD_SLASH, 0]) {
        [self absoluteLocationPath_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'locationPath'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLocationPath:)];
}

- (void)relativeLocationPath_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchRelativeLocationPath:)];

    [self step_]; 
    while ([self speculate:^{ if ([self predicts:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH, 0]) {[self match:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH discard:NO]; } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH, 0]) {[self match:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH discard:NO]; } else {[self raise:@"No viable alternative found in rule 'relativeLocationPath'."];}[self step_]; }]) {
        if ([self predicts:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH, 0]) {
            [self match:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH discard:NO]; 
        } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH, 0]) {
            [self match:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH discard:NO]; 
        } else {
            [self raise:@"No viable alternative found in rule 'relativeLocationPath'."];
        }
        [self step_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelativeLocationPath:)];
}

- (void)absoluteLocationPath_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchAbsoluteLocationPath:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_FORWARD_SLASH discard:NO]; 
        if ([self speculate:^{ [self relativeLocationPath_]; }]) {
            [self relativeLocationPath_]; 
        }
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH, 0]) {
        [self abbreviatedAbsoluteLocationPath_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'absoluteLocationPath'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAbsoluteLocationPath:)];
}

- (void)abbreviatedAbsoluteLocationPath_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchAbbreviatedAbsoluteLocationPath:)];

    [self match:XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH discard:NO]; 
    [self relativeLocationPath_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAbbreviatedAbsoluteLocationPath:)];
}

- (void)filterExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchFilterExpr:)];

    [self primaryExpr_]; 
    while ([self speculate:^{ [self predicate_]; }]) {
        [self predicate_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchFilterExpr:)];
}

- (void)primaryExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchPrimaryExpr:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_DOLLAR, 0]) {
        [self variableReference_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self literal_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self number_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, XPEGPARSER_TOKEN_KIND_FALSE, XPEGPARSER_TOKEN_KIND_TRUE, 0]) {
        [self functionCall_]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        [self expr_]; 
        [self match:XPEGPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimaryExpr:)];
}

- (void)variableReference_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchVariableReference:)];

    [self match:XPEGPARSER_TOKEN_KIND_DOLLAR discard:NO]; 
    [self qName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchVariableReference:)];
}

- (void)literal_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchLiteral:)];

    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)number_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchNumber:)];

    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNumber:)];
}

- (void)functionCall_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchFunctionCall:)];

    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self actualFunctionCall_]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_FALSE, XPEGPARSER_TOKEN_KIND_TRUE, 0]) {
        [self booleanLiteralFunctionCall_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'functionCall'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchFunctionCall:)];
}

- (void)actualFunctionCall_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchActualFunctionCall:)];

    [self functionName_]; 
    [self match:XPEGPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    if ([self speculate:^{ [self argument_]; while ([self speculate:^{ [self match:XPEGPARSER_TOKEN_KIND_COMMA discard:YES]; [self argument_]; }]) {[self match:XPEGPARSER_TOKEN_KIND_COMMA discard:YES]; [self argument_]; }}]) {
        [self argument_]; 
        while ([self speculate:^{ [self match:XPEGPARSER_TOKEN_KIND_COMMA discard:YES]; [self argument_]; }]) {
            [self match:XPEGPARSER_TOKEN_KIND_COMMA discard:YES]; 
            [self argument_]; 
        }
    }
    [self match:XPEGPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchActualFunctionCall:)];
}

- (void)booleanLiteralFunctionCall_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchBooleanLiteralFunctionCall:)];

    [self booleanLiteral_]; 
    [self match:XPEGPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self match:XPEGPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchBooleanLiteralFunctionCall:)];
}

- (void)functionName_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchFunctionName:)];

    [self testAndThrow:(id)^{ return NE(LS(1), @"true") && NE(LS(1), @"false") && NE(LS(1), @"comment") && NE(LS(1), @"text") && NE(LS(1), @"processing-instruction") && NE(LS(1), @"node"); }]; 
    [self qName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFunctionName:)];
}

- (void)booleanLiteral_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchBooleanLiteral:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_TRUE, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_TRUE discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_FALSE, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_FALSE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'booleanLiteral'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBooleanLiteral:)];
}

- (void)qName_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchQName:)];

    if ([self speculate:^{ [self prefix_]; [self match:XPEGPARSER_TOKEN_KIND_COLON discard:NO]; }]) {
        [self prefix_]; 
        [self match:XPEGPARSER_TOKEN_KIND_COLON discard:NO]; 
    }
    [self localPart_]; 

    [self fireDelegateSelector:@selector(parser:didMatchQName:)];
}

- (void)prefix_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchPrefix:)];

    [self ncName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPrefix:)];
}

- (void)localPart_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchLocalPart:)];

    [self ncName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchLocalPart:)];
}

- (void)ncName_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchNcName:)];

    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNcName:)];
}

- (void)argument_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchArgument:)];

    [self expr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchArgument:)];
}

- (void)predicate_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchPredicate:)];

    [self match:XPEGPARSER_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    [self predicateExpr_]; 
    [self match:XPEGPARSER_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPredicate:)];
}

- (void)predicateExpr_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchPredicateExpr:)];

    [self expr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPredicateExpr:)];
}

- (void)step_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchStep:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_ABBREVIATEDAXIS, XPEGPARSER_TOKEN_KIND_ANCESTOR, XPEGPARSER_TOKEN_KIND_ANCESTOR_OR_SELF, XPEGPARSER_TOKEN_KIND_ATTRIBUTE, XPEGPARSER_TOKEN_KIND_CHILD, XPEGPARSER_TOKEN_KIND_DESCENDANT, XPEGPARSER_TOKEN_KIND_DESCENDANT_OR_SELF, XPEGPARSER_TOKEN_KIND_FOLLOWING, XPEGPARSER_TOKEN_KIND_FOLLOWING_SIBLING, XPEGPARSER_TOKEN_KIND_NAMESPACE, XPEGPARSER_TOKEN_KIND_PARENT, XPEGPARSER_TOKEN_KIND_PRECEDING, XPEGPARSER_TOKEN_KIND_PRECEDING_SIBLING, XPEGPARSER_TOKEN_KIND_SELF, 0]) {
        [self axis_]; 
        [self stepBody_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, XPEGPARSER_TOKEN_KIND_COMMENT, XPEGPARSER_TOKEN_KIND_DOT, XPEGPARSER_TOKEN_KIND_DOT_DOT, XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR, XPEGPARSER_TOKEN_KIND_NODE, XPEGPARSER_TOKEN_KIND_PROCESSING_INSTRUCTION, XPEGPARSER_TOKEN_KIND_TEXT, 0]) {
        [self implicitAxisStep_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'step'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStep:)];
}

- (void)axis_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchAxis:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_ANCESTOR, XPEGPARSER_TOKEN_KIND_ANCESTOR_OR_SELF, XPEGPARSER_TOKEN_KIND_ATTRIBUTE, XPEGPARSER_TOKEN_KIND_CHILD, XPEGPARSER_TOKEN_KIND_DESCENDANT, XPEGPARSER_TOKEN_KIND_DESCENDANT_OR_SELF, XPEGPARSER_TOKEN_KIND_FOLLOWING, XPEGPARSER_TOKEN_KIND_FOLLOWING_SIBLING, XPEGPARSER_TOKEN_KIND_NAMESPACE, XPEGPARSER_TOKEN_KIND_PARENT, XPEGPARSER_TOKEN_KIND_PRECEDING, XPEGPARSER_TOKEN_KIND_PRECEDING_SIBLING, XPEGPARSER_TOKEN_KIND_SELF, 0]) {
        [self axisName_]; 
        [self match:XPEGPARSER_TOKEN_KIND_DOUBLE_COLON discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_ABBREVIATEDAXIS, 0]) {
        [self abbreviatedAxis_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'axis'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAxis:)];
}

- (void)axisName_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchAxisName:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_ANCESTOR, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_ANCESTOR discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_ANCESTOR_OR_SELF, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_ANCESTOR_OR_SELF discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_ATTRIBUTE, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_ATTRIBUTE discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_CHILD, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_CHILD discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DESCENDANT, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_DESCENDANT discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DESCENDANT_OR_SELF, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_DESCENDANT_OR_SELF discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_FOLLOWING, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_FOLLOWING discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_FOLLOWING_SIBLING, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_FOLLOWING_SIBLING discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_NAMESPACE, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_NAMESPACE discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_PARENT, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_PARENT discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_PRECEDING, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_PRECEDING discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_PRECEDING_SIBLING, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_PRECEDING_SIBLING discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_SELF, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_SELF discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'axisName'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAxisName:)];
}

- (void)abbreviatedAxis_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchAbbreviatedAxis:)];

    [self match:XPEGPARSER_TOKEN_KIND_ABBREVIATEDAXIS discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAbbreviatedAxis:)];
}

- (void)stepBody_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchStepBody:)];

    [self nodeTest_]; 
    while ([self speculate:^{ [self predicate_]; }]) {
        [self predicate_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchStepBody:)];
}

- (void)nodeTest_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchNodeTest:)];

    if ([self speculate:^{ [self nameTest_]; }]) {
        [self nameTest_]; 
    } else if ([self speculate:^{ [self typeTest_]; }]) {
        [self typeTest_]; 
    } else if ([self speculate:^{ [self match:XPEGPARSER_TOKEN_KIND_PROCESSING_INSTRUCTION discard:NO]; [self match:XPEGPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; [self literal_]; [self match:XPEGPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; }]) {
        [self match:XPEGPARSER_TOKEN_KIND_PROCESSING_INSTRUCTION discard:NO]; 
        [self match:XPEGPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        [self literal_]; 
        [self match:XPEGPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'nodeTest'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNodeTest:)];
}

- (void)nameTest_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchNameTest:)];

    if ([self speculate:^{ [self match:XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; }]) {
        [self match:XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; 
    } else if ([self speculate:^{ [self ncName_]; [self match:XPEGPARSER_TOKEN_KIND_COLON discard:NO]; [self match:XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; }]) {
        [self ncName_]; 
        [self match:XPEGPARSER_TOKEN_KIND_COLON discard:NO]; 
        [self match:XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR discard:NO]; 
    } else if ([self speculate:^{ [self qName_]; }]) {
        [self qName_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'nameTest'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNameTest:)];
}

- (void)typeTest_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchTypeTest:)];

    [self nodeType_]; 
    [self match:XPEGPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self match:XPEGPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchTypeTest:)];
}

- (void)nodeType_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchNodeType:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_COMMENT, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_COMMENT discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_TEXT, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_TEXT discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_PROCESSING_INSTRUCTION, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_PROCESSING_INSTRUCTION discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_NODE, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_NODE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'nodeType'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchNodeType:)];
}

- (void)abbreviatedStep_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchAbbreviatedStep:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_DOT, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_DOT discard:NO]; 
    } else if ([self predicts:XPEGPARSER_TOKEN_KIND_DOT_DOT, 0]) {
        [self match:XPEGPARSER_TOKEN_KIND_DOT_DOT discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'abbreviatedStep'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAbbreviatedStep:)];
}

- (void)implicitAxisStep_ {
    
    [self fireDelegateSelector:@selector(parser:willMatchImplicitAxisStep:)];

    if ([self predicts:XPEGPARSER_TOKEN_KIND_DOT, XPEGPARSER_TOKEN_KIND_DOT_DOT, 0]) {
        [self abbreviatedStep_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, XPEGPARSER_TOKEN_KIND_COMMENT, XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR, XPEGPARSER_TOKEN_KIND_NODE, XPEGPARSER_TOKEN_KIND_PROCESSING_INSTRUCTION, XPEGPARSER_TOKEN_KIND_TEXT, 0]) {
        [self stepBody_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'implicitAxisStep'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchImplicitAxisStep:)];
}

@end
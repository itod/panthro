/*
 *  Exedore.h
 *  Exedore
 *
 *  Created by Todd Ditchendorf on 7/14/09.
 *  Copyright 2009 Todd Ditchendorf. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import <Exedore/XPParser.h>
#import <Exedore/XPNodeInfo.h>
#import <Exedore/XPContext.h>
#import <Exedore/XPController.h>

// Expr
#import <Exedore/XPNodeEnumerator.h>
#import <Exedore/XPStaticContext.h>
#import <Exedore/XPLastPositionFinder.h>

#import <Exedore/XPExpression.h>
#import <Exedore/XPBinaryExpression.h>
#import <Exedore/XPBooleanExpression.h>
#import <Exedore/XPRelationalExpression.h>
#import <Exedore/XPArithmeticExpression.h>

#import <Exedore/XPNodeSetExpression.h>
#import <Exedore/XPSingletonExpression.h>
#import <Exedore/XPParentNodeExpression.h>

#import <Exedore/XPValue.h>
#import <Exedore/XPBooleanValue.h>
#import <Exedore/XPNumericValue.h>
#import <Exedore/XPStringValue.h>
#import <Exedore/XPObjectValue.h>

#import <Exedore/XPNodeSetValue.h>
#import <Exedore/XPNodeSetIntent.h>
#import <Exedore/XPNodeSetExtent.h>
#import <Exedore/XPSingletonNodeSet.h>

#import <Exedore/XPFunction.h>

// Fn
#import <Exedore/FNBoolean.h>
#import <Exedore/FNCeiling.h>
#import <Exedore/FNConcat.h>
#import <Exedore/FNContains.h>
#import <Exedore/FNCount.h>
#import <Exedore/FNEndsWith.h>
#import <Exedore/FNFloor.h>
#import <Exedore/FNLast.h>
#import <Exedore/FNNot.h>
#import <Exedore/FNNumber.h>
#import <Exedore/FNPosition.h>
#import <Exedore/FNRound.h>
#import <Exedore/FNStartsWith.h>
#import <Exedore/FNString.h>
#import <Exedore/FNStringLength.h>
#import <Exedore/FNSubstring.h>
#import <Exedore/FNSubstringAfter.h>
#import <Exedore/FNSubstringBefore.h>
#import <Exedore/FNSum.h>

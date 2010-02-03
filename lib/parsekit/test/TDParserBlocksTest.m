//
//  TDParserBlocksTest.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 9/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDParserBlocksTest.h"

@implementation TDParserBlocksTest

- (void)setUp {
}


- (void)tearDown {
}


#ifdef MAC_OS_X_VERSION_10_6
#if !TARGET_OS_IPHONE
- (void)testMath {
    s = @"2 4 6 8";
    start= [PKTokenAssembly assemblyWithString:s];
    
    PKNumber *n = [PKNumber number];
    p = [PKRepetition repetitionWithSubparser:n];
    
    n.assemblerBlock = ^(PKAssembly *a) {
        if (![a isStackEmpty]) {
            PKToken *tok = [a pop];
            [a push:[NSNumber numberWithFloat:tok.floatValue]];
        }
    };
    
    p.assemblerBlock = ^(PKAssembly *a) {
        NSNumber *total = [a pop];
        if (!total) {
            total = [NSNumber numberWithFloat:0];
        }

        while (![a isStackEmpty]) {
            NSNumber *n = [a pop];
            total = [NSNumber numberWithFloat:[total floatValue] + [n floatValue]];
        }
        
        [a push:total];
    };
             
    PKAssembly *result = [p completeMatchFor:start];
    TDNotNil(result);
    TDEqualObjects(@"[20]2/4/6/8^", [result description]);
    TDEquals((double)20.0, [[result pop] doubleValue]);
}
#endif
#endif

@end

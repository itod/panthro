//
//  TDTokenizerBlocksTest.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 9/16/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDTokenizerBlocksTest.h"

@implementation TDTokenizerBlocksTest

- (void)setUp {
}


- (void)tearDown {
}


#ifdef MAC_OS_X_VERSION_10_6
#if !TARGET_OS_IPHONE
- (void)testBlastOff {
    s = @"\"It's 123 blast-off!\", she said, // watch out!\n"
    @"and <= 3 'ticks' later /* wince */, it's blast-off!";
    t = [PKTokenizer tokenizerWithString:s];
    
    NSLog(@"\n\n starting!!! \n\n");

    [t enumerateTokensUsingBlock:^(PKToken *tok, BOOL *stop) {
        NSLog(@"(%@)", tok.stringValue);
    }];
                                         
    
    NSLog(@"\n\n done!!! \n\n");
}
#endif
#endif

@end

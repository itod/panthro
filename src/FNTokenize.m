//
//  FNTokenize.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNTokenize.h"
#import "FNMatches.h"
#import <Panthro/XPValue.h>
#import "XPStringValue.h"
#import "XPException.h"
#import "XPEmptySequence.h"

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation FNTokenize

+ (NSString *)name {
    return @"tokenize";
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    NSUInteger numArgs = [self checkArgumentCountForMin:2 max:3];
    
    id input = [self.args[0] simplify];
    self.args[0] = input;
    
    id pattern = [self.args[1] simplify];
    self.args[1] = pattern;

    id flags = nil;
    if (numArgs > 2) {
        flags = [self.args[2] simplify];
        self.args[2] = flags;
    }
    
    BOOL isFlagsValue = !flags || (flags && [flags isValue]);
    
    if ([input isValue] && [pattern isValue] && isFlagsValue) {
        result = [self evaluateInContext:nil];
    } else if ([pattern isValue] && isFlagsValue && [[pattern asString] isEqualToString:@""]) {
        result = [XPEmptySequence instance];
    }
    
    result.range = self.range;
    return result;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    XPSequenceValue *result = [XPEmptySequence instance];
    
    NSString *input = [self.args[0] evaluateAsStringInContext:ctx];
    NSUInteger inputLen = [input length];
    if (inputLen) {
        
        NSString *pattern = [self.args[1] evaluateAsStringInContext:ctx];
        if ([pattern length]) {
            
            NSString *flags = @"";
            if ([self numberOfArguments] > 2) {
                flags = [self.args[2] evaluateAsStringInContext:ctx];
            }
            
            NSRegularExpressionOptions opts = [FNMatches regexOptionsForString:flags];
            
            //NSString *escapedStr = [NSRegularExpression escapedPatternForString:regexStr];
            
            NSError *err = nil;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:opts error:&err];
            if (!regex) {
                [XPException raiseIn:self format:@"could not create Regex from pattern '%@'", pattern];
            }
            
            NSArray *matches = [regex matchesInString:input options:0 range:NSMakeRange(0, [input length])];
            NSUInteger numMatches = [matches count];
            NSAssert(NSNotFound != numMatches, @"this would be surprising");
            
            NSMutableArray *vals = [NSMutableArray arrayWithCapacity:numMatches];
            NSUInteger start = 0;
            for (NSTextCheckingResult *match in matches) {
                NSRange r = NSMakeRange(start, match.range.location - start);
                NSString *str = [input substringWithRange:r];
                XPAssert(str);
                XPStringValue *sval = [XPStringValue stringValueWithString:str];
                XPAssert(sval);
                [vals addObject:sval];
                start = NSMaxRange(match.range);
            }
            
            if (start < inputLen) {
                NSRange r = NSMakeRange(start, inputLen - start);
                NSString *str = [input substringWithRange:r];
                XPAssert(str);
                XPStringValue *sval = [XPStringValue stringValueWithString:str];
                XPAssert(sval);
                [vals addObject:sval];
            }
            
            result = [[[XPAtomicSequence alloc] initWithContent:vals] autorelease];
        }
    }
    
    return result;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *result = [self evaluateAsSequenceInContext:ctx];
    return result;
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNTokenize *f = [[[FNTokenize alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end

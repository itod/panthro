//
//  FNMatches.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNMatches.h"
#import "XPValue.h"
#import "XPBooleanValue.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation FNMatches

+ (NSRegularExpressionOptions)regexOptionsForString:(NSString *)flags {
    NSRegularExpressionOptions opts = 0;
    
    if ([flags length]) {
        if ([flags rangeOfString:@"i"].length) {
            opts |= NSRegularExpressionCaseInsensitive;
        }
        
        if ([flags rangeOfString:@"m"].length) {
            opts |= NSRegularExpressionAnchorsMatchLines;
        }
        
        if ([flags rangeOfString:@"x"].length) {
            opts |= NSRegularExpressionAllowCommentsAndWhitespace;
        }
        
        if ([flags rangeOfString:@"s"].length) {
            opts |= NSRegularExpressionDotMatchesLineSeparators;
        }
        
        if ([flags rangeOfString:@"u"].length) {
            opts |= NSRegularExpressionUseUnicodeWordBoundaries;
        }
    }

    return opts;
}


+ (NSString *)name {
    return @"matches";
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}


- (XPExpression *)simplify {
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
        return [self evaluateInContext:nil];
    }
    
    if ([pattern isValue] && isFlagsValue && [[pattern asString] isEqualToString:@""]) {
        return [XPBooleanValue booleanValueWithBoolean:NO];
    }
    
    return self;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    BOOL result = NO;
    
    NSString *input = [self.args[0] evaluateAsStringInContext:ctx];
    if ([input length]) {
        
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
                [NSException raise:@"XPathException" format:@"could not create Regex from pattern '%@'", pattern];
            }
            
            NSUInteger numMatches = [[regex matchesInString:input options:0 range:NSMakeRange(0, [input length])] count];
            NSAssert(NSNotFound != numMatches, @"this would be surprising");
            
            if (NSNotFound == numMatches || 0 == numMatches) {
                result = NO;
            } else {
                result = YES;
            }
        }
    }
    
    return result;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPBooleanValue booleanValueWithBoolean:[self evaluateAsBooleanInContext:ctx]];
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNMatches *f = [[[FNMatches alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end

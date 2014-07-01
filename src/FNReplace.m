//
//  FNReplace.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNReplace.h"
#import "XPValue.h"
#import "XPStringValue.h"
#import "FNMatches.h"
#import "XPException.h"

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation FNReplace

+ (NSString *)name {
    return @"replace";
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    NSUInteger numArgs = [self checkArgumentCountForMin:3 max:4];
    
    id input = [self.args[0] simplify];
    self.args[0] = input;
    
    id pattern = [self.args[1] simplify];
    self.args[1] = pattern;
    
    id replacement = [self.args[2] simplify];
    self.args[2] = replacement;
    
    id flags = nil;
    if (numArgs > 3) {
        flags = [self.args[3] simplify];
        self.args[3] = flags;
    }
    
    BOOL isFlagsValue = !flags || (flags && [flags isValue]);
    
    if ([input isValue] && [pattern isValue] && [replacement isValue] && isFlagsValue) {
        result = [self evaluateInContext:nil];
    } else if ([pattern isValue] && [replacement isValue] && isFlagsValue && [[pattern asString] isEqualToString:@""]) {
        result = [XPStringValue stringValueWithString:@""];
    }
    
    result.range = self.range;
    return result;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSString *result = @"";
    
    NSString *input = [self.args[0] evaluateAsStringInContext:ctx];
    if ([input length]) {
        
        NSString *pattern = [self.args[1] evaluateAsStringInContext:ctx];
        if ([pattern length]) {
            
            NSString *replacement = [self.args[2] evaluateAsStringInContext:ctx];
            
            NSString *flags = @"";
            if ([self numberOfArguments] > 3) {
                flags = [self.args[3] evaluateAsStringInContext:ctx];
            }
            
            NSRegularExpressionOptions opts = [FNMatches regexOptionsForString:flags];
            
            //NSString *escapedStr = [NSRegularExpression escapedPatternForString:regexStr];
            
            NSError *err = nil;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:opts error:&err];
            if (!regex) {
                [XPException raiseIn:self format:@"could not create Regex from pattern '%@'", pattern];
            }
            
            result = [regex stringByReplacingMatchesInString:input options:opts range:NSMakeRange(0, [input length]) withTemplate:replacement];
        }
    }
    
    return result;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    NSString *str = [self evaluateAsStringInContext:ctx];
    XPValue *val = [XPStringValue stringValueWithString:str];
    val.range = self.range;
    return val;
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNReplace *f = [[[FNReplace alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end

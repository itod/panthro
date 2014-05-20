//
//  XPPattern.h
//  Panthro
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import <Foundation/Foundation.h>

@interface XPPattern : NSObject

- (double)defaultPriority;

@property (nonatomic, copy) NSString *originalText;
@property (nonatomic, assign) NSRange range;
@end

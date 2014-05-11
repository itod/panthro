//
//  XPBindery.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/10/14.
//
//

#import <Foundation/Foundation.h>

@protocol XPBinding;
@class XPValue;

@interface XPBindery : NSObject

- (void)setValue:(XPValue *)val forVariable:(id <XPBinding>)binding;
- (XPValue *)valueForVariable:(id <XPBinding>)binding;
@end

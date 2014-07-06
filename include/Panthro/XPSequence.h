//
//  XPSequence.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/4/14.
//
//

#import <Foundation/Foundation.h>

@protocol XPItem;
@protocol XPSequenceEnumeration;

@protocol XPSequence <NSObject>

- (id <XPItem>)head;
- (id <XPSequenceEnumeration>)enumerate;
@end

//
//  XPSequenceEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/4/14.
//
//

#import <Foundation/Foundation.h>

@protocol XPItem;

@protocol XPSequenceEnumeration <NSFastEnumeration, NSObject>

- (id <XPItem>)nextObject;
- (BOOL)hasMoreObjects;

//- (id <XPItem>)currentObject;
//- (NSUInteger)position;

@end

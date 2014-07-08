//
//  XPItem.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/4/14.
//
//

#import <Panthro/XPSequence.h>

@protocol XPItem <XPSequence>

@property (nonatomic, copy, readonly) NSString *stringValue;
@property (nonatomic, assign, readonly) BOOL isAtomized;

@end

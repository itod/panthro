//
//  XPScope.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/6/14.
//
//

#import <Panthro/XPItem.h>

@class XPUserFunction;

@protocol XPScope <NSObject>

- (void)setItem:(id <XPItem>)item forVariable:(NSString *)name;
- (id <XPItem>)itemForVariable:(NSString *)name;
- (XPUserFunction *)userFunctionNamed:(NSString *)name;

@property (nonatomic, retain, readonly) id <XPScope>enclosingScope;
@end

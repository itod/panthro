//
//  XPComparer.h
//  Exedore
//
//  Created by Todd Ditchendorf on 8/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPComparer : NSObject {

}

- (NSComparisonResult)compare:(id)a to:(id)b;
- (XPComparer *)comparerForDataTypeURI:(NSString *)dataTypeURI localName:(NSString *)dataTypeLocalName;
- (XPComparer *)ascendingComparer:(BOOL)ascending;
@end

//
//  PKTestScaffold.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "Panthro.h"

#import "XPEGParser.h"

#define TDTrue(e) XCTAssertTrue((e), @"")
#define TDFalse(e) XCTAssertFalse((e), @"")
#define TDNil(e) XCTAssertNil((e), @"")
#define TDNotNil(e) XCTAssertNotNil((e), @"")
#define TDEquals(e1, e2) XCTAssertEqual((e1), (e2), @"")
#define TDEqualObjects(e1, e2) XCTAssertEqualObjects((e1), (e2), @"")

extern NSString *XPContentsOfFile(NSString *relFilePath);
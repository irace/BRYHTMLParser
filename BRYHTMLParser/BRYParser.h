//
//  BRYParser.h
//  StackOverflow
//
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRYNode.h"

@interface BRYParser : NSObject

/// Returns the doc tag
@property (nonatomic, readonly) id <BRYNode> doc;

/// Returns the body tag
@property (nonatomic, readonly) id <BRYNode> body;

/// Returns the html tag
@property (nonatomic, readonly) id <BRYNode> html;

/// Returns the head tag
@property (nonatomic, readonly) id <BRYNode> head;

- (instancetype)initWithContentsOfURL:(NSURL *)url error:(NSError **)error;

- (instancetype)initWithData:(NSData *)data error:(NSError **)error NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithString:(NSString *)string error:(NSError **)error NS_DESIGNATED_INITIALIZER;

@end

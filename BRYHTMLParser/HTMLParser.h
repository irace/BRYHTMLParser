//
//  HTMLParser.h
//  StackOverflow
//
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"

@interface HTMLParser : NSObject

/// Returns the doc tag
@property (nonatomic, readonly, nullable) id <HTMLNode> doc;

/// Returns the body tag
@property (nonatomic, readonly, nullable) id <HTMLNode> body;

/// Returns the html tag
@property (nonatomic, readonly, nullable) id <HTMLNode> html;

/// Returns the head tag
@property (nonatomic, readonly, nullable) id <HTMLNode> head;

- (nullable instancetype)initWithContentsOfURL:(nonnull NSURL *)url error:(NSError * _Nullable * _Nullable)error;

- (nonnull instancetype)initWithData:(nonnull NSData *)data error:(NSError * _Nullable * _Nullable)error NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)initWithString:(nonnull NSString *)string error:(NSError * _Nullable * _Nullable)error NS_DESIGNATED_INITIALIZER;

@end

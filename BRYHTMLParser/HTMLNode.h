//
//  HTMLNode.h
//  BRYHTMLParser
//
//  Created by Bryan Irace on 7/15/15.
//  Copyright (c) 2015 Bryan Irace. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(unsigned int, HTMLNodeType) {
    HTMLUnkownNode,
    
    HTMLHrefNode,
    HTMLTextNode,
    HTMLSpanNode,
    
    HTMLOlNode,
    HTMLUlNode,
    HTMLLiNode,
    
    HTMLImageNode,
    
    HTMLStrongNode,
    HTMLEmNode,
    HTMLDelNode,
    
    HTMLBoldNode,
    HTMLItalicNode,
    HTMLStrikeNode,
    
    HTMLPNode,
    HTMLBrNode,
    HTMLBlockQuoteNode,
    
    HTMLPreNode,
    HTMLCodeNode,
};

@protocol HTMLNode <NSObject>

/// Returns the first child element
@property (nonatomic, readonly, nullable) id <HTMLNode> firstChild;

/// Returns the plaintext contents of node
@property (nonatomic, readonly, copy, nullable) NSString *contents;

/// Returns the plaintext contents of this node + all children
@property (nonatomic, readonly, copy, nullable) NSString *allContents;

/// Returns the html contents of the node
@property (nonatomic, readonly, copy, nullable) NSString *rawContents;

/// Returns next sibling in tree
@property (nonatomic, readonly, nullable) id <HTMLNode> nextSibling;

/// Returns previous sibling in tree
@property (nonatomic, readonly, nullable) id <HTMLNode> previousSibling;

/// Returns the class name
@property (nonatomic, readonly, copy, nullable) NSString *className;

/// Returns the tag name
@property (nonatomic, readonly, copy, nullable) NSString *tagName;

/// Returns the parent
@property (nonatomic, readonly, nullable) id <HTMLNode> parent;

/// Returns the first level of children
@property (nonatomic, readonly, copy, nonnull) NSArray<id<HTMLNode>> *children;

/// Returns the node type if know
@property (nonatomic, readonly) HTMLNodeType nodetype;

/// Gets the attribute value matching tha name
- (nullable NSString *)getAttributeNamed:(nonnull NSString *)name;

/// Find children with the specified tag name
- (nonnull NSArray<id<HTMLNode>> *)findChildTags:(nonnull NSString *)tagName;

/// Looks for a tag name e.g. "h3"
- (nullable id <HTMLNode>)findChildTag:(nonnull NSString *)tagName;

/// Returns a single child of class
- (nullable id <HTMLNode>)findChildOfClass:(nonnull NSString *)className;

/// Returns all children of class
- (nonnull NSArray<id<HTMLNode>> *)findChildrenOfClass:(nonnull NSString *)className;

/// Finds a single child with a matching attribute. Set `allowPartial` to match partial matches, e.g. <img src="http://www.google.com> [findChildWithAttribute:@"src" matchingName:"google.com" allowPartial:TRUE]
- (nullable id <HTMLNode>)findChildWithAttribute:(nonnull NSString *)attribute matchingName:(nonnull NSString *)className allowPartial:(BOOL)partial;

/// Finds all children with a matching attribute
- (nonnull NSArray<id<HTMLNode>> *)findChildrenWithAttribute:(nonnull NSString *)attribute matchingName:(nonnull NSString *)className allowPartial:(BOOL)partial;

@end

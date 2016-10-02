//
//  HTMLNode.m
//  StackOverflow
//
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.
//

#import "BRYLibXMLHTMLNode.h"
#import <libxml/HTMLtree.h>

@interface BRYLibXMLHTMLNode ()

@property (nonatomic) xmlNode * node;

@end

@implementation BRYLibXMLHTMLNode

-(BRYLibXMLHTMLNode*)parent
{
    return [[BRYLibXMLHTMLNode alloc] initWithXMLNode:_node->parent];
}

-(BRYLibXMLHTMLNode*)nextSibling {
    return [[BRYLibXMLHTMLNode alloc] initWithXMLNode:_node->next];
}

-(BRYLibXMLHTMLNode*)previousSibling {
    return [[BRYLibXMLHTMLNode alloc] initWithXMLNode:_node->prev];
}

void setAttributeNamed(xmlNode * node, const char * nameStr, const char * value) {

    char * newVal = (char *)malloc(strlen(value)+1);
    memcpy (newVal, value, strlen(value)+1);

    bool copyUsed = false;

    for(xmlAttrPtr attr = node->properties; NULL != attr; attr = attr->next)
    {
        if (strcmp((char*)attr->name, nameStr) == 0)
        {
            xmlNode * child = attr->children;
                    if (child != NULL)
                    {
                        free(child->content);
                        child->content = (xmlChar*)newVal;

                        if (!copyUsed)
                        {
                            copyUsed = true;
                        }
                    }

                    break;
        }
    }

    if (!copyUsed)
    {
        free(newVal);
    }

}

NSString * getAttributeNamed(xmlNode * node, const char * nameStr)
{
    for(xmlAttrPtr attr = node->properties; NULL != attr; attr = attr->next)
    {
        if (strcmp((char*)attr->name, nameStr) == 0)
        {
            xmlNode * child = attr->children;
            
                    if (child != NULL)
                    {
                        return [NSString stringWithCString:(void*)child->content encoding:NSUTF8StringEncoding];
                    }

                    break;
        }
    }

    return NULL;
}

-(NSString*)getAttributeNamed:(NSString*)name
{
    const char * nameStr = [name UTF8String];

    return getAttributeNamed(_node, nameStr);
}

//Returns the class name
-(NSString*)className
{
    return [self getAttributeNamed:@"class"];
}

//Returns the tag name
-(NSString*)tagName
{
        if (_node->name == nil)
                return nil;

    return [NSString stringWithCString:(void*)_node->name encoding:NSUTF8StringEncoding];
}


-(BRYLibXMLHTMLNode*)firstChild
{
    return [[BRYLibXMLHTMLNode alloc] initWithXMLNode:_node->children];
}


-(void)findChildrenWithAttribute:(const char*)attribute matchingName:(const char*)className inXMLNode:(xmlNode *)node inArray:(NSMutableArray*)array allowPartial:(BOOL)partial
{
    xmlNode *cur_node = NULL;
    const char * classNameStr = className;
    //BOOL found = NO;

    for (cur_node = node; cur_node; cur_node = cur_node->next) 
    {
        for(xmlAttrPtr attr = cur_node->properties; NULL != attr; attr = attr->next)
        {

            if (strcmp((char*)attr->name, attribute) == 0)
            {
                for(xmlNode * child = attr->children; NULL != child; child = child->next)
                {

                    BOOL match = NO;
                    if (!partial && strcmp((char*)child->content, classNameStr) == 0)
                        match = YES;
                    else if (partial && strstr ((char*)child->content, classNameStr) != NULL)
                        match = YES;

                    if (match)
                    {
                        //Found node
                        BRYLibXMLHTMLNode * nNode = [[BRYLibXMLHTMLNode alloc] initWithXMLNode:cur_node];
                        [array addObject:nNode];
                        break;
                    }
                }
                break;
            }
        }

        [self findChildrenWithAttribute:attribute matchingName:className inXMLNode:cur_node->children inArray:array allowPartial:partial];
    }

}

-(void)findChildTags:(NSString*)tagName inXMLNode:(xmlNode *)node inArray:(NSMutableArray*)array
{
    xmlNode *cur_node = NULL;
    const char * tagNameStr =  [tagName UTF8String];

    if (tagNameStr == nil)
        return;

    for (cur_node = node; cur_node; cur_node = cur_node->next) 
    {
        if (cur_node->name && strcmp((char*)cur_node->name, tagNameStr) == 0)
        {
            BRYLibXMLHTMLNode * node = [[BRYLibXMLHTMLNode alloc] initWithXMLNode:cur_node];
            [array addObject:node];

        }

        [self findChildTags:tagName inXMLNode:cur_node->children inArray:array];
    }
}


-(NSArray*)findChildTags:(NSString*)tagName
{
    NSMutableArray * array = [NSMutableArray array];

    [self findChildTags:tagName inXMLNode:_node->children inArray:array];

    return array;
}

-(BRYLibXMLHTMLNode*)findChildTag:(NSString*)tagName inXMLNode:(xmlNode *)node
{
    xmlNode *cur_node = NULL;
    const char * tagNameStr =  [tagName UTF8String];

    for (cur_node = node; cur_node; cur_node = cur_node->next) 
    {
        if (cur_node && cur_node->name && strcmp((char*)cur_node->name, tagNameStr) == 0)
        {
            return [[BRYLibXMLHTMLNode alloc] initWithXMLNode:cur_node];
        }

        BRYLibXMLHTMLNode * cNode = [self findChildTag:tagName inXMLNode:cur_node->children];
        if (cNode != NULL)
        {
            return cNode;
        }
    }

    return NULL;
}

-(BRYLibXMLHTMLNode*)findChildTag:(NSString*)tagName
{
    return [self findChildTag:tagName inXMLNode:_node->children];
}


-(NSArray*)children
{
    xmlNode *cur_node = NULL;
    NSMutableArray * array = [NSMutableArray array];

    for (cur_node = _node->children; cur_node; cur_node = cur_node->next)
    {
        BRYLibXMLHTMLNode * node = [[BRYLibXMLHTMLNode alloc] initWithXMLNode:cur_node];
        [array addObject:node];
    }

    return array;
}

/*
-(NSString*)description
{
    NSString * string = [NSString stringWithFormat:@"<%s>%@\n", _node->name, [self contents]];

    for (HTMLNode * child in [self children])
    {
        string = [string stringByAppendingString:[child description]];
    }

    string = [string stringByAppendingString:[NSString stringWithFormat:@"<%s>\n", _node->name]];

    return string;
}*/

-(BRYLibXMLHTMLNode*)findChildWithAttribute:(const char*)attribute matchingName:(const char*)name inXMLNode:(xmlNode *)node allowPartial:(BOOL)partial
{
    xmlNode *cur_node = NULL;
    const char * classNameStr = name;
    //BOOL found = NO;

    if (node == NULL)
        return NULL;

    for (cur_node = node; cur_node; cur_node = cur_node->next) 
    {
        for(xmlAttrPtr attr = cur_node->properties; NULL != attr; attr = attr->next)
        {
            if (strcmp((char*)attr->name, attribute) == 0)
            {
                for(xmlNode * child = attr->children; NULL != child; child = child->next)
                {

                    BOOL match = NO;
                    if (!partial && strcmp((char*)child->content, classNameStr) == 0)
                        match = YES;
                    else if (partial && strstr ((char*)child->content, classNameStr) != NULL)
                        match = YES;

                    if (match)
                    {
                        return [[BRYLibXMLHTMLNode alloc] initWithXMLNode:cur_node];
                    }
                }
                break;
            }
        }

        BRYLibXMLHTMLNode * cNode = [self findChildWithAttribute:attribute matchingName:name inXMLNode:cur_node->children allowPartial:partial];
        if (cNode != NULL)
        {
            return cNode;
        }
    }

    return NULL;
}

-(BRYLibXMLHTMLNode*)findChildWithAttribute:(NSString*)attribute matchingName:(NSString*)className allowPartial:(BOOL)partial
{
    return [self findChildWithAttribute:[attribute UTF8String] matchingName:[className UTF8String] inXMLNode:_node->children allowPartial:partial];
}

-(BRYLibXMLHTMLNode*)findChildOfClass:(NSString*)className
{
    BRYLibXMLHTMLNode * node = [self findChildWithAttribute:"class" matchingName:[className UTF8String]  inXMLNode:_node->children allowPartial:NO];
    return node;
}

-(NSArray*)findChildrenWithAttribute:(NSString*)attribute matchingName:(NSString*)className allowPartial:(BOOL)partial
{
    NSMutableArray * array = [NSMutableArray array];

    [self findChildrenWithAttribute:[attribute UTF8String] matchingName:[className UTF8String] inXMLNode:_node->children inArray:array allowPartial:partial];

    return array;
}


-(NSArray*)findChildrenOfClass:(NSString*)className
{
    return [self findChildrenWithAttribute:@"class" matchingName:className allowPartial:NO];
}

-(instancetype)initWithXMLNode:(xmlNode*)xmlNode
{
    if (self = [super init])
    {
        _node = xmlNode;
    }
    return self;
}

#ifdef NS_UNAVAILABLE
- (instancetype)init NS_UNAVAILABLE {
    return nil;
}
#endif

-(void)appendChildContentsToString:(NSMutableString*)string inNode:(xmlNode*)node
{
    if (node == NULL)
        return;

    xmlNode *cur_node = NULL;
    for (cur_node = node; cur_node; cur_node = cur_node->next) 
    {
        if (cur_node->content)
        {
            [string appendString:[NSString stringWithCString:(void*)cur_node->content encoding:NSUTF8StringEncoding]];
        }

        [self appendChildContentsToString:string inNode:cur_node->children];
    }
}

-(NSString*)contents
{
    if (_node->children && _node->children->content)
    {
        return [NSString stringWithCString:(void*)_node->children->content encoding:NSUTF8StringEncoding];
    }

    return nil;
}

BRYNodeType nodeType(xmlNode * _node)
{
    if (_node == NULL || _node->name == NULL)
        return BRYUnkownNode;

    const char * tagName = (const char*)_node->name;
    if (strcmp(tagName, "a") == 0)
        return BRYHrefNode;
    else if (strcmp(tagName, "text") == 0)
        return BRYTextNode;
    else if (strcmp(tagName, "code") == 0)
        return BRYCodeNode;
    else if (strcmp(tagName, "span") == 0)
        return BRYSpanNode;
    else if (strcmp(tagName, "p") == 0)
        return BRYPNode;
    else if (strcmp(tagName, "ul") == 0)
        return BRYUlNode;
    else if (strcmp(tagName, "li") == 0)
        return BRYLiNode;
    else if (strcmp(tagName, "img") == 0)
        return BRYImageNode;
    else if (strcmp(tagName, "ol") == 0)
        return BRYOlNode;
    else if (strcmp(tagName, "strong") == 0)
        return BRYStrongNode;
    else if (strcmp(tagName, "pre") == 0)
        return BRYPreNode;
    else if (strcmp(tagName, "blockquote") == 0)
        return BRYBlockQuoteNode;
    else if (strcmp(tagName, "b") == 0)
        return BRYBoldNode;
    else if (strcmp(tagName, "i") == 0)
        return BRYItalicNode;
    else if (strcmp(tagName, "strike") == 0)
        return BRYStrikeNode;
    else if (strcmp(tagName, "br") == 0)
        return BRYBrNode;
    else if (strcmp(tagName, "em") == 0)
        return BRYEmNode;
    else if (strcmp(tagName, "del") == 0)
        return BRYDelNode;
    else
        return BRYUnkownNode;

}

-(BRYNodeType)nodetype
{
    return nodeType(_node);
}

NSString * allNodeContents(xmlNode*node)
{
    if (node == NULL)
        return nil;

    void * contents = xmlNodeGetContent(node);
    if (contents)
    {

        NSString * string = [NSString stringWithCString:contents encoding:NSUTF8StringEncoding];
        xmlFree(contents);
        return string;
    }

    return @"";
}

-(NSString*)allContents
{
    return allNodeContents(_node);
}

NSString * rawContentsOfNode(xmlNode * node)
{
    xmlBufferPtr buffer = xmlBufferCreateSize(1000);
    xmlOutputBufferPtr buf = xmlOutputBufferCreateBuffer(buffer, NULL);

    htmlNodeDumpOutput(buf, node->doc, node, (const char*)node->doc->encoding);

    xmlOutputBufferFlush(buf);

    NSString * string = nil;

    if (buffer->content) {
        string = [[NSString alloc] initWithBytes:(const void *)xmlBufferContent(buffer) length:xmlBufferLength(buffer) encoding:NSUTF8StringEncoding];
    }

    xmlOutputBufferClose(buf);
    xmlBufferFree(buffer);

    return string;
}

-(NSString*)rawContents {
    return rawContentsOfNode(_node);
}

@end

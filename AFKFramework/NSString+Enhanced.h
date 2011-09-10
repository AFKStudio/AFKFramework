//
//  NSString+Enhanced.h
//  Tunesque
//
//  Created by Marco Tabini on 11-08-19.
//  Copyright (c) 2011 Marco Tabini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Enhanced)


- (NSString *) stringByResolvingXMLEntities;
- (NSString *) trimmedString;
- (NSString *) stringByAddingPercentEscapes;

    
@end

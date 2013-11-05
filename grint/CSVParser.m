//
//  CSVParser.m
//  grint
//
//  Created by Peter Rocker on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSVParser.h"

@implementation NSString (CSVParser)

-(NSArray *)csvRows
{   
    NSMutableArray* outRows = [NSMutableArray array];
    
    NSCharacterSet* newlineCharSet = [NSCharacterSet newlineCharacterSet];
    NSCharacterSet* separatorCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"¥"];
    
    NSArray* lines = [self componentsSeparatedByCharactersInSet:newlineCharSet];
    for ( NSString* line in lines )
    {
        if ( !line.length ) continue;
        NSArray* columns = [line componentsSeparatedByCharactersInSet:separatorCharactersSet];
        if ( columns.count )
        {
            [outRows addObject:columns];
        }
    }
    
    return outRows;
}

@end

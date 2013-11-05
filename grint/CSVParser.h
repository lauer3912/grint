//
//  CSVParser.h
//  grint
//
//  Created by Peter Rocker on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CsvParser)
// Returns an array of arrays for rows & columns
-(NSArray *)csvRows;
@end


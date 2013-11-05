//
//  GrintBDetail2.m
//  GrintB
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintBDetail2.h"
#import "GrintBDetail3.h"
#import "CSVParser.h"
#import <MessageUI/MessageUI.h>

@implementation GrintBDetail2
@synthesize detailViewController = _detailViewController;
@synthesize rows, rawRows;
@synthesize username;
@synthesize locman;
@synthesize csv;
@synthesize spinnerView;
@synthesize fname, lname;
@synthesize userLat, userLon, shouldWarnGPS;
@synthesize isLeaderboard, leaderboardName, leaderboardPass;

CGRect tempBounds;

bool hasReceivedLocB = NO;

/*NSString* csv = 
 */

- (void) downloadRows{
    
    // NSString *downloadTemp = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.peter-rocker.net/GrintB/geocodes.csv"]];
    
    NSString *downloadTemp = [NSString stringWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/courses.dat"] encoding:NSUTF8StringEncoding error:nil];
    
    if(downloadTemp.length > 0){
        csv = [NSString stringWithString:downloadTemp];
        
        NSLog(@"%@", csv);
        
    }
    else{ //default
        csv = @"";
        /*        csv = @"Biltmore¥Coral Gables¥1210 Anastasia Ave, Coral Gables, Florida 33134-6340 United States¥-80.278748¥25.741488¥(305) 460-5364¥www.biltmorehotel.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nBriar Bay¥Miami¥9373 SW 134th St, Miami, Florida 33176-5744 United States¥-80.345018¥25.645268¥(305) 235-6667¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nCalusa¥Miami¥9400 SW 130th Ave, Miami, Florida 33186-1773 United States¥-80.406327¥25.682622¥¥www.calusacountryclub.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥Costa Greens¥Miami¥100 Costa del Sol Blvd, Miami, Florida 33178-2310 United States¥-80.353847¥25.804785¥(305) 592-9210¥www.costagreensgolfclub.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥Country Club of Miami - West¥Hialeah¥6801 Miami Gardens Dr, Hialeah, Florida 33015-3407 United States¥-80.3128480911¥25.9426672192¥¥www.miamidade.gov¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nCountry Club of Miami - East¥Hialeah¥6801 Miami Gardens Dr, Hialeah, Florida 33015-3407 United States¥-80.3128480911¥25.9426672192¥¥www.miamidade.gov¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nDeering Bay¥Coral Gables¥13610 Deering Bay Dr, Coral Gables, Florida 33158-2800 United States¥-80.290463¥25.644452¥¥www.dbycc.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nDon Shula's Senator¥Miami Lakes¥7601 NW 154th St, Miami Lakes, Florida 33014-6880 United States¥-80.324858¥25.913311¥305.820.8106 or 800.24.SHULA¥www.donshulahotel.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nDoral Gold¥Miami¥4400 NW 87th Ave, Miami, Florida 33178-2101 United States¥-80.337394¥25.813357¥305-592-2000 ¥www.doralresort.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nDoral Red¥Miami¥4400 NW 87th Ave, Miami, Florida 33178-2101 United States¥-80.337394¥25.813356¥305-592-2000 ¥www.doralresort.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nDoral Great White¥Miami¥4400 NW 87th Ave, Miami, Florida 33178-2101 United States¥-80.337394¥25.813355¥305-592-2000 ¥www.doralresort.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nDoral Jim McLean Signature¥Miami¥4400 NW 87th Ave, Miami, Florida 33178-2101 United States¥-80.337394¥25.813354¥305-592-2000 ¥www.doralresort.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nDoral TPC Blue Monster¥Miami¥4400 NW 87th Ave, Miami, Florida 33178-2101 United States¥-80.337394¥25.813358¥305-592-2000 ¥www.doralresort.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nFisher Island¥Miami Beach¥1 Fisher Island Dr, Miami Beach, Florida 33109-0001 United States¥-80.146075¥25.761707¥¥www.fisherislandclub.net¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nGranada¥Coral Gables¥2001 Granada Blvd, Coral Gables, Florida 33134-4703 United States¥-80.275194¥25.75298¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nGreynolds Park¥North Miami Beach¥17530 W Dixie Hwy, North Miami Beach, Florida 33160-4819 United States¥-80.15081¥25.937858¥¥www.miamidade.gov¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nKillians Greens¥Miami¥9980 SW 104th St, Miami, Florida 33176-2847 United States¥-80.357253¥25.672671¥¥www.costagreensgolf.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nLa Gorce¥Miami Beach¥5685 Alton Rd, Miami Beach, Florida 33140-2018 United States¥-80.130322¥25.836436¥¥www.lagorcecc.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nMelreese International Links¥Miami¥1802 NW 37th Ave, Miami, Florida 33125-1052 United States¥-80.256065¥25.791418¥(305) 633-4583¥internationallinksgolfclub.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nMiami Beach¥Miami Beach¥2301 Alton Rd, Miami Beach, Florida 33140-4255 United States¥-80.138169¥25.799628¥¥www.miamibeachgolfclub.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nMiami Shores¥Miami¥10000 Biscayne Blvd, Miami Shores, Florida 33138-2646 United States¥-80.176209¥25.86758¥¥www.miamishoresgolf.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nMiami Springs¥Miami Springs¥650 Curtiss Pkwy, Miami Springs, Florida 33166-5250 United States¥-80.286188¥25.816513¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nMiccosuke Baracuda¥Miami¥6401 Kendale Lakes Dr, Miami, Florida 33183-1801 United States¥-80.429108¥25.707776¥¥www.miccosukeegolf.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nMiccosuke Dolphin¥Miami¥6401 Kendale Lakes Dr, Miami, Florida 33183-1801 United States¥-80.429108¥25.707776¥¥www.miccosukeegolf.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nMiccosuke Marlin¥Miami¥6401 Kendale Lakes Dr, Miami, Florida 33183-1801 United States¥-80.429108¥25.707776¥¥www.miccosukeegolf.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nNormandy Shores¥Miami Beach¥2401 Biarritz Dr., Miami Beach, Florida 33141 United States¥-80.143528¥25.852785¥Â (305)868-6502¥www.normandyshoresgolfclub.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nPresidential¥North Miami Beach¥19650 NE 18th Ave, North Miami Beach, Florida 33179-3135 United States¥-80.165706¥25.956739¥¥www.presidentialcc.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nRiviera¥Coral Gables¥1155 Blue Rd, Coral Gables, Florida 33146-1112 United States¥-80.274407¥25.726894¥¥www.rivieracc.org¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nWestview¥Miami¥2601 NW 119th St, Miami, Florida 33167-2665 United States¥-80.242053¥25.882726¥¥www.westviewcc.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nHillcrest¥Hollywood¥4600 Hillcrest Dr, Hollywood, FL 33021, USA¥-80.189037323¥25.9995942634¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nOrangebrook East¥Hollywood¥400 Entrada Dr Hollywood, FL 33021-7040¥-80.173393¥26.008098¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nOrangebrook West¥Hollywood¥400 Entrada Dr Hollywood, FL 33021-7040¥-80.173393¥26.008099¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nThe Club at Emerald Hills¥Hollywood¥4100 N. Hills Dr Hollywood FL 33021¥-80.184867¥26.042995¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nThe Diplomat¥Hallandale Beach¥501 Diplomat Pkwy, Hallandale Beach, Florida 33009-3710 United States¥-80.129477¥25.99257¥¥www.diplomatcountryclub.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nTurnberry Isle Miller¥Aventura¥19999 W Country Club Dr, Aventura, Florida 33180-2401 United States¥-80.139576¥25.961733¥(800) 327-7028¥www.turnberryisle.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nTurnberry Isle Soffer¥Aventura¥19999 W Country Club Dr, Aventura, Florida 33180-2401 United States¥-80.139576¥25.961732¥(800) 327-7028¥www.turnberryisle.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nCrandon¥Key Biscayne¥6700 Crandon Blvd, Key Biscayne, Florida 33149 United States¥-80.1571083069¥25.7146261773¥¥www.miamidade.gov¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nPlantation Preserve¥Plantation¥7050 West Broward Blvd, Plantation FL 33317¥-80.242917¥26.120801¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nOcala Municipal Course¥Ocala¥3130 E. Silver Springs Blvd., Ocala, FL 34470¥-82.093469¥29.193421¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nStone Creek Golf Club¥Ocala¥9676 SW 62nd Loop, Ocala FL 34481¥-82.32154¥29.126941Â ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nWentworth Hills¥Plainville¥27 Bow St Plainville, MA 02762¥-71.372974¥42.013037¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nRobert T. Lynch Municipal GC¥Brookline¥1281 W Roxbury Pkwy Brookline, MA 02467¥-71.145797¥42.297897¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nLeo J. Martin Memorial¥Weston¥85 Park Rd Weston, MA 02493¥-71.26799¥42.335324¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nBinks Forest¥Wellington¥400 Binks Forest Drive Wellington, Florida 33414¥-80.293198¥26.676199¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nSugarcane Belle Glade¥Belle Glade¥2619 W Canal Street North Belle Glade¥-80.692007¥26.699122¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥\nPembroke Lakes¥Pembroke Pines¥10500 Taft StreetÂ Â Pembroke Pines, FL 33026-2821¥-80.286872¥26.020568¥(954) 431-4144¥www.pembrokelakesgolf.com¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥";*/
        
    }
    
    rawRows = [[NSMutableArray alloc] initWithArray:[csv csvRows]];
    
    [self generateRows];
}

- (void) generateRows{
    
    //first apply search parameters
    
    rows = nil;
    rows = [[NSMutableArray alloc] init];
    
    for(NSMutableArray* s in rawRows){
        
        if(searchBar1.text.length > 0){
            
            NSRange textRange;
            textRange =[[[s objectAtIndex:0] lowercaseString] rangeOfString:[searchBar1.text lowercaseString]];
            
            if(textRange.location == NSNotFound)
            {
                //do nothing
                
            }
            else{
                
                float R = 3958.75587; // miles
                float dLat = (((NSString*)[s objectAtIndex:4]).floatValue-userLat)* M_PI / 180;
                float dLon = (((NSString*)[s objectAtIndex:3]).floatValue-userLon)* M_PI / 180;
                float lat1 = userLat * M_PI / 180;
                float lat2 = (((NSString*)[s objectAtIndex:4]).floatValue-userLat)* M_PI / 180;
                
                float a = sin(dLat/2) * sin(dLat/2) +
                sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
                float c = 2 * atan2(sqrt(a), sqrt(1-a));
                float d = R * c;
                
                [s addObject:[NSString stringWithFormat:@"%.1f", d]];
                
                [rows addObject:[NSMutableArray arrayWithArray:s] ];
                
            }
            
        }
        else{
            
            float R = 3958.75587; // miles
            float dLat = (((NSString*)[s objectAtIndex:4]).floatValue-userLat)* M_PI / 180;
            float dLon = (((NSString*)[s objectAtIndex:3]).floatValue-userLon)* M_PI / 180;
            float lat1 = userLat * M_PI / 180;
            float lat2 = (((NSString*)[s objectAtIndex:4]).floatValue-userLat)* M_PI / 180;
            
            float a = sin(dLat/2) * sin(dLat/2) +
            sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
            float c = 2 * atan2(sqrt(a), sqrt(1-a));
            float d = R * c;
            
            [s addObject:[NSString stringWithFormat:@"%.1f", d]];
            
            [rows addObject:[NSMutableArray arrayWithArray:s] ];
        }
        
        
        
    }
    
    
    NSLog(@"number of raw rows: %d", rawRows.count);
    
    NSLog(@"number of rows: %d", rows.count);
    rows = [NSMutableArray arrayWithArray:[rows sortedArrayUsingComparator:^(id a, id b) {
        NSNumber *first = [NSNumber numberWithFloat:[(NSString*)[(NSMutableArray*)a objectAtIndex:8] floatValue]];
        NSNumber *second = [NSNumber numberWithFloat:[(NSString*)[(NSMutableArray*)b objectAtIndex:8] floatValue]];
        return [first compare:second];
    }]];
    
    
    [tableView1 reloadData];
    
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rows.count + 1;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self generateRows];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [self generateRows];
    [searchBar resignFirstResponder];
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
 {
 
 if(indexPath.row >= rows.count){
 return tempBounds.size.height;
 }
 
 NSString *text = [[rows objectAtIndex:indexPath.row]objectAtIndex:0];
 
 if(searchBar1.text.length > 0){
 
 NSRange textRange;
 textRange =[[text lowercaseString] rangeOfString:[searchBar1.text lowercaseString]];
 
 if(textRange.location == NSNotFound)
 {
 return 0;
 
 }
 else{
 return tempBounds.size.height;
 }
 
 }
 else{
 return tempBounds.size.height;
 }
 }*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row >= rows.count){
        
        [cell.textLabel setText:@"Request a course"];
        [cell.detailTextLabel setText:@"Course not listed here? Let us know!"];
        
        cell.tag = -1;
        
    }
    
    else{
        [cell.textLabel setText:[[rows objectAtIndex:indexPath.row]objectAtIndex:0]];
        [cell.detailTextLabel setText:[[rows objectAtIndex:indexPath.row]objectAtIndex:2]];
        
            
            /* float R = 3958.75587; // miles
             float dLat = (((NSString*)[[rows objectAtIndex:indexPath.row]objectAtIndex:4]).floatValue-userLat)* M_PI / 180;
             float dLon = (((NSString*)[[rows objectAtIndex:indexPath.row]objectAtIndex:3]).floatValue-userLon)* M_PI / 180;
             float lat1 = userLat * M_PI / 180;
             float lat2 = (((NSString*)[[rows objectAtIndex:indexPath.row]objectAtIndex:4]).floatValue-userLat)* M_PI / 180;
             
             float a = sin(dLat/2) * sin(dLat/2) +
             sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2); 
             float c = 2 * atan2(sqrt(a), sqrt(1-a)); 
             float d = R * c;
             
             [cell.textLabel setText:[cell.textLabel.text stringByAppendingFormat:@" - %.1f miles", d]];*/
            
            [cell.textLabel setText:[cell.textLabel.text stringByAppendingFormat:@" - %@ miles", [[rows objectAtIndex:indexPath.row]objectAtIndex:8]]];
            
        
        cell.tag = [[[rows objectAtIndex:indexPath.row]objectAtIndex:7] intValue];
        
    }
    return cell;
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    [self dismissModalViewControllerAnimated:YES];
    
    if(result == MFMailComposeResultSent){
    
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Request a Course" message:@"Your Course Request will be processed shortly, You can use our \"Shoot your Scorecard\" feature or wait until we upload the course. We apologize for the inconvenience" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    if (!self.detailViewController) {
        self.detailViewController = [[GrintBDetail3 alloc] initWithNibName:@"GrintBDetail3" bundle:nil];
    }
    
    if(indexPath.row >= rows.count){
       /* UITextField *textField;
        UIAlertView *prompt;
        [(GrintBDetail3* )self.detailViewController setCourseName:@"Manual Entry Skipped"];
        [(GrintBDetail3* )self.detailViewController setCourseAddress:@"Manual Entry"];
        
        prompt = [[UIAlertView alloc] initWithTitle:@"Enter Course Name" message:@"nnn" delegate:self.detailViewController cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];  [textField setBackgroundColor:[UIColor whiteColor]]; [textField setPlaceholder:@"course name"]; textField.tag = 99; [prompt addSubview:textField];
        // [prompt setTransform:CGAffineTransformMakeTranslation(0.0, 110.0)]; 
        [prompt show];
        
        [textField becomeFirstResponder];*/
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        
        mail.mailComposeDelegate = self;
        
        [mail setToRecipients:[NSArray arrayWithObject:@"courses@thegrint.com"]];
        [mail setSubject:@"Course request"];    
        [mail setMessageBody:@"Please let us know the name of your course and in which state it is located:\n\n" isHTML:NO];
        
        [self presentModalViewController:mail animated:YES];
        
        
    }
    else{
        
        
        NSString* savedPastCourses = [[NSUserDefaults standardUserDefaults]stringForKey:@"pastcourses"];
        NSMutableString* pastcourses;
        if(savedPastCourses){
            pastcourses = [[NSMutableString alloc]initWithString:savedPastCourses];
        }
        else{
            pastcourses = [[NSMutableString alloc]initWithString:@""];
        }
        
        if([pastcourses rangeOfString:[[rows objectAtIndex:indexPath.row] objectAtIndex:0]].location == NSNotFound){
        
        NSMutableString* pastCourseCSV = [[NSMutableString alloc]initWithString:@""];
        
        for(NSString* a in [rows objectAtIndex:indexPath.row]){
            [pastCourseCSV appendFormat:@"%@¥", a];
        }
        [pastCourseCSV appendString:@"\n"];
        
        [pastcourses insertString:pastCourseCSV atIndex:0];
        [[NSUserDefaults standardUserDefaults] setValue:pastcourses forKey:@"pastcourses"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        }

        
        [(GrintBDetail3* )self.detailViewController setCourseName:[[rows objectAtIndex:indexPath.row] objectAtIndex:0]];
        [(GrintBDetail3* )self.detailViewController setCourseAddress:[[rows objectAtIndex:indexPath.row] objectAtIndex:2]];
        ((GrintBDetail3*)self.detailViewController).username = self.username;
        ((GrintBDetail3*)self.detailViewController).fname = fname;
        ((GrintBDetail3*)self.detailViewController).lname = lname;
        ((GrintBDetail3*)self.detailViewController).courseID = [NSNumber numberWithInt:[tableView cellForRowAtIndexPath:indexPath].tag];
        
        ((GrintBDetail3*)self.detailViewController).isLeaderboard = isLeaderboard;
        ((GrintBDetail3*)self.detailViewController).leaderboardPass = leaderboardPass;
        ((GrintBDetail3*)self.detailViewController).leaderboardName = leaderboardName;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }

    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(isLeaderboard){
      self.title = NSLocalizedString(@"Leaderboard Course", @"Leaderboard Course");
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Select Course", @"Select Course");
        spinnerView = [SpinnerView loadSpinnerIntoView:self.view];

    }
        
    //  NSLog([NSString stringWithFormat:@"finished reading %d rows", rows.count]);
    //  NSLog([NSString stringWithFormat:@"finished reading %d columns", ((NSMutableArray*)[rows objectAtIndex:0]).count]);
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"resetScore"];

            [self downloadRows];
    
    // [tableView1 reloadData];
    
    
    if(shouldWarnGPS){
        
        [[[UIAlertView alloc]initWithTitle:@"Your GPS Location service is disabled." message:@"We used FL, USA as a default location. To enable GPS location go to your phone Settings/Privacy" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        shouldWarnGPS = NO;
    }

    
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    hasReceivedLocB = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    
    NSLog(@"making new bounds");
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    tempBounds = CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, cell.bounds.size.width, cell.bounds.size.height);
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
        
}


- (void)swipeRightDetected:(id)sender{
    
    [[self navigationController]popViewControllerAnimated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end

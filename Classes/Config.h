/*
 *  Config.h
 *  
 *
 *  Created by Marku on 11/16/10.
 *  Copyright 2010 The Chill Mill. All rights reserved.
 *
 */

#pragma mark -
#pragma mark Misc Schortcuts

//#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#define OPAQUE_HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]
#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

#define UIAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define DOCDIR [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#pragma mark -
#pragma mark Config Options

#define TESTFLIGHTON 0

#if TESTFLIGHTON
#define NSLog TFLog
#endif


#define POPULATIONMODE 0
#define DEBUGMODE 0
#define LOCALMODE 1
#define AFNETWORKING 1



#pragma mark -
#pragma mark FILENAMES

#define FILE_SQLITE_BUNDLED 	[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"COREDATA.sqlite"]
#define FILE_ALLPOSTS 			[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bookmarks.xml"]
#define FILE_TAGS				[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tags.xml"]
#define FILE_BUNDLED    		[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BundledFile.plist"]



#define FILE_SQLITE     		[DOCDIR stringByAppendingPathComponent:@"COREDATA.sqlite"]
#define FILE_PREFS      		[DOCDIR stringByAppendingPathComponent:@"Preference.plist"]
#define FILE_DUMP	    		[DOCDIR stringByAppendingPathComponent:@"json.plist"]



#pragma mark -
#pragma mark URLs and Strings

#define PLACEHOLDER_IMG @"Icon.png"


//
//  DVHelper.m
//
//  Created by PHILIP LODEN on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DVHelper.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation UITableView (XCRHelper)

- (void)deselectSelectedRow {
  if (self.indexPathForSelectedRow) {
    [self deselectRowAtIndexPath:self.indexPathForSelectedRow animated:YES];
  }
}

@end

@implementation NSDictionary (XCRHelper)

- (id)objectForKeyOrDefault:(id)aKey aDefault:(id)aDefault {
  id obj = [self objectForKey:aKey];
  
  return (! obj || obj == [NSNull null]) ? aDefault : obj;
}

- (id)objectForKeyOrEmptyString:(id)aKey {
  return [self objectForKeyOrDefault:aKey aDefault:@""];
}

- (id)objectForKeyOrNil:(id)aKey {
  return [self objectForKeyOrDefault:aKey aDefault:nil];
}

- (NSInteger)intForKeyOrDefault:(id)aKey aDefault:(NSInteger)aDefault {
  id object = [self objectForKeyOrDefault:aKey aDefault:nil];
  
  if (object) {
    if ([object respondsToSelector:@selector(intValue)]) {
      return [object intValue];
    }
  }
  
  return aDefault;
}

- (BOOL)boolForKeyOrDefault:(id)aKey aDefault:(BOOL)aDefault {
  id object = [self objectForKeyOrDefault:aKey aDefault:nil];
  
  if (object) {
    if ([object respondsToSelector:@selector(boolValue)]) {
      return [object boolValue];
    }
  }
  
  return aDefault;    
}

- (id)objectForInt:(NSInteger)anInt {
  return [self objectForKey:[NSNumber numberWithInt:anInt]];
}

@end

@implementation NSMutableDictionary (XCRHelper)

- (void)setObjectIfNotNil:(id)anObject forKey:(id)aKey {
  if (anObject) {
    [self setObject:anObject forKey:aKey];
  }
}

@end

@implementation NSString (DVHelper)

- (id)JSONValue {
  NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
  NSError *e = nil;
  return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
}

@end

@implementation DVHelper

+ (void)shiftOriginX:(UIView *)aView x:(CGFloat)x {
	CGRect frameRect = aView.frame;
	frameRect.origin.x += x;
	aView.frame = frameRect;
}

+ (void)shiftOriginY:(UIView *)aView y:(CGFloat)y {
	CGRect frameRect = aView.frame;
	frameRect.origin.y += y;
	aView.frame = frameRect;
}

+ (void)setOriginX:(UIView *)aView x:(CGFloat)x {
	CGRect frameRect = aView.frame;
	frameRect.origin.x = x;
	aView.frame = frameRect;
}

+ (void)setOriginY:(UIView *)aView y:(CGFloat)y {
	CGRect frameRect = aView.frame;
	frameRect.origin.y = y;
	aView.frame = frameRect;	
}

+ (void)setOrigin:(UIView *)aView origin:(CGPoint)origin {
	CGRect frameRect = aView.frame;
	frameRect.origin = origin;
	aView.frame = frameRect;
}

+ (void)setWidth:(UIView *)aView width:(CGFloat)width {
	CGRect frameRect = aView.frame;
	frameRect.size.width = width;
	aView.frame = frameRect;
}

+ (void)setHeight:(UIView *)aView height:(CGFloat)height {
	CGRect frameRect = aView.frame;
	frameRect.size.height = height;
	aView.frame = frameRect;  
}

+ (void)setSize:(UIView *)aView size:(CGSize)aSize {
	CGRect frameRect = aView.frame;
	frameRect.size = aSize;
	aView.frame = frameRect;   
}

// Encode a data (which has a string inside of it) into a base64 encoded string.
// Adapted from http://www.cocoadev.com/index.pl?BaseSixtyFour
// Public Domain license
// cyrusn@stwing.upenn.edu
+ (NSString *)base64Encoding:(NSData *)aData {
	// Guard against empty data.
	if ([aData length] == 0) { return @""; }
	
	char *characters = malloc((([aData length] + 2) / 3) * 4);
	// Guard against malloc failure.
	if (characters == NULL) { return @""; }
	
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (i < [aData length]) {
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [aData length])
			buffer[bufferLength++] = ((char *)[aData bytes])[i++];
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1) {
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];      
		} else {
			characters[length++] = '='; 
		}
		if (bufferLength > 2) {
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		} else {
			characters[length++] = '='; 
		}
	}
	
	return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

+ (void)showErrorAlertWithMessage:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert release];
}

+ (BOOL)isNilOrEmtpyString:(NSString *)aString {
  if (aString == nil) return YES;
  
  if ([aString respondsToSelector:@selector(isEqualToString:)]) {
    if ([aString isEqualToString:@""]) return YES;
  }
  
  if ((id)aString == [NSNull null]) return YES; // fugly
  
  return NO;
}

+ (NSString *)stringOrDefault:(NSString *)aString defaultString:(NSString *)defaultString {
  if (aString == nil ) {
    return defaultString;
  } else {
    return ([DVHelper isNilOrEmtpyString:aString]) ? defaultString : aString;
  }
}

+ (UIView *)firstResponderForView:(UIView *)aView {
  __block UIView * (^getFirstResponder)(UIView *);
  
  getFirstResponder = ^(UIView *aView) {
    UIView *c = nil;
    
    if ([aView isFirstResponder]) {
      return aView;
    }
    if ([[aView subviews] count] > 0) {
      for (UIView *subview in aView.subviews) {
        c = getFirstResponder(subview);
        if (c) return c;
      }
    }
    return c;
  };  
  
  return getFirstResponder(aView);
}

+ (id)getOrCreateTemplate:anEntityName
                predicate:(NSPredicate *)aPredicate
                  context:(NSManagedObjectContext *)aContext
                didCreate:(BOOL*)didCreate
              createBlock:(id(^)())aCreateBlock
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:anEntityName inManagedObjectContext:aContext];
  [request setEntity:entity];
  [request setPredicate:aPredicate];
  NSError *anyError = nil;
  NSArray *fetchedObjects = [aContext executeFetchRequest:request error:&anyError];
  
  [request release];
  
  if( fetchedObjects == nil ) {
    // throw exception
  }
  
  if ([fetchedObjects count] == 0) {
    *didCreate = YES;
    id obj = aCreateBlock();
    return obj;
    return nil;
  } else if ([fetchedObjects count] > 1) {
#warning FIXME ploden
    // throw more than one exception
    return nil;
  } else {
    *didCreate = NO;
    return [fetchedObjects objectAtIndex:0];
  }
}

+ (NSFetchedResultsController *)fetchedResultsController:(NSString *)anEntityName
                                               predicate:(NSPredicate *)aPredicate
                                          sortDescriptor:(NSSortDescriptor *)aSortDescriptor
                                                 context:(NSManagedObjectContext *)aContext
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:anEntityName inManagedObjectContext:aContext];
  [fetchRequest setEntity:entity];
  [fetchRequest setPredicate:aPredicate];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
  [fetchRequest setFetchBatchSize:20];

  NSFetchedResultsController *fetchedResultsController = 
  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                      managedObjectContext:aContext
                                        sectionNameKeyPath:nil 
                                                 cacheName:nil];

  [fetchRequest release];
  
  return [fetchedResultsController autorelease]; 
}

+ (id)loadObjectOfClassFromNib:(Class)aClass {
  NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(aClass) owner:nil options:nil];

  for (id obj in nibContents) {
    if ([obj isKindOfClass:aClass]) {
      return obj;
    }
  }
  return nil;
}

+ (void)raiseVirtualMethodCalledException {
  [NSException raise:@"VirtualMethodCalledException" format:@"This method must be implemented by the subclass"];
}

@end

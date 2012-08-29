//
//  DVHelper.m
//
//  Created by PHILIP LODEN on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DVHelper.h"
#import <objc/runtime.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

IMP impOfCallingMethod(id lookupObject, SEL selector)
{
  NSUInteger returnAddress = (NSUInteger)__builtin_return_address(0);
  NSUInteger closest = 0;
  
  // Iterate over the class and all superclasses
  Class currentClass = object_getClass(lookupObject);
  while (currentClass)
  {
    // Iterate over all instance methods for this class
    unsigned int methodCount;
    Method *methodList = class_copyMethodList(currentClass, &methodCount);
    unsigned int i;
    for (i = 0; i < methodCount; i++)
    {
      // Ignore methods with different selectors
      if (method_getName(methodList[i]) != selector)
      {
        continue;
      }
      
      // If this address is closer, use it instead
      NSUInteger address = (NSUInteger)method_getImplementation(methodList[i]);
      if (address < returnAddress && address > closest)
      {
        closest = address;
      }
    }
    
    free(methodList);
    currentClass = class_getSuperclass(currentClass);
  }
  
  return (IMP)closest;
}

@implementation NSObject (SupersequentImplementation)

// Lookup the next implementation of the given selector after the
// default one. Returns nil if no alternate implementation is found.
- (IMP)getImplementationOf:(SEL)lookup after:(IMP)skip
{
  BOOL found = NO;
  
  Class currentClass = object_getClass(self);
  while (currentClass)
  {
    // Get the list of methods for this class
    unsigned int methodCount;
    Method *methodList = class_copyMethodList(currentClass, &methodCount);
    
    // Iterate over all methods
    unsigned int i;
    for (i = 0; i < methodCount; i++)
    {
      // Look for the selector
      if (method_getName(methodList[i]) != lookup)
      {
        continue;
      }
      
      IMP implementation = method_getImplementation(methodList[i]);
      
      // Check if this is the "skip" implementation
      if (implementation == skip)
      {
        found = YES;
      }
      else if (found)
      {
        // Return the match.
        free(methodList);
        return implementation;
      }
    }
    
    // No match found. Traverse up through super class' methods.
    free(methodList);
    
    currentClass = class_getSuperclass(currentClass);
  }
  return nil;
}

@end

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

- (NSString *)DV_stringByPercentEncodingUsingEncoding:(NSStringEncoding)encoding {
return (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self,
                                                            NULL, (CFStringRef)@";/?:@&=$+{}<>,",
                                                            CFStringConvertNSStringEncodingToEncoding(encoding));
}  

@end

@implementation NSArray (DVHelper)

- (NSArray *)DV_sortedArrayUsingKey:(NSString *)aKey ascending:(BOOL)ascending {
  NSSortDescriptor * descriptor = [[[NSSortDescriptor alloc] initWithKey:aKey ascending:ascending] autorelease];
  NSArray *a = [NSArray arrayWithObject:descriptor];
  return [self sortedArrayUsingDescriptors:a];
}

@end

@implementation UILabel (DVHelper)

- (void)DV_sizeToFitVerticallyConstrainedToHeight:(CGFloat)aHeight {
  CGSize s = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, aHeight) lineBreakMode:self.lineBreakMode];
  [DVHelper setHeight:self height:s.height];
}

@end

@implementation UINavigationController (DVHelper)

- (void)DV_pushViewControllerFadeIn:(UIViewController *)viewController {
  [UIView transitionWithView:self.view
                    duration:0.75
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    [self pushViewController:viewController animated:NO];
                  }
                  completion:NULL
   ];
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
  NSArray *fetchedObjects = [DVHelper fetchResultsForEntityName:anEntityName predicate:aPredicate managedObjectContext:aContext];;
    
  if( fetchedObjects == nil ) {
    // throw exception
  }
  
  if ([fetchedObjects count] == 0) {
    if (didCreate != NULL) {
      *didCreate = YES;
    }
    id obj = aCreateBlock();
    return obj;
    return nil;
  } else if ([fetchedObjects count] > 1) {
#warning FIXME ploden
    // throw more than one exception
    return nil;
  } else {
    if (didCreate != NULL) {
      *didCreate = NO;
    }
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

+ (void)setContentWidth:(UIScrollView *)aScrollView width:(CGFloat)aWidth {
  [aScrollView setContentSize:CGSizeMake(aWidth, aScrollView.contentSize.height)];
}

+ (void)scaleImageView:(UIImageView *)imageView image:(UIImage *)image maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight {
  CGFloat newWidth = image.size.width;
  CGFloat newHeight = image.size.height;
  
  CGFloat scale = 1.0f;
  
  if (image.size.width > maxWidth) {
    scale = maxWidth / image.size.width;
    CGFloat scaledHeight = image.size.height * scale;
    if (scaledHeight > maxHeight) {
      scale = maxHeight / image.size.height;
    }
  } else if (image.size.height > maxHeight) {
    scale = maxHeight / image.size.height;
  }
  
  newWidth = image.size.width * scale;
  newHeight = image.size.height * scale;
  
  [imageView setImage:image];
  [DVHelper setSize:imageView size:CGSizeMake(newWidth, newHeight)];
}

+ (CFDictionaryRef)CFDictionaryWithObjectsAndKeys:(NSArray *)objects keys:(NSArray *)keys {
  NSRange objectsRange = NSMakeRange(0, [objects count]);
  id* cObjectsArray = calloc(objectsRange.length, sizeof(id));
  [objects getObjects:cObjectsArray range:objectsRange];
  
  NSRange keysRange = NSMakeRange(0, [keys count]);
  id* cKeysArray = calloc(keysRange.length, sizeof(id));
  [keys getObjects:cKeysArray range:keysRange];
  
  CFDictionaryRef dict = CFDictionaryCreate(kCFAllocatorDefault,
                                            (const void **)cKeysArray,
                                            (const void **)cObjectsArray,
                                            [objects count],
                                            &kCFTypeDictionaryKeyCallBacks,
                                            &kCFTypeDictionaryValueCallBacks);
  
  return dict;
}

+ (NSArray *)fetchResultsForEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate managedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
  [fetchRequest setPredicate:predicate];
  NSError *error = nil;
  NSArray *a = [context executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  return a;
}

+ (NSArray *)fetchLocalResultsForEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate managedObjectContext:(NSManagedObjectContext *)context
{
  return [DVHelper fetchResultsForEntityName:entityName predicate:predicate managedObjectContext:context];
  /*
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
  [fetchRequest setAffectedStores:[NSArray arrayWithObject:APPDELEGATE.localStore]];
  [fetchRequest setPredicate:predicate];
  NSError *error = nil;
  NSArray *a = [context executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  NSLog(@"local results: %@", a);
  return a;
   */
}

@end

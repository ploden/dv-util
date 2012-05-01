#import "PRPNibBasedTableViewCell.h"

@implementation PRPNibBasedTableViewCell

#pragma mark -
#pragma mark Cell generation
// START:CellIdentifier
+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}
// END:CellIdentifier

// START:CellForTableView
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    NSString *cellID = [self cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        NSAssert2(([nibObjects count] > 0) && 
                  [[nibObjects objectAtIndex:0] isKindOfClass:[self class]],
                  @"Nib '%@' does not appear to contain a valid %@", 
                  [self nibName], NSStringFromClass([self class]));
        cell = [nibObjects objectAtIndex:0];
    }
    return cell;    
}
// END:CellForTableView

#pragma mark -
#pragma mark Nib support
// START:Nib
+ (UINib *)nib {
    NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
    return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+ (NSString *)nibName {
    return [self cellIdentifier];
}

// END:Nib

@end
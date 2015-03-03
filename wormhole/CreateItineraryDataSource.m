//
//  CreateItineraryDataSource.m
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "CreateItineraryDataSource.h"

NSString *const CreateItineraryCellIdentifier = @"CreateItineraryCellIdentifier";

@interface CreateItineraryDataSource()

@property (nonatomic, strong) NSMutableArray *locations;

@end

@implementation CreateItineraryDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locations = [NSMutableArray array];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CreateItineraryCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CreateItineraryCellIdentifier];
    }

    if (self.locations.count == 0) {
        cell.textLabel.text = NSLocalizedString(@"add_entry", nil);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        cell.textLabel.text = [self.locations[indexPath.row] valueForKey:@"title"];
        cell.detailTextLabel.text = [self.locations[indexPath.row] valueForKey:@"vicinity"];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.locations removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *source = self.locations[sourceIndexPath.row];
    [self.locations removeObjectAtIndex:sourceIndexPath.row];
    [self.locations insertObject:source atIndex:destinationIndexPath.row];
}

- (void)addPlace:(Place *)place
{
    [self.locations addObject:place];
}

- (NSArray *)places
{
    return [self.locations copy];
}

@end

//
//  TaskListCoreDataTableViewController.m
//  OrElse
//
//  Created by Hani Kazmi on 03/08/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import "TaskListCoreDataTableViewController.h"
#import "Task.h"


static float const kTableViewRowHeight = 58.0;


@interface TaskListCoreDataTableViewController ()

@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSIndexPath *swipedCell;

@end


@implementation TaskListCoreDataTableViewController

#pragma mark - Properties

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        id delegate = [[UIApplication sharedApplication] delegate];
        if ([delegate performSelector:@selector(managedObjectContext)]) {
            _managedObjectContext = [delegate managedObjectContext];
        }
    }
    
    return _managedObjectContext;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup fetchedResultsController
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                              ascending:YES]];
    request.predicate = nil;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"DatabaseCache"];
    
    // Start initial setup if first launch
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        [self performSegueWithIdentifier:@"setupSegue" sender:self];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"taskCell";
    
    SwipableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Setup cell
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = task.name;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewRowHeight;
}


#pragma mark - SwipeableTableViewCell Delegate

- (void)didSwipeRightInCellWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.swipedCell compare:indexPath] != NSOrderedSame) {

        // Unswipe the currently swiped cell
        SwipableTableViewCell *currentlySwipedCell = (SwipableTableViewCell *)[self.tableView cellForRowAtIndexPath:self.swipedCell];
        [currentlySwipedCell returnCellToCentre];
    }
    
    // Set the swipedCell property
    self.swipedCell = indexPath;
}

- (void)didSwipeLeftInCellWithIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.swipedCell compare:indexPath] != NSOrderedSame) {
        
        // Unswipe the currently swiped cell
        SwipableTableViewCell *currentlySwipedCell = (SwipableTableViewCell *)[self.tableView cellForRowAtIndexPath:self.swipedCell];
        [currentlySwipedCell returnCellToCentre];
        
    }
    
    // Set the swipedCell property
    self.swipedCell = indexPath;
}


#pragma mark - Navigation

- (IBAction)cancelUnwindSegueCallback:(UIStoryboardSegue *)segue
{
    [segue.sourceViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

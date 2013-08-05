//
//  TaskListCoreDataTableViewController.m
//  OrElse
//
//  Created by Hani Kazmi on 03/08/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import "TaskListCoreDataTableViewController.h"
#import "Task.h"
#import "SwipeCell.h"

@interface TaskListCoreDataTableViewController ()

@property (strong, nonatomic) NSIndexPath *swipedCell;

@end

@implementation TaskListCoreDataTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = nil;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        [self performSegueWithIdentifier:@"setupSegue" sender:self];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"taskCell";

    SwipeCell *cell = (SwipeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SwipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Task *task =[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = task.name;
    cell.detailTextLabel.text = @"sas";
    cell.indexPath = indexPath;
    cell.delegate = self;


    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (IBAction)myCancelUnwindSegueCallback:(UIStoryboardSegue *)segue{
    [segue.sourceViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)mySaveUnwindSegueCallback:(UIStoryboardSegue *)segue{
    
}

#pragma mark SwipeCellDelegate methods

-(void)didSwipeRightInCellWithIndexPath:(NSIndexPath *)indexPath{
    
    if ([_swipedCell compare:indexPath] != NSOrderedSame) {
        
        // Unswipe the currently swiped cell
        SwipeCell *currentlySwipedCell = (SwipeCell *)[self.tableView cellForRowAtIndexPath:_swipedCell];
        [currentlySwipedCell didSwipeLeftInCell:self];
        
    }
    
    // Set the _swipedCell property
    _swipedCell = indexPath;
    
}

-(void)didSwipeLeftInCellWithIndexPath:(NSIndexPath *)indexPath {
    
    if ([_swipedCell compare:indexPath] == NSOrderedSame) {
        
        _swipedCell = nil;
        
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_swipedCell) {
        
        SwipeCell *currentlySwipedCell = (SwipeCell *)[self.tableView cellForRowAtIndexPath:_swipedCell];
        [currentlySwipedCell didSwipeLeftInCell:self];
        
    }
    
}
@end

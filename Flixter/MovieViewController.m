//
//  MovieViewController.m
//  Flixter
//
//  Created by Edwin Delgado on 6/15/22.
//

#import "MovieViewController.h"
#import "TableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *myArray;
@property (nonatomic, strong) NSArray *filteredData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.MovieTableView.dataSource = self;
    self.MovieTableView.delegate = self;
    self.movieSearchBar.delegate = self;
    
    self.activityIndicator.hidesWhenStopped = true;
    
    [self fetchData];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action: @selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    NSIndexPath *indexOfSender = [self.tableView indexPathForCell: sender];
    NSDictionary *dataToPass = self.filteredData[indexOfSender.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.dataDict = dataToPass;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500/";
    NSString *imageUrl = self.filteredData[indexPath.row][@"poster_path"];
    NSString *fullUrl = [baseUrl stringByAppendingString:imageUrl];
    NSURL *posterImageUrl = [NSURL URLWithString:fullUrl];
    cell.titleLabel.text = self.filteredData[indexPath.row][@"title"];
    cell.synopsisLabel.text = self.filteredData[indexPath.row][@"overview"];
    [cell.posterImage setImageWithURL:posterImageUrl];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger size = self.filteredData.count;
    if(self.myArray.count > 0){
        [self.activityIndicator stopAnimating];
    }
    return size;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"title", searchText];
        self.filteredData = [self.myArray
                             filteredArrayUsingPredicate: predicate];
        
        NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.myArray;
    }
    
    [self.tableView reloadData];
 
}

- (void) fetchData {
    [self.activityIndicator startAnimating];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=2776775714d19037afd0ba0f10c5052d"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                              message:@"Please try again."
                                              preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction * action) {
                   [self fetchData];
               }];
                
               [alert addAction:defaultAction];
               [self presentViewController:alert animated:YES completion:nil];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//               NSLog(@"%@", dataDictionary);
               
               self.myArray = dataDictionary[@"results"];
               self.filteredData = self.myArray;
               [self.tableView reloadData];
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               
           }
        [self.activityIndicator stopAnimating];
        [self.refreshControl endRefreshing];
       }];
    
    [task resume];
}

@end

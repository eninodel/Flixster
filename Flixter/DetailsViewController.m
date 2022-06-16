//
//  DetailsViewController.m
//  Flixter
//
//  Created by Edwin Delgado on 6/16/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500/";
    NSString *posterUrl = self.dataDict[@"poster_path"];
    NSString *backgroundUrl = self.dataDict[@"backdrop_path"];
    NSString *fullPosterUrlString = [baseUrl stringByAppendingString:posterUrl];
    NSString *fullBackgroundUrlString = [baseUrl stringByAppendingString:backgroundUrl];

    NSURL *fullPosterUrl = [NSURL URLWithString:fullPosterUrlString];
    NSURL *fullBackgroundUrl = [NSURL URLWithString:fullBackgroundUrlString];
    
    self.titleLabel.text = self.dataDict[@"title"];
    self.synopsisLabel.text = self.dataDict[@"overview"];
    
    [self.posterImage setImageWithURL:fullPosterUrl];
    [self.backgroundImage setImageWithURL:fullBackgroundUrl];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

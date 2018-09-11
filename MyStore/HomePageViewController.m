//
//  HomePageViewController.m
//  MyStore
//
//  Created by utkarsh.sri on 04/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import "HomePageViewController.h"
#import "WebViewController.h"
#import "NewsStatusResponseModel.h"
#import "NewsSuccessModel.h"
#import "NewsTableView.h"

@interface HomePageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet NewsTableView *newsTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *catagoryScrollView;
@property (nonatomic) NSURL *apiURL;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsTableView.rowHeight = 70;
    self.apiURL = [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=in&apiKey=e12b38aab6f546b78700191506122030"];
    [self fetchNews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchAction:(UIButton *)sender {
    NSString *query = self.searchField.text;
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"\%20"];
    NSLog(@"%@", query);
    if (query) {
        self.apiURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://newsapi.org/v2/everything?q=%@&sortBy=publishedAt&sources=the-hindu&apiKey=e12b38aab6f546b78700191506122030",query]];
        [self fetchNews];
    }
}

- (IBAction)selectCatagory:(UIButton *)sender {
    NSLog(@"Button pressed : %ld",(long)sender.tag);
    switch (sender.tag) {
        case 1:
            self.apiURL = [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=in&apiKey=e12b38aab6f546b78700191506122030"];
            break;
        case 2:
            self.apiURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://newsapi.org/v2/top-headlines?sources=new-scientist&sortBy=publishedAt&apiKey=e12b38aab6f546b78700191506122030"]];
            break;
        case 3:
            self.apiURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://newsapi.org/v2/top-headlines?sources=financial-times&sortBy=publishedAt&apiKey=e12b38aab6f546b78700191506122030"]];
            break;
        case 4:
            self.apiURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://newsapi.org/v2/top-headlines?sources=espn&sortBy=publishedAt&apiKey=e12b38aab6f546b78700191506122030"]];
            break;
    }  
    [self fetchNews];
}



- (void) fetchNews {
    NSURL *url = self.apiURL;
    NSData *jsonResultsForNews = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *jsonDictionaryForNews = [NSJSONSerialization JSONObjectWithData:jsonResultsForNews options:0 error:NULL];
    
    if ([self checkForSuccessInDictionary:jsonDictionaryForNews]) {
        NSLog(@"Fetch successful");
        NewsSuccessModel *successJsonModel = [MTLJSONAdapter modelOfClass:[NewsSuccessModel class] fromJSONDictionary:jsonDictionaryForNews error:nil];
        self.newsTableView.newsArray = successJsonModel.articles;
    } else {
        NSLog(@"Fetch Unsuccessful.");
    }
    
}

- (NSURL *) getAPIURL {
    return [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=e12b38aab6f546b78700191506122030"];
}

- (BOOL) checkForSuccessInDictionary: (NSDictionary *) jsonDictionary {
    NewsStatusResponseModel *statusJsonModel = [MTLJSONAdapter modelOfClass:[NewsStatusResponseModel class] fromJSONDictionary:jsonDictionary error:nil];
    if ([statusJsonModel.status isEqualToString:@"ok"])
         return YES;
    return NO;
}


- (void)prepareWebViewController:(WebViewController *)wvc toDisplayURL:(NSString *)url {
    wvc.newsURL = url;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.newsTableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display News"]) {
                if ([segue.destinationViewController isKindOfClass:[WebViewController class]]) {
                    NSString *url = self.newsTableView.newsArray[indexPath.row][@"url"];
                    [self prepareWebViewController:segue.destinationViewController toDisplayURL:url];
                }
            }
        }
    }
}

//- (void) addLabelsToCatagoryScrollView {
//    NSArray *catagoryLabels = @[@"sports",@"general",@"technology",@"science",@"business"];
//    for (int i = 0; i<[catagoryLabels count]; i++) {
//        UILabel *label = [[UILabel alloc] init];
//        label.text = catagoryLabels[i];
//        [self.catagoryScrollView addSubview:label];
//        NSLog(@"added %@",catagoryLabels[i]);
//    }
//}

@end
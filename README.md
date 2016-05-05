
#iOS App first start guide

Setup

```
    NSMutableArray *paths = [NSMutableArray new];
    
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"jpg"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"jpg"]];
    
    [[KSGuideManager shared] showGuideViewWithImages:paths];
```

Custom Button

```
    [[KSGuideManager shared] setDelegate:self];
    
    - (UIButton *)KSGuidLastPageButton {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 200, 44)];
        [button setTitle:@"Hi~~" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.layer setCornerRadius:5];
        [button.layer setBorderColor:[UIColor grayColor].CGColor];
        [button.layer setBorderWidth:1.0f];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setCenter:CGPointMake(kScreenBounds.size.width / 2, kScreenBounds.size.height - 100)];
    return button;
}
```



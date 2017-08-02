//
//  VideoShowViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "VideoShowViewController.h"
#import "VideoTableViewCell.h"
#import "IJKVideoViewController.h"
#import <SDCycleScrollView.h>
#import "BannerWebViewController.h"
@interface VideoShowViewController ()<UITableViewDelegate,UITableViewDataSource,VideoTableViewCellDelegate,SDCycleScrollViewDelegate>
@property (strong, nonatomic) UITableView * videoTableView;
@property (strong, nonatomic) UICollectionView * videoCollectionView;
@property (nonatomic, strong)YKBasic *model;
@property (nonatomic, strong)BNBasic * bannerModel;
@property (nonatomic, strong)YLbaseC * models;
@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, strong)NSMutableArray * linkMutableArray;
@property (nonatomic, strong)SDCycleScrollView * bannerScrollView;
/* 创建gif动画实现下啦刷新*/
@property(nonatomic,strong)NSMutableArray * refreshImages;// 刷新动画的图片数组
@property(nonatomic,strong)NSMutableArray * normalImages;// 普通状态下的图片数组
@end

@implementation VideoShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.userInteractionEnabled = YES;
    //self.videoTableView.backgroundColor = [UIColor redColor];
    _linkMutableArray = [[NSMutableArray alloc]init];
    [self getNetWork];
   // [self dispatchAllRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changeSelectButtonLive" object:nil];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"当前滚动的Y：%f\n    %f",scrollView.contentOffset.y,self. videoTableView.frame.origin.y);
}
-(void)change:(NSNotification *)notifier{
    NSLog(@"%@",notifier.object);
    NSInteger tag = [notifier.object integerValue];
    if (tag ==101) {
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dispatchAllRequest{
    // 利用线程依赖关系测试
    __weak typeof (self)weakSelf =self;
    
    NSBlockOperation * operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf getNetWork];
        
    }];
    NSBlockOperation * operation2 = [NSBlockOperation blockOperationWithBlock:^{
       // [weakSelf getBannerScrollImage];
        
    }];
    NSBlockOperation * operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf startHttp];
    }];
    

    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    [queue addOperations:@[operation1,operation2,operation3] waitUntilFinished:NO];
    /*
     关于信号量
     信号量：就是一种可用来控制访问资源的数量的标识，设定了一个信号量，在线程访问之前，加上信号量的处理，则可告知系统按照我们指定的信号量数量来执行多个线程。
     其实，这有点类似锁机制了，只不过信号量都是系统帮助我们处理了，我们只需要在执行线程之前，设定一个信号量值，并且在使用时，加上信号量处理方法就行了。
     信号量为0则阻塞线程，大于0则不会阻塞。因此我们可以通过改变信号量的值，来控制是否阻塞线程，从而达到线程同步。
     在GCD中有三个函数是semaphore的操作，分别是：
     　　dispatch_semaphore_create　　　创建一个semaphore
     　　dispatch_semaphore_signal　　　发送一个信号
     　　dispatch_semaphore_wait　　　　等待信号
     　　简单的介绍一下这三个函数，第一个函数有一个整形的参数，我们可以理解为信号的总量，dispatch_semaphore_signal是发送一个信号，自然会让信号总量加1，dispatch_semaphore_wait等待信号，当信号总量少于0的时候就会一直等待，否则就可以正常的执行，并让信号总量-1，根据这样的原理，我们便可以快速的创建一个并发控制来同步任务和有限资源访问控制。
     */
    
    
    
}



-(void)getBannerScrollImage{
    NSString * url = @"http://120.55.238.158/api/live/ticker?lc=0000000000000058&cc=TG0001&cv=IK4.0.55_Iphone&proto=7&idfa=5B102160-7173-4620-A659-37C27A39A830&idfv=D9DAB927-1911-4D28-9B54-B30B60D54CCC&devi=846d0f96942885c610a3998b58389b9b751b9ffb&osversion=ios_10.300000&ua=iPhone7_2&imei=&imsi=&uid=475791895&sid=20Kqq2q6a5oz0huXIldxTTgo1gCvV0emi18feLCRz3co9a62v5Y&conn=wifi&mtid=8c7a5373a02b4e9530e6a2e02f5ac6e5&mtxid=2cf0a2f3b316&logid=&s_sg=ff0a770b261c73ec58b6a2046afd4899&s_sc=100&s_st=1495679948";
    [Tool getNetWorkWithUrl:url WithParamaters:nil success:^(id response) {
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:responseJSON];
        _bannerModel = [BNBasic modelObjectWithDictionary:dic];
        NSMutableArray * array = [[NSMutableArray alloc]init];
        for (int i=0; i<_bannerModel.ticker.count; i++) {
            BNTicker * ticker = _bannerModel.ticker[i];
            if (i ==_bannerModel.ticker.count-1) {
                ticker.image = [NSString stringWithFormat:@"http:\/\/img2.inke.cn\/%@",ticker.image];
            }
            [_linkMutableArray addObject:ticker.link];
            [array addObject:ticker.image];
        }
        self.bannerScrollView.imageURLStringsGroup = array;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.videoTableView reloadData];
            
        });
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}


-(void)getNetWork{
    // 映客数据url
    NSString *urlStr = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    [Tool getNetWorkWithUrl:urlStr WithParamaters:nil success:^(id response) {
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:responseJSON];
        _model  =[YKBasic modelObjectWithDictionary:dic];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.videoTableView reloadData];

        });
        [self.videoTableView.mj_header endRefreshing];

        
    } failure:^(NSError *error) {
        [self.videoTableView.mj_header endRefreshing];

        
    }];
    [self getBannerScrollImage];
    
}
-(void)startHttp{
    // 暂时未获得数据
    NSString * url = @"http://120.55.238.158/api/live/users?start=0&count=20&id=1495679930511052&lc=0000000000000058&cc=TG0001&cv=IK4.0.55_Iphone&proto=7&idfa=5B102160-7173-4620-A659-37C27A39A830&idfv=D9DAB927-1911-4D28-9B54-B30B60D54CCC&devi=846d0f96942885c610a3998b58389b9b751b9ffb&osversion=ios_10.300000&ua=iPhone7_2&imei=&imsi=&uid=475791895&sid=20Kqq2q6a5oz0huXIldxTTgo1gCvV0emi18feLCRz3co9a62v5Y&conn=wifi&mtid=8c7a5373a02b4e9530e6a2e02f5ac6e5&mtxid=2cf0a2f3b316&logid=&s_sg=a5513738451222e43468dcbdda6f1781&s_sc=100&s_st=1495679948";
    [Tool getNetWorkWithUrl:url WithParamaters:nil success:^(id response) {
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:responseJSON];
         _models = [YLbaseC modelObjectWithDictionary:dic];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.videoTableView reloadData];
            
        });
    } failure:^(NSError *error) {
        
        
    }];
    
    
    


}

-(SDCycleScrollView *)bannerScrollView{
    if (!_bannerScrollView) {
        _bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130 ) delegate:self placeholderImage:nil];
        _bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerScrollView.currentPageDotColor =  [UIColor cyanColor]; // 自定义分页控件小圆标颜色
        _bannerScrollView.pageDotColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        _bannerScrollView.autoScrollTimeInterval = 3;
        [self.view addSubview:_bannerScrollView];
    }
    
    return _bannerScrollView;
}
#pragma mark - 点击图片方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerWebViewController * webBanner = [[BannerWebViewController alloc]init];
    webBanner.hidesBottomBarWhenPushed = YES;
    webBanner.bannerStr = _linkMutableArray[index];
    [self.navigationController pushViewController:webBanner animated:YES];
    
    
    
}
#pragma mark - 动画数组懒加载 . 默认状态图片
-(NSMutableArray *)normalImages
{
    if (_normalImages == nil) {
        _normalImages = [[NSMutableArray alloc]init];
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_0001"]];
        [self.normalImages addObject:image];
        
    }
    return _normalImages;
}
#pragma mark - 动画数组懒加载 . 正在刷新状态图片
-(NSMutableArray *)refreshImages{
    if (_refreshImages == nil) {
        _refreshImages = [[NSMutableArray alloc]init];
        // 循环添加图片
        for (int i =0; i<29; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_00%02d",i+1]];
            [self.refreshImages addObject:image];
            
        }
    }
    
    return _refreshImages;
    
}
-(void)loadNewData{
    [self getNetWork];
     [self.videoTableView.mj_header endRefreshing];
}
-(UITableView *)videoTableView{
    if (!_videoTableView) {
        _videoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-135) style:UITableViewStylePlain];
        _videoTableView.delegate = self;
        _videoTableView.dataSource = self;
        _videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_videoTableView];
        MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
      
       // [header setImages:self.refreshImages forState:MJRefreshStateRefreshing];
        [header setImages:self.refreshImages duration:0.5 forState:MJRefreshStateRefreshing];
        [header setImages:self.normalImages duration:0 forState:MJRefreshStateIdle];
        [header setImages:self.refreshImages duration:0 forState:MJRefreshStatePulling];



        //[header setImages:self.normalImages forState:MJRefreshStateIdle];
       // [header setImages:self.refreshImages forState:MJRefreshStatePulling];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _videoTableView.mj_header = header;
        _videoTableView.tableHeaderView = self.bannerScrollView;
        
    }
    
    
    return _videoTableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"CELLID";
    VideoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[VideoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //删除cell的所有子视图
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }

    cell.videoLives = _model.lives[indexPath.row];
    cell.delegate = self;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}
-(void)videoTableViewCellWithCell:(VideoTableViewCell *)cell withCellHeight:(CGFloat)height{
    _cellHeight = height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YKLives * model = _model.lives[indexPath.row];
    IJKVideoViewController * vc = [[IJKVideoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.videoLives = model;
    vc.scrollArray = _model.lives;
    vc.videoStream_addr = model.streamAddr;
    [self.navigationController pushViewController:vc animated:YES];
    
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

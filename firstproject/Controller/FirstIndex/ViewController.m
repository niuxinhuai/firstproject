//
//  ViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/9.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
#import "ViewController.h"
#import <AVFoundation/AVSpeechSynthesis.h>
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking.h>
#import "CircleView.h"
#import "UIColor+HexColor.h"
#import "TFHpple.h"
#import "WebViewJavascriptBridge.h"
#import <objc/runtime.h>
#import <sqlite3.h>
#import "TenCentProgressView.h"
@interface ViewController ()<AVSpeechSynthesizerDelegate,UIWebViewDelegate>{
    NSString * filePath;
    AVAudioRecorder * recorde;
    NSString * textTitle;
    NSString *recoderName;//文件名
    BOOL isSelect;
}
@property (nonatomic, strong) UIButton * button;
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) AVAudioSession * sessions;
@property (nonatomic, strong) NSURL * recordFileUrl;
@property (nonatomic, strong) AVAudioPlayer * player;

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIButton * topButton;
@property (nonatomic, strong) CircleView * views;
@property (nonatomic, strong) UIActivityIndicatorView * indicator;
@property (nonatomic, strong) TenCentProgressView * circleView;
@end
static sqlite3 * db = nil;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isSelect = NO;
    [self createSqlite];

   // self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
   // [self createSpeechSpeak];
    /*
     avspeech支持的语言种类包括：
     
     "[AVSpeechSynthesisVoice 0x978a0b0] Language: th-TH",
     
     "[AVSpeechSynthesisVoice 0x977a450] Language: pt-BR",
     
     "[AVSpeechSynthesisVoice 0x977a480] Language: sk-SK",
     
     "[AVSpeechSynthesisVoice 0x978ad50] Language: fr-CA",
     
     "[AVSpeechSynthesisVoice 0x978ada0] Language: ro-RO",
     
     "[AVSpeechSynthesisVoice 0x97823f0] Language: no-NO",
     
     "[AVSpeechSynthesisVoice 0x978e7b0] Language: fi-FI",
     
     "[AVSpeechSynthesisVoice 0x978af50] Language: pl-PL",
     
     "[AVSpeechSynthesisVoice 0x978afa0] Language: de-DE",
     
     "[AVSpeechSynthesisVoice 0x978e390] Language: nl-NL",
     
     "[AVSpeechSynthesisVoice 0x978b030] Language: id-ID",
     
     "[AVSpeechSynthesisVoice 0x978b080] Language: tr-TR",
     
     "[AVSpeechSynthesisVoice 0x978b0d0] Language: it-IT",
     
     "[AVSpeechSynthesisVoice 0x978b120] Language: pt-PT",
     
     "[AVSpeechSynthesisVoice 0x978b170] Language: fr-FR",
     
     "[AVSpeechSynthesisVoice 0x978b1c0] Language: ru-RU",
     
     "[AVSpeechSynthesisVoice 0x978b210] Language: es-MX",
     
     "[AVSpeechSynthesisVoice 0x978b2d0] Language: zh-HK",中文(香港)粤语
     
     "[AVSpeechSynthesisVoice 0x978b320] Language: sv-SE",
     
     "[AVSpeechSynthesisVoice 0x978b010] Language: hu-HU",
     
     "[AVSpeechSynthesisVoice 0x978b440] Language: zh-TW",中文(台湾)
     
     "[AVSpeechSynthesisVoice 0x978b490] Language: es-ES",
     
     "[AVSpeechSynthesisVoice 0x978b4e0] Language: zh-CN",中文(普通话)
     
     "[AVSpeechSynthesisVoice 0x978b530] Language: nl-BE",
     
     "[AVSpeechSynthesisVoice 0x978b580] Language: en-GB",英语(英国)
     
     "[AVSpeechSynthesisVoice 0x978b5d0] Language: ar-SA",
     
     "[AVSpeechSynthesisVoice 0x978b620] Language: ko-KR",
     
     "[AVSpeechSynthesisVoice 0x978b670] Language: cs-CZ",
     
     "[AVSpeechSynthesisVoice 0x978b6c0] Language: en-ZA",
     
     "[AVSpeechSynthesisVoice 0x978aed0] Language: en-AU",
     
     "[AVSpeechSynthesisVoice 0x978af20] Language: da-DK",
     
     "[AVSpeechSynthesisVoice 0x978b810] Language: en-US",英语(美国)
     
     "[AVSpeechSynthesisVoice 0x978b860] Language: en-IE",
     
     "[AVSpeechSynthesisVoice 0x978b8b0] Language: hi-IN",
     
     "[AVSpeechSynthesisVoice 0x978b900] Language: el-GR",
     
     "[AVSpeechSynthesisVoice 0x978b950] Language: ja-JP"     */
    [self.view addSubview:self.button];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.views];
    [self dispatchAllRequest];
    self.colorType = ButtonItemTitleColorTypeBlue;

    //单独调用
    int sym = EMOJI_CODE_TO_SYMBOL(0x1F600);
    NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
   // NSLog(@"arr==%@",emoT);
    
    //获取数组
    NSArray *arrEmotion = [self defaultEmoticons];
   // NSLog(@"%@",arrEmotion);
    for (NSString *str in arrEmotion) {
     //a   NSLog(@"===%@",str);
    }
    UIImage * images = [UIImage imageNamed:@"lionAnimo"];

    UIImageView * imagev = [[UIImageView alloc]initWithImage:images];
    imagev.contentMode = UIViewContentModeScaleAspectFill;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:images]];
   // [self.view addSubview:self.circleView];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)createSqlite{
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * fileName = [path stringByAppendingPathComponent:@"Sqlite.sqlite"];
    NSLog(@"%@",fileName);
    if ((sqlite3_open(fileName.UTF8String, &db )== SQLITE_OK)) {
        NSLog(@"打开数据库成功");
        NSString * sql = @"create table if not exists t_text (id integer primary key autoincrement,name text);";
        char * errmsg;
        sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"建表失败 -- %s",errmsg);
        }else{
            NSLog(@"建表成功");
        }
    }else{
        NSLog(@"失败");
    }
}



-(UIActivityIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = CGPointMake(100, 125);
        _indicator.color = [UIColor redColor];
        [self.view addSubview:_indicator];
        unsigned  int count = 0;
        Ivar *members = class_copyIvarList([UIButton class], &count);
        
        for (int i = 0; i < count; i++)
        {
            Ivar var = members[i];
            const char *memberAddress = ivar_getName(var);
            const char *memberType = ivar_getTypeEncoding(var);
            NSLog(@"address = %s ; type = %s",memberAddress,memberType);
        }
    }
    
    return _indicator;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.indicator.backgroundColor = [UIColor cyanColor];
    [self.circleView tencentStartAnimation];
    isSelect = !isSelect;
    if (isSelect) {
        [self.indicator startAnimating];
        return;
    }
    [self.indicator stopAnimating];
}
//获取默认表情数组
- (NSArray *)defaultEmoticons {
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            [array addObject:emoT];
        }
    }
    return array;
}
-(void)dispatchAllRequest{
    // 利用线程依赖关系测试
    __weak typeof (self)weakSelf =self;
    
    NSBlockOperation * operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf requestA];
        
    }];
    NSBlockOperation * operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf requestB];
        
    }];
    NSBlockOperation * operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf requestC];
        
    }];
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    [queue addOperations:@[operation1,operation2,operation3] waitUntilFinished:NO];
    NSLog(@"我加载完了可以刷新了");
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

- (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    //match: 所有匹配到的字符,根据() 包含级
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            
            [array addObject:component];
            
        }
        
    }
    
    return array;
}


-(void)requestA{
    
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
   [manager GET:@"http://qr.bookln.cn/qr.html?crcode=110000000F00000000000000B3ZX1CEC" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
      // NSLog(@"%@",str);
       NSArray * registArray = [self matchString:str toRegexString:@"\\[.*\\]"];
      // NSLog(@"%@",registArray);
       NSString * listStr = registArray[10];
       

       NSData * alldata = [listStr dataUsingEncoding:NSUTF8StringEncoding];
         NSArray * responseJSON = [NSJSONSerialization JSONObjectWithData:alldata options:NSJSONReadingMutableLeaves error:nil];
      // NSLog(@"%@",responseJSON);

       
       
       
       dispatch_semaphore_signal(sema);
   NSLog(@"11111111");
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       ////计数+1操作

       dispatch_semaphore_signal(sema);
   NSLog(@"1111111122");
       
   }];
    
    NSLog(@"正在刷新A");
    //若计数为0则一直等待
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"已经刷新A");
}
-(void)requestB{
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [manager GET:@"http://g.tbcdn.cn/mtb/lib-flexible/0.3.4/??flexible_css.js,flexible.js" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_semaphore_signal(sema);
        NSLog(@"222222222");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ////计数+1操作
        
        dispatch_semaphore_signal(sema);
        NSLog(@"222222222233");
        
    }];
    
    NSLog(@"正在刷新B");
    //若计数为0则一直等待
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"已经刷新B");

}
-(void)requestC{
    
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [manager GET:@"http://api.cjkt.com/mobile/index/data" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_semaphore_signal(sema);
        NSLog(@"333333333");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ////计数+1操作
        
        dispatch_semaphore_signal(sema);
        NSLog(@"333333333344");
        
    }];
    
    NSLog(@"正在刷新C");
    //若计数为0则一直等待
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"已经刷新C");
}


-(UIView*)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:self.view.bounds];
        _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        [_topView addSubview:self.topButton];
    }
    
    return _topView;
}
-(UIButton *)topButton{
    if (!_topButton) {
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topButton setTitle:@"相对坐标" forState:UIControlStateNormal];
        _topButton.backgroundColor = [UIColor whiteColor];
        [_topButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGRect rect = [self.view convertRect:self.button.frame toView:self.topView];
        _topButton.frame = rect;
        [_topButton addTarget:self action:@selector(dissMissView) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _topButton;
    
}
-(void)dissMissView{
    [self.topView removeFromSuperview];
    
}
#pragma mark - 不规则矩形
-(CircleView *)views{
    if (!_views) {
        _views = [[CircleView alloc]initWithFrame:CGRectMake(80, 80, 100, 100)];
        _views.backgroundColor = [UIColor clearColor];
        _views.lineWidth = 2.0;
        _views.strokeColors = [UIColor blackColor];
        _views.fillColors = [UIColor orangeColor];
    }
    
    
    return _views;
}
- (TenCentProgressView *)circleView{
    if (!_circleView) {
        _circleView = [[TenCentProgressView alloc]init];
        _circleView.frame = CGRectMake(140, 100, 30, 30);
        _circleView.backgroundColor = [UIColor redColor];
    }
    
    
    return _circleView;
}

-(UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"开始录音" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.backgroundColor =[UIColor cyanColor];
        _button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        _button.bounds = CGRectMake(0, 0, 100, 40);
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _button.selected = NO;
    }
    return _button;
}
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2+60);
        _label.bounds = CGRectMake(0, 0, self.view.frame.size.width, 50);
        _label.backgroundColor = [UIColor redColor];
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont systemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_label];
        
    }
    return _label;
}


-(void)buttonClick:(UIButton *)sender{
    sender.selected =!sender.selected;

    NSString * str = sender.selected ?@"正在录音":@"暂停";
#pragma mark - 数据库增加数据
//    NSString * sql = [NSString stringWithFormat:@"insert into t_text(name) values('%@');",[NSString stringWithFormat:@"小丸子--%d",arc4random_uniform(20)]];
//    char * errorMsg;
//    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errorMsg);
//    if (errorMsg) {
//        NSLog(@"失败原因 -%s",errorMsg);
//    }else{
//        NSLog(@"OK");
//    }
#pragma mark - 数据库删除数据操作
//    NSString * sql = @"delete from t_text where id > 3 and id < 6;";
//    char * errmsg;
//    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
//    if (errmsg) {
//        NSLog(@"删除失败--%s",errmsg);
//    }else{
//        NSLog(@"删除成功");
//    }
#pragma mark - 数据库更新数据操作
//    NSString * sql = @"update t_text set name = 'hello-world' where id = 9;";
//    char * errmsg;
//    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
//    if (errmsg) {
//        NSLog(@"修改失败--%s",errmsg);
//    }else{
//        NSLog(@"修改成功");
//    }
#pragma mark - 数据库查询操作
//    NSString * sql = @"select * from t_text;";
//    
//    //查询的句柄,游标
//    sqlite3_stmt * stmt;
//    
//    if (sqlite3_prepare(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
//        
//        //查询数据
//        while (sqlite3_step(stmt) == SQLITE_ROW) {
//            
//            //获取表数据的内容
//            //sqlite3_column_text('句柄'，字段索引值)
//            
//            NSString * name = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
//            
//            NSLog(@"name = %@",name);
//            
//        }
//    }
    
    [sender setTitle:str forState:UIControlStateNormal];
    if (sender.selected) {
        NSLog(@"开始录音");
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSString * dateStr = [formater stringFromDate:[NSDate date]];
        filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",dateStr]];
        self.recordFileUrl = [NSURL fileURLWithPath:filePath];
        AVAudioSession * session = [AVAudioSession sharedInstance];
        NSError * sessionError;
        if (session == nil) {
         //   NSLog(@"Error session : %@",[sessionError description]);
        }else{
            [session setActive:YES error:nil];
        }
        self.sessions = session;
        // 获取沙盒地址用于存储
       // NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
       // filePath = [path stringByAppendingString:@"/sex.var"];
      //  NSLog(@"%@",filePath);
        
        // 设置参数
        NSDictionary * recordSetting = [[NSDictionary alloc]initWithObjectsAndKeys:
                                        //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                        [NSNumber numberWithFloat:8000.0],AVSampleRateKey,
                                        // 音频格式
                                        [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                        //采样位数  8、16、24、32 默认为16
                                        [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                        // 音频通道数 1 或 2
                                        [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                        //录音质量
                                        [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,nil];
        
        recorde = [[AVAudioRecorder alloc]initWithURL:self.recordFileUrl settings:recordSetting error:nil];
        if (recorde) {
            recorde.meteringEnabled = YES;
            [recorde prepareToRecord];
            [recorde record];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60*NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                
            });
            
        }else{
           
            NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        }
    }else{
        // 暂停操作
        NSLog(@"暂停录音");
        if ([recorde isRecording]) {
            [recorde stop];
        }
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            unsigned long long sizefile =[[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
            textTitle = [NSString stringWithFormat:@"文件大小为%.2fkb",sizefile/1024.0];
            self.label.text = textTitle;
            NSDictionary * dict = [fileManager attributesOfItemAtPath:filePath error:nil];
            NSLog(@"暂停录音获取录音数据 ： %@",dict);
            
        }
        [self performSelector:@selector(playAcrion) withObject:self afterDelay:3];
        
    }
    
}
-(void)playAcrion{
    [self playRecorde];
}
-(void)playRecorde{
  
   /* NSData * daraAudio = [NSData dataWithContentsOfURL:self.recordFileUrl];
    NSString * docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePaths = [NSString stringWithFormat:@"%@/%@.mp3",filePath,daraAudio];
    NSData * endData = [[NSData alloc]initWithContentsOfFile:filePaths];
    NSString * urlString = [[NSString alloc]initWithData:endData encoding:NSUTF8StringEncoding];
    
    [daraAudio writeToFile:filePaths atomically:YES];
    NSURL * url = [NSURL fileURLWithPath:filePaths];*/
    
    
    
    
    NSError *error;
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:self.recordFileUrl error:&error];
    if (self.player == nil) {
          NSLog(@"Error crenting player: %@", [error description]);
    }
    self.player.numberOfLoops = 0;
    NSLog(@"%li",self.player.data.length/1024);
   // [self.sessions setCategory:AVAudioSessionCategoryPlayback error:nil];
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    //建议播放之前设置yes，播放结束设置no，这个功能是开启红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification"
                                               object:nil];
    [self.player play];
   /* NSData * data = self.player.data;
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"解析数据获得的为  %@",dic);
    NSLog(@"获取过来的字符串是 ： %@",str);8*/
    
    
}

-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

#pragma mark -  根据文字，进行读
-(void)createSpeechSpeak{
    AVSpeechSynthesizer * speech = [[AVSpeechSynthesizer alloc]init];
    speech.delegate =self;
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc]initWithString:@"臣本布衣，躬耕于南阳，苟全性命于乱世，不求闻达于诸侯。先帝不以臣卑鄙，猥自枉屈，三顾臣于草庐之中，咨臣以当世之事，由是感激，遂许先帝以驱驰。后值倾覆，受任于败军之际，奉命于危难之间，尔来二十有一年矣。先帝知臣谨慎，故临崩寄臣以大事也。受命以来，夙夜忧叹，恐托付不效，以伤先帝之明，故五月渡泸，深入不毛。今南方已定，兵甲已足，当奖率三军，北定中原，庶竭驽钝，攘除奸凶，兴复汉室，还于旧都。此臣所以报先帝而忠陛下之职分也。至于斟酌损益，进尽忠言，则攸之、祎、允之任也"];
    utterance.rate = 0.5;// 设置语速 范围0-1
    AVSpeechSynthesisVoice * voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置发音，普通话
    utterance.voice = voice;
    [speech speakUtterance:utterance];
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---开始播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---完成播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放中止");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---恢复播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放取消");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  CustomViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "CustomViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "MBProgressHUD+GR.h"
@interface CustomViewController ()<CBCentralManagerDelegate,UIAlertViewDelegate,CBPeripheralDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger timerCount;
}
@property (strong, nonatomic) CBCentralManager * BLEManager;
@property (strong, nonatomic) CBPeripheral     * BLperipheral;
@property (strong, nonatomic) CBCharacteristic * characteristic;
@property (strong, nonatomic) UITableView      * bluetoothTableView;
@property (strong, nonatomic) NSMutableArray   * blueMutableAttay;
@property (strong, nonatomic) NSTimer          * myTimer;
@property (strong, nonatomic) MBProgressHUD    * hud;
@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    timerCount =0;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.BLEManager isScanning];
    if ([self.BLEManager isScanning]) {
        // 正在扫描
        [MBProgressHUD showIndicatorWithView:self.view showMessage:@"正在扫描蓝牙设备"];
    }
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(notifierTimerEnd) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
}
- (void)viewWillDisappear:(BOOL)animated{
    [_myTimer invalidate];
    _myTimer = nil;
}
- (void)notifierTimerEnd{
    if (timerCount>=20) {
        [self.BLEManager stopScan];
        [_myTimer invalidate];
        _myTimer = nil;
    }
    timerCount++;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CBCentralManager *)BLEManager{
    if (!_BLEManager) {
        _BLEManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    
    return _BLEManager;
}
#pragma mark - 蓝牙开发必写协议方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    /*
     CBManagerStateUnknown = 0,
     CBManagerStateResetting,
     CBManagerStateUnsupported,
     CBManagerStateUnauthorized,
     CBManagerStatePoweredOff,
     CBManagerStatePoweredOn,
     */
    MBProgressHUD *HUD;
    NSString * message;
    switch (central.state) {
        case 0:
            message = @"初始化中，请稍后……";
            break;
        case 1:
            message = @"设备不支持状态，过会请重试……";
            break;
        case 2:
            message = @"设备未授权状态，过会请重试……";
            break;
        case 3:
            message = @"设备未授权状态，过会请重试……";
            break;
        case 4:
            message = @"尚未打开蓝牙，请在设置中打开……";
            break;
        case 5:
            message = @"蓝牙已经成功开启，稍后……";
            break;
        default:
            break;
            
    }
    HUD = [MBProgressHUD showMessage:message toView:self.view];
    if (self.BLEManager.state != CBCentralManagerStatePoweredOn) {// 如果没有开启设备
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"开启蓝牙" message:nil delegate:self cancelButtonTitle:@"不开启" otherButtonTitles:@"开启", nil];
        alertView.tag = 1000;
        alertView.delegate = self;
        [alertView show];

    }else{
        // 开始扫描
        [self.BLEManager scanForPeripheralsWithServices:nil options:nil];
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",buttonIndex);
    if (buttonIndex ==1) {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"Prefs:root=Bluetooth"]];
    }
}
//手机蓝牙发现了一个蓝牙硬件peripheral//每发现一个蓝牙设备都会调用此函数（如果想展示搜索到得蓝牙可以逐一保存peripheral并展示）
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
  //  NSLog(@"发现蓝牙设备:%@\n%@",peripheral,advertisementData);//
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    if (peripheral) {
        if (peripheral.name && ![peripheral.name isEqualToString:@"(null)"]) {
            [array addObject:peripheral];
            
            for (CBPeripheral * per in array) {
                if (![self.blueMutableAttay containsObject:per]) {
                    if (self.blueMutableAttay.count >=20) {
                        return;
                    }
                    [self.blueMutableAttay addObject:per];
                    [self.bluetoothTableView reloadData];
                    
                }
            }
        }
     
    }

//    

    
}
// 中心管理者连接外设成功
- (void)centralManager:(CBCentralManager *)central // 中心管理者
  didConnectPeripheral:(CBPeripheral *)peripheral // 外设
{
    [MBProgressHUD hideHUDForView:self.view];
    _hud = [MBProgressHUD showMessage:@"链接成功" toView:self.view];

    NSLog(@"%s, line = %d, %@=连接成功", __FUNCTION__, __LINE__, peripheral.name);
    // 连接成功之后,可以进行服务和特征的发现
    
    //  设置外设的代理
    self.BLperipheral.delegate = self;
    
    // 外设发现服务,传nil代表不过滤
    // 这里会触发外设的代理方法 - (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    [self.BLperipheral discoverServices:nil];
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    
    NSLog(@"链接成功的设备为：%@",peripheral);
    
}

// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _hud = [MBProgressHUD showMessage:error.localizedDescription toView:self.view];

    NSLog(@"%s, line = %d, %@=连接失败", __FUNCTION__, __LINE__, peripheral.name);
}

// 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _hud = [MBProgressHUD showMessage:error.localizedDescription toView:self.view];
    NSLog(@"%s, line = %d, %@=断开连接", __FUNCTION__, __LINE__, peripheral.name);
}
//4.获得外围设备的服务 & 5.获得服务的特征

// 发现外设服务里的特征的时候调用的代理方法(这个是比较重要的方法，你在这里可以通过事先知道UUID找到你需要的特征，订阅特征，或者这里写入数据给特征也可以)
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    
    for (CBCharacteristic *cha in service.characteristics) {
        //NSLog(@"%s, line = %d, char = %@", __FUNCTION__, __LINE__, cha);
        _characteristic = cha;
    }
}


// 更新特征的value的时候会调用 （凡是从蓝牙传过来的数据都要经过这个回调，简单的说这个方法就是你拿数据的唯一方法） 你可以判断是否
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    NSLog(@"已经收到蓝牙发过来的数据:%@",characteristic.value);
    NSString * bydeString = [self hexadecimalString:characteristic.value];
    NSLog(@"解析二进制出来的数据为:%@",bydeString);
    if ([characteristic  isEqual: @"你要的特征的UUID或者是你已经找到的特征"]) {
        //characteristic.value就是你要的数据
    }
}


- (UITableView *)bluetoothTableView{
    if (!_bluetoothTableView) {
        _bluetoothTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _bluetoothTableView.backgroundColor = [UIColor whiteColor];
        _bluetoothTableView.delegate = self;
        _bluetoothTableView.dataSource = self;
        [self.view addSubview:_bluetoothTableView];
    }
    
    return _bluetoothTableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.blueMutableAttay.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*OffHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    CBPeripheral * per = self.blueMutableAttay[indexPath.row];
    cell.textLabel.text =per.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",per.identifier];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.center = CGPointMake(SCREEN_WIDTH-80, 20);
    button.bounds = CGRectMake(0, 0, 40, 40);
    [button addTarget:self action:@selector(writeDataClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"发送数据" forState:UIControlStateNormal];
    [cell addSubview:button];
    
    return cell;
}
- (void)writeDataClick{
    NSMutableData *value = [NSMutableData data];
    //在这里把数据转成data存储到value里面
    NSLog(@"%@",value);
    [self.BLperipheral writeValue:value forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MBProgressHUD showIndicatorWithView:self.view showMessage:@"链接中，请稍等"];
            CBPeripheral *peripheral = self.blueMutableAttay[indexPath.row];
    
            self.BLperipheral = peripheral;
            [self.BLEManager connectPeripheral:self.BLperipheral options:nil];//如果是自己要连接的蓝牙硬件，那么进行连接
        
}

- (NSMutableArray *)blueMutableAttay{
    if (!_blueMutableAttay) {
        _blueMutableAttay = [[NSMutableArray alloc]init];
    }
    return _blueMutableAttay;
}


//将传入的NSData类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}
//将传入的NSString类型转换成NSData并返回
- (NSData*)dataWithHexstring:(NSString *)hexstring{
    NSData* aData;
    return aData = [hexstring dataUsingEncoding: NSUTF16StringEncoding];
}
// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}
//转换成十进制
- (NSString *)to10:(NSString *)num
{
    NSString *result = [NSString stringWithFormat:@"%ld", strtoul([num UTF8String],0,16)];
    return result;
}
//转换成十六进制
- (NSString *)to16:(int)num
{
    NSString *result = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",num]];
    if ([result length] < 2) {
        result = [NSString stringWithFormat:@"0%@", result];
    }
    return result;
    
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

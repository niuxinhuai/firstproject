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
#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"
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
@property (nonatomic, strong) UITextField      * my_textField;
@property (nonatomic, strong) UIButton         * senderButton;
@property (strong, nonatomic) UIButton         * getDataButton;
@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    timerCount =0;
    [self.view addSubview:self.my_textField];
    [self.view addSubview:self.senderButton];
    [self.view addSubview:self.getDataButton];
    
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
        _BLEManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
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
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"开启蓝牙" message:nil delegate:self cancelButtonTitle:@"不开启" otherButtonTitles:@"开启", nil];
//        alertView.tag = 1000;
//        alertView.delegate = self;
//        [alertView show];

    }else{
        // 开始扫描
        [self.BLEManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options:nil];
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
    // 连接外设
   // [central connectPeripheral:peripheral options:nil];
    peripheral.delegate =self;
    self.BLperipheral = peripheral;
    [self.BLEManager connectPeripheral:self.BLperipheral options:nil];//如果是自己要连接的蓝牙硬件，那么进行连接
//    if (peripheral) {
//        if (peripheral.name && ![peripheral.name isEqualToString:@"(null)"]) {
//            [array addObject:peripheral];
//            
//            for (CBPeripheral * per in array) {
//                if (![self.blueMutableAttay containsObject:per]) {
//                    if (self.blueMutableAttay.count >=20) {
//                        return;
//                    }
//                    [self.blueMutableAttay addObject:per];
//                   // [self.bluetoothTableView reloadData];
//                    
//                }
//            }
//        }
//     
//    }

//    

    
}
// 中心管理者连接外设成功
- (void)centralManager:(CBCentralManager *)central // 中心管理者
  didConnectPeripheral:(CBPeripheral *)peripheral // 外设
{
    [MBProgressHUD hideHUDForView:self.view];
    _hud = [MBProgressHUD showMessage:@"链接成功" toView:self.view];

    [self.BLEManager stopScan];
    NSLog(@"%s, line = %d, %@=连接成功", __FUNCTION__, __LINE__, peripheral.name);
    // 连接成功之后,可以进行服务和特征的发现
    
    //  设置外设的代理
    self.BLperipheral.delegate = self;
    
    // 外设发现服务,传nil代表不过滤
    // 这里会触发外设的代理方法 - (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    [self.BLperipheral discoverServices:@[[CBUUID UUIDWithString:SERVICE_UUID]]];
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    
    // 遍历出外设中所有的服务
    for (CBService *service in peripheral.services) {
        NSLog(@"所有的服务：%@",service);
    }
    
    // 这里仅有一个服务，所以直接获取
    CBService *service = peripheral.services.lastObject;
    // 根据UUID寻找服务中的特征
    [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CHARACTERISTIC_UUID]] forService:service];

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
        [peripheral readValueForCharacteristic:self.characteristic];
        
        // 订阅通知
        [peripheral setNotifyValue:YES forCharacteristic:self.characteristic];
        

    }
}
/** 订阅状态的改变 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"订阅失败");
        NSLog(@"%@",error);
    }
    if (characteristic.isNotifying) {
        NSLog(@"订阅成功");
    } else {
        NSLog(@"取消订阅");
    }
}


// 更新特征的value的时候会调用 （凡是从蓝牙传过来的数据都要经过这个回调，简单的说这个方法就是你拿数据的唯一方法） 你可以判断是否
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    NSLog(@"已经收到蓝牙发过来的数据:%@",characteristic.value);
    NSString * bydeString = [self hexadecimalString:characteristic.value];
    NSLog(@"解析二进制出来的数据为:%@",bydeString);
    
    // 另一种解析方法
    NSData * data = characteristic.value;
    NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"当前接收到的数据为 : %@",dataStr);
    self.my_textField.text = dataStr;
    
    if ([characteristic  isEqual: @"你要的特征的UUID或者是你已经找到的特征"]) {
        //characteristic.value就是你要的数据
    }
}
/** 写入数据 */
#pragma mark - 写入数据
- (void)sendAnithingWithDate{
    // 用NSData类型来写入
    NSData *data = [self.my_textField.text dataUsingEncoding:NSUTF8StringEncoding];
    // 根据上面的特征self.characteristic来写入数据
    [self.BLperipheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}
/** 读取数据 */
- (void)getAnithingWithDate {
    [self.BLperipheral readValueForCharacteristic:self.characteristic];
}

/** 写入数据回调 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"写入成功");
}


- (UITableView *)bluetoothTableView{
    if (!_bluetoothTableView) {
        _bluetoothTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200*OffHeight) style:UITableViewStylePlain];
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
- (UITextField *)my_textField{
    if (!_my_textField) {
        _my_textField = [[UITextField alloc]init];
        _my_textField.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 30);
        _my_textField.bounds = CGRectMake(0, 0, 200, 50);
        [_my_textField setBorderStyle:UITextBorderStyleLine];
        
    }
    return _my_textField;
    
}

- (UIButton *)senderButton{
    if (!_senderButton) {
        _senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _senderButton.center = CGPointMake(self.my_textField.center.x-80, CGRectGetMaxY(self.my_textField.frame)+50);
        _senderButton.bounds = CGRectMake(0, 0, 100, 30);
        [_senderButton setTitle:@"发送数据" forState:0];
        [_senderButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_senderButton addTarget:self action:@selector(sendAnithingWithDate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _senderButton;
}
- (UIButton *)getDataButton{
    if (!_getDataButton) {
        _getDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _getDataButton.center = CGPointMake(self.my_textField.center.x+80, CGRectGetMaxY(self.my_textField.frame)+50);
        _getDataButton.bounds = CGRectMake(0, 0, 100, 30);
        [_getDataButton setTitle:@"读取数据" forState:0];
        [_getDataButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_getDataButton addTarget:self action:@selector(getAnithingWithDate) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _getDataButton;
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

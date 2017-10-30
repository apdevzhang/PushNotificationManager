//
//  ViewController.swift
//  PushNotificationManagerExample-Swift
//
//  Created by BANYAN on 2017/10/25.
//  Copyright © 2017年 GREENBANYAN. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UNUserNotificationCenterDelegate,CLLocationManagerDelegate {
 
    //MARK:Property
    let normalArray: [String] = ["普通推送","普通推送,自定义提示音"]
    let graphicsArray: [String] = ["图像推送",
                                   "图像推送,自定义提示音",
                                   "图像推送,下载方式",
                                   "图像推送,下载方式,自定义提示音"]
    let videoArray: [String] = ["视频推送",
                                "视频推送,自定义提示音",
                                "视频推送,下载方式",
                                "视频推送,下载方式,自定义提示音"]
    let timingArray: [String] = ["定时推送",
                                 "定时推送,自定义提示音",
                                 "指定时间",
                                 "指定时间,自定义提示音",
                                 "定时推送,字典方式",
                                 "定时推送,字典方式,自定义提示音"]
    let interactiveArray: [String] = ["交互推送",
                                      "交互推送,自定义提示音"]
    let locationArray: [String] = ["定点推送",
                                   "定点推送,自定义提示音"]
    
    var _tableView: UITableView!
    
    let locationManager: CLLocationManager = CLLocationManager()
    var currentLongitude: Double = 0.0 //当前经度
    var currentLatitude: Double = 0.0 //当前纬度
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = UIColor.white
       
        UNUserNotificationCenter.current().delegate = self; //设置代理
        
        initUI() //UI
        locationPermission() //申请定位权限
    }
    
    
    //MARK:UI
    func initUI() {
        _tableView = UITableView.init(frame:CGRect.init(x:0,y:0,width:self.view.frame.size.width,height:self.view.frame.size.height),style:UITableViewStyle.plain)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(_tableView)
        _tableView.register(UITableViewCell().classForCoder, forCellReuseIdentifier: "cellId")
    }
    
    //MARK:申请定位权限
    func locationPermission() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
    }
    
    //MARK:UITbleviewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 4
        } else if section == 2 {
            return 4
        } else if section == 3 {
            return 6
        } else if section == 4 {
            return 2
        } else if section == 5 {
            return 2
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return " 普通类型"
        } else if section == 1 {
            return "图像类型"
        } else if section == 2 {
            return "视频类型"
        } else if section == 3 {
            return "定时类型"
        } else if section == 4 {
            return "交互类型"
        } else if section == 5 {
            return "定点类型"
        }
        return ""
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel!.text = normalArray[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel!.text = graphicsArray[indexPath.row]
        } else if indexPath.section == 2 {
            cell.textLabel?.text = videoArray[indexPath.row]
        } else if indexPath.section == 3 {
            cell.textLabel?.text = timingArray[indexPath.row]
        } else if indexPath.section == 4 {
            cell.textLabel?.text = interactiveArray[indexPath.row]
        } else if indexPath.section == 5 {
            cell.textLabel?.text = locationArray[indexPath.row]
        }
        
        cell.textLabel?.textAlignment = NSTextAlignment.left
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        cell.textLabel?.textColor = UIColor.lightGray
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        return cell
    } 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        switch indexPath.section {
        case 0: // "普通类型" = "PushNotificationStyleNormal";
            if indexPath.row == 0 {
                PushNotificationManager().normalPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "1-1", timeInterval: 3, repeat: false)
            } else if indexPath.row == 1 {
                PushNotificationManager().normalPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "1-2", soundName: "tmp.mp3", timeInterval: 3, repeat: false)
            }
        case 1: //"图像类型" = "PushNotificationStyleGraphics";
            if indexPath.row == 0 {
                PushNotificationManager().graphicsPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "2-1", fileName: "Graphics.jpg", timeInterval: 3, repeat: false)
            } else if indexPath.row == 1 {
                PushNotificationManager().graphicsPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "2-2", fileName: "Graphics.jpg", soundName: "tmp.mp3", timeInterval: 3, repeat: false)
            } else if indexPath.row == 2 {
                PushNotificationManager().graphicsPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "2-3", urlString: "https://i.loli.net/2017/09/30/59cf8056a1e21.jpg", timeInterval: 3, repeat: false)
            } else if indexPath.row == 3 {
                PushNotificationManager().graphicsPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "2-4", urlString: "https://i.loli.net/2017/09/30/59cf8056a1e21.jpg", soundName: "tmp.mp3", timeInterval: 3, repeat: false)
            }
        case 2: // "视频类型" = "PushNotificationStyleVideo";
            if indexPath.row == 0 {
                PushNotificationManager().videoPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "3-1", fileName: "Raining.mp4", timeInterval: 3, repeat: false)
            } else if indexPath.row == 1 {
                PushNotificationManager().videoPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "3-2", fileName: "Raining.mp4", soundName: "tmp.mp3", timeInterval: 3, repeat: false)
            } else if indexPath.row == 2 {
                PushNotificationManager().videoPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "3-3", urlString: "http://mvideo.spriteapp.cn/video/2017/0929/043c1392-a527-11e7-8f71-1866daeb0df1cutblack_wpcco.mp4", timeInterval: 5, repeat: false) //下载视频需要一定时间,所有我间隔给的时间较长
            } else if indexPath.row == 3 {
                PushNotificationManager().videoPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "3-4", urlString: "http://mvideo.spriteapp.cn/video/2017/0929/043c1392-a527-11e7-8f71-1866daeb0df1cutblack_wpcco.mp4", soundName: "tmp.mp3", timeInterval: 5, repeat: false)
            }
        case 3: // "定时类型" = "PushNotificationStyleTiming";
            if indexPath.row == 0 {
                PushNotificationManager().timingPushNotification(withTitle: "2017-10-27", subTitle: "little tired", body: "want to go home", identifier: "4-1", weekday: "1", hour: "2", minute: "49", second: "50", timeInterval: 3, repeat: false)
            } else if indexPath.row == 1 {
                PushNotificationManager().timingPushNotification(withTitle: "2017-10-27", subTitle: "little tired", body: "want to go home", identifier: "4-2", weekday: "1", hour: "2", minute: "49", second: "50", soundName: "tmp.mp3", timeInterval: 3, repeat: false)
            } else if indexPath.row == 2 {
                PushNotificationManager().timingPushNotification(withTitle: "王菲", subTitle: "《单行道》", body: "春眠不觉晓,庸人偏自扰", identifier: "4-3", year: "2017", month: "10", day: "2", hour: "2", minute: "0", second: "0", timeInterval: 3, repeat: false)
            } else if indexPath.row == 3 {
                PushNotificationManager().timingPushNotification(withTitle: "王菲", subTitle: "《单行道》", body: "春眠不觉晓,庸人偏自扰", identifier: "4-4", year: "2017", month: "10", day: "2", hour: "2", minute: "0", second: "0", soundName: "tmp.mp3", timeInterval: 3, repeat: false)
            } else if indexPath.row == 4 {
                PushNotificationManager().timingPushNotification(withTitle: "Bang Gang", subTitle: "《Forever Now》", body: "You can see her in the distance\n Where she walks alone\n Thenyou follow her direction\n To your second home", identifier: "4-5", fireDate: ["year":2017,"month":10,"day":2,"hour":2,"minute":55], timeInterval: 3, repeat: false)
            } else if indexPath.row == 5 {
                PushNotificationManager().timingPushNotification(withTitle: "Bang Gang", subTitle: "《Forever Now》", body: "You can see her in the distance\n Where she walks alone\n Thenyou follow her direction\n To your second home", identifier: "4-6", fireDate: ["year":2017,"month":10,"day":2,"hour":2,"minute":55], soundName: "tmp.mp3", timeInterval: 3, repeat: false)
            }
        case 4: //"交互类型" = "PushNotificationStyleInteractive";
            if indexPath.row == 0 {
                
                let inputAction = UNTextInputNotificationAction(
                    identifier: "reply",
                    title: "评论",
                    options: [.foreground],
                    textInputButtonTitle: "发送",
                    textInputPlaceholder: "说点什么")
                
                let enterAction = UNNotificationAction(
                    identifier: "enter",
                    title: "进入",
                    options: [.foreground])
                
                let cancelAction = UNNotificationAction(
                    identifier: "cancel",
                    title: "销毁",
                    options: [.destructive])
                
                PushNotificationManager().interactivePushNotification(withTitle: "Bang Gang", subTitle: "《Forever Now》", body: "You can see her in the distance\n Where she walks alone\n Then you follow her direction\n To your second home", identifier: "5-1", identifierArray: [inputAction.identifier,enterAction.identifier,cancelAction.identifier], actionArray:[inputAction,enterAction,cancelAction], timeInterval: 3, repeat: false);
            } else if indexPath.row == 1 {
                
                let inputAction = UNTextInputNotificationAction(
                    identifier: "reply",
                    title: "评论",
                    options: [.foreground],
                    textInputButtonTitle: "发送",
                    textInputPlaceholder: "说点什么")
                
                let enterAction = UNNotificationAction(
                    identifier: "enter",
                    title: "进入",
                    options: [.foreground])
                
                let cancelAction = UNNotificationAction(
                    identifier: "cancel",
                    title: "销毁",
                    options: [.destructive])
                
                PushNotificationManager().interactivePushNotification(withTitle: "Bang Gang", subTitle: "《Forever Now》", body: "You can see her in the distance\n Where she walks alone\n Then you follow her direction\n To your second home", identifier: "5-2", identifierArray: [inputAction.identifier,enterAction.identifier,cancelAction.identifier], actionArray: [inputAction,enterAction,cancelAction], soundName: "tmp.mp3", timeInterval: 3, repeat: false)
            }
        case 5: // "定点类型" = "PushNotificationStyleLocation";
            if indexPath.row == 0 {
                PushNotificationManager().locationPushNotification(withTitle: "Pink Floyd", subTitle: "《Wish You Were Here》", body: "How I wish you were here", identifier: "6-1", longitude: 120.030632, latitude: 30.288121, radius: 100, notifyOnEntry: true, notifyOnExit: true, repeat: false)
            } else if indexPath.row == 1 {
                PushNotificationManager().locationPushNotification(withTitle: "Pink Floyd", subTitle: "《Wish You Were Here》", body: "How I wish you were here", identifier: "6-2", longitude: 120.030632, latitude: 30.288121, radius: 100, notifyOnEntry: true, ontifyOnExit: true, soundName: "tmp.mp3", repeat: false)
            }
        default:
            print("")
        }
        _tableView.reloadData()
    }
    
    //MARK:iOS10->前台收到通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let identifier = notification.request.identifier //推送标识符
        let categoryIdentifier = notification.request.content.categoryIdentifier //推送里类别的标识符
        
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
                //远程推送
        } else {
            if !identifier.isEmpty {
                print("推送标识符为:\(identifier)")
            }
            if !categoryIdentifier.isEmpty {
                print("推送里类别标识符:\(categoryIdentifier)")
            }
        }
        completionHandler([.sound,.alert,.badge])
    }
    //MARK:iOS10->后台点击通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.notification.request.identifier
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
        print("标识符为:\(identifier)" + "如果存在类别标识:\(categoryIdentifier)")
        
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            //远程推送
        } else {
            //这里暂时只写出标识符为`5-2`的示例,对应为交互类型自定义提示音
            if identifier == "5-2" {
                if response.actionIdentifier == "reply" {
                    let textResponse = (response as? UNTextInputNotificationResponse)?.userText
                    print("你回复的文字为:\(textResponse!)")
                } else if response.actionIdentifier == "enter" {
                    print("你点击了'进入'")
                } else if response.actionIdentifier == "cancel" {
                    print("你点击了'取消'")
                }
            }
        }
        completionHandler()
    }
    //MARK:iOS10以下
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("iOS10收到新推送消息:\(userInfo)")
        if application.applicationState == UIApplicationState.active {
            // 代表从前台接受消息app
        }else{
            // 代表从后台接受消息后进入app            
        }
        completionHandler(.newData)
    }
    
    //MARK:CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations.last!
        
        currentLongitude = currentLocation.coordinate.longitude
        currentLatitude = currentLocation.coordinate.latitude
        
        print("当前经度:\(currentLocation.coordinate.longitude)" + "\n" + "当前纬度:\(currentLocation.coordinate.latitude)")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("离开监控区域")
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("进入监控区域")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位出错\(error)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


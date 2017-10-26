//
//  ViewController.swift
//  PushNotificationManagerExample-Swift
//
//  Created by BANYAN on 2017/10/25.
//  Copyright © 2017年 GREENBANYAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UNUserNotificationCenterDelegate {
 
//////////////////
    var normalArray: [String] = ["普通推送","普通推送,自定义提示音"]
    var graphicsArray: [String] = ["图像推送",
                                   "图像推送,自定义提示音",
                                   "图像推送,下载方式",
                                   "图像推送,下载方式,自定义提示音"]
    var videoArray: [String] = ["视频推送",
                                "视频推送,自定义提示音",
                                "视频推送,下载方式",
                                "视频推送,下载方式,自定义提示音"]
    var timingArray: [String] = ["定时推送",
                                 "定时推送,自定义提示音",
                                 "指定时间",
                                 "指定时间,自定义提示音",
                                 "定时推送,字典方式",
                                 "定时推送,字典方式,自定义提示音"]
    var interactiveArray: [String] = ["交互推送",
                                      "交互推送,自定义提示音"]
    var locationArray: [String] = ["定点推送",
                                   "定点推送,自定义提示音"]
    
    var _tableView: UITableView!
    
///////;
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = UIColor.white
       
        UNUserNotificationCenter.current().delegate = self; //设置代理
        
        initUI() //UI
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
    
    //MARK:<UITbleviewDelegate,UITableViewDataSource>
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
        case 0:
            if indexPath.row == 0 {
               PushNotificationManager().normalPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "1-1", timeInterval: 3, repeat: false)
            } else if indexPath.row == 1 {
                 PushNotificationManager().normalPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "1-2", soundName: "tmp.mp3", timeInterval: 3, repeat: false)
            }
        case 1:
            if indexPath.row == 0 {
                PushNotificationManager().graphicsPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "2-1", fileName: "Graphics.jpg", timeInterval: 3, repeat: false)
            } else if indexPath.row == 1 {
                PushNotificationManager().graphicsPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "2-2", fileName: "Graphics.jpg", soundName: "tmp.mp3", timeInterval: 3, repeat: false)
            } else if indexPath.row == 2 {
                PushNotificationManager().graphicsPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "2-3", urlString: "https://i.loli.net/2017/09/30/59cf8056a1e21.jpg", timeInterval: 3, repeat: false)
            } else if indexPath.row == 3 {
                PushNotificationManager().graphicsPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "2-4", urlString: "https://i.loli.net/2017/09/30/59cf8056a1e21.jpg", soundName: "tmp.mp3", timeInterval: 3, repeat: false)
            }
        case 2:
            if indexPath.row == 0 {
                PushNotificationManager().videoPushNotification(withTitle: "John Winston Lennon", subTitle: "《Imagine》", body: "You may say that I'm a dreamer, but I'm not the only one", identifier: "3-1", fileName: "Raining.mp4", timeInterval: 3, repeat: false)
            } else if indexPath.row == 1 {
                //
            }
        case 3:
            if indexPath.row == 0 {
                //
            } else if indexPath.row == 1 {
                //
            } else if indexPath.row == 2 {
                
            } else if indexPath.row == 3 {
                
            } else if indexPath.row == 4 {
                
            } else if indexPath.row == 5 {
                
            }
        case 4:
            if indexPath.row == 0 {
                //
            } else if indexPath.row == 1 {
                //
            }
        case 5:
            if indexPath.row == 0 {
                //
            } else if indexPath.row == 1 {
                //
            }
        default:
            print("")
        }
        _tableView.reloadData()
    }
    
    //MARK:iOS10->前台收到通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.alert,.badge])
    }

    //MARK:iOS10->后台点击通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ViewController.swift
//  GCD
//
//  Created by YouXianMing on 15/10/9.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var queue     : GCDQueue!
    var group     : GCDGroup!
    var timer     : GCDTimer!
    var semaphore : GCDSemaphore!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        timerUse()
    }
    
    // MARK: 各种用法
    
    /**
    普通用法
    */
    func normalUse() {
        
        GCDQueue.globalQueue.excute { 
            
            // 子线程执行操作
            
            GCDQueue.mainQueue.excute({ 
                
                // 主线程更新UI
            })
        }
        
        
        GCDQueue.executeInGlobalQueue { 
            
            // 子线程执行操作
            
            GCDQueue.executeInMainQueue({ 
                
                // 主线程更新UI
            })
        }
    }
    
    /**
    延时用法
    */
    func delayUse() {
        
        GCDQueue.executeInGlobalQueue({ 
            
            // 延时 2s 执行
            
            }, afterDelaySeconds: 2)
    }
    
    func waitExecute() {
        
        queue = GCDQueue(queueType: .ConcurrentQueue)
        
        queue.waitExecute { 
            
            print("1")
            sleep(1)
        }
        
        queue.waitExecute { 
            
            print("2")
            sleep(1)
        }
        
        queue.waitExecute { 
            
            print("3")
            sleep(1)
        }
        
        queue.waitExecute { 
            
            print("4")
        }
    }
    
    /**
    设置屏障
    */
    func barrierExecute() {
        
        queue = GCDQueue(queueType: .ConcurrentQueue)
        
        queue.excute { 
            
            print("1")
        }
        
        queue.excute { 
            
            print("2")
        }
        
        queue.excute { 
            
            print("3")
            sleep(1)
        }
        
        queue.barrierExecute { 
            
            print("barrierExecute")
        }
        
        queue.excute { 
            
            print("4")
        }
        
        queue.excute { 
            
            print("5")
        }
        
        queue.excute { 
            
            print("6")
        }
    }
    
    /**
    GCDGroup的使用
    */
    func groupUse() {
        
        group = GCDGroup()
        queue = GCDQueue()
        
        queue.excute({ 
            
            print("1")
            
            }, inGroup: group)
        
        queue.excute({ 
            
            print("2")
            
            }, inGroup: group)
        
        queue.excute({ 
            
            print("3")
            
            }, inGroup: group)
        
        queue.excute({ 
            
            print("4")
            
            }, inGroup: group)
        
        queue.excute({ 
            
            print("5")
            
            }, inGroup: group)
        
        queue.excute({ 
            
            print("6")
            
            }, inGroup: group)
        
        queue.excute({ 
            
            print("7")
            
            }, inGroup: group)
        
        queue.excute({ 
            
            print("8")
            
            }, inGroup: group)
        
        queue.notify({ 
            
            print("都完成了")
            
            }, inGroup: group)
    }
    
    /**
    GCDTimer的使用
    */
    func timerUse() {
        
        timer = GCDTimer(inQueue: GCDQueue.globalQueue)
        timer.event({
            
            print("timer event")
            
            }, timeIntervalWithSeconds: 5, delayWithSeconds: 5)
        
        timer.start()
    }
    
    /**
    GCD信号量的使用
    */
    func semaphoreUse() {
        
        semaphore = GCDSemaphore()
        queue     = GCDQueue(queueType: .ConcurrentQueue)
        
        queue.excute {  
            
            print("1")
            self.semaphore.signal()
        }
        
        queue.excute {  
            
            print("2")
            self.semaphore.signal()
        }
        
        queue.excute {  
            
            print("3")
            self.semaphore.signal()
        }
        
        queue.excute { 
            
            print("4")
            self.semaphore.signal()
        }
        
        queue.excute { 
            
            self.semaphore.wait()
            self.semaphore.wait()
            self.semaphore.wait()
            self.semaphore.wait()
            
            print("都完成了")
        }
    }
}


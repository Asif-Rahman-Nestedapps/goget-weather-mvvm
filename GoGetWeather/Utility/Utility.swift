//
//  Utility.swift
//  GoGetWeather
//
//  Created by Akond Asif Ur Rahman on 1/11/19.
//  Copyright © 2019 Akond Asif Ur Rahman. All rights reserved.
//

import UIKit
import  MBProgressHUD
class Utility: NSObject {
    //MARK: - Show/Hide ProgressView
    
   class func showProgressView(view:UIView){
        MBProgressHUD.showAdded(to: view, animated: true);
    }
    
   class func hideProgressView(view:UIView){
        MBProgressHUD.hide(for: view, animated: true);
    }

}

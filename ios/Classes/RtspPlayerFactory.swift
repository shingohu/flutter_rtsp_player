//
//  RtspPlayerFactory.swift
//  flutter_rtsp_player
//
//  Created by shingohu on 2023/6/6.
//

import UIKit
import Flutter

class RtspPlayerFactory: NSObject,FlutterPlatformViewFactory {
    
    
    var _messenger : FlutterBinaryMessenger
      
      init(messenger : FlutterBinaryMessenger) {
          
          self._messenger = messenger
          super.init()
          

          
      }
    
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
      
    
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return RtspPlayer.init(frame: frame, viewId: viewId, messenger: _messenger)
    }
    

}

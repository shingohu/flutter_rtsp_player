//
//  RtspPlayer.swift
//  flutter_rtsp_player
//
//  Created by shingohu on 2023/6/5.
//

import UIKit
import MobileVLCKit
import UIKit
import Flutter
import Foundation


public class RtspPlayer: NSObject ,FlutterPlatformView{
    var hostedView:UIView
    var vlcMediaPlayer: VLCMediaPlayer?
    
    
    
    
    init(frame: CGRect, viewId: Int64, messenger:FlutterBinaryMessenger) {
        
        self.hostedView = UIView(frame: frame)
        super.init()
        
        let methodChannel = FlutterMethodChannel(name: "rtsp_player_\(viewId)", binaryMessenger: messenger)
        
        methodChannel.setMethodCallHandler { (call, result) in
            
            let method = call.method
            
            if(method == "initialize"){
                let options = (call.arguments as! Dictionary<String, Any>)["options"] as! Array<String>
                
                let url =  (call.arguments as! Dictionary<String, Any>)["url"] as! String
                
                let autoPlay =  (call.arguments as! Dictionary<String, Any>)["autoPlay"] as! Bool
                
                
                self.initialize(options: options, url: url, autoPlay: autoPlay)
                
                result(true)
                
                
            }else if(method == "play"){
                self.play()
                result(true)
            }else if(method == "stop"){
                self.stop()
                result(true)
            }else if(method == "pause"){
                self.pause()
                result(true)
            }else if(method == "isPlaying"){
                result(self.isPlaying())
            }
            
            
        }
        
    }
    
    
    
    
    
    public func initialize(options:Array<String>,url:String,autoPlay:Bool){
        
        self.vlcMediaPlayer = VLCMediaPlayer.init(options: options)
        self.vlcMediaPlayer!.drawable = self.hostedView
        
        let media:VLCMedia = VLCMedia(url: URL(string: url)!);
        
        if(!options.isEmpty){
            for option in options {
                media.addOption(option)
            }
        }
        self.vlcMediaPlayer!.media = media
        if(autoPlay){
            self.vlcMediaPlayer!.play()
        }
        
    }
    
    
    
    public func play() {
        
        self.vlcMediaPlayer?.play()
    }
    
    public func pause() {
        
        self.vlcMediaPlayer?.pause()
    }
    
    public func stop() {
        
        self.vlcMediaPlayer?.stop()
    }
    
    public func isPlaying() -> Bool{
        if(self.vlcMediaPlayer != nil){
            return self.vlcMediaPlayer!.isPlaying 
        }
        return false
    }
    
    
    
    
    
    public func view() -> UIView {
        return hostedView
    }
    
    
}

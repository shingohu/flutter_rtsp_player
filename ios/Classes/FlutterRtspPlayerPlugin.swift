import Flutter
import UIKit

public class FlutterRtspPlayerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_rtsp_player", binaryMessenger: registrar.messenger())
        let instance = FlutterRtspPlayerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        
        
        registrar.register(RtspPlayerFactory.init(messenger: registrar.messenger()), withId: "rtsp_player")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        result(FlutterMethodNotImplemented)
    }
}

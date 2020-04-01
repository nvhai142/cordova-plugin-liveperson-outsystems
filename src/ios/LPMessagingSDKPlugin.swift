import Foundation
import LPMessagingSDK
import LPInfra
import LPAMS

@objc(LPMessagingSDKPlugin) class LPMessagingSDKPlugin: CDVPlugin {

	// adding delegates and callbacks for Cordova to notify javascript wrapper when functions complete
    var callBackCommandDelegate: CDVCommandDelegate?
    var callBackCommand:CDVInvokedUrlCommand?

    var registerLpPusherCallbackCommandDelegate: CDVCommandDelegate?
    var registerLpPusherCallbackCommand: CDVInvokedUrlCommand?

    var globalCallbackCommandDelegate: CDVCommandDelegate?
    var globalCallbackCommand: CDVInvokedUrlCommand?

	var lpAccountNumber:String?

    override init() {
		super.init()
    }
    
    override func pluginInitialize() {
        print("@@@ iOS pluginInitialize")
    }

	@objc(lp_sdk_init:)
    func lp_sdk_init(command: CDVInvokedUrlCommand) {

		guard let lpAccountNumber = command.arguments.first as? String else {
            print("Can't init without brandID")
            return
        }

        self.lpAccountNumber = lpAccountNumber

        print("lpMessagingSdkInit brandID --> \(lpAccountNumber)")

	}

	func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func convertDeviceTokenString(token:String) -> Data {
        
        var result: [String] = []
        let characters = Array(token)
        stride(from: 0, to: characters.count, by: 8).forEach {
            result.append(String(characters[$0..<min($0+8, characters.count)]))
        }

        var tokenAsString = result.joined(separator: " ")

        tokenAsString = "<" + tokenAsString + ">"

        let tokenAsNSData = tokenAsString.hexadecimal()! as NSData
        let tokenAsData = tokenAsString.hexadecimal()!

        print("@@@ tokenAsNSData \(tokenAsNSData)")
        print("@@@ tokenAsData \(tokenAsData)")

        print("@@@ string as 8 character chunks ... \(result)")
        print("@@@ tokenAsString --> \(tokenAsString)" )

        return tokenAsData
    }

}

extension String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.

    func hexadecimal() -> Data? {
        var data =   Data(capacity: self.count/2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
}
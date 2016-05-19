# QRScanner-iOS-Swift
QRScanner-iOS-Swift is a QR code scanning library written in Swift

# Features
QR Code Scanning

# Requirements
iOS 8.0+
Xcode 7.3+

#Usage
- instatnciate ScannerViewController
- set deleget of the ScannerViewController instance
- implemnet  QRScannerViewControllerDelegate
- peresent ScannerViewController instance from your ViewController

# QRScannerViewControllerDelegate methods
    func codeDidFound(code: String)
    func isValidCode(code: String)->Bool
    func didFail()
    func didCancel()



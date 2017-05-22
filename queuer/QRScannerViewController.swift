//
//  QRScannerViewController.swift
//  queuer
//
//  Created by Shoutem on 5/20/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class QRScannerViewController: UIViewController {
    
    // Input
    var viewModel: QRScannerViewModel!
    
    // Output
    let scannerDismised = PublishSubject<Void>()
    let codeScanned = PublishSubject<String>()

    @IBOutlet var descriptionLabel: UILabel!
    
    // View
    var overlay: UIView!
    var yellowBorder: UIView!
    var greenBorder: UIView!
    
    // Session
    var captureSession: AVCaptureSession?
    var captureSessionPaused: Bool!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startObserving()
        setupNavigationBar()
        setupViews()
        setupLabels()
        
        do {
            try setupScanning()
        } catch {
            print(error)
            return
        }
        
        bringSubviews()
    }
    
    private func startObserving() {
        viewModel.processing.bind { [weak self] processing in
            self?.captureSessionPaused = processing
        }.disposed(by: disposeBag)
        viewModel.codeApproved.asDriver(onErrorJustReturn:()).drive(onNext: { [weak self] in
            self?.codeApproved()
        }).disposed(by: disposeBag)
    }
    
    // MARK:- Navigation bar
    private func setupNavigationBar() {
        navigationItem.title = UIConstants.qrScannerTitle
        let dismissButton = UIBarButtonItem(image: UIImage(named: "ButtonClose"), style: .done, target: nil, action: nil)
        dismissButton.rx.tap.bind(to: scannerDismised).disposed(by: disposeBag)
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    // MARK:- Views
    private func setupViews() {
        let rectangle = createRectangleGap()
        overlay = createOverlay(forRectangle: rectangle)
        yellowBorder = createBorder(forRectangle: rectangle, ofColor: UIConstants.qrScannerYellowBorder)
        greenBorder = createBorder(forRectangle: rectangle, ofColor: UIConstants.qrScannerGreenBorder)
        
        view.addSubview(overlay)
        view.addSubview(yellowBorder)
        view.addSubview(greenBorder)
    }
    
    private func createRectangleGap() -> CGRect {
        let width = view.frame.width
        let height = view.frame.height
        return CGRect(x: width/2 - 150, y: height/2 - 200, width: 300, height: 300)
    }
    
    private func createOverlay(forRectangle rectangle: CGRect) -> UIView {
        let overlayView = UIView(frame: view.frame)
        overlayView.alpha = 0.7
        overlayView.backgroundColor = UIConstants.cameraOverlayColor
        
        // Create a path with the rectangle in it.
        let path = CGMutablePath()
        path.addRect(rectangle)
        path.addRect(CGRect(x: 0, y: 0, width: overlayView.frame.width, height: overlayView.frame.height))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path;
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        // Release the path since it's not covered by ARC.
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
    
    private func createBorder(forRectangle rectangle: CGRect, ofColor color: UIColor) -> UIView {
        let borderView = UIView()
        borderView.layer.borderColor = color.cgColor
        borderView.layer.borderWidth = 2
        borderView.frame = rectangle
        return borderView
    }
    
    // MARK:- Labels
    private func setupLabels() {
        descriptionLabel.font = UIConstants.qrScannerDescriptionLabelFont
        descriptionLabel.textColor = UIConstants.qrScannerDescriptionLabelColor
        descriptionLabel.text = UIConstants.qrScannerDescriptionLabelText
    }
    
    // MARK:- QR scanning
    private func setupScanning() throws {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        let input = try AVCaptureDeviceInput(device: captureDevice)
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession?.startRunning()
    }
    
    // MARK:- Presenting subviews after recording started
    private func bringSubviews() {
        view.bringSubview(toFront: overlay)
        view.bringSubview(toFront: descriptionLabel)
        view.bringSubview(toFront: yellowBorder)
    }

    // MARK:- Called on scan success
    private func codeApproved() {
        captureSessionPaused = true
        view.bringSubview(toFront: greenBorder)
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            view.bringSubview(toFront: yellowBorder)
            return
        } else if captureSessionPaused {
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            captureSessionPaused = true
            codeScanned.onNext(metadataObj.stringValue)
        }
    }
}

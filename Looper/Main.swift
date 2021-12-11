//
//  Main.swift
//  Looper
//
//  Created by Julian Silvestri on 2021-12-11.
//

import UIKit
import AVFoundation

class Main: UIViewController, AVAudioRecorderDelegate {
    

    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordingSession = AVAudioSession.sharedInstance()
        openingLogoAnimation()
        setupDisplay()
        // Do any additional setup after loading the view.
    }

    
    
    //MARK: Opening Logo Animation
    func openingLogoAnimation(){
        UIView.animate(withDuration: 1, animations: {
            self.logo.frame = CGRect(x: 16, y: 25, width: 79, height: 82)
        }, completion: {_ in
            UIView.animate(withDuration: 0.5, animations: {
                self.recordBtn.alpha = 1
            })
        })
    }
    
    func setupDisplay(){
        self.stopBtn.alpha = 0
        self.recordBtn.alpha = 0
    }
    
    func setupRecorder(){
        do {
            try self.recordingSession.setCategory(.playAndRecord, mode: .default)
            try self.recordingSession.setActive(true)
            self.recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("success recording")
                    } else {
                        print("failed to record")
                    }
                }
            }
        } catch {
            print("failure getting permission")
        }
    }
    
    //MARK: Record Btn Tapped
    func recordBtnTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    
    //MARK: Finish Recording
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            //recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            //recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    //MARK: Start Recording
    func startRecording() {
        print("starting to record")
        //self.view.isUserInteractionEnabled = false
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording001.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    //MARK: Get Documents Directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder) {
    }

    
}

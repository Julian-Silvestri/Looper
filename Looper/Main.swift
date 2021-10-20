//
//  ViewController.swift
//  Looper
//
//  Created by Julian Silvestri on 2021-10-19.
//

import UIKit
import AVFoundation

class DynamicLooperCell: UICollectionViewCell{
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var restartBtn: UIButton!
}

class Main: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,AVAudioRecorderDelegate,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var looperCollectionView: UICollectionView!
    @IBOutlet weak var logo: UIImageView!
    
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openingLogoAnimation()
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
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
        self.looperCollectionView.dataSource = self
        self.looperCollectionView.delegate = self
    }
    
    //MARK: Opening Logo Animation
    func openingLogoAnimation(){
        UIView.animate(withDuration: 1, animations: {
            self.logo.frame = CGRect(x: 16, y: 20, width: 79, height: 82)

        })
    }
    
    //MARK: Number of rows in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    //MARK: Cell For Row At
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.looperCollectionView.dequeueReusableCell(withReuseIdentifier: "looperCell", for: indexPath) as! DynamicLooperCell
        
        cell.recordBtn.setTitle("Record", for: .normal)
        cell.recordBtn.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        
        return cell
    }
    
    //MARK: Start Recording
    func startRecording() {
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
    
    //MARK: Finish Recording
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    //MARK: Record Btn Tapped
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }

}


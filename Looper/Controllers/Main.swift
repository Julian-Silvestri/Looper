//
//  Main.swift
//  Looper
//
//  Created by Julian Silvestri on 2021-12-11.
//

import UIKit
import AVFoundation

class Main: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    @IBOutlet weak var looperLogo: UIImageView!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //audioPlayer = AVAudioPlayer()
        self.audioPlayer = AVAudioPlayer()
        self.audioRecorder = AVAudioRecorder()
        //audioPlayer = AVAudioPlayer()

        self.recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //allowed
                        print("allowed to record")
                    } else {
                        // failed to record!
                        print("not allowed to record")
                    }
                }
            }
        } catch {
            // failed to record!
        }
        setupDisplay()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        openingLogoAnimation()
    }
    
    
//    \    func playAudioFile(){
//        do {
//            if audioFileUrl == nil{
//                return
//            }
//               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//               try AVAudioSession.sharedInstance().setActive(true)
//               /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//               player = try AVAudioPlayer(contentsOf: audioFileUrl, fileTypeHint: AVFileType.m4a.rawValue)
//               /* iOS 10 and earlier require the following line:
//               player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//               guard let player = player else { return }
//               player.play()
//            print("PLAYING::::: \(audioFileUrl)")
//           }
//        catch let error {
//               print(error.localizedDescription)
//           }
//    }

    
    //play your recorded audio
    @IBAction func playAudio(sender: AnyObject) {
        print("trying to play audio")

        if self.audioRecorder == nil {
            
            let audioFileUrl = getAudioRecorded()
            
            do {

                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
//                let mainUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "recording002.mp3", ofType: nil)!)
                
               /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl, fileTypeHint: AVFileType.mp3.rawValue)
               /* iOS 10 and earlier require the following line:
               player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//                guard let player = audioPlayer else { return }
                audioPlayer?.delegate = self
                audioPlayer?.volume = 4.0
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                print("PLAYING::::: \(audioFileUrl)")
           } catch let error {
                print(error.localizedDescription)
           }
            
//
//            //let path = Bundle.main.path(forResource: "recording001.mp4", ofType:"mp4")
//            //let fileURL = NSURL(fileURLWithPath: path ?? "recording001.mp4")
//            var error : NSError?
//            let soundFileUrl = getAudioRecorded()
//            do {
//
//                audioPlayer = try AVAudioPlayer.init(contentsOf: soundFileUrl as URL)
//                //audioPlayer = try AVAudioPlayer(contentsOfURL: fileURL, error: nil)
//
//            } catch {
//                print(error)
//            }
//
//
//            if let err = error{
//                print("audioPlayer error: \(err.localizedDescription)")
//            }else{
//                print("PLAYING!!!")
//                audioPlayer.delegate = self
//                audioPlayer.prepareToPlay()
//                audioPlayer.volume = 4.0
//                audioPlayer.play()
//            }
        } else{
            print("cant play audio, recorder is running")
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //recordBtn.isEnabled = true
        //stopBtn.isEnabled = false
    }

    private func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        print("Audio Play Decode Error")
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }

    private func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        print("Audio Record Encode Error")
    }
    
    //MARK: Opening Logo Animation
    func openingLogoAnimation(){
        UIView.animate(withDuration: 0.5, animations: {
            self.looperLogo.frame = CGRect(x: 10, y: 35, width: 90, height: 90)
        }, completion: { _ in
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
        //self.recordBtn.addAction(, for: .touchUpInside)
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
    
//    //MARK: Record Btn Tapped
//    func recordBtnTapped() {
//        if audioRecorder == nil {
//            startRecording()
//        } else {
//            finishRecording(success: true)
//        }
//    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        
        if audioRecorder == nil {
            //already stopped
            print("already stopped")
        } else {
            print("Stopping recording")
            audioRecorder.stop()
            audioRecorder = nil
        }

    }
    //MARK: Finish Recording
    func finishRecording(success: Bool) {

    }
    
    //MARK: Start Recording
    @IBAction func startRecording(_ sender: Any) {
        //self.view.isUserInteractionEnabled = false

        if audioRecorder == nil {
           
            self.stopBtn.alpha = 1
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording002.m4a")

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            self.audioRecorder = AVAudioRecorder()

            do {
                self.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                self.audioRecorder.delegate = self
                print("recording now....")
                self.audioRecorder.prepareToRecord()
                self.audioRecorder.record()
            } catch {
                finishRecording(success: false)
            }
        } else {
            print("ERROR -> Had to stop recording (startRecording, ibaciton)")
            finishRecording(success: true)
        }

    }
    
    //MARK: Get Documents Directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder) {
    }

    func getAudioRecorded() -> URL{
        // getting URL path for audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPath[0]
        let soundFilePath = (docDir as NSString).appendingPathComponent("recording002.m4a")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        print(soundFilePath)
        return soundFileURL as URL

    }

//    func prepareAudioPlayer() {
//
//        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let docDir = dirPath[0]
//        let path = (docDir as NSString).appendingPathComponent("recording001.mp4")
//
////        guard let path = Bundle.main.path(forResource: "recording001.m4a", ofType:"m4a") else {
////            return
////        }
//        let fileURL = URL(fileURLWithPath: path)
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
//        } catch let ex {
//            print(ex.localizedDescription)
//        }
//        audioPlayer?.prepareToPlay()
//        audioPlayer?.delegate = self
//    }
}

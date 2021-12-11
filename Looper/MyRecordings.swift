//
//  MyRecordings.swift
//  Looper
//
//  Created by Julian Silvestri on 2021-12-11.
//

import UIKit
import AVFoundation

class LooperCell: UICollectionViewCell {
    @IBOutlet weak var titleOfTrackLabel: UILabel!
    
}


class MyRecordings: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVAudioRecorderDelegate {

    @IBOutlet weak var looperCollectionView: UICollectionView!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        looperCollectionView.delegate = self
        looperCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        
//        let itemSize = UIScreen.main.bounds.width/2 - 3
//
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: itemSize, height: itemSize)
//
//        layout.minimumInteritemSpacing = 3
//        layout.minimumLineSpacing = 3
//
//        looperCollectionView.collectionViewLayout = layout
    }
    
    
    //MARK: Number of rows in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    
    
    //MARK: Cell For Row At
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.looperCollectionView.dequeueReusableCell(withReuseIdentifier: "looperCell", for: indexPath) as! LooperCell
        
        cell.titleOfTrackLabel.text = "My First Recording"
        
        return cell
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

        }
    }
    
    //MARK: Get Documents Directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //MARK: Stopped Tapped
    @objc func stoppedTapped(success: Bool){
        audioRecorder.stop()
        audioRecorder = nil
        if success {
            //recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            //recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder) {
    }

    func getFileUrl() -> URL{
        let filename = "recording001.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenWidth = UIScreen.main.bounds.width
        return CGSize.init(width: (screenWidth-55) / 2, height: (screenWidth-55) / 2 * 1.481)

    }
    

}

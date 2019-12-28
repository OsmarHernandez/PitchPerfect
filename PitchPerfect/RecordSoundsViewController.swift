//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Osmar Hernández on 23/12/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import AVFoundation

enum RecordStatus {
    case start
    case pause
}

class RecordSoundsViewController: UIViewController {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        stopRecordingButton.isEnabled = false
    }
    
    func configureUIWhenRecording(isEnabled: Bool) {
        recordingLabel.text = isEnabled ? "Recording in Progress" : "Tap to start recording"
        stopRecordingButton.isEnabled = isEnabled
        recordButton.isEnabled = !isEnabled
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        configureUIWhenRecording(isEnabled: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordingButton(_ sender: UIButton) {
        configureUIWhenRecording(isEnabled: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not successful")
        }
    }
}

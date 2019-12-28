//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Osmar Hernández on 23/12/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet var playSoundButtons: [UIButton]!
    @IBOutlet weak var stopButton: UIButton!
    
    enum ButtonType: Int { case slow = 0, fast, chipmunk, vader, echo, reverb }
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var buttonType: ButtonType? {
        didSet {
            switch buttonType! {
            case .slow:
                playSound(rate: 0.5)
            case .fast:
                playSound(rate: 1.5)
            case .chipmunk:
                playSound(pitch: 1000)
            case .vader:
                playSound(pitch: -1000)
            case .echo:
                playSound(echo: true)
            case .reverb:
                playSound(reverb: true)
            }
            
            configureUI(.playing)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI(.notPlaying)
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        buttonType = ButtonType(rawValue: sender.tag)
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopAudio()
    }
    
    @IBAction func recordANewSound(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // TODO: Status bar is hidden for landscape mode
}


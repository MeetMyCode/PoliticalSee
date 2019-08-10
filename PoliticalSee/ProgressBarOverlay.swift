//
//  ProgressBarOverlay.swift
//  PoliticalSee
//
//  Created by Rossco on 06/03/2017.
//  Copyright © 2017 Coco. All rights reserved.
//

import UIKit
import Foundation

class ProgressBarOverlay: UIViewController, UpdateProgressBarProtocol {
    
    
    var startvcReference: StartVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DIAGNOSTIC
        print("Overlay Segue Successfully Called!")
        
        GetMpData.delegate = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.global(qos: .background).async {
            GetMpData.start(startvcReference: self.startvcReference!)
        }
        
        
    }
    
    //ACTIONS AND OUTLETS
    
    
    @IBOutlet weak var ProgressBar: UIProgressView!
    
    
    @IBOutlet weak var ProgressBarMessageField: UILabel!
    

    //MARK: - PROTOCOL METHODS
    
    func updateProgressBar(message: String, percentComplete: Float) {
        
        print("Progress: \(percentComplete * 100)%")
    
        DispatchQueue.main.async {
            self.ProgressBar?.setProgress(percentComplete, animated: false)
            self.ProgressBarMessageField.text = message
        }
        
        if percentComplete == 1{
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    

}//END OF CLASS

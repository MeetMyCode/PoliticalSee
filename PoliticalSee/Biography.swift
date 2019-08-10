//
//  Biography.swift
//  PoliticalSee
//
//  Created by Ross Higgins on 01/02/2017.
//  Copyright © 2017 Coco. All rights reserved.
//

import UIKit

class Biography: UIViewController {
    
    //MARK: - CLASS VARIABLES
    var mpImage: UIImage?
    var currentMp: [String:String]?
    
    var updateMp: [String:String]?{
        didSet{
            
            currentMp = updateMp!
            updateBioInfo()
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBioInfo()
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        print("button pressed!")
    }
    
    //MARK: - ACTIONS AND OUTLETS
    
    

    @IBOutlet weak var mpBioImage: UIImageView!
    
    @IBOutlet weak var mpBioWebView: UIWebView!
    
    @IBOutlet weak var mpName: UITextView!
    
    @IBOutlet weak var mpDoB: UITextView!
    
    @IBOutlet weak var mpSince: UITextView!
        
    @IBOutlet weak var mpConstituency: UITextView!
    
    @IBOutlet weak var mpFinancialInterests: UITextView!
    
    
    
    
    
    //MARK: - MISC METHODS
    
    func updateBioInfo(){
        
        let mpId = currentMp?["idNum"]
        
        DispatchQueue.global(qos: .background).async {
            
            let request = URLRequest(url: URL(string: "http://data.parliament.uk/membersdataplatform/services/images/MemberPhoto/\(mpId!)/")!)
            
            let session = URLSession(configuration: .ephemeral)
            let task = session.dataTask(with: request, completionHandler: { (Data, URLResponse, Error) in
                
                print("Data is: \(Data)")
                
                let image = UIImage(data: Data!)
                
                DispatchQueue.main.async {
                    self.mpBioImage.image = image!
                    
                }
                
            })
            task.resume()
        }
        
        
        //SET TEXTFIELD VALUES
        mpName.text = currentMp?["fullName"]
        mpDoB.text = currentMp?["dob"]
        mpSince.text = currentMp?["startedInHouseOfCommons"]
        mpConstituency.text = currentMp?["constituency"]
        mpFinancialInterests.text = currentMp?["financialInterests"]
        
        
        let nameForHyphenation = self.currentMp?["fullName"]
        let hyphenatedName = nameForHyphenation!.replacingOccurrences(of: " ", with: "-")
        
        let searchUrl = "http://www.parliament.uk/biographies/commons/\(hyphenatedName)/\(mpId!)/"
        
        let encodedSearchUrl = searchUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        mpBioWebView.loadRequest(URLRequest(url: URL(string: encodedSearchUrl!)!))
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
}//END OF CLASS

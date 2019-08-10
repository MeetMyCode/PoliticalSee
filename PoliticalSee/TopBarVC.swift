//
//  TopBarVC.swift
//  PoliticalSee
//
//  Created by Ross Higgins on 19/01/2017.
//  Copyright © 2017 Coco. All rights reserved.
//

import Foundation
import UIKit

class TopBarVC: UIViewController{
    
    var politicalParties = PoliticalInformation.getpoliticalParties()
    var categoryOptions = ["Party","MPs with £ Interests", "MPs with Facebook", "MPs with Twitter", "MPs with Youtube", "MPs with Blogs", "MPs with Flickr"]
    var filterButtonText = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //HIDE THE DETAIL BUTTON UNTIL AN APPROPRIATE CATEGORY IS SELECTED.
        CategoryDetailButton.isHidden = true
        

    }
    

    //ACTIONS AND OULETS
    
    
    @IBOutlet weak var CategoryDetailButton: UIButton!
    
    @IBAction func CategoryDetailButtonPressed(_ sender: UIButton) {
        //INITIATE THE FILTERING OF FILTEREDMPLIST ARRAY
        performSegue(withIdentifier: "toCategoryPickerOverlay", sender: sender)
    }
    

    
    @IBOutlet weak var CategoryFilterButton: UIButton!
    
    @IBAction func CategoryFilterButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toCategoryPickerOverlay", sender: sender)
    }

    
    //SEGUE METHODS
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategoryPickerOverlay"{

            let buttonTag = (sender as! UIButton).tag
            
            let vc = segue.destination as! CategoryPickerOverlayVC
            vc.xPosition = (sender as! UIButton).frame.maxX
            vc.yPosition = (sender as! UIButton).frame.maxY + (sender as! UIButton).frame.height
            vc.buttonIDTag = buttonTag
            
            switch (sender as! UIButton).tag {
            case 1:
                vc.CategoryPickerElements = categoryOptions
     
            case 20:
                vc.CategoryPickerElements = politicalParties
            default: break
                //DO NOTHING
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
}//END OF CLASS

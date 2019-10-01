//
//  CategoryPickerOverlayVC.swift
//  PoliticalSee
//
//  Created by Ross Higgins on 19/01/2017.
//  Copyright © 2017 Coco. All rights reserved.
//

import UIKit
import Foundation


class CategoryPickerOverlayVC: UIViewController {
    
    var xPosition: CGFloat?
    var yPosition: CGFloat?
    var CategoryPickerElements: [String]?
    var buttonIDTag: Int?
    var CategoryPickerView: UIView?
    var button: UIButton?
    var buttonOrigin = CGPoint(x: 0, y: 0)
    var buttonSize: CGSize?
    var collectiveButtonFrameSize: CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //CONSTRUCT BUTTON OBJECTS AND SET RELEVANT ATTRIBUTES THAT APPEAR INSIDE THE PICKER BOX

        switch buttonIDTag! {
        case 1:
            for eachButton in CategoryPickerElements!{
                buttonSize = CGSize(width: 200, height: 20)
                collectiveButtonFrameSize = CGSize(width: (buttonSize?.width)!, height: CGFloat(CategoryPickerElements!.count) * (buttonSize?.height)!)
                CategoryPicker.frame = CGRect(origin: CGPoint(x: xPosition!, y: yPosition!), size: collectiveButtonFrameSize!)
                CategoryPicker.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                CategoryPicker.sizeToFit()
                button = createButton(eachButton: eachButton)
            }
        case 20:
            for eachButton in CategoryPickerElements!{
                buttonSize = CGSize(width: 300, height: 20)
                collectiveButtonFrameSize = CGSize(width: (buttonSize?.width)!, height: CGFloat(CategoryPickerElements!.count) * (buttonSize?.height)!)
                CategoryPicker.frame = CGRect(origin: CGPoint(x: xPosition!, y: yPosition!), size: collectiveButtonFrameSize!)
                CategoryPicker.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                CategoryPicker.sizeToFit()
                button = createButton(eachButton: eachButton)
            }
        default: break
 
        }
        self.view.addSubview(CategoryPicker)
    }

    //ACTIONS AND OUTLETS
    
    @IBOutlet weak var CategoryPicker: UIView!

    //SEGUE METHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwindToStartVC"{
            
            let buttonText = (sender as! UIButton).titleLabel?.text
            
            let vc = segue.destination as! StartVC

            switch buttonText! {
                
            //CATEGORY OPTION BUTTON SELECTED
            case "Party":
                
                vc.topBarReference?.CategoryFilterButton.setTitle(buttonText, for: .normal)
                vc.topBarReference?.CategoryDetailButton.setTitle(vc.topBarReference?.politicalParties[0], for: .normal)
                vc.topBarReference?.CategoryDetailButton.isHidden = false
                
                let searchText = vc.topBarReference?.politicalParties[0]
                vc.mpListVC?.customSearchBarSearch(searchText: searchText!, flag: "party")
                
            case "MPs with £ Interests":
                vc.topBarReference?.CategoryFilterButton.setTitle(buttonText, for: .normal)
                vc.topBarReference?.CategoryDetailButton.isHidden = true
                
                let searchText = "MPs with £ Interests"
                vc.mpListVC?.customSearchBarSearch(searchText: searchText, flag: nil)
                
            case "MPs with Facebook":
                vc.topBarReference?.CategoryFilterButton.setTitle(buttonText, for: .normal)
                vc.topBarReference?.CategoryDetailButton.isHidden = true
                
                let searchText = "MPs with Facebook"
                vc.mpListVC?.customSearchBarSearch(searchText: searchText, flag: nil)
                
            case "MPs with Twitter":
                vc.topBarReference?.CategoryFilterButton.setTitle(buttonText, for: .normal)
                vc.topBarReference?.CategoryDetailButton.isHidden = true
                
                let searchText = "MPs with Twitter"
                vc.mpListVC?.customSearchBarSearch(searchText: searchText, flag: nil)
            
            case "MPs with Youtube":
                vc.topBarReference?.CategoryFilterButton.setTitle(buttonText, for: .normal)
                vc.topBarReference?.CategoryDetailButton.isHidden = true
                
                let searchText = "MPs with Youtube"
                vc.mpListVC?.customSearchBarSearch(searchText: searchText, flag: nil)
                
            case "MPs with Blogs":
                vc.topBarReference?.CategoryFilterButton.setTitle(buttonText, for: .normal)
                vc.topBarReference?.CategoryDetailButton.isHidden = true
                
                let searchText = "MPs with Blogs"
                vc.mpListVC?.customSearchBarSearch(searchText: searchText, flag: nil)
                
            case "MPs with Flickr":
                vc.topBarReference?.CategoryFilterButton.setTitle(buttonText, for: .normal)
                vc.topBarReference?.CategoryDetailButton.isHidden = true
                
                let searchText = "MPs with Flickr"
                vc.mpListVC?.customSearchBarSearch(searchText: searchText, flag: nil)
                
                
                
                
                
                
            //DETAIL OPTION BUTTONS SELECTED.
             
            default:
                let searchText = buttonText!
                vc.mpListVC?.customSearchBarSearch(searchText: searchText, flag: "party")


            }
        }
    }
    
    //MISC METHODS

    @objc func FilterOptionButtonPressed(sender: UIButton) {
        performSegue(withIdentifier: "unwindToStartVC", sender: sender)
        
    }

    
    func createButton(eachButton: String) -> UIButton{
        
        let newButton = UIButton(frame: CGRect(origin: buttonOrigin, size: buttonSize!))
        newButton.backgroundColor = #colorLiteral(red: 0.7629032731, green: 0.9849207997, blue: 0.5062804818, alpha: 1)
        newButton.setTitle(eachButton, for: .normal)
        newButton.titleLabel?.font.withSize(UIFont.buttonFontSize)
        newButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        newButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .highlighted)
        newButton.addTarget(self, action: #selector(self.FilterOptionButtonPressed), for: .touchUpInside)
        CategoryPicker.addSubview(newButton)
        buttonOrigin = CGPoint(x: buttonOrigin.x, y: buttonOrigin.y + 20)
        
        return newButton
    }
    
    
    
    
    
}//END OF CLASS

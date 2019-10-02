//
//  TabBar.swift
//  PoliticalSee
//
//  Created by Ross Higgins on 01/02/2017.
//  Copyright © 2017 Coco. All rights reserved.
//

import UIKit

class TabBar: UIViewController {
    
    //MARK: - CLASS VARIABLES
    
    var currentVcInDetailPane = ""
    
    var detailPaneVCReference: DetailPane?
    var detailContainerView: UIView?
    var ParentVC: StartVC?
    
    var mpDataArray: [[String:String]]?
    
    //REFERENCES TO EACH SWAPPABLE VC
    var tabBioRef: Biography?
    var tabStatsRef: StatsAboutParliament?
    var tabSocialRef: SocialMedia?
    var tabNewsRef: NewsFeeds?
    var tabPetitionsRef: Petitions?
    
    var currentMp: [String:String]?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    //MARK: - ACTIONS AND OUTLETS
    
    @IBAction func ToBioPage(_ sender: UIButton) {
        
        replaceDetailVC(sender: sender)
    }
    
    @IBAction func toStats(_ sender: UIButton) {
        replaceDetailVC(sender: sender)
    }
    
    
    @IBAction func toSocialMedia(_ sender: UIButton) {
        replaceDetailVC(sender: sender)
    }
    
    @IBAction func toPetitions(_ sender: UIButton) {
        replaceDetailVC(sender: sender)
    }
    
    @IBAction func toNewsFeeds(_ sender: UIButton) {
        replaceDetailVC(sender: sender)
    }

    
    //MARK: - MISC METHODS

    
    func replaceDetailVC(sender: UIButton){
        
        var vcName: String!

        switch sender.tag {
        case 0:
            vcName = "Biography"
        case 1:
            vcName = "Stats"
        case 2:
            vcName = "Social Media"
        case 3:
            vcName = "Petitions"
        case 4:
            vcName = "News Feed"
        default:
            print("something went wrong - no viewcontroller matched!")
        }
        SwapOutControllers(vcName: vcName)

    }
    
    func SwapOutControllers(vcName: String){
        
        //CHECK currentVcInDetailPane FOR WHICH VC IS TO BE REMOVED/REPLACED.
        
        switch currentVcInDetailPane {
            
        case "Biography":
            
            //REMOVE OLD VC
            tabBioRef?.willMove(toParent: nil)
            tabBioRef?.view.removeFromSuperview()
            tabBioRef?.removeFromParent()
            
        case "News Feed":
            
            //REMOVE OLD VC
            tabNewsRef?.willMove(toParent: nil)
            tabNewsRef?.view.removeFromSuperview()
            tabNewsRef?.removeFromParent()
            
        case "Social Media":
            
            //REMOVE OLD VC
            tabSocialRef?.willMove(toParent: nil)
            tabSocialRef?.view.removeFromSuperview()
            tabSocialRef?.removeFromParent()
            
        case "Petitions":
            
            //REMOVE OLD VC
            tabPetitionsRef?.willMove(toParent: nil)
            tabPetitionsRef?.view.removeFromSuperview()
            tabPetitionsRef?.removeFromParent()
            
        case "Stats":
            
            //REMOVE OLD VC
            tabStatsRef?.willMove(toParent: nil)
            tabStatsRef?.view.removeFromSuperview()
            tabStatsRef?.removeFromParent()
            
        default:
            print("Error: unrecognised value for currentVcInDetailPane.")
        }
        

        //ADD NEW VC ACCORDING TO VALUE OF VCNAME.
        switch vcName {
            
        case "Biography":
            
            if tabBioRef != nil{
                //DO NOTHING - TAB ALREADY EXISTS IN VIEW HIERARCHY.
            }else{
                //TAB BIO REF HAS NOT BEEN SET YET.
                let newVc = storyboard?.instantiateViewController(withIdentifier: "Biography") as? Biography
                tabBioRef = newVc!
                tabBioRef?.currentMp = currentMp!
                
                //ADD NEW VC
                ParentVC?.addChild(tabBioRef!)
            }

            let width = detailContainerView?.frame.width
            let height = detailContainerView?.frame.height
            
            tabBioRef?.view.frame = CGRect(x: 0, y: 0, width: width!, height: height!)
            
            detailContainerView?.addSubview((tabBioRef?.view)!)
            
            tabBioRef?.didMove(toParent: ParentVC)
            
            //SET THE CURRENT VC IN DETAIL PANE.
            currentVcInDetailPane = "Biography"
            
            
        case "Social Media":
            let newVc = storyboard?.instantiateViewController(withIdentifier: "Social Media") as? SocialMedia
            
            tabSocialRef = newVc
            
            //ADD NEW VC
            ParentVC?.addChild(newVc!)
            
            let width = detailContainerView?.frame.width
            let height = detailContainerView?.frame.height
            
            newVc?.view.frame = CGRect(x: 0, y: 0, width: width!, height: height!)
            
            detailContainerView?.addSubview((newVc?.view)!)
            
            newVc?.didMove(toParent: ParentVC)
            
            //SET THE CURRENT VC IN DETAIL PANE.
            currentVcInDetailPane = "Social Media"

            
        case "News Feed":
            let newVc = storyboard?.instantiateViewController(withIdentifier: "News Feed") as? NewsFeeds
            
            tabNewsRef = newVc
            
            //ADD NEW VC
            ParentVC?.addChild(newVc!)
            
            let width = detailContainerView?.frame.width
            let height = detailContainerView?.frame.height
            
            newVc?.view.frame = CGRect(x: 0, y: 0, width: width!, height: height!)
            
            detailContainerView?.addSubview((newVc?.view)!)
            
            newVc?.didMove(toParent: ParentVC)
            
            //SET THE CURRENT VC IN DETAIL PANE.
            currentVcInDetailPane = "News Feed"

            
        case "Stats":
            let newVc = storyboard?.instantiateViewController(withIdentifier: "Stats") as? StatsAboutParliament
            newVc?.currentMp = currentMp!
            tabStatsRef = newVc
            
            //ADD NEW VC
            ParentVC?.addChild(newVc!)
            
            let width = detailContainerView?.frame.width
            let height = detailContainerView?.frame.height
            
            newVc?.view.frame = CGRect(x: 0, y: 0, width: width!, height: height!)
            
            detailContainerView?.addSubview((newVc?.view)!)
            
            newVc?.didMove(toParent: ParentVC)
            
            //SET THE CURRENT VC IN DETAIL PANE.
            currentVcInDetailPane = "Stats"

        
        case "Petitions":
            let newVc = storyboard?.instantiateViewController(withIdentifier: "Petitions") as? Petitions
            
            tabPetitionsRef = newVc
            
            //ADD NEW VC
            ParentVC?.addChild(newVc!)
            
            let width = detailContainerView?.frame.width
            let height = detailContainerView?.frame.height
            
            newVc?.view.frame = CGRect(x: 0, y: 0, width: width!, height: height!)
            
            detailContainerView?.addSubview((newVc?.view)!)
            
            newVc?.didMove(toParent: ParentVC)
            
            //SET THE CURRENT VC IN DETAIL PANE.
            currentVcInDetailPane = "Petitions"
            
            
        default:
            print("Error: No VC Found!")
        }

        
    }


    
    
    
    
    
    
    
    
    

}//END OF CLASS

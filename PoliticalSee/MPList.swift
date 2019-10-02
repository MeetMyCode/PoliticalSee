//
//  MPList.swift
//  PoliticalSee
//
//  Created by Ross Higgins on 14/01/2017.
//  Copyright © 2017 Coco. All rights reserved.
//

import Foundation
import UIKit

class MPList: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    //CLASS VARIABLES
    var lowerCaseNames = [String]()
    
    
    var tabBarReference: TabBar?
    var tabBioRef: Biography?
    
    var detailContainerVCReference: DetailPane?
    
    //IS THE CURRENT VC OF TYPE DETAILPANE?
    var currentVcIsDetailPane = true

    var detailContainerView: UIView?
    var parentVC: StartVC?
    
    //BOTH FILTERED AND NON-FILTERED ARRAYS MUST BE OBSERVED VIA DIDSET. THEY ARE POPULATED FROM THE TEXT FILE IN STARTVC2
    //BOTH ARE AN ARRAY OF DICTIONARIES, EACH CONTAINING THE NAME, PARTY AND CONSTITUENCY OF EACH MP FOUND
    //IE ["NAME":"BOB","PARTY":"CONSERVATIVES","CONSTITUENCY":"LONDON"]
    var filteredMpInfoList = [[String:String]](){
        didSet {
            mpListTV?.reloadData()
            print("filteredMpInfoList updated!")
        }
    }
    
    var mpInfoList = [[String:String]](){
        didSet {
            self.filteredMpInfoList = self.mpInfoList
            
            //ADD THE NAMES TO A SEPERATE ARRAY AND LOWERCASE THEM ALL (FOR COMPARISON PURPOSES WHEN SEARCHING)
            for eachMp in mpInfoList{
                lowerCaseNames.append(eachMp["fullTitle"]!)
            }
            print("mpInfoList updated!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mpListTV.delegate = self
        mpListTV.dataSource = self
        searchBar.delegate = self
        
        
        //GIVE THE TV A BORDER
        mpListTV.layer.masksToBounds = true
        mpListTV.layer.borderColor = UIColor( red: 153/255, green: 153/255, blue:0/255, alpha: 1.0 ).cgColor
        mpListTV.layer.borderWidth = 2.0
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        mpListTV.reloadData()

        
//        //DIAGNOSTIC
//        print(filteredMpInfoList)
    }
    
    //MARK: - IBACTIONS AND OUTLETS
    
    @IBOutlet weak var mpListTV: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
     
    //MARK: - SEARCHBAR METHODS
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchText == ""{
            filteredMpInfoList = mpInfoList
            
        }else{
            filteredMpInfoList = []
            
            for mp in mpInfoList{
                
                let name = mp["fullTitle"]

                if name!.lowercased().contains(searchText.lowercased()) {
                    
                    self.filteredMpInfoList.append(mp)
                    //print("******************* names added to filtered array are: \(self.filteredMpInfoList)")
                }
            }
        }
        
    }

    
    
    //MARK: - TABLEVIEW METHODS
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        print("number of cells in table view is: \(filteredMpInfoList.count)")
        
        //SET THE CURRENT MP IN THE TAB BAR VC SO THAT WHEN YOU CHANGE BETWEEN TABS, THE CURRENT MP'S INFO IS AVAILABLE.
        tabBarReference?.currentMp = filteredMpInfoList[indexPath.row]
        
        replaceDetailVC(detailView: detailContainerView!, detailVC: detailContainerVCReference!, parentVC: parentVC!, indexPath: indexPath)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return filteredMpInfoList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        
        let mp = filteredMpInfoList[indexPath.row] as NSDictionary

        cell.MpName.text = mp["fullTitle"] as? String
        cell.Constituency.text! = mp["constituency"] as! String
        cell.PartyLogo.image! = getPartyLogo(partyName: mp["party"] as! String)

        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 1
    }
    
    //MISC METHODS
    
    func replaceDetailVC(detailView: UIView, detailVC: DetailPane, parentVC: StartVC, indexPath: IndexPath){
        
        let mp = filteredMpInfoList[indexPath.row]

        
        //IF THE ORIGINAL DETAILPANE HAS ALREADY BEEN REPLACED, YOU ONLY NEED TO UPDATE THE DATA IN THE SAME BIOGRAPHY CLASS INSTANCE. THEREFORE, JUST UPDATE/REPLACE THE MP INFORMATION.
        if tabBioRef != nil{
            
            tabBioRef?.updateMp = mp

        }else{
            
            //THIS RUNS AT STARTUP AND AUTO LOADS THE FIRST MP.
            
            tabBioRef = storyboard?.instantiateViewController(withIdentifier: "Biography") as? Biography
            tabBioRef?.currentMp = mp
            
            tabBarReference?.tabBioRef = tabBioRef!
            tabBarReference?.currentVcInDetailPane = "Biography"
            tabBarReference?.currentMp = mp
            
            //REMOVE OLD VC OF TYPE DETAILPANE - THIS IS THE FIRST MP TO LOAD AT STARTUP.
            detailVC.willMove(toParent: nil)
            detailVC.view.removeFromSuperview()
            detailVC.removeFromParent()
            
            //ADD NEW VC
            parentVC.addChild(tabBioRef!)
            
            let width = detailContainerView?.frame.width
            let height = detailContainerView?.frame.height
            
            tabBioRef?.view.frame = CGRect(x: 0, y: 0, width: width!, height: height!)
            
            detailContainerView?.addSubview((tabBioRef?.view)!)
            
            tabBioRef?.didMove(toParent: parentVC)


        }
        
    }

    func getPartyLogo(partyName: String) -> UIImage{
        
        switch partyName {
        case "Labour":
            return #imageLiteral(resourceName: "LabourLogo") as UIImage
            
        case "Liberal Democrat":
            return #imageLiteral(resourceName: "LibDemLogo") as UIImage

        case "Conservative":
            return #imageLiteral(resourceName: "toryLogo") as UIImage
            
        case "Scottish National Party":
            return #imageLiteral(resourceName: "snpLogo") as UIImage
            
        case "Democratic Unionist Party":
            return #imageLiteral(resourceName: "DUPLogo") as UIImage

        case "Plaid Cymru":
            return #imageLiteral(resourceName: "PlaidCymruLogo") as UIImage

        case "Social Democratic & Labour Party":
            return #imageLiteral(resourceName: "SDLPLogo") as UIImage

        case "Sinn Fein":
            return #imageLiteral(resourceName: "sinnFeinLogo") as UIImage

        case "UK Independence Party":
            return #imageLiteral(resourceName: "UKIPLogo") as UIImage

        case "Green Party":
            return #imageLiteral(resourceName: "GreenLogo") as UIImage
            
        case "Labour (Co-op)":
            return #imageLiteral(resourceName: "LabourLogo") as UIImage

        case "Ulster Unionist Party":
            return #imageLiteral(resourceName: "UUPLogo") as UIImage
            
        default:
            return #imageLiteral(resourceName: "ImagePlaceHolder") as UIImage

        }
        
        
    }
    
    
    func customSearchBarSearch(searchText: String, flag: String?){
        
        //USE THIS FOR SELECTING BY PARTY.
        if flag != nil{
            
            switch flag! {
                
                case "party":
                    
                    if searchText == "All"{
                        filteredMpInfoList = mpInfoList
                    }else{
                        filteredMpInfoList = []
                        for eachMp in mpInfoList{
                            if eachMp["party"] == searchText{
                                filteredMpInfoList.append(eachMp)
                            }
                        }
                    }

                    
                default:
                    break
            }
   
        }else{
            
            //USE THIS FOR SELECTING BY FINANCIAL INTERESTS.
            switch searchText {
            case "MPs with £ Interests":
                filteredMpInfoList = []
                for eachMp in mpInfoList{
                    if eachMp["financialInterests"] != "No financial interests publicised."{
                        filteredMpInfoList.append(eachMp)
                    }
                }
                
            case "MPs with Facebook":
                filteredMpInfoList = []
                for eachMp in mpInfoList{
                    if eachMp["facebook"] != "Not publicised."{
                        filteredMpInfoList.append(eachMp)
                    }
                }
             
            case "MPs with Twitter":
                filteredMpInfoList = []
                for eachMp in mpInfoList{
                    if eachMp["twitter"] != "Not publicised."{
                        filteredMpInfoList.append(eachMp)
                    }
                }
                
            case "MPs with Youtube":
                filteredMpInfoList = []
                for eachMp in mpInfoList{
                    if eachMp["youtube"] != "Not publicised."{
                        filteredMpInfoList.append(eachMp)
                    }
                }
                
            case "MPs with Blogs":
                filteredMpInfoList = []
                for eachMp in mpInfoList{
                    if eachMp["blog"] != "Not publicised."{
                        filteredMpInfoList.append(eachMp)
                    }
                }
                
            case "MPs with Flickr":
                filteredMpInfoList = []
                for eachMp in mpInfoList{
                    if eachMp["flickr"] != "Not publicised."{
                        filteredMpInfoList.append(eachMp)
                    }
                }
                
            default:
                break
            }    
            
        }

    }
    
    
    //MISC FUNCTIONS

    
    
    
    
}//END OF CLASS

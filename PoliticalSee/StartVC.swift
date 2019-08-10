//
//  StartVC2.swift
//  PoliticalSee
//
//  Created by Ross Higgins on 17/01/2017.
//  Copyright © 2017 Coco. All rights reserved.
//

import Foundation
import UIKit


class StartVC: UIViewController{
    
    //MARK: - CLASS VARIABLES
    
    //PROGRESS BAR COMPONENTS
    var ProgressBar: UIProgressView?
    var ProgressTextField: UILabel?
    var ProgressContainer: UIView?
    
    //CONTAINER VIEW VC REFERENCES FROM EMBED SEGUES.
    var mpListVC: MPList?
    var topBarReference: TopBarVC?
    var tabBarReference: TabBar?
    var detailPane: DetailPane?
    var fileSize: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //MARK: - CHECK IF MPDATA HAS BEEN POPULATED. IF SO, DO NOTHING, OTHERWISE GET MP INFO VIA GETMPDATA.START()
        let file: FileHandle? = FileHandle(forReadingAtPath: "/Users/rossco/Desktop/Swift Development/PoliticalSee/PoliticalSee/mpData.txt")
        
        do{
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: "/Users/rossco/Desktop/Swift Development/PoliticalSee/PoliticalSee/mpData.txt")
            fileSize = fileAttributes[FileAttributeKey.size] as? Int
            
            file?.closeFile()
 
            //DIAGNOSTIC PRINT
            //print("size of data is: \(text)")
            //print("size of data is: \(fileSize!)")
            
        }catch{
            print("Error: \(error)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setEmbedSegueReferences()
        
        //FETCH MP INFO AND POPULATE MPDATA.TXT.
        if fileSize == 0{
            
            //SHOW PROGRESS OVERLAY AND RETRIEVE API DATA
            self.performSegue(withIdentifier: "toProgressBarOverlay", sender: self)
            
        }else{
            
            //PROCESS THE POPULATED TEXT FILE.
            processTextFile()
        }

    }
    

    //MARK: - IBACTIONS AND OUTLETS
    
    @IBOutlet weak var detailContainer: UIView!
 
    
    //MARK: - SEGUE METHODS (FOR STORING A REFERENCE TO THE EMBEDDED VC AT THE WHEN EMBEDDING TAKES PLACE)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            //EMBEDDED SEGUES
        
            if segue.identifier == "toLeftPane"{
                mpListVC = segue.destination as? MPList
            }
            
            if segue.identifier == "toTopBarPane"{
                topBarReference = segue.destination as? TopBarVC
            }
            
            if segue.identifier == "toTabBar"{
                tabBarReference = segue.destination as? TabBar
            }
            
            if segue.identifier == "toDetailPane"{
                detailPane = segue.destination as? DetailPane
            }
        
        
            //NON-EMBEDDED SEGUES
        
            if segue.identifier == "toProgressBarOverlay"{
                let vc = segue.destination as? ProgressBarOverlay
                vc?.startvcReference = self
            }

    }
    
    //MARK: - UNWIND SEGUE
    @IBAction func unwindToStartVC(segue: UIStoryboardSegue) {}

    //MISC FUNCTIONS

    func processTextFile(){

        //READ FROM MPDATA.TXT ONE LINE AT A TIME AND STORE THE RELEVANT INFO FROM EACH LINE INTO AN MPINFO DICTIONARY OBJECT.
        //THEN STORE THE COLLECTION OF THOSE OBJECTS INTO AND MPINFO ARRAY.
        
        var finalMpInfoList = [[String:String]]()
        
        //FIXME: - THIS MIGHT HAVE TO BE SET AS A RELATIVE PATH WHEN BUILDING FOR RELEASE.
        let filePath = URL(fileURLWithPath: "/Users/rossco/Desktop/Swift Development/PoliticalSee/PoliticalSee/mpData.txt")
        
        do{
            
            var draftMpInfoList = [String]()
            
            //READ IN FILE CONTENTS
            let contents = try String(contentsOf: filePath, encoding: .utf8)
            let lines = contents.components(separatedBy: .newlines)
            
            //APPEND EACH LINE TO A SEPERATE INDEX LOCATION IN THE ARRAY
            for line in lines{
                draftMpInfoList.append(line)
            }
            draftMpInfoList.removeLast()
            
            
            //DIAGNOSTICS 1 PRINT OF THE FILE
            //            print("draft mp info list contains:")
            //            for eachMp in draftMpInfoList{
            //                print(eachMp)
            //            }
            
            
            for eachMp in draftMpInfoList{
                
                //RESET MPINFO TO DEFAULT FIRST.
                var mpInfo = PoliticalInformation.getMpDictionary()
                
                let components = eachMp.components(separatedBy: "*")
                
                //DIAGNOSTIC PRINT
                //                print("\(components.count) items in components array:")
                //                print("\(components)")
                
                mpInfo["idNum"] = components[0]
                mpInfo["firstName"] = components[1]
                mpInfo["middleName"] = components[2]
                mpInfo["surname"] = components[3]
                mpInfo["fullName"] = components[4]
                mpInfo["fullTitle"] = components[5]
                mpInfo["placeOfBirth"] = components[6]
                mpInfo["gender"] = components[7]
                mpInfo["startedInHouseOfCommons"] = components[8]
                mpInfo["party"] = components[9]
                mpInfo["dob"] = components[10]
                mpInfo["age"] = components[11]
                mpInfo["financialInterests"] = components[12]
                mpInfo["politicalInterests"] = components[13]
                mpInfo["countriesOfInterest"] = components[14]
                mpInfo["otherInterests"] = components[15]
                mpInfo["web"] = components[16]
                mpInfo["youtube"] = components[17]
                mpInfo["flickr"] = components[18]
                mpInfo["blog"] = components[19]
                mpInfo["facebook"] = components[20]
                mpInfo["twitter"] = components[21]
                mpInfo["constituency"] = components[22]
                mpInfo["parliamentaryPhone"] = components[23]
                mpInfo["parliamentaryEmail"] = components[24]
                mpInfo["parliamentaryFax"] = components[25]
                mpInfo["parliamentaryAddress"] = components[26]
                mpInfo["departmentalAddress"] = components[27]
                mpInfo["departmentalPhone"] = components[28]
                mpInfo["departmentalFax"] = components[29]
                mpInfo["departmentalEmail"] = components[30]
                mpInfo["constituencyPhone"] = components[31]
                mpInfo["constituencyEmail"] = components[32]
                mpInfo["constituencyFax"] = components[33]
                mpInfo["constituencyAddress"] = components[34]
                mpInfo["governmentPostHeld"] = components[35]
                mpInfo["parliamentaryPostHeld"] = components[36]
                mpInfo["staff"] = components[37]
                
                
                finalMpInfoList.append(mpInfo)
                
                //DIAGNOSTICS 4: PRINT OUT EACH MP FROM THE FINAL LIST.
                //                for each in mpInfo{
                //                    print("     \(each.key) - \(each.value)")
                //                }
            }
            
            //DIAGNOSTICS 4: PRINT OUT EACH MP FROM THE FINAL LIST.
            //            var count = 1
            //            let total = finalMpInfoList.count
            //            for each in finalMpInfoList{
            //
            //                print("(After reading from file.) \(count) out of \(total)")
            //
            //                    for mp in each{
            //                    print("     \(mp.key) - \(mp.value)")
            //                }
            //                count += 1
            //            }
            
            
        }catch{
            print("error is: \(error as NSError)")
        }
        
        //AFTER FINALMPINFOLIST HAS BEEN SUCCESSFULLY POPULATED, ASSIGN ITS VALUE TO MPINFOLIST IN THE MPLIST CLASS.
        
        
        DispatchQueue.main.async {
            self.mpListVC?.mpInfoList = finalMpInfoList            
            PoliticalInformation.setMpDataArray(array: finalMpInfoList)
            
            self.tabBarReference?.currentMp = finalMpInfoList[0]
            
            self.mpListVC?.tableView((self.mpListVC?.mpListTV)!, didSelectRowAt: IndexPath(row: 0, section: 0))
        }
        
    }
    
    
    //MARK: MISC FUNCTIONS
    
    func constructProgressSubView(){
        
        //x: 168, y: 297,width 688, height 195
        ProgressContainer = UIView(frame: CGRect(x: 168, y: 297, width: 688, height: 195))
        ProgressContainer?.backgroundColor = UIColor.lightGray
        ProgressContainer?.tag = 100
        self.view.addSubview(ProgressContainer!)
        
        //x 39,y 75,width 611,height 2
        ProgressBar = UIProgressView(frame: CGRect(x: 39, y: 75, width: 611, height: 2))
        ProgressBar?.tag = 101
        ProgressContainer?.addSubview(ProgressBar!)

        
        //x 39,y 98,width 611,height 21
        ProgressTextField = UILabel(frame: CGRect(x: 39, y: 98, width: 611, height: 21))
        ProgressTextField?.tag = 102
        ProgressTextField?.text = "Update message goes here..."
        ProgressContainer?.addSubview(ProgressTextField!)

    }
    
    func setEmbedSegueReferences(){
        
        tabBarReference?.detailPaneVCReference = detailPane
        tabBarReference?.detailContainerView = detailContainer
        

        
        mpListVC?.detailContainerVCReference = detailPane
        mpListVC?.detailContainerView = detailContainer
        mpListVC?.parentVC = self
        mpListVC?.tabBarReference = tabBarReference
        
    }

    
    
    
    
    
    
    
}//END OF CLASS

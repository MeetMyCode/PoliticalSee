//
//  StartVC.swift
//  PoliticalSee
//
//  Created by Ross Higgins on 14/01/2017.
//  Copyright © 2017 Coco. All rights reserved.
//

import UIKit
import Foundation

class StartVC: UIViewController {
    
    var mpBioDict = [String:String]()
    
    var resultsString = ""
    var resultsCount: Int?
    var numberOfMps = 0
    
    weak var mpListVC: MPList?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: - IF INFORMATION IS GOING TO BE RETRIEVED FROM THE NET, CHECK FOR INTERNET CONNECTION FIRST!
        

        let resultsPerPage = 4333
        //let MOPApiBaseUrl = "http://lda.data.parliament.uk/commonsmembers.json?_view=members&_pageSize="
        let MOPApiBaseUrl = "http://data.parliament.uk/membersdataplatform/services/mnis/members/query/House=Commons%7CIsEligible=true"

        let memberBioInfoUrl = URL(string: "\(MOPApiBaseUrl)\(resultsPerPage)")
        var request = URLRequest(url: memberBioInfoUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        //request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")


        //CREATE A SESSION CONFIGURATION
        let sessionWithoutADelegate = URLSession(configuration: .ephemeral)
        //sessionWithoutADelegate.dataTask(with: URLRequest)
        
        
        //CREATE THE URL AND MAKE THE REQUEST
            sessionWithoutADelegate.dataTask(with: request, completionHandler: { (data, response, error) in

                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    

                    
                    //CONTAINS ALL THE EACHMPINFO INFO COLLECTED FOR ALL OF THE MPS FOUND
                    var mpInfoList = [NSDictionary]()
                    
                    //CONTAINS THE INFO COLLECTED FOR EACH MP FOUND
                    var eachMpInfo = ["name":"","party":"","constituency":""]
                    
                    //CONTAINS THE NAMES COLLECTED FOR EACH MP FOUND AND NOT FOUND IN THE LIST
                    var mpFound = [String]()
                    var mpNotFound = [String]()
                    
                    //HANDLE THE RETURNED DATA
                    do{
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        let resultDict = json as! NSDictionary
                        
                        print(resultDict)
                        print(response! as URLResponse)
                        
                        
                        let resultsSection = resultDict["members"] as! NSDictionary

                        //let resultsSection = resultDict["result"] as! NSDictionary
                        
                        //print(resultsSection)

                        //THIS SECTION CONTAINS THE INFORMATION YOU WANT - NAME, CONSTITUENCY, PARTY AFFILIATION ETC
                        self.resultsCount = resultsSection["totalResults"] as? Int
                        let mpList = resultsSection["items"] as! NSArray
                        
                        
                        //THIS IS WHERE YOU EXTRACT SAID NAME, CONSTITUENCY, PARTY AFFILIATION ETC
                        for each in mpList{
            
                            let eachMp = each as! NSDictionary
                                
                                //EXTRACT THE FULL NAME - IF THE NAME IS IN THE LIST OF MPS, THEY WILL HAVE A PARTY AFFILIATION AND CONSTITUENCY
                                let mpFullNameKey = eachMp["fullName"] as! NSDictionary
                                let mpFullNameValue = mpFullNameKey["_value"] as! String
                                
                                let listOfMps = ListOfMPs()
//                                print("list of MPs (\(listOfMps.currentMps.count)) is:")
//                                for each in listOfMps.currentMps{
//                                    print("\(each)")
//                                }
                            
                            if listOfMps.currentMps.contains(mpFullNameValue){
                                
                                //APPEND THE FULL NAME TO EACHMPINFO
                                eachMpInfo["name"] = mpFullNameValue
                                mpFound.append(mpFullNameValue)
                                
                                //EXTRACT THE CONSTITUENCY
                                if let mpConstituencyDict = eachMp["constituency"] as? NSDictionary{
                                    
                                    let mpConstituencyKey = mpConstituencyDict["label"] as! NSDictionary
                                        if let mpConstituencyValue = mpConstituencyKey["_value"] as? String{
                                            eachMpInfo["constituency"] = mpConstituencyValue
                                        }else{
                                            eachMpInfo["constituency"] = "No constituency found."
                                        }
                                }
                                
                                //EXTRACT THE PARTY AFFILIATION
                                if let mpPartyKey = eachMp["party"] as? NSDictionary{
                                    if let mpPartyValue = mpPartyKey["_value"] as? String{
                                        eachMpInfo["party"] = mpPartyValue
                                    }else{
                                        eachMpInfo["party"] = "not a party member."
                                    }
                                }
                                
                                //ADD THE MPS INFO TO THE MP INFO LIST ARRAY
                                mpInfoList.append(eachMpInfo as NSDictionary)
                                self.numberOfMps += 1
                                
                                
                            }else{
                                mpNotFound.append(mpFullNameValue)
                            }
                                
                            


//                            //TWITTER NAME
//                            if let mpTwitterKey = (eachMp["twitter"] as? NSDictionary){
//                                if let mpTwitterValue = mpTwitterKey["_value"] as? String{
//                                    self.resultsString.append(" - " + mpTwitterValue)
//                                }
//                            }
//                            
//                            //GENDER
//                            let mpGenderKey = eachMp["gender"] as! NSDictionary
//                            let mpGenderValue = mpGenderKey["_value"] as! String
//                            self.resultsString.append(mpGenderValue)
//
//                            //WEBSITE
//                            if let mpWebSiteValue = eachMp["homePage"] as? String{
//                                self.resultsString.append(" - " + mpWebSiteValue)
//
//                            }

                        }
                        
                        //MARK: - AFTER ALL THE INFO HAS BEEN EXTRACTED FOR EACH MP - BELOW ARE SOME DIAGNISTICS
//                        let smallSet: Set<String> = Set(mpFound)
//                        let listOfMps = ListOfMPs()
//                        let bigSet: Set<String> = Set(listOfMps.currentMps)
//                        
//                        let mpsNotFoundSet = bigSet.symmetricDifference(smallSet)
//                        
//                        print("big set (listOfMPs.currentMps) = \(bigSet.count)")
//                        print("smallset (mpFound) = \(smallSet.count)")
//                        print("mpInfoList = \(mpInfoList.count)")
//                        print("mpFound = \(mpFound.count)")
//                        print("mpNotFound = \(mpNotFound.count)")
//                        print("mpNotFoundSet = \(mpsNotFoundSet.count)")
//
//
//                        print("\(mpsNotFoundSet.count) MPs from (listOfMPs.currentMps) not found online.")
//                        
//                        //FIXME: - SEARCH THROUGH THE PRINT OUT OF MPLIST TO AMEND THE SPELLINGS IN listOfMPs.currentMps SO THAT THEY MATCH THE SPELLING FOUND ONLINE.
//                        
//                        for each in mpsNotFoundSet{
//                            print(each)
//                            
//                        }
//                        
//                        //print("number of MPs not found: \(mpNotFound.count)")
//                        print("number mps found: \(mpInfoList.count)")
//                        
//                        
//                        
//                        
//                        
//                        //POPULATE THE MPLIST ARRAYS (ON THE UI THREAD) WITH THE FINAL LIST OF MP DATA
//                        DispatchQueue.main.async {
//                            
//                            self.mpListVC?.mpInfoList = mpInfoList
//                            print("********************** \(mpInfoList.count) in mpInfoList is: \(mpInfoList)")
//                        }

                    
                    }catch{
                        print("Error: \(error)")
  
                    }
                    
                    //DIAGNOSTICS: - CHECKING FOR DUPLICATE ENTRIES
                    
                    for each in mpFound{
                        
                        var found = false
                        
                        for each2 in mpFound{
                            
                            if each == each2{
                                
                                if found == true{
                                    print("duplicate found: \(each2)")
                                }
                                
                                found = true
                            }
                        }
                    }

                    
                    //print("\(self.numberOfMps) out of \(self.resultsCount!) results.")
                    //print("\(self.resultsString)")


                }
            }).resume()
            
  


    
    
    }
    

    
    //SEGUE METHODS
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LeftPane"{
            mpListVC = segue.destination as? MPList
        }
    }

}//END OF CLASS


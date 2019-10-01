import UIKit
import Foundation


protocol UpdateProgressBarProtocol: class {
    func updateProgressBar(message: String, percentComplete: Float)
}

class GetMpData{
    
    private static var eachMp = PoliticalInformation.getMpDictionary()
    
    private static var mpList = [[String:String]]()
    private static var parliamentaryAddress = [String]()
    private static var departmentalAddress = [String]()
    private static var constituencyAddress = [String]()
    private static var placeOfBirth = [String]()
    private static var count = 1
    private static var progressCounter: Float = 0.0
    static var delegate: UpdateProgressBarProtocol?
    
    static func start(startvcReference: StartVC){
        
        //SET DEFAULT VALUES FOR self.eachMp
        for (key,_) in self.eachMp{
            self.eachMp[key] = "Not publicised."
            
        }
        
        let dispatchGroup1 = DispatchGroup()
        dispatchGroup1.enter()
        
        getMpInfo(dispatchGroup1: dispatchGroup1)

        dispatchGroup1.wait()
        
        print("mp info retrieval complete!")

        //WRITE ALL MP DATA TO FILE
        let file: FileHandle? = FileHandle(forWritingAtPath: "/Users/rossco/Desktop/Software Development/Swift Development/PoliticalSee/PoliticalSee/mpData.txt")
        writeMpToFile(file: file)
        file?.closeFile()
        
        //ONCE ALL DATA HAS BEEN WRITTEN TO FILE, PROCESS IT FOR DISPLAY.
        startvcReference.processTextFile()
        
    }
    
    private static func getMpInfo(dispatchGroup1: DispatchGroup){
        
        /*
         THIS HTTP REQUEST COLLECTS INFORMATION ABOUT MPS AS LISTED IN THE self.eachMp ARRAY.
         */
        
        let url = URL(string: "http://data.parliament.uk/membersdataplatform/services/mnis/members/query/House=Commons%7CIsEligible=true/")
        
        
        var request1 = URLRequest(url: url!)
        request1.addValue("application/json", forHTTPHeaderField: "content-type")
        let session1 = URLSession(configuration: .ephemeral)
        
        let result = session1.dataTask(with: request1) { (Data, URLResponse, Error) in
            
            let response = URLResponse as! HTTPURLResponse
            
            if response.statusCode == 200{
                
                do{
                    
                    let parsedJson = try JSONSerialization.jsonObject(with: Data!, options: [])
                    
                    let resultsDict = parsedJson as! NSDictionary
                    
                    //print("returned json data is \(resultsDict)")
                    
                    let member = resultsDict["Members"] as! NSDictionary
                    let members = member["Member"] as! NSArray
                    
                    for each in members{
                        
                        let mp = each as! NSDictionary
                        
                        //MARK: - GRAB BASIC MP SPECIFIC DETAILS
                        if mp["@Member_Id"] is NSNull{
                            //DO NOTHING
                        }else{
                            self.eachMp["idNum"] = mp["@Member_Id"] as? String
                        }
                        
                        
                        //THIS VALUE IS EITHER GOING TO BE A STRING (ACTUAL DOB IS PRESENT) OR A DICTIONARY (DOB IS NOT PRESENT).
                        if mp["DateOfBirth"] is NSNull{
                            //DO NOTHING
                        }else{
                            
                            if (mp["DateOfBirth"] as? NSDictionary) != nil{
                                //DO NOTHING
                            }else{
                                let dateOfBirthStringToFormat = mp["DateOfBirth"] as? String
                                
                                self.eachMp["dob"] = formatDateOfBirthString(dateOfBirthStringToFormat: dateOfBirthStringToFormat!)
                                
                                print("date fo birth is: \(self.eachMp["dob"])")
                            }
                        }
                        if mp["DisplayAs"] is NSNull{
                            //DO NOTHING
                        }else{
                            self.eachMp["fullName"] = mp["DisplayAs"] as? String
                        }
                        
                        if mp["FullTitle"] is NSNull{
                            //DO NOTHING
                        }else{
                            self.eachMp["fullTitle"] = mp["FullTitle"] as? String
                        }
                        
                        if mp["Gender"] is NSNull{
                            //DO NOTHING
                        }else{
                            self.eachMp["gender"] = mp["Gender"] as? String
                        }
                        
                        if mp["HouseStartDate"] is NSNull{
                            //DO NOTHING
                        }else{
                            
                            let commmonsStartDate = mp["HouseStartDate"] as? String
                            let dateStarted = getTimeInCommons(commonsStartDate: commmonsStartDate!)
                            self.eachMp["startedInHouseOfCommons"] = dateStarted
                        }
                        
                        if mp["MemberFrom"] is NSNull{
                            //DO NOTHING
                        }else{
                            self.eachMp["constituency"] = mp["MemberFrom"] as? String
                        }
                        
                        
                        if let partyAffiliation = mp["Party"] as? NSDictionary{
                            
                            if partyAffiliation["#text"] is NSNull{
                                //DO NOTHING
                            }else{
                                self.eachMp["party"] = partyAffiliation["#text"] as? String
                            }
                        }
                        
                        let mpId = mp["@Member_Id"] as? String
                        
                        let dispatchGroup = DispatchGroup()
                        dispatchGroup.enter()
                        
                        getMpSpecificDetails(mpId: mpId!, dispatchGroup: dispatchGroup)
                        
                        dispatchGroup.wait()
                        
                        //MARK: - APPEND THE MP TO MPLIST
                        self.mpList.append(self.eachMp)
                        
                        //CLEAR THE self.eachMp ARRAY FOR RE-USE
                        for (key,_) in self.eachMp{
                            self.eachMp[key] = "Not publicised."
                        }

                        //MARK: - UPDATE THE PROGRESS BAR
                        progressCounter += 1
                        let percentComplete = progressCounter / Float(members.count) //THIS MUST BE A VALUE RANGING FROM 0.0 TO 1.0.
                        
                        delegate?.updateProgressBar(message: "MP \(Int(progressCounter)) of \(members.count) retrieved.", percentComplete: percentComplete)
                        
                        print("Mp Retrieved - Progress Bar Updated!")
                    
                    }

                }catch{
                    print("Error: \(Error!)")
                }
   
            }else{
                print("status code is: \(response.statusCode)")
            }
   
            
            dispatchGroup1.leave()
        }
        result.resume()
        
    }
    
    private static func getTimeInCommons(commonsStartDate: String) -> String{
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateStarted = dateFormatter.date(from: commonsStartDate)
        
        //CALCULATE AGE
        let secondsInAYear = 31557600
        let timePeriodInCommons = Int(Date().timeIntervalSince(dateStarted!)) / secondsInAYear
        
        //FORMAT GIVEN DATE OF BIRTH
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        let startdate = dateFormatter.string(from: dateStarted!)
        
        let timeInCommons = "\(startdate) (\(timePeriodInCommons) years ago.)"
        
        return timeInCommons
    
    
    }
    
    private static func formatDateOfBirthString(dateOfBirthStringToFormat: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let birthDate = dateFormatter.date(from: dateOfBirthStringToFormat)
        
        //CALCULATE AGE
        let secondsInAYear = 31557600
        let age = Int(Date().timeIntervalSince(birthDate!)) / secondsInAYear
        
        //MARK: - GET AGE.
        eachMp["age"] = String(age)
        
        
        //FORMAT GIVEN DATE OF BIRTH
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        let dobString = dateFormatter.string(from: birthDate!)
        
        let ageStringToReturn = "\(dobString) (\(age) years of age.)"
        
        return ageStringToReturn
    }
    
    
    private static func getMpSpecificDetails(mpId: String, dispatchGroup: DispatchGroup){
        
        /*
         
         GET SPECIFIC MP DETAILS - FINANCIAL INTERESTS, WEB, TWITTER AND CONSTITUENCY.
         
         */
        
        let apiUrl = URL(string: "http://data.parliament.uk/membersdataplatform/services/mnis/members/query/id=\(mpId)/FullBiog")
        //let apiUrl = URL(string: "http://data.parliament.uk/membersdataplatform/services/mnis/members/query/id=328/FullBiog")
        
        
        var httpRequest = URLRequest(url: apiUrl!)
        httpRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        let session2 = URLSession(configuration: .ephemeral)
        
        let request2 = session2.dataTask(with: httpRequest) { (Data, URLResponse, Error) in
            let response = URLResponse as! HTTPURLResponse
            
            //CHECK IF THE REQUEST WAS SENT SUCCESSFULLY
            if response.statusCode == 200{
                
                let data = Data as Data?
                print("success!")
                
                do{
                    
                    let parsedJson = try JSONSerialization.jsonObject(with: data!, options: [])
                    let results = parsedJson as! NSDictionary
                    
                    //print("specific mp details are: \(results)")
                    
                    //MARK: - GET ADDRESS DETAILS
                    let members = results["Members"] as! NSDictionary
                    let member = members["Member"] as! NSDictionary
                    
                    let addresses = member["Addresses"] as! NSDictionary
                    
                    //IF MULTIPLE ADDRESS ENTRIES EXIST, TREAT AS AN ARRAY, ELSE TREAT AS DICTIONARY
                    if let mpAddresses = addresses["Address"] as? NSArray{
                        
                        for each in 0...(mpAddresses.count - 1){
                            
                            let eachAddress = mpAddresses[each] as? NSDictionary
                            self.getMpAddressDetailsHelperFunction(eachAddress: eachAddress, mpId: mpId)
                        }
                        
                    }else{
                        //ONLY ONE ADDRESS ENTRY EXISTS, SO TREAT AS DICTIONARY.
                        let mpAddress = addresses["Address"] as? NSDictionary
                        self.getMpAddressDetailsHelperFunction(eachAddress: mpAddress, mpId: mpId)
                    }
                    
                    //MARK: - GET STAFFING DETAILS
                    if member["Staffing"] is NSNull{
                        self.eachMp["staff"] = "No staff details publicised."
                    }else{
                        self.eachMp["staff"] = member["Staffing"] as? String
                    }
                    
                    
                    //GET PLACE OF BIRTH + FIRST/MIDDLE AND SURNAMES.
                    let basicDetails = member["BasicDetails"] as! NSDictionary
                    
                    //MARK: - GET PLACE OF BIRTH
                    var placeOfBirth = ""
                    if basicDetails["TownOfBirth"] is NSNull{
                        //DO NOTHING
                    }else{
                        placeOfBirth.append((basicDetails["TownOfBirth"] as? String)!)
                    }
                    
                    if basicDetails["CountryOfBirth"] is NSNull{
                        //DO NOTHING
                    }else{
                        placeOfBirth.append(", \((basicDetails["CountryOfBirth"] as? String)!)")
                    }
                    self.eachMp["placeOfBirth"] = placeOfBirth
                    
                    //MARK: - GET FIRST, MIDDLE AND LAST NAMES
                    self.eachMp["firstName"] = basicDetails["GivenForename"] as? String
                    
                    if basicDetails["GivenMiddleNames"] is NSNull{
                        //DO NOTHING
                    }else{
                        self.eachMp["middleName"] = basicDetails["GivenMiddleNames"] as? String
                    }
                    
                    
                    self.eachMp["surname"] = basicDetails["GivenSurname"] as? String
                    
                    //MARK: - GET POLITICAL AND COUNTRY INTERESTS
                    if member["BiographyEntries"] is NSNull{
                        
                        self.eachMp["politicalInterests"] = "No political interests publicised."
                        self.eachMp["countriesOfInterest"] = "No countries of interest publicised."
                        
                    }else{
                        
                        let BioInterests = member["BiographyEntries"] as! NSDictionary
                        
                        //CAST TO ARRAY IF MORE THAN ONE ELEMENT EXISTS (ONLY ONE ELEMENT = 3 KEY-VALUE PAIRS = NSDICTIONARY)
                        if let interests = BioInterests["BiographyEntry"] as? NSArray{
                            
                            for each in 0...(interests.count - 1){
                                
                                let interest = interests[each] as? NSDictionary
                                
                                switch interest?["Category"] as! String{
                                case "Political Interests":
                                    self.eachMp["politicalInterests"] = interest?["Entry"] as? String
                                    
                                case "Countries of interest":
                                    self.eachMp["countriesOfInterest"] = interest?["Entry"] as? String
                                    
                                default:
                                    print("Error: The mp has an interest that you have not accounted for.")
                                }
                                
                            }
                            
                        }else{
                            
                            //CAST TO NSDICTIONARY IF ONLY ONE ELEMENT OF 3 KEY-VALUE PAIRS IS PRESENT.
                            let interests = BioInterests["BiographyEntry"] as! NSDictionary
                            
                            
                            switch interests["Category"] as! String{
                            case "Political Interests":
                                self.eachMp["politicalInterests"] = interests["Entry"] as? String
                                
                            case "Countries of interest":
                                self.eachMp["countriesOfInterest"] = interests["Entry"] as? String
                                
                            default:
                                print("Error: The mp has an interest that you have not accounted for.")
                            }
                            
                            
                            
                        }
                        
                    }
                    
                    //MARK: - GET FINANCIAL INTERESTS
                    if member["Interests"] is NSNull{
                        self.eachMp["financialInterests"] = "No financial interests publicised."
                    }else{
                        self.eachMp["financialInterests"] = member["Interests"] as? String
                    }
                    
                    
                    //MARK: - GET GOVERMENT POSTS HELD
                    //IF MULTIPLE GOVERMENT POST ENTRIES EXIST, TREAT AS AN ARRAY, ELSE TREAT AS DICTIONARY
                    if member["GovernmentPosts"] is NSNull{
                        //DO NOTHING
                    }else{
                        
                        let governmentPosts = member["GovernmentPosts"] as? NSDictionary
                        
                        if let governmentPost = governmentPosts?["GovernmentPost"] as? NSArray{
                            
                            for each in 0...(governmentPost.count - 1){
                                
                                let eachGovernmentPost = governmentPost[each] as? NSDictionary
                                self.eachMp["governmentPostHeld"] = eachGovernmentPost?["Name"] as? String
                            }
                            
                        }else{
                            //ONLY ONE GOVERMENT POST ENTRY EXISTS, SO TREAT AS DICTIONARY.
                            let governmentPosts = member["GovernmentPosts"] as? NSDictionary
                            let governmentPost = governmentPosts?["GovernmentPost"] as? NSDictionary
                            
                            self.eachMp["governmentPostHeld"] = governmentPost?["Name"] as? String
                        }
                        
                    }
                    
                    //MARK: - GET PARLIAMENTARY POSTS HELD
                    //IF MULTIPLE PARLIAMENTARY POST ENTRIES EXIST, TREAT AS AN ARRAY, ELSE TREAT AS DICTIONARY
                    if member["ParliamentaryPosts"] is NSNull{
                        //DO NOTHING
                    }else{
                        
                        let parliamentaryPosts = member["ParliamentaryPosts"] as? NSDictionary
                        
                        if let parliamentaryPost = parliamentaryPosts?["ParliamentaryPost"] as? NSArray{
                            
                            for each in 0...(parliamentaryPost.count - 1){
                                
                                let eachParliamentaryPost = parliamentaryPost[each] as? NSDictionary
                                self.eachMp["parliamentaryPostHeld"] = eachParliamentaryPost?["Name"] as? String
                            }
                            
                        }else{
                            //ONLY ONE PARLIAMENTARY POST ENTRY EXISTS, SO TREAT AS DICTIONARY.
                            let parliamentaryPosts = member["ParliamentaryPosts"] as? NSDictionary
                            let parliamentaryPost = parliamentaryPosts?["ParliamentaryPost"] as? NSDictionary
                            
                            self.eachMp["parliamentaryPostHeld"] = parliamentaryPost?["Name"] as? String
                        }
                        
                    }
                    
                }catch{
                    print("error is: \(Error.debugDescription as String!)")
                }
                
                
            }else{
                
                print("error. Http Response Code = \(response.statusCode)")
            }
      
            dispatchGroup.leave()
  
        }
        request2.resume()
  
    }
    
    
   private static func getMpAddressDetailsHelperFunction(eachAddress: NSDictionary?, mpId: String){
        
        //print("current mp address type is: \(eachAddress?["Type"])")
        
        switch eachAddress?["Type"] as! String{
            
            
        case "Blog":
            if eachAddress?["Address1"] is NSNull{
                self.eachMp["blog"] = "No Blog publicised."
            }else{
                self.eachMp["blog"] = eachAddress?["Address1"] as? String
            }
            
        case "Facebook":
            if eachAddress?["Address1"] is NSNull{
                self.eachMp["facebook"] = "No Facebook page publicised."
            }else{
                self.eachMp["facebook"] = eachAddress?["Address1"] as? String
            }
            
        case "Website":
            if eachAddress?["Address1"] is NSNull{
                self.eachMp["web"] = "No web page publicised."
            }else{
                self.eachMp["web"] = eachAddress?["Address1"] as? String
            }
            
        //MARK: - DEPARTMENTAL ADDRESS
        case "Departmental":
            //CLEAR THE DEPARTMENTAL ADDRESS ARRAY FORST.
            self.departmentalAddress.removeAll()
            
            if eachAddress?["Address1"] is NSNull{
                self.departmentalAddress.append("none")
            }else{
                self.departmentalAddress.append((eachAddress?["Address1"] as? String)!)
            }
            
            if eachAddress?["Address2"] is NSNull{
                self.departmentalAddress.append("none")
            }else{
                self.departmentalAddress.append((eachAddress?["Address2"] as? String)!)
            }
            
            if eachAddress?["Address3"] is NSNull{
                self.departmentalAddress.append("none")
            }else{
                self.departmentalAddress.append((eachAddress?["Address3"] as? String)!)
            }
            
            if eachAddress?["Address4"] is NSNull{
                self.departmentalAddress.append("none")
            }else{
                self.departmentalAddress.append((eachAddress?["Address4"] as? String)!)
            }
            
            if eachAddress?["Address5"] is NSNull{
                self.departmentalAddress.append("none")
            }else{
                self.departmentalAddress.append((eachAddress?["Address5"] as? String)!)
            }
            
            if eachAddress?["Postcode"] is NSNull{
                self.departmentalAddress.append("none")
            }else{
                self.departmentalAddress.append((eachAddress?["Postcode"] as? String)!)
            }
            
            //CREATE FINAL DEPARTMENTAL ADDRESS STRING
            //CLEAR THE DEPARTMENTAL MP ADDRESS VALUE FROM self.eachMp FIRST.
            self.eachMp["departmentalAddress"] = ""
            
            for each in self.departmentalAddress{
                
                if each == "none"{
                    
                    //DO NOTHING
                    
                }else{
                    
                    (self.eachMp["departmentalAddress"])?.append("\(each), ")
                    
                }
                
            }
            
            //REMOVE THE LAST COMMA AND SPACE CHARACTER FROM THE FINAL DEPARTMENTAL ADDRESS STRING.
            
            var string = self.eachMp["departmentalAddress"]
            var lastIndex = string?.index(before: (string?.endIndex)!)
            string?.remove(at: lastIndex!)
            
            lastIndex = string?.index(before: (string?.endIndex)!)
            string?.remove(at: lastIndex!)
            
            //APPEND FINAL CONSTITUENCY ADDRESS STRING TO self.eachMp.
            self.eachMp["departmentalAddress"] = string!
            
            
            //MARK: - GET DEPARTMENTAL PHONE NUMBER
            if eachAddress?["Phone"] is NSNull{
                //DO NOTHING
            }else{
                self.eachMp["departmentalPhone"] = eachAddress?["Phone"] as? String
            }
            
            //MARK: - GET DEPARTMENTAL FAX NUMBER
            if eachAddress?["Fax"] is NSNull{
                //DO NOTHING
            }else{
                self.eachMp["departmentalFax"] = eachAddress?["Fax"] as? String
            }
            
            //MARK: - GET DEPARTMENTAL EMAIL
            if eachAddress?["Email"] is NSNull{
                //DO NOTHING
            }else{
                self.eachMp["departmentalEmail"] = eachAddress?["Email"] as? String
            }
            
            
            
        case "Youtube":
            if eachAddress?["Address1"] is NSNull{
                self.eachMp["youtube"] = "No Youtube channel publicised."
            }else{
                self.eachMp["youtube"] = eachAddress?["Address1"] as? String
            }
            
        case "Parliamentary":
            
            //FIRST CLEAR THE PARLIAMENTARY ADDRESS ARRAY
            self.parliamentaryAddress.removeAll()
            
            if eachAddress?["Address1"] is NSNull{
                self.parliamentaryAddress.append("none")
            }else{
                self.parliamentaryAddress.append((eachAddress?["Address1"] as? String)!)
            }
            
            if eachAddress?["Address2"] is NSNull {
                self.parliamentaryAddress.append("none")
            }else{
                self.parliamentaryAddress.append((eachAddress?["Address2"] as? String)!)
            }
            
            if eachAddress?["Address3"] is NSNull{
                self.parliamentaryAddress.append("none")
            }else{
                self.parliamentaryAddress.append((eachAddress?["Address3"] as? String)!)
            }
            
            if eachAddress?["Address4"] is NSNull{
                self.parliamentaryAddress.append("none")
            }else{
                self.parliamentaryAddress.append((eachAddress?["Address4"] as? String)!)
            }
            
            if eachAddress?["Address5"] is NSNull{
                self.parliamentaryAddress.append("none")
            }else{
                self.parliamentaryAddress.append((eachAddress?["Address5"] as? String)!)
            }
            
            if eachAddress?["Postcode"] is NSNull{
                self.parliamentaryAddress.append("none")
            }else{
                self.parliamentaryAddress.append((eachAddress?["Postcode"] as? String)!)
            }
            
            //CREATE FINAL PARLIAMENTARY ADDRESS STRING
            //CLEAR THE PREVIOUS MP ADDRESS VALUE FROM self.eachMp FIRST.
            self.eachMp["parliamentaryAddress"] = ""
            
            for each in self.parliamentaryAddress{
                
                if each == "none"{
                    
                    //DO NOTHING
                    
                }else{
                    
                    
                    (self.eachMp["parliamentaryAddress"])?.append("\(each), ")
                    
                }
                
            }
            
            //REMOVE THE LAST COMMA AND SPACE CHARACTER FROM THE FINAL ADDRESS STRING.
            var string = self.eachMp["parliamentaryAddress"]
            
            var lastIndex = string?.index(before: (string?.endIndex)!)
            string?.remove(at: lastIndex!)
            
            lastIndex = string?.index(before: (string?.endIndex)!)
            string?.remove(at: lastIndex!)
            
            //APPEND FINAL ADDRESS STRING TO self.eachMp.
            self.eachMp["parliamentaryAddress"] = string!
            
            //MARK: - GET PARLIAMENTARY PHONE NUMBER
            if eachAddress?["Phone"] is NSNull{
                //DO NOTHING
            }else{
                self.eachMp["parliamentaryPhone"] = eachAddress?["Phone"] as? String
                
            }
            
            //MARK: - GET PARLIAMENTARY FAX NUMBER
            if eachAddress?["Fax"] is NSNull{
                //DO NOTHING
            }else{
                self.eachMp["parliamentaryFax"] = eachAddress?["Fax"] as? String
            }
            
            //MARK: - GET PARLIAMENTARY EMAIL
            if eachAddress?["Email"] is NSNull{
                //DO NOTHING
            }else{
                self.eachMp["parliamentaryEmail"] = eachAddress?["Email"] as? String
            }
            
        case "Constituency":
            
            //CLEAR THE CONSTITUENCY ADDRESS ARRAY FORST.
            self.constituencyAddress.removeAll()
            
            if eachAddress?["Address1"] is NSNull{
                self.constituencyAddress.append("none")
            }else{
                self.constituencyAddress.append((eachAddress?["Address1"] as? String)!)
            }
            
            if eachAddress?["Address2"] is NSNull{
                self.constituencyAddress.append("none")
            }else{
                self.constituencyAddress.append((eachAddress?["Address2"] as? String)!)
            }
            
            if eachAddress?["Address3"] is NSNull{
                self.constituencyAddress.append("none")
            }else{
                self.constituencyAddress.append((eachAddress?["Address3"] as? String)!)
            }
            
            if eachAddress?["Address4"] is NSNull{
                self.constituencyAddress.append("none")
            }else{
                self.constituencyAddress.append((eachAddress?["Address4"] as? String)!)
            }
            
            if eachAddress?["Address5"] is NSNull{
                self.constituencyAddress.append("none")
            }else{
                self.constituencyAddress.append((eachAddress?["Address5"] as? String)!)
            }
            
            if eachAddress?["Postcode"] is NSNull{
                self.constituencyAddress.append("none")
            }else{
                self.constituencyAddress.append((eachAddress?["Postcode"] as? String)!)
            }
            
            
            //CREATE FINAL CONSTITUENCY ADDRESS STRING
            
            //CLEAR THE PREVIOUS MP ADDRESS VALUE FROM self.eachMp FIRST.
            self.eachMp["constituencyAddress"] = ""
            
            for each in self.constituencyAddress{
                
                if each == "none"{
                    
                    //DO NOTHING
                    
                }else{
                    
                    (self.eachMp["constituencyAddress"])?.append("\(each), ")
                    
                }
                
            }
            
            //REMOVE THE LAST COMMA AND SPACE CHARACTER FROM THE FINAL CONSTITUENCY ADDRESS STRING.
            if self.eachMp["constituencyAddress"] == ""{
                
                self.eachMp["constituencyAddress"] = "No constituency address publicised."
                
            }else{
                
                var string = self.eachMp["constituencyAddress"]
                var lastIndex = string?.index(before: (string?.endIndex)!)
                string?.remove(at: lastIndex!)
                
                lastIndex = string?.index(before: (string?.endIndex)!)
                string?.remove(at: lastIndex!)
                
                //APPEND FINAL CONSTITUENCY ADDRESS STRING TO self.eachMp.
                self.eachMp["constituencyAddress"] = string!
                
            }
            
            
            //MARK: - GET CONSTITUENCY PHONE NUMBER
            if eachAddress?["Phone"] is NSNull{
                //DO NOTHING
            }else{
                self.eachMp["constituencyPhone"] = eachAddress?["Phone"] as? String
            }
            
            //MARK: - GET CONSTITUENCY FAX NUMBER
            if eachAddress?["Fax"] is NSNull{
                //DO NOTHING
            }else{
                self.eachMp["constituencyFax"] = eachAddress?["Fax"] as? String
            }
            
            //MARK: - GET CONSTITUENCY EMAIL
            if eachAddress?["Email"] is NSNull{
                //DO NOTHING
            }else{
                self.eachMp["constituencyEmail"] = eachAddress?["Email"] as? String
            }
            
        case "Twitter":
            if eachAddress?["Address1"] is NSNull{
                //DO NOTHING
            }else{
                self.eachMp["twitter"] = eachAddress?["Address1"] as? String
            }
            
        case "Flickr":
            if eachAddress?["Address1"] is NSNull{
                self.eachMp["flickr"] = "No Flickr account publicised."
            }else{
                self.eachMp["flickr"] = eachAddress?["Address1"] as? String
            }
            
        default:
            print("Something went wrong. An address was found that you have not planned for.")
            break
        }
        
    }
    
    private static func writeMpToFile(file: FileHandle?){

        if file != nil {
            
            for each in mpList{
                
                //GO TO THE END OF THE FILE BEFORE WRITING TO ENSURE THAT NO EMPTY LINE IS LEFT AT THE END!
                file?.seekToEndOfFile()
                
                let id = each["idNum"]!
                let firstName = each["firstName"]!
                let middleNames = each["middleName"]!
                let surname = each["surname"]!
                let fullName = each["fullName"]!
                let fullTitle = each["fullTitle"]!
                let placeOfBirth = each["placeOfBirth"]!
                let gender = each["gender"]!
                let startedInCommons = each["startedInHouseOfCommons"]!
                let party = each["party"]!
                let dob = each["dob"]!
                let age = each["age"]!
                let financialInterests = each["financialInterests"]!
                let politicalInterests = each["politicalInterests"]!
                let countriesOfInterest = each["countriesOfInterest"]!
                let otherInterests = each["otherInterests"]!
                let web = each["web"]!
                let youtube = each["youtube"]!
                let flickr = each["flickr"]!
                let blog = each["blog"]!
                let facebook = each["facebook"]!
                let twitter = each["twitter"]!
                let constituency = each["constituency"]!
                let parliamentaryPhone = each["parliamentaryPhone"]!
                let parliamentaryEmail = each["parliamentaryEmail"]!
                let parliamentaryFax = each["parliamentaryFax"]!
                let parliamentaryAddress = each["parliamentaryAddress"]!
                let departmentalAddress = each["departmentalAddress"]!
                let departmentalPhone = each["departmentalPhone"]!
                let departmentalFax = each["departmentalFax"]!
                let departmentalEmail = each["departmentalEmail"]!
                let constituencyPhone = each["constituencyPhone"]!
                let constituencyEmail = each["constituencyEmail"]!
                let constituencyFax = each["constituencyFax"]!
                let constituencyAddress = each["constituencyAddress"]!
                let governmentPostHeld = each["governmentPostHeld"]!
                let parliamentaryPostHeld = each["parliamentaryPostHeld"]!
                let staff = each["staff"]!
                
                
                let data = ("\(id)*\(firstName)*\(middleNames)*\(surname)*\(fullName)*\(fullTitle)*\(placeOfBirth)*\(gender)*\(startedInCommons)*\(party)*\(dob)*\(age)*\(financialInterests)*\(politicalInterests)*\(countriesOfInterest)*\(otherInterests)*\(web)*\(youtube)*\(flickr)*\(blog)*\(facebook)*\(twitter)*\(constituency)*\(financialInterests)*\(web)*\(twitter)*\(parliamentaryPhone)*\(parliamentaryEmail)*\(parliamentaryFax)*\(parliamentaryAddress)*\(departmentalAddress)*\(departmentalPhone)*\(departmentalFax)*\(departmentalEmail)*\(constituencyPhone)*\(constituencyEmail)*\(constituencyFax)*\(constituencyAddress)*\(governmentPostHeld)*\(parliamentaryPostHeld)*\(staff)\n").data(using: String.Encoding.utf8)
                
                
                //MARK: - WRITE TO THE FILE.
                file?.write(data!)
                
            }
            
            
        }else{
            print("File not found.")
        }
    }
    

    
    //MISC FUNCTIONS
    
    func embedViewControllers(){
//        
//        if segue.identifier == "toLeftPane"{
//            mpListVC = segue.destination as? MPList
//        }
//        
//        if segue.identifier == "toTopBarPane"{
//            topBarReference = segue.destination as? TopBarVC
//        }
//        
//        if segue.identifier == "toTabBar"{
//            tabBarReference = segue.destination as? TabBar
//            
//        }
//        
//        if segue.identifier == "toDetailPane"{
//            detailPane = segue.destination as? DetailPane
//        }
//        
//        if segue.identifier == "toProgessBarOverlay"{
//            let vc = segue.destination as? ProgressBarOverlay
//            vc?.startvcReference = self
//        }
        
 
        
        
        
        
    }

    
    
    
    
}//END OF CLASS

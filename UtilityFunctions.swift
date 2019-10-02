
import UIKit
import Foundation


class UtilityFunctions: UIViewController{
    
    override func viewDidLoad() {
        
        getBasicMpInfo()
        
        getMpContactDetails()

    }
    
    func getMpContactDetails(){
    
        /*
         
         BELOW IS USED FOR FETCHING MP DATA FROM DATA.PARLIAMENT. THE RETURNED JSON IS THEN PARSED - RELEVANT DATA EXTRACTED AND WRITTEN TO A COMMA SEPERATED TEXT FILE - MPsWithWebAndTwitter.txt.
         
         */
        
        var webSearchMpInfo = ["surname":"","web":"","twitter":"","constituency":""]
        var webSearchMpList = [NSDictionary]()

        let apiUrl = URL(string: "http://lda.data.parliament.uk/members.json?_view=members&_pageSize=4333&_page=0")

        let MPSocialFilePath: FileHandle? = FileHandle(forWritingAtPath: "/Users/rossco/Desktop/Swift Development/PoliticalSee/MPsWithWebAndTwitter.txt")

        let httpRequest = URLRequest(url: apiUrl!)

        let session2 = URLSession(configuration: .ephemeral)

        let request2 = session2.dataTask(with: httpRequest) { (Data, URLResponse, Error) in
            let data = Data as Data?
            let response = URLResponse as! HTTPURLResponse

            //CHECK IF THE REQUEST WAS SENT SUCCESSFULLY
            if response.statusCode == 200{

                print("success!")

                do{
                    let parsedJson = try JSONSerialization.jsonObject(with: data!, options: [])
                    let results = parsedJson as! NSDictionary
                    let resultsDict = results["result"] as! NSDictionary
                    let allMps = resultsDict["items"] as! NSArray

                    var count = 0 //USED WHEN PRINTING OFF THE NUMBER OF MPS IN THE ARRAY THAT HAVE CONSTITUENCIES

                    //GRAB RELEVANT INFO FROM EACH MP
                    for each in allMps{

                        var twit: String?
                        var web: String?
                        var constituency: String?
                        var mpGender: String?
                        var about: String?

                        let eachMp = each as! NSDictionary

                        //GET SURNAME
                        let surname = eachMp["familyName"] as! NSDictionary

                        //GET GENDER
                        if let gender = eachMp["gender"] as? NSDictionary{
                            mpGender = gender["_value"] as? String

                        }else{
                            mpGender = "No gender specified."
                        }

                        //GET PARLIAMENT BIO WEB ADDRESS
                        about = eachMp["_about"] as? String

                        //GET CONSTITUENCY
                        if let cons = eachMp["constituency"] as? NSDictionary{

                            let label = cons["label"] as! NSDictionary
                            constituency = label["_value"] as? String

                        }else{
                            constituency = "No constituency found."
                        }

                        //GET TWITTER
                        if let twitter = eachMp["twitter"] as? NSDictionary{

                            twit = twitter["_value"] as! String?

                        }else{
                            twit = "No Twitter account found."
                        }

                        //GET WEBSITE
                        if let homePage = eachMp["homePage"]{

                            web = homePage as? String

                        }else{
                            web = "No website found."
                        }

                        if constituency != "No constituency found."{

                            count += 1
                            webSearchMpInfo["surname"] = surname["_value"] as? String
                            webSearchMpInfo["gender"] = mpGender!
                            webSearchMpInfo["about"] = about!
                            webSearchMpInfo["web"] = web!
                            webSearchMpInfo["twitter"] = twit!
                            webSearchMpInfo["contituency"] = constituency!

                            if MPSocialFilePath != nil {
                                // SET THE DATA TO BE WRITTEN.
                                let data = ("\(surname["_value"]!)*\(mpGender!)*\(about!)*\(constituency!)*\(web!)*\(twit!)\n").data(using: String.Encoding.utf8)

                                // WRITE TO THE FILE.
                                MPSocialFilePath?.write(data!)
                            }
                            else {
                                print("Ooops! Something went wrong!")
                            }
                            print("\(count) - \(surname["_value"]!) - \(mpGender!) - of \(constituency!) has homepage: \(web!) and twitter: \(twit!)")
                            
                        }
                        webSearchMpList.append(webSearchMpInfo as NSDictionary)
                    }
                    
                    //CLOSE THE FILE.
                    MPSocialFilePath?.closeFile()
                    
                }catch{
                    print(Error as NSError?)
                }
                
            }else{
                
                print("error. Http Response Code = \(response.statusCode)")
            }
            
        }
        request2.resume()
    
    
    }
    
    
    
    func getBasicMpInfo(){
        
        /*
         THIS HTTP REQUEST COLLECTS INFORMATION ABOUT MPS AS LISTED IN THE EACHMP ARRAY.
         */
        
        var mpList = [NSDictionary]()
        var eachMp = ["idNum":"","fullName":"","fullTitle":"","gender":"","startedInHouseOfCommons":"","party":"","comesFrom":"","dob":""]
        
        let testJsonUrl = "http://data.parliament.uk/membersdataplatform/services/mnis/members/query/House=Commons%7CIsEligible=true/"
        
        let url = URL(string: testJsonUrl)
        
        var request1 = URLRequest(url: url!)
        request1.addValue("application/json", forHTTPHeaderField: "content-type")
        let session1 = URLSession(configuration: .ephemeral)
        
        let result = session1.dataTask(with: request1) { (Data, URLResponse, Error) in
            
            let response = URLResponse as! HTTPURLResponse
            
            if response.statusCode == 200{
                
                do{
                    
                    let parsedJson = try JSONSerialization.jsonObject(with: Data!, options: [])
                    let resultsDict = parsedJson as! NSDictionary
                    let member = resultsDict["Members"] as! NSDictionary
                    let members = member["Member"] as! NSArray
                    var count = 1
                    for each in members{
                        
                        let mp = each as! NSDictionary
                        
                        //TODO: - GRAB THE FINANCIAL INTERESTS OF EACH MP
                        
                        
                        eachMp["idNum"] = mp["@Member_Id"] as? String
                        eachMp["dob"] = mp["DateOfBirth"] as? String
                        eachMp["fullName"] = mp["DisplayAs"] as? String
                        eachMp["fullTitle"] = mp["FullTitle"] as? String
                        eachMp["gender"] = mp["Gender"] as? String
                        eachMp["startedInHouseOfCommons"] = mp["HouseStartDate"] as? String
                        eachMp["comesFrom"] = mp["MemberFrom"] as? String
                        
                        let partyAffiliation = mp["Party"] as! NSDictionary
                        eachMp["party"] = partyAffiliation["#text"] as? String
                        
                        //WRITE EACH MP DATA TO FILE
                        let file: FileHandle? = FileHandle(forWritingAtPath: "/Users/rossco/Desktop/Swift Development/PoliticalSee/PoliticalSee/basicMpData.txt")
                        self.writeMpToFile(mp: eachMp as NSDictionary, file: file)
                        file?.closeFile()
                        
                        mpList.append(eachMp as NSDictionary)
                        
                        print("\(count) - \(eachMp)")
                        count += 1
                        
                    }
                    print("total members: \(count)")
                    
                }catch{
                    print("Error: \(Error!)")
                }
                
            }else{
                print("status code is: \(response.statusCode)")
            }
            
        }
        result.resume()
        
        
    }
    
    
    func writeMpToFile(mp: NSDictionary, file: FileHandle?){
        
        if file != nil {
            // SET THE DATA TO BE WRITTEN.
            
            let name = mp["fullName"] as! String
            let title = mp["fullTitle"] as! String
            let id = mp["idNum"] as! String
            
            var dob: String!
            if mp["dob"] != nil{
                
                dob = mp["dob"] as! String
            }else{
                dob = "No DoB given."
            }
            
            let gender = mp["gender"] as! String
            let comesFrom = mp["comesFrom"] as! String
            let startedInCommons = mp["startedInHouseOfCommons"] as! String
            let party = mp["party"] as! String
            
            let data = ("\(name)*\(title)*\(gender)*\(dob!)*\(comesFrom)*\(id)*\(startedInCommons)*\(party)\n").data(using: String.Encoding.utf8)
            
            file?.seekToEndOfFile()
            
            // WRITE TO THE FILE.
            file?.write(data!)
        }
        else {
            print("Ooops! Something went wrong!")
        }
        
    }

}//END OF CLASS

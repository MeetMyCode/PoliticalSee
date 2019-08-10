//
//  PoliticalInformation.swift
//  PoliticalSee
//
//  Created by Ross Higgins on 14/01/2017.
//  Copyright © 2017 Coco. All rights reserved.
//

import Foundation
import UIKit

public class PoliticalInformation{
    //MARK: METHODS
    
    static func getParliamentWideStatsAnalyses() -> [String]{
        return parliamentWideStatsAnalyses
    }
    
    static func getpoliticalParties() -> [String]{
        return politicalParties
    }
    
    static func getMpDictionary() -> [String:String]{
        return eachMp
    }
    
    static func getParliamentCrossSectionTypes() -> [String]{
        return parliamentCrossSectionTypes
    }
    
    static func getStatsAnalysesForThisMp() -> [String]{
        return statsAnalysesForThisMp
    }
    
    static func getStatsAnalysesForAllMen() -> [String]{
        return statsAnalysesForAllMen
    }
    
    static func getStatsAnalysesForAllWomen() -> [String]{
        return statsAnalysesForAllWomen
    }
    
    static func getMpDataArray() -> [[String:String]]{
        return mpDataArray!
    }
    
    static func setMpDataArray(array: [[String:String]]){
        mpDataArray = array
    }

    static func getMpAgeRanges() -> [String:Int]{
        return mpAgeRanges
    }
    
    //MARK: - DATA FOR STATS ANALYSES.
    private static let parliamentCrossSectionTypes = ["Across Parliament","For This MP","Men Only","Women Only"]

    private static let parliamentWideStatsAnalyses = ["Gender Distribution","Age Distribution", "Seats Per Party"]
    private static let statsAnalysesForThisMp = ["Analysis1", "Analysis2", "Analysis3", ]
    private static let statsAnalysesForAllMen = ["Analysis10", "Analysis11", "Analysis12"]
    private static let statsAnalysesForAllWomen = ["Analysis100", "Analysis101", "Analysis102"]
    private static var mpAgeRanges = ["20-25":0, "25-30":0, "30-35":0, "35-40":0, "40-45":0, "45-50":0, "50-55":0, "55-60":0, "60-65":0, "65-70":0, "70-75":0, "75-80":0, "80-85":0, "85-90":0, "90-95":0, "95-100":0]

    
    //MARK: - MP DATA ARRAY
    private static var mpDataArray: [[String:String]]?
    
    
    //MARK: - POLITICAL PARTIES
    private static let politicalParties = ["All","Speaker","Independent","Labour","Liberal Democrat","Conservative","Scottish National Party","Democratic Unionist Party","Plaid Cymru","Social Democratic & Labour Party","Sinn Fein","UK Independence Party","Green Party","Labour (Co-op)","Ulster Unionist Party"]

    //MARK: - DATA FOR EACH MP.
    private static var eachMp = ["idNum":"","firstName":"","middleName":"","surname":"","fullName":"","fullTitle":"","placeOfBirth":"","gender":"","startedInHouseOfCommons":"","party":"","dob":"","age":"","financialInterests":"","politicalInterests":"","countriesOfInterest":"","otherInterests":"","web":"","youtube":"","flickr":"","blog":"","facebook":"","twitter":"","constituency":"","parliamentaryPhone":"","parliamentaryEmail":"","parliamentaryFax":"","parliamentaryAddress":"","departmentalAddress":"","departmentalPhone":"","departmentalFax":"","departmentalEmail":"","constituencyPhone":"","constituencyEmail":"","constituencyFax":"","constituencyAddress":"","governmentPostHeld":"","parliamentaryPostHeld":"","staff":""]
    
    //MARK: - TWITTER ACCESS.
    static var twitterAccess = ["AppOnlyAuth":"https://api.twitter.com/oauth2/token","RequestTokenUrl":"https://api.twitter.com/oauth/request_token","AuthorizeUrl":"https://api.twitter.com/oauth/authorize","AccessTokenUrl":"https://api.twitter.com/oauth/access_token","APIKey":"94bkDKEYl9WbXCwVYbelxJblH"]
    

    
}//END OF CLASS

//
//  StatsAboutParliament.swift
//  PoliticalSee
//
//  Created by Rossco on 03/04/2017.
//  Copyright © 2017 Coco. All rights reserved.
//


/*
    
    AGE DISTRIBUTION, GENDER %, ATTENDANCES/YEAR/MP, HOW MANY HAVE SOCIAL MEDIA?, WAGE +/- WITH TIME, FEMALE/MALE COMPARISON.
 
 */


import UIKit
import Foundation
import Charts

class StatsAboutParliament: UIViewController {
    
    //Y-AXIS TITLE BAR - THIS IS CREATED ON THE FLY AS THE VIEW NEEDS TO BE ROTATED TO DISPLAY ITS TEXT VERTICALLY.
    var YAxisTitle: UILabel?
    
    var currentMp = [String:String]()
    var mpDataArray = PoliticalInformation.getMpDataArray()
    
    var males: Double?
    var females: Double?
    var seatsPerPartyDict = [String:Int]()
    var ageDistributionDict = PoliticalInformation.getMpAgeRanges()

    var colorPerParty = [UIColor]()
    var PieChart: PieChartView?
    var BarChart: BarChartView?

    override func viewDidLoad() {
        super.viewDidLoad()

        //DATA EXTRACTION FOR USE IN GRAPHS
        extractGenders()
        extractSeatsPerParty()
        extractAges()
        
        //HIDE SELECTANALYSISBUTTON & SELECTCHARTTYPEBUTTON - NEXT BUTTON APPEARS AFTER PREVIOUS HAS BEEN SELECTED.
        SelectAnalysisButton.isHidden = true
        SelectChartType.isHidden = true
        
        //HIDE CHART TITLE AND X-AXIS TITLE BARS.
        ChartTitle.isHidden = true
        XAxisTitle.isHidden = true
        


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }

    //MARK: - ACTIONS AND OUTLETS
    
    @IBOutlet weak var DefaultGraphLabel: UILabel?
    
    @IBOutlet weak var ChartTitle: UILabel!
    
    @IBOutlet weak var XAxisTitle: UILabel!
    

    @IBOutlet weak var SelectParliamentCrossSection: UIButton!

    @IBAction func SelectParliamentCrossSectionButton(_ sender: UIButton) {
        print("SelectParliamentCrossSectionButton pressed!")
        performSegue(withIdentifier: "toGenericPicker", sender: sender)
    }
    
    
    @IBOutlet weak var SelectAnalysisButton: UIButton!
    
    @IBAction func SelectAnalysisButtonPressed(_ sender: UIButton) {
        print("SelectAnalysisButtonPressed!")
        performSegue(withIdentifier: "toGenericPicker", sender: sender)
    }
    
    
    @IBOutlet weak var SelectChartType: UIButton!
    
    @IBAction func SelectChartTypeButtonPressed(_ sender: UIButton) {
        print("SelectChartTypeButtonPressed!")
        performSegue(withIdentifier: "toGenericPicker", sender: sender)
    }
    
    

    //MARK: - SEGUE METHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing for segue now...")
        
        switch (sender as! UIButton).tag {
            
        case 0:
            let vc = segue.destination as! GenericPicker
            vc.dataArray = PoliticalInformation.getParliamentCrossSectionTypes()
            vc.statsVcRef = self
            vc.buttonTagFromStats = (sender as! UIButton).tag
            
        case 1:
            let vc = segue.destination as! GenericPicker

            //["Across Parliament","For This MP","Men Only","Women Only"]
            switch (SelectParliamentCrossSection.titleLabel?.text)! {
                
            case "Across Parliament":
                vc.dataArray = PoliticalInformation.getParliamentWideStatsAnalyses()
                
            case "For This MP":
                vc.dataArray = PoliticalInformation.getStatsAnalysesForThisMp()
                
            case "Men Only":
                vc.dataArray = PoliticalInformation.getStatsAnalysesForAllMen()
                
            case "Women Only":
                vc.dataArray = PoliticalInformation.getStatsAnalysesForAllWomen()
                
            default:
                print("Error: Unknown cross-section given!")
            }
            
            vc.statsVcRef = self
            vc.buttonTagFromStats = (sender as! UIButton).tag

            
        case 2:
            let vc = segue.destination as! GenericPicker
            vc.statsVcRef = self
            vc.dataArray = ["Pie Chart","Bar Chart"]
            vc.buttonTagFromStats = (sender as! UIButton).tag

        default:
            print("Error: unindentified button detected!")
        }
        

    }
    
        
    @IBAction func unwindToStats(segue:UIStoryboardSegue) {}
    
    //MARK: - MISC FUNCTIONS
    
    func constructGraph(crossSection: String, analysisToDo: String, chartType: String){
        
        removePreviousChartView()
        
        //["Across Parliament","For This MP","Men Only","Women Only"]
        switch crossSection {
        case "Across Parliament":
            getChartForParliamentWideAnalysis(analysis: analysisToDo, chartType: chartType)
            
        case "For This MP":
            getChartForMpAnalysis(analysis: analysisToDo, chartType: chartType)
            
        case "Men Only":
            getChartForMenOnlyAnalysis(analysis: analysisToDo, chartType: chartType)
            
        case "Women Only":
            getChartForWomenOnlyAnalysis(analysis: analysisToDo, chartType: chartType)
            
        default:
            print("Error: Unexpected cross-section supplied!")
        }
        
        switch analysisToDo {
        
        case "Gender Distribution":
            
            switch chartType {
                
            case "Pie Chart":
                setupGenderDistributionGraph(chartType: chartType)
                
            case "Bar Chart":
                setupGenderDistributionGraph(chartType: chartType)
                
            default:
                print("Error: Unknown Chart Type Requested!")
            }
            
        case "Age Distribution":
            print("Age Distribution graph displayed!")
            
        default:
            break
        }
        
    }
    
    func getChartForMpAnalysis(analysis: String, chartType: String){
        let chart = (SelectChartType.titleLabel?.text)!

        //FIXME: WAITING FOR CODE....
    }
    
    func getChartForMenOnlyAnalysis(analysis: String, chartType: String){
        let chart = (SelectChartType.titleLabel?.text)!

        //FIXME: WAITING FOR CODE....

    }
    
    func getChartForWomenOnlyAnalysis(analysis: String, chartType: String){
        let chart = (SelectChartType.titleLabel?.text)!

        //FIXME: WAITING FOR CODE....

    }

    func getChartForParliamentWideAnalysis(analysis: String, chartType: String){
        
        //["Gender Distribution","Age Distribution", "Seats Per Party"]
        switch analysis {
            
        case "Gender Distribution":
            setupGenderDistributionGraph(chartType: chartType)
            
        case "Age Distribution":
            setupAgeDistributionGraph(chartType: chartType)
            
        case "Seats Per Party":
            setupSeatsPerPartyGraph(chartType: chartType)
            
        default:
            print("Error: Unknown analysis requested!")
        }
    }
    
    func extractAges(){
        
        
        
        
        
        
    }
    
    func extractSeatsPerParty(){
        
        var parties = PoliticalInformation.getpoliticalParties()
        parties.remove(at: 0)
        
        //POPULATE KEYS AND DEFAULT VALUES OF 0.
        for each in parties{
            seatsPerPartyDict.updateValue(0, forKey: each)
        }
        print("seatsPerPartyDict is: \(seatsPerPartyDict)")
        
        //RETRIEVE PARTY COUNTS FOR ALL MPS.
        for mp in mpDataArray{
            
            for party in parties{
                
                if party == mp["party"]{
                    seatsPerPartyDict.updateValue(incrementPartyCount(party: party), forKey: party)
                }
            }
        }
        
        //DIAGNOSTIC PRINT TO CHECK IF COUNTS ARE BEING ALLOCATED CORRENTLY.
//        var totalCount = 0
//        for each in seatsPerPartyDict{
//            print("\(each.key) - \(each.value)")
//            totalCount = totalCount + each.value
//        }
//        print("totalCount = \(totalCount)")
        
    }
    
    func incrementPartyCount(party: String) -> Int{
        
        let count = seatsPerPartyDict["\(party)"]! + 1
        
        return count
    }
    
    func extractGenders(){
        
        var maleCount = 0.0
        var femaleCount = 0.0
        for eachMp in mpDataArray{
            
            if eachMp["gender"] == "F"{
                
                femaleCount += 1
                
            }else if eachMp["gender"] == "M"{
                
                maleCount += 1
            }
            
        }
        
        self.males = maleCount
        self.females = femaleCount
        
    }
    
    func setupAgeDistributionGraph(chartType: String){
        
        print("Age Distribution Graph Displayed!")
        
        //GENERATE COLORS TO USE IN THE GRAPHS BELOW.
        let colorToUse = generateColorsToUse(numberOfColors: 16)
        
        switch chartType {
            
        case "Pie Chart":

            print("One Pie Chart coming up!")
            
            setupGraphView(forChartType: chartType)
            
            PieChart?.centerText = "Distribution of MPs by Age."
            PieChart?.chartDescription?.text = ""
            
            
            let dobNotPresent = populateAgeDistributionDict()
            
            //CREATE SEPERATE DATA ENTRIES PER PARTY.
            var entries = [PieChartDataEntry]()
            for ageGroup in ageDistributionDict{
                let entry = PieChartDataEntry(value: Double(ageGroup.value), label: "\(ageGroup.key)")
                entries.append(entry)
            }
            
            //CREATE DATASET.
            let ageDistributionDataSet = PieChartDataSet(values: entries, label: "Age Distribution.\(dobNotPresent) MP(s) have not published their age.")
            
            //ENSURE A DIFFERENT COLOR FOR EACH PIE SLICE IN THE DATASET WITH CUSTOM COLOR ARRAY.
            ageDistributionDataSet.colors = colorToUse
            
            PieChart?.data = PieChartData(dataSet: ageDistributionDataSet)
            
        case "Bar Chart":
            print("One Bar Chart coming up!")
            
            
            //FIXME: - PIE CHART DONE. SORT OUT THIS GRAPH NOW!
            
            setupGraphView(forChartType: chartType)
            setupTitleBars()

            
            BarChart?.chartDescription?.text = ""
            
            let dobNotGiven = populateAgeDistributionDict()
            
            ChartTitle?.text = "The Distribution of MPs by Age."
            XAxisTitle?.text = "Age Group. \(dobNotGiven) Mps have not published their age."
            YAxisTitle?.text = "Number of MPs"
            
            var dataSets = [BarChartDataSet]()
            var incrementer = 0
            
            //CREATE SEPERATE DATA ENTRIES AND DATASETS PER PARTY.
            for ageGroup in ageDistributionDict{
                let entry = BarChartDataEntry(x: Double(incrementer), y: Double(ageGroup.value))
                let set = BarChartDataSet(values: [entry], label: "\(ageGroup.key)")
                dataSets.append(set)
                incrementer = incrementer + 1
            }
            
            //ENSURE A DIFFERENT COLOR FOR EACH BAR/DATASET.
            for set in dataSets{
                set.setColor(colorToUse[dataSets.index(of: set)!])
            }
            
            BarChart?.data = BarChartData(dataSets: dataSets)
            
        default:
            print("Error: Unknown chartType given in setupSeatsPerPartyGraph")
        }
        
    }
    
    func populateAgeDistributionDict() -> Int{
        
        var dobNotGiven = 0
        
        //POPULATE AGE DISTRIBUTION DICTIONARY.
        var startAge = 20
        for eachMp in mpDataArray{
            
            //SOME MPS HAVE NOT PUBLISHED THEIR DOB. CHECK FOR THIS CONDITION FIRST.
            if let age = Int(eachMp["age"]!){
                
                for _ in 0...ageDistributionDict.count - 1{
                    
                    if age >= startAge && age <= startAge + 5{
                        
                        ageDistributionDict["\(startAge)-\(startAge + 5)"] = ageDistributionDict["\(startAge)-\(startAge + 5)"]! + 1
                        
                    }
                    startAge = startAge + 5
                }
                
            }else{
                dobNotGiven = dobNotGiven + 1
            }
            
            //RESET AGE FOR NEXT MP.
            startAge = 20
        }
        
        return dobNotGiven
    }
    
    func setupSeatsPerPartyGraph(chartType: String){
        
        //GENERATE COLORS TO USE IN THE GRAPHS BELOW.
        let colorToUse = generateColorsToUse(numberOfColors: 14)
        
        switch chartType {
            
        case "Pie Chart":
            print("One Pie Chart coming up!")
            
            setupGraphView(forChartType: chartType)
            
            PieChart?.centerText = "Party Seating Proportions."
            PieChart?.chartDescription?.text = "Proportionate Amount of Seats Per Party."
                        
            //CREATE SEPERATE DATA ENTRIES PER PARTY.
            var entries = [PieChartDataEntry]()
            for eachParty in seatsPerPartyDict{
                let entry = PieChartDataEntry(value: Double(eachParty.value), label: "\(eachParty.key)")
                entries.append(entry)
            }
            
            //CREATE DATASET.
            let seatsPerPartyDataSet = PieChartDataSet(values: entries, label: "Seats Per Party")
            
            //ENSURE A DIFFERENT COLOR FOR EACH PIE SLICE IN THE DATASET WITH CUSTOM COLOR ARRAY.
            seatsPerPartyDataSet.colors = colorToUse
            
            PieChart?.data = PieChartData(dataSet: seatsPerPartyDataSet)
            
        case "Bar Chart":
            print("One Bar Chart coming up!")
            
            setupGraphView(forChartType: chartType)
            setupTitleBars()
            ChartTitle?.text = "The Number of Seats Held in Parliament by Each Party."
            XAxisTitle?.text = "Political Party"
            YAxisTitle?.text = "Number of Seats Held"
            
            
            BarChart?.chartDescription?.text = "Proportionate Amount of Seats Per Party."
            
            var dataSets = [BarChartDataSet]()
            var incrementer = 0
            
            //CREATE SEPERATE DATA ENTRIES AND DATASETS PER PARTY.
            for eachParty in seatsPerPartyDict{
                let entry = BarChartDataEntry(x: Double(incrementer), y: Double(eachParty.value))
                let set = BarChartDataSet(values: [entry], label: "\(eachParty.key)")
                dataSets.append(set)
                incrementer = incrementer + 1
            }

            //ENSURE A DIFFERENT COLOR FOR EACH BAR/DATASET.
            for set in dataSets{
                set.setColor(colorToUse[dataSets.index(of: set)!])
            }
            
            BarChart?.data = BarChartData(dataSets: dataSets)

        default:
            print("Error: Unknown chartType given in setupSeatsPerPartyGraph")
        }
        

    }
    
    func setupGenderDistributionGraph(chartType: String){
        
        //GENERATE COLORS TO USE IN THE GRAPHS BELOW.
        let colorsToUse = generateColorsToUse(numberOfColors: 2)
        
        let totalMps = Double(self.males! + self.females!)
        
        //DECIMALISE TO 1 PLACE.
        let percentMen = Double(Int(((self.males! / totalMps) * 100) * 10)) / 10
        let percentWomen = Double(Int(((self.females! / totalMps) * 100) * 10)) / 10
        
        switch chartType {
            
        case "Pie Chart":
            print("One Pie Chart coming up!")
        
            setupGraphView(forChartType: chartType)
            
            PieChart?.centerText = "% Males vs Females"
            PieChart?.chartDescription?.text = "Proportion of Males and Female MPs in Parliament."
            
            let males = PieChartDataEntry(value: Double(self.males!), label: "Males (\(percentMen)%)")
            let females = PieChartDataEntry(value: Double(self.females!), label: "Females (\(percentWomen)%)")
            
            let dataSet = PieChartDataSet(values: [males,females], label: "")
            
            //ENSURE A DIFFERENT COLOR FOR EACH PIE SLICE.
            dataSet.colors = colorsToUse

            PieChart?.data = PieChartData(dataSet: dataSet)
            
        case "Bar Chart":
            print("One Bar Chart coming up!")
            
            setupGraphView(forChartType: chartType)
            setupTitleBars()
            BarChart?.chartDescription?.text = ""
            ChartTitle?.text = "The Proportion of Men:Women in Parliament."
            XAxisTitle?.text = "Gender"
            YAxisTitle?.text = "Number of Men/Women"
            
            let males = BarChartDataEntry(x: 0.0, y: self.males!)
            let females = BarChartDataEntry(x: 1.0, y: self.females!)

            //CREATE A SEPERATE DATASET FOR EACH BAR/SET OF BARS WITH IT'S/THEIR OWN KEY LABEL.
            let maleDataSet = BarChartDataSet(values: [males], label: "Males \(percentMen)%")
            let femaleDataSet = BarChartDataSet(values: [females], label: "Females \(percentWomen)%")

            //SET X AXIS BAR LABELS AND POSTION.
            BarChart?.xAxis.labelPosition = .bottom
            BarChart?.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Males (\(percentMen)%)","Females (\(percentWomen)%)"])
            BarChart?.xAxis.granularity = 1
            
            BarChart?.legend.enabled = false

            
            
            //ENSURE A DIFFERENT COLOR FOR EACH BAR.
            maleDataSet.setColor(colorsToUse[0])
            femaleDataSet.setColor(colorsToUse[1])

            BarChart?.data = BarChartData(dataSets: [maleDataSet, femaleDataSet])
            
        default:
            print("Error: Unknown Chart Type Given in setupGenderDistributionGraph!")
        }
        
    }
    
    func generateColorsToUse(numberOfColors: Int) -> [UIColor]{
    
        var colorArray = [UIColor]()
        
        for _ in 0...numberOfColors - 1{
            
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            
            colorArray.append(color)
        }

        return colorArray
    }
    
    func setupGraphView(forChartType: String){
        
        switch forChartType {
            
        case "Pie Chart":
            
            hideTitleBars()
            
            //SET SIZE
            PieChart = PieChartView(frame: CGRect(x: 50, y: 65, width: 663, height: 526))
            PieChart?.tag = 1001
            PieChart?.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
            PieChart?.backgroundColor = UIColor.white
            self.view.addSubview(PieChart!)
            

            PieChart?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            PieChart?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            PieChart?.topAnchor.constraint(equalTo: SelectParliamentCrossSection.bottomAnchor).isActive = true
            


        case "Bar Chart":
            
            showTitleBars()
            
            //SET SIZE
            BarChart = BarChartView(frame: CGRect(x: 50, y: 65, width: 663, height: 526))
            BarChart?.tag = 1002
            BarChart?.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
            BarChart?.backgroundColor = UIColor.white
            self.view.addSubview(BarChart!)

            BarChart?.bottomAnchor.constraint(equalTo: (XAxisTitle?.topAnchor)!).isActive = true
            BarChart?.topAnchor.constraint(equalTo: (ChartTitle?.bottomAnchor)!).isActive = true
            BarChart?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
            BarChart?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 50).isActive = true
            

        default:
            print("Error: Unknown chart type given in setupGraphView(forChartType: String)!")
        }
        
    }

    
    func setupTitleBars(){

        //CREATE Y AXIS TITLE BAR.
        YAxisTitle = UILabel(frame: CGRect(x: (-258 + 30), y: ((self.view.frame.height / 2) - 16), width: 526, height: 30))
        YAxisTitle?.textAlignment = .center
        YAxisTitle?.tag = 1003
        YAxisTitle?.text = "Y Axis Title Bar."
        
        //TRANSFORM  Y-AXIS TITLE LABEL TO DISPLAY VERTICALLY
        YAxisTitle?.backgroundColor = UIColor.white
        self.view.addSubview(YAxisTitle!)
        YAxisTitle?.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
     

    }
    
    func hideTitleBars(){
        
        //HIDE CHART TITLE AND X-AXIS TITLE BARS.
        ChartTitle.isHidden = true
        XAxisTitle.isHidden = true
        YAxisTitle?.isHidden = true
    }
    
    func showTitleBars(){
        //SHOW CHART TITLE AND X-AXIS TITLE BARS.
        ChartTitle.isHidden = false
        XAxisTitle.isHidden = false
        YAxisTitle?.isHidden = false
    }
    
    func removePreviousChartView(){
        
        print("Removing previous chart view...")
        
        //REMOVE THE DEFAULT CENTER LABEL & ANY PREVIOUS CHART VIEWS.
        let subviews = self.view.subviews
        for each in subviews{
            if each.tag == 1000 || each.tag == 1001 || each.tag == 1002 || each.tag == 1003{
                
                if each != nil{
                    each.removeFromSuperview()
                }
            }
        }

    }
    
    
}//END OF CLASS

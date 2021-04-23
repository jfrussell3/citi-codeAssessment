//
//  ViewController.swift
//  WeatherDisplay
//
//  Created by john Russell on 4/22/21.
//

import UIKit


let standardOrangeColor = UIColor(red: 233/255, green: 185/255, blue: 90/255, alpha: 1.0)

class ViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource  {
    
    var dataInstanceNumber:Int!
    var weatherItem:WeatherItem!
    var currentCity:String = ""
    
    private var serviceWrapper : ServiceWrapper = ServiceWrapper()
    private var decoder : JSONDecoder?
    private let tableFooterLinePixels :CGFloat = 2.0
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentConditionsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
    }
    
    
    // MARK: -  Initial and ongoing setup and decoration
    
    func setup()
    {
        dataInstanceNumber = 0
        
        self.setupUI()
        
        self.fetchData()
    }
    
    
    func setupUI()
    {
        self.title = "Weather"
        
        // Add right button
        let button = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(rightButtonPressed))
        navigationItem.rightBarButtonItem = button
        
        // Navbar decoration
        self.navigationController?.navigationBar.barTintColor = standardOrangeColor

        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navigationItem.largeTitleDisplayMode = .never

        cityNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        currentConditionsLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        cityNameLabel.numberOfLines = 0
                
        let font = cityNameLabel.font
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]

        activityIndicator.color = standardOrangeColor
        self.view.bringSubviewToFront(self.activityIndicator)
        activityIndicator.isHidden = true
        
        self.setupTableView()
    }
    
    func setupTableView()
    {
        tableView.isHidden = true
        
        tableView.separatorStyle = .none
                
        let px = tableFooterLinePixels / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        tableView.tableFooterView  = line
        line.backgroundColor = .black
    }
    
    func setupTableViewCell(cell:UITableViewCell)
    {
        let width = cell.frame.size.width * 2 // isn't wide enough // Todo: fix magic number
        
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: width, height: px)
        let lineView = UIView(frame: frame)
        lineView.backgroundColor = self.tableView.separatorColor
        cell.addSubview(lineView)
    }
    
    
    func showHUD()
    {

        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    
    func hideHUD()
    {

       self.activityIndicator.stopAnimating()
        
    }
    
    
    func fetchData()
    {
        self.showHUD()
        
        currentCity = Helper.citiesArray[dataInstanceNumber]
        weatherItem = nil
        
        cityNameLabel.text = currentCity
        currentConditionsLabel.text = "Fetching Data ..."
        
        // Todo: rethink this
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let urlString = "http://api.openweathermap.org/data/2.5/weather?appid=b274c5ce65b3e435688f3098769c6dee&q=\(currentCity)"
        
        //let urlString = "http://nadurlname&q=\(currentCity)"
        
        guard let url = URL(string:urlString)
        else
        {
            
            return
            
        }
                
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        serviceWrapper.fetchDataWithDataTask(with: urlRequest, success: { [self] (data) in
            
            if let weatherData = data
            {
                
                self.decoder = JSONDecoder()
                
                // Todo: parse json data 
                
                //  let jsonDecoder = JSONDecoder()
                
//                  if let patientList : [PatientInfo] = try? self.decoder?.decode(Array<PatientInfo>.self, from: patientInfoData)
//                  {
//                    success(patientList)
//                }
                
                
                
                // Stubbed data
                let array = Helper.createWeatherDataTestData()
                weatherItem = array[self.dataInstanceNumber]
                
                DispatchQueue.main.async(execute:
                {
                    self.decorateDataFields()
                    self.hideHUD()
                })
                
                
            }
            

            
        }) { (error) in
            
            print("Error")
            
                        
            DispatchQueue.main.async(execute:
            {
                self.cityNameLabel.text = error.debugDescription
                self.cityNameLabel.isHidden = false
                self.hideHUD()
            })
            
            
            
            //failure(error)
        }
        
        
    }
    
    func decorateDataFields()
    {
        let shouldDisableButton = (dataInstanceNumber+1 < Helper.maxDisplayWeatherItems)
        self.navigationItem.rightBarButtonItem?.isEnabled = shouldDisableButton
        
        // data decoration

        if weatherItem == nil
        {
            //cityNameLabel.text = currentCity
            currentConditionsLabel.text = "Error fetching data" // Todo: set font color to red
            cityNameLabel.isHidden = false
            currentConditionsLabel.isHidden = false
            
            tableView.delegate = nil
            tableView.dataSource = nil
        }
        else
        {
            tableView.delegate = self
            tableView.dataSource = self
            
            cityNameLabel.text = weatherItem.cityName
            currentConditionsLabel.text = weatherItem.description

            cityNameLabel.isHidden = false
            currentConditionsLabel.isHidden = false
            
            tableView.isHidden = false
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    
    
    // MARK: -  Actions
    @objc func rightButtonPressed(sender: UIBarButtonItem) {
       
        dataInstanceNumber += 1
        
        self.fetchData()
        
    }
    
    
    // MARK: - Table view

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let number = weatherItem.details.count
        return number
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        tableFooterLinePixels
        
        
        let number = 38.0
        return CGFloat(number)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1,
                        reuseIdentifier: "ReuseIdentifier")

        let detailItem = weatherItem.details[indexPath.row]
        cell.textLabel?.text = detailItem.title
        cell.detailTextLabel?.text = detailItem.value
        
        cell.detailTextLabel?.textColor = cell.textLabel?.textColor

        self.setupTableViewCell(cell: cell)
        
        return cell
    }


   


}



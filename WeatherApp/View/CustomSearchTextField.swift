//
//  CustomSearchTextField.swift
//  CustomSearchField
//
//  Created by Emrick Sinitambirivoutin on 19/02/2019.
//  Copyright © 2019 Emrick Sinitambirivoutin. All rights reserved.
//

import UIKit
import CoreData

class CustomSearchTextField: UITextField{
    
    var dataList : [CitiesData] = [CitiesData]() //{
    //        didSet {
    //            DispatchQueue.main.async {
    //                print(self.dataList[0].cityName)
    //                self.appendToResult(dataList: self.dataList)
    //            }
    //        }
    //    }
    let lock = NSLock()
    var resultsList : [SearchItem] = [SearchItem]() //{
//        willSet {
//            lock.lock()
//        }
//        didSet {
//            lock.unlock()
//        }
//    }
    
    var tableView: UITableView?
    
    var currentItemId: Int?
    
    let context = DatabaseManager.shared.persistentContainer.viewContext
    
    // Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
    }
    
    //////////////////////////////////////////////////////////////////////////////
    // Text Field related methods
    //////////////////////////////////////////////////////////////////////////////
    
    @objc open func textFieldDidChange(){
        print("Text changed ...")
        filter(text: self.text!)
        //        appendToResult()
        tableView?.isHidden = false
    }
    
    @objc open func textFieldDidBeginEditing() {
        print("Begin Editing")
    }
    
    @objc open func textFieldDidEndEditing() {
        tableView?.isHidden = true
        print("End editing")
        
    }
    
    @objc open func textFieldDidEndEditingOnExit() {
        print("End on Exit")
    }
    
    //////////////////////////////////////////////////////////////////////////////
    // Data Handling methods
    //////////////////////////////////////////////////////////////////////////////
    
    // MARK: CoreData manipulation methods
    
    func loadItems(withRequest request : NSFetchRequest<CitiesData>, text: String) {
        print("loading items")
        
        DatabaseManager.shared.persistentContainer.performBackgroundTask { (context) in
            do {
                self.dataList = try context.fetch(request)
                
                self.appendToResult(dataList: self.dataList, text: text)
                
            } catch {
                print("Error while fetching data: \(error)")
            }
        }
    }
    
    // MARK: Filtering methods
    
    fileprivate func filter(text: String) {
        let predicate = NSPredicate(format: "cityName CONTAINS[cd] %@", text)
        let request : NSFetchRequest<CitiesData> = CitiesData.fetchRequest()
        request.predicate = predicate
        
        loadItems(withRequest : request, text: text)
    }
    
    var workItem = DispatchWorkItem {
        
    }
    
    func appendToResult(dataList: [CitiesData], text: String) {
        workItem.cancel()
        print("4")
//        self.resultsList = []
        var result = [SearchItem]()
        print("self data list name = \(self.dataList.first?.cityName)")
        print("local data list name = \(dataList.first?.cityName)")
        
//        workItem = DispatchWorkItem(block: {

        for i in 0..<dataList.count {
            if self.dataList.count != dataList.count {
                DispatchQueue.main.async {
//                    self.filter(text: self.text!)
                    self.tableView?.reloadData()
                }
                break
            }
                print("1")
                guard let cityName = dataList[i].cityName, let countyName = dataList[i].countryName else {
                    print(dataList[i].cityName, dataList[i].countryName)
                    return }
            print(dataList.count)
            print(self.dataList.count)
                let item = SearchItem(cityName: cityName, countryName: countyName, id: Int(dataList[i].cityId))
//
                let cityFilterRange = (item.cityName as NSString).range(of: text, options: .caseInsensitive)
                let countryFilterRange = (item.countryName as NSString).range(of: text, options: .caseInsensitive)

                if cityFilterRange.location != NSNotFound {
                    item.attributedCityName = NSMutableAttributedString(string: item.cityName)
                    item.attributedCountryName = NSMutableAttributedString(string: item.countryName)

                    item.attributedCityName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: cityFilterRange)
                    if countryFilterRange.location != NSNotFound {
                        item.attributedCountryName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: countryFilterRange)
                    }
            print("2")
            result.append(item)
            print("3")
            self.resultsList = result
                }
        }
//        })
//        DispatchQueue.main.async(execute: workItem)
        workItem.perform()
//
        DispatchQueue.main.async {
            self.updateSearchTableView()
//            //            self.tableView?.reloadData()
//            self.tableView?.isHidden = false
//
        }
        
    }
}

extension CustomSearchTextField: UITableViewDelegate, UITableViewDataSource {
    
    //////////////////////////////////////////////////////////////////////////////
    // Table View related methods
    //////////////////////////////////////////////////////////////////////////////
    
    // MARK: TableView creation and updating
    
    // Create SearchTableview
    func buildSearchTableView() {
        
        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)
            
        } else {
            //addData()
            print("tableView created")
            tableView = UITableView(frame: CGRect.zero)
        }
        
        updateSearchTableView()
    }
    
    // Updating SearchtableView
    func updateSearchTableView() {
        
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            
            if tableView.contentSize.height < 300 {
                tableHeight = tableView.contentSize.height
            } else {
                tableHeight = 300
            }
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            
            tableView.reloadData()
        }
    }
    
    // MARK: TableViewDataSource methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection = \(resultsList.count)")
        return resultsList.count
    }
    
    // MARK: TableViewDelegate methods
    
    //Adding rows in the tableview with the data from dataList
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let localResultList = resultsList
        if indexPath.row >= localResultList.count {
//            tableView.reloadData()
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.attributedText = localResultList[indexPath.row].getFormatedText()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row")
        self.text = resultsList[indexPath.row].getStringText()
        
        self.currentItemId = resultsList[indexPath.row].id
        tableView.isHidden = true
        self.endEditing(true)
    }
    
}


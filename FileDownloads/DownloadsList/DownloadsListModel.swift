//
//  DownloadsListModel.swift
//  FileDownloads
//
//  Created by Saiefeddine HAYOUNI on 07/08/2022.
//

import Foundation
protocol DownloadsListModelProtocol: AnyObject {
    var download: [Download] { get set }
    var numberOfRows: Int { get }
}

public class DownloadsListModel: DownloadsListModelProtocol {
    var download = [Download]()
    
    var maxConcurrentOperationCount: Int = 0
    
    public init(maxConcurrentOperationCount: Int ) {
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
    
    var numberOfRows: Int {
        download.count
    }
}

//
//  DownloadsList.swift
//  FileDownloads
//
//  Created by Saiefeddine HAYOUNI on 03/08/2022.
//

import UIKit
import UIKit


public class DownloadsList: NibView {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Constants

    struct K {
        static let downloadsSessionIdentifier = "Download"
        static let pourcentage = "0%"
    }
    var manager :  DownloadManager {
        let manager = DownloadManager.shared
        manager.delegate = self
        return manager
    }
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier:
                                                                K.downloadsSessionIdentifier)
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    //Model: DownloadsListModel
    public var model: DownloadsListModel? {
        didSet {
            if let model = model {
                self.tableView.registerNibCell(ofType: DownloadsCell.self)
                self.tableView.dataSource = self
                manager.urlSession = downloadsSession
                manager.maxConcurrentOperationCount = model.maxConcurrentOperationCount 
            }
        }
    }
    /// start download file
    /// - Parameter url: URL
    public func startDownload(for url: URL) {
        let download = Download(url: url, pourcentage: K.pourcentage, state: .start)
        model?.download.append(download)
        manager.start(with: download)
        tableView.reloadData()
    }
}

extension DownloadsList: DownloadManagerDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}

//
//  DownloadManager.swift
//  FileDownloads
//
//  Created by Saiefeddine HAYOUNI on 02/08/2022.
//

import Foundation

protocol DownloadManagerDelegate: AnyObject {
    func reloadData()
}

public class DownloadManager: NSObject {
    
    public static let shared = DownloadManager()
    var maxConcurrentOperationCount = 0
    weak var delegate: DownloadManagerDelegate?
    var urlSession: URLSession?
    public var activeDownloads: [URL: Download] = [:]
    
    lazy var downloadQueue: OperationQueue = {
        let operation = OperationQueue()
        operation.maxConcurrentOperationCount = maxConcurrentOperationCount
        return operation
    }()
    /// start download task
    /// - Parameter download: Download
    func start(with download: Download) {
        downloadQueue.addOperation {
            var download = Download(url: download.url, pourcentage: "0%", state: .start)
            download.sessionTask = self.urlSession?.downloadTask(with: download.url)
            download.sessionTask?.resume()
            download.state = .start
            self.activeDownloads[download.url] = download
        }
    }
    /// search local path
    /// - Parameter download: URL
    func localFilePath(for url: URL) -> URL? {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    /// cancel task
    /// - Parameter download: Download
    func cancelTask(with download: Download) {
        guard var download = self.activeDownloads[download.url] else { return }
        
        download.sessionTask?.cancel()
        activeDownloads[ download.url ] = nil
        download.state = .cancel
        delegate?.reloadData()
    }
    /// pause task
    /// - Parameter download: Download
    func pauseTask(with download: Download) {
        guard var download = self.activeDownloads[download.url] else { return }
        download.sessionTask?.cancel(byProducingResumeData: { (data) in
            download.resumeData = data
        })
        download.state = .pause
        delegate?.reloadData()
    }
    /// resume task
    /// - Parameter download: Download
    func resumeTask(with download: Download) {
        guard var download = self.activeDownloads[download.url] else { return }
        if let resumeData = download.resumeData {
            download.sessionTask = urlSession?.downloadTask(withResumeData: resumeData)
        } else {
            download.sessionTask = urlSession?.downloadTask(with: download.url)
        }
        download.state = .resume
        download.sessionTask?.resume()
        delegate?.reloadData()
    }
}

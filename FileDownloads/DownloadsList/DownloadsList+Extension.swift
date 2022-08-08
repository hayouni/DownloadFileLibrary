//
//  DownloadsList+Extension.swift
//  FileDownloads
//
//  Created by Saiefeddine HAYOUNI on 05/08/2022.
//

import Foundation
import UIKit

 extension DownloadsList: UITableViewDataSource {
     
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.numberOfRows ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: DownloadsCell.self, for: indexPath)
        guard let model = self.model else { return cell }

        cell.onPause = { [weak self] ( indexPath) in
            guard let self = self, let selectedIndexPath = indexPath else { return }
            model.download[selectedIndexPath.row].state = .pause
            self.manager.pauseTask(with: model.download[selectedIndexPath.row])
        }
        
        cell.onStop = { [weak self] ( indexPath) in
            guard let self = self, let selectedIndexPath = indexPath else { return }
            model.download[selectedIndexPath.row].state = .cancel
            self.manager.cancelTask(with: model.download[selectedIndexPath.row])
        }
        
        cell.onResume = { [weak self] ( indexPath) in
            guard let self = self, let selectedIndexPath = indexPath else { return }
            model.download[selectedIndexPath.row].state = .resume
            self.manager.resumeTask(with: model.download[selectedIndexPath.row])
        }
        
        cell.configCell(download: model.download[indexPath.row ], indexPath: indexPath)
        return cell
        
    }
    
}
    extension DownloadsList: URLSessionDownloadDelegate {
        
        public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {}
        
        public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            
            guard
                let url = downloadTask.originalRequest?.url,
                let model = model else {
                return
            }
            
            guard let index = model.download.firstIndex(where: {"\($0.url)" == url.absoluteString}) else { return }
            model.download[index].state = .done
            DispatchQueue.main.async {
                if let downloadCell = self.tableView.cellForRow(at: IndexPath(row: index,
                                                                           section: 0)) as? DownloadsCell {
                    downloadCell.updateDisplay(download: model.download[index])
                }
            }
        }
        
        public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                               didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                               totalBytesExpectedToWrite: Int64) {
            guard
                let url = downloadTask.originalRequest?.url,
                var download = manager.activeDownloads[url],
                let model = model else {
                return
            }
            
            guard let index = model.download.firstIndex(where: {"\($0.url)" == url.absoluteString}) else { return }
            let pourcentage = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)) * 100

            download.pourcentage = "\(pourcentage)%"
            model.download[index].pourcentage = "\(pourcentage)%"

            DispatchQueue.main.async {
                if let downloadCell = self.tableView.cellForRow(at: IndexPath(row: index,
                                                                           section: 0)) as? DownloadsCell {
                    downloadCell.updateDisplay(download: download)
                }
            }
        }
    }
    

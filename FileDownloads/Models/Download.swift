//
//  Download.swift
//  
//
//  Created by Saiefeddine HAYOUNI on 04/08/2022.
//

import Foundation

public typealias Closure = () -> Void

public enum DownloadState: Int {
    case start = 0
    case pause
    case resume
    case cancel
    case done
}

public struct Download {
    let url: URL
    var pourcentage: String
    var state: DownloadState
    var sessionTask: URLSessionDownloadTask?
    var resumeData: Data?
    var isDownloaded: Bool = false

}

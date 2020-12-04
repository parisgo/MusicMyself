//
//  DirectoryMonitor.swift
//  MusicMyself
//
//  Created by XYU on 03/12/2020.
//

import Foundation

protocol DirectoryMonitorDelegate: class {
    func directoryMonitorDidObserveChange(directoryMonitor: DirectoryMonitor)
}

class DirectoryMonitor {
    weak var delegate: DirectoryMonitorDelegate?

    var monitoredDirectoryFileDescriptor: CInt = -1
    let directoryMonitorQueue =  DispatchQueue(label: "directorymonitor", attributes: .concurrent)
    var directoryMonitorSource: DispatchSourceFileSystemObject?
    var url: URL

    init(url: URL) {
        self.url = url
    }

    func startMonitoring() {
        // Listen for changes to the directory (if we are not already).
        if directoryMonitorSource == nil && monitoredDirectoryFileDescriptor == -1 {
            // Open the directory referenced by URL for monitoring only.
            monitoredDirectoryFileDescriptor = open((url as NSURL).fileSystemRepresentation, O_EVTONLY)

            // Define a dispatch source monitoring the directory for additions, deletions, and renamings.
            directoryMonitorSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: monitoredDirectoryFileDescriptor, eventMask: .write, queue: directoryMonitorQueue)
            
            // Define the block to call when a file change is detected.
            directoryMonitorSource?.setEventHandler{
                // Call out to the `DirectoryMonitorDelegate` so that it can react appropriately to the change.
                self.delegate?.directoryMonitorDidObserveChange(directoryMonitor: self)
            }

            // Define a cancel handler to ensure the directory is closed when the source is cancelled.
            directoryMonitorSource?.setCancelHandler{
                close(self.monitoredDirectoryFileDescriptor)

                self.monitoredDirectoryFileDescriptor = -1
                self.directoryMonitorSource = nil
            }

            // Start monitoring the directory via the source.
            directoryMonitorSource?.resume()
        }
    }

    func stopMonitoring() {
        // Stop listening for changes to the directory, if the source has been created.
        if directoryMonitorSource != nil {
            // Stop monitoring the directory via the source.
            directoryMonitorSource?.cancel()
        }
    }
}

extension DispatchSourceFileSystemObject {
    var dataStrings: [String] {
        var s = [String]()
        if data.contains(.all)      { s.append("all") }
        if data.contains(.attrib)   { s.append("attrib") }
        if data.contains(.delete)   { s.append("delete") }
        if data.contains(.extend)   { s.append("extend") }
        if data.contains(.funlock)  { s.append("funlock") }
        if data.contains(.link)     { s.append("link") }
        if data.contains(.rename)   { s.append("rename") }
        if data.contains(.revoke)   { s.append("revoke") }
        if data.contains(.write)    { s.append("write") }
        
        return s
    }
}

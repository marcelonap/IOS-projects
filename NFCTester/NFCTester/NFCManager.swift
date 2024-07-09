//
//  NFCManager.swift
//  NFCTester
//
//  Created by Marcelo Napoleao Sampaio on 2024-03-29.
//

import Foundation
import CoreNFC

class NFCReaderViewModel: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    var nfcSession: NFCNDEFReaderSession?
    @Published var readMessages: [String] = []
    
    func beginScanning() {
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.alertMessage = "Hold your iPhone near the item to learn more about it."
        nfcSession?.begin()
    }
    
    // NFCNDEFReaderSessionDelegate methods
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // Handle error
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("entered didbecomeactivecallback")
    }
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                // Check if the record's TNF indicates it's a well-known type
                if record.typeNameFormat == .nfcWellKnown {
                    // Attempt to extract the text and locale from the record
                    let (text, _) = record.wellKnownTypeTextPayload()
                    if let unwrappedText = text {
                        DispatchQueue.main.async {
                            print(unwrappedText)
                            self.readMessages.append(unwrappedText)
                        }
                    }
                }
            }
        }
    }
}

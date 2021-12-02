//
//  ConnectionManager.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 19.11.21.
//

import Foundation
import MultipeerConnectivity

protocol ConnectionManagerDelegate {
    func didJoinSession(in: ConnectionManager)
    func didHostSession(in: ConnectionManager)
    func didRecieveClient(event: Event, in: ConnectionManager)
}

class ConnectionManager: NSObject {
    private static let service = "con-manager"
    
    let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private var advertiserAssistant: MCNearbyServiceAdvertiser?
    private var session: MCSession?
    private var isHosting = false
    
    var connected = false
    var peers: [MCPeerID] = []
    var events: [Event] = []
    
    var delegate: ConnectionManagerDelegate?
    
    func send(_ event: Event) {
        events.append(event)
        guard let session = session,
              let data = event.data,
              !session.connectedPeers.isEmpty else { return }
        
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func join() {
        peers.removeAll()
        events.removeAll()
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
        guard let window = UIApplication.shared.windows.first,
            let session = session
        else { return }
        
        let mcBrowserViewController = MCBrowserViewController(serviceType: ConnectionManager.service, session: session)
        mcBrowserViewController.delegate = self
        window.rootViewController?.present(mcBrowserViewController, animated: true)
    }
    
    func host() {
        isHosting = true
        peers.removeAll()
        events.removeAll()
        connected = true
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
        advertiserAssistant = MCNearbyServiceAdvertiser(
            peer: myPeerId,
            discoveryInfo: nil,
            serviceType: ConnectionManager.service)
        advertiserAssistant?.delegate = self
        advertiserAssistant?.startAdvertisingPeer()
        delegate?.didHostSession(in: self)
    }
}

extension ConnectionManager: MCSessionDelegate {
 
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let event = try? JSONDecoder().decode(Event.self, from: data) else { return }
        DispatchQueue.main.async {
            self.events.append(event)
            self.delegate?.didRecieveClient(event: event, in: self)
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            // Connect to new peer
            if !peers.contains(peerID) {
                DispatchQueue.main.async {
                    self.peers.insert(peerID, at: 0)
                }
            }
        case .notConnected:
            // delete peer from list
            DispatchQueue.main.async {
                if let index = self.peers.firstIndex(of: peerID) {
                    self.peers.remove(at: index)
                }
                if self.peers.isEmpty && !self.isHosting {
                    self.connected = false
                }
            }
        case .connecting:
            print("Connecting to: \(peerID.displayName)")
        @unknown default:
            fatalError("This should not happen")
        }
    }
    
    /// Unrelevant delegate functions
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
}

extension ConnectionManager: MCBrowserViewControllerDelegate {
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    browserViewController.dismiss(animated: true) {
      self.connected = true
        self.delegate?.didJoinSession(in: self)
    }
  }

  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    session?.disconnect()
    browserViewController.dismiss(animated: true)
  }
}


extension ConnectionManager: MCNearbyServiceAdvertiserDelegate {
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    invitationHandler(true, session)
  }
}

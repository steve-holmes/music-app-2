//
//  MusicTrackDataSource.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import Foundation

protocol MusicTrackDataSource {
    
    var musicTracks: MusicTracks { get set }
    var mode: MusicMode { get set }
    
    var isEmpty: Bool { get }
    
    func nextTrack() -> Track?
    func replaceCurrentTrack(_ track: Track)
    
    func backward() -> Track?
    func forward() -> Track?
    
    func next() -> Track?
    func previous() -> Track?
    
    func nextMode() -> MusicMode
    
}

class MAMusicTrackDataSource: MusicTrackDataSource {
    
    var loadedTracks: [Track] = []
    var tracks: [Track] = []
    var currentTrack: Track!
    
    var musicTracks: MusicTracks {
        get {
            return MusicTracks(
                tracks: tracks,
                selectedTrack: currentTrack
            )
        }
        set {
            loadedTracks = []
            tracks = newValue.tracks
            currentTrack = newValue.selectedTrack
        }
    }
    
    var mode: MusicMode = .flow
    
    var isEmpty: Bool {
        return tracks.isEmpty
    }
    
    func nextTrack() -> Track? {
        switch mode {
        case .flow:         return nextTrackInFlowMode()
        case .repeat:       return nextTrackInRepeatMode()
        case .repeatOne:    return nextTrackInRepeatOneMode()
        case .shuffle:      return nextTrackInShuffleMode()
        }
    }
    
    func replaceCurrentTrack(_ track: Track) {
        currentTrack = track
    }
    
    func backward() -> Track? {
        guard let previousTrack = previous() else { return nil }
        replaceCurrentTrack(previousTrack)
        return previousTrack
    }
    
    func forward() -> Track? {
        guard let nextTrack = next() else { return nil }
        replaceCurrentTrack(nextTrack)
        return nextTrack
    }
    
    func previous() -> Track? {
        let currentIndex = tracks.index(of: currentTrack)!
        let previousIndex = currentIndex - 1
        
        if previousIndex < 0 { return nil }
        return tracks[previousIndex]
    }
    
    func next() -> Track? {
        let currentIndex = tracks.index(of: currentTrack)!
        let nextIndex = currentIndex + 1
        
        if nextIndex >= tracks.count { return nil }
        return tracks[nextIndex]
    }
    
    func nextMode() -> MusicMode {
        mode = mode.next
        return mode
    }
    
    fileprivate func addLoadTracks(_ track: Track) {
        if !loadedTracks.contains(track) {
            loadedTracks.append(track)
        }
    }
    
}

// MARK: Flow Mode

extension MAMusicTrackDataSource {
    
    fileprivate func nextTrackInFlowMode() -> Track? {
        let currentIndex = tracks.index(of: currentTrack)!
        let nextIndex = (currentIndex + 1) % tracks.count
        
        if nextIndex == 0 {
            return nil
        }
        
        addLoadTracks(currentTrack)
        currentTrack = tracks[nextIndex]
        return currentTrack
    }
    
}

// MARK: Repeat Mode

extension MAMusicTrackDataSource {
    
    fileprivate func nextTrackInRepeatMode() -> Track {
        let track = nextTrackInFlowMode()
        
        if track == nil {
            addLoadTracks(currentTrack)
            currentTrack = tracks[0]
            return currentTrack
        }
        
        return track!
    }
    
}

// MARK: Repeat One Mode

extension MAMusicTrackDataSource {
    
    fileprivate func nextTrackInRepeatOneMode() -> Track? {
        return currentTrack
    }
    
}

// MARK: Shuffle Mode

extension MAMusicTrackDataSource {
    
    fileprivate func nextTrackInShuffleMode() -> Track? {
        addLoadTracks(currentTrack)
        
        if loadedTracks.count == tracks.count {
            return nil
        }
        
        var track = tracks[0]
        repeat {
            let randomIndex = Int(arc4random_uniform(UInt32(tracks.count)))
            track = tracks[randomIndex]
        } while (track == currentTrack || loadedTracks.contains(track))
        
        currentTrack = track
        return currentTrack
    }
    
}

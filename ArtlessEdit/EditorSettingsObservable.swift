//
//  EditorSettingsObservable.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 28/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class EditorSettingsObservable: ObservableSettings {
    var subscribers: [EditorSettingsObserver] = []
    
    func notifySubscribers(settings: EditorSettings) {
        for subscriber in subscribers {
            subscriber.updateSettings(settings)
        }
    }
    
    func addSubscriber(subscriber: EditorSettingsObserver) {
        subscribers.append(subscriber)
    }
    
    func removeSubscriber(subscriberToRemove: EditorSettingsObserver) {
        var index = 0
        for subscriber in subscribers {
            if subscriber === subscriberToRemove {
                subscribers.removeAtIndex(index)
                break
            }
            index += 1
        }
    }
    
}
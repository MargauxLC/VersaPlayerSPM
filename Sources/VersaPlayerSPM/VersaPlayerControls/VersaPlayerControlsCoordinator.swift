//
//  VersaPlayerControlsCoordinator.swift
//  VersaPlayer Demo
//
//  Created by Jose Quintero on 10/11/18.
//  Copyright © 2018 Quasar. All rights reserved.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif
import CoreMedia
import AVFoundation

@available(iOSApplicationExtension, unavailable)
open class VersaPlayerControlsCoordinator: View, VersaPlayerGestureRecieverViewDelegate {

    /// VersaPlayer instance being used
    weak var player: VersaPlayerView?
    
    /// VersaPlayerControls instance being used
    weak public var controls: VersaPlayerControls?
    
    /// VersaPlayerGestureRecieverView instance being used
    public var gestureReciever: VersaPlayerGestureRecieverView?

    deinit {
        
    }

    #if os(macOS)
    
    override open func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        configureView()
    }
    
    open override func layout() {
        super.layout()
        stretchToEdges()
    }
    
    #else
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureView()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        stretchToEdges()
    }
    
    #endif
    
    public func configureView() {
        if let h = superview as? VersaPlayerView {
            player = h
            if let controls = controls {
                addSubview(controls)
            }
            if gestureReciever == nil {
                let gestureReciever = VersaPlayerGestureRecieverView()
                gestureReciever.delegate = self
                #if os(macOS)
                addSubview(gestureReciever, positioned: NSWindow.OrderingMode.below, relativeTo: nil)
                #else
                addSubview(gestureReciever)
                sendSubviewToBack(gestureReciever)
                #endif
                self.gestureReciever = gestureReciever
            }
            stretchToEdges()
        }
    }
    
    public func stretchToEdges() {
        translatesAutoresizingMaskIntoConstraints = false
        if let parent = superview {
            topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        }
    }
    
    /// Notifies when pinch was recognized
    ///
    /// - Parameters:
    ///     - scale: CGFloat value
    open func didPinch(with scale: CGFloat) {
        
    }
    
    /// Notifies when tap was recognized
    ///
    /// - Parameters:
    ///     - point: CGPoint at which tap was recognized
    open func didTap(at point: CGPoint) {
        guard let behaviour = controls?.behaviour else { return }
        if behaviour.showingControls {
            behaviour.hide()
        }else {
            behaviour.show()
        }
    }
    
    /// Notifies when tap was recognized
    ///
    /// - Parameters:
    ///     - point: CGPoint at which tap was recognized
    open func didDoubleTap(at point: CGPoint) {
        guard let playerLayer = player?.renderingView.playerLayer else { return }
        if playerLayer.videoGravity == AVLayerVideoGravity.resizeAspect {
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        }else {
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        }
    }
    
    /// Notifies when pan was recognized
    ///
    /// - Parameters:
    ///     - translation: translation of pan in CGPoint representation
    ///     - at: initial point recognized
    open func didPan(with translation: CGPoint, initially at: CGPoint) {
        
    }
    
    #if os(tvOS)
    /// Swipe was recognized
    ///
    /// - Parameters:
    ///     - direction: gestureDirection
    open func didSwipe(with direction: UISwipeGestureRecognizer.Direction) {
        
    }
    #endif

}

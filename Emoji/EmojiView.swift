//
//  EmojiView.swift
//  Emoji
//
// Created by de Bits on 4/17/22.

// The missing sample code for
// https://developer.apple.com/wwdc17/235
// Copy Right would belong to Apple even for this that they did not actually
// publish except in video.

import UIKit
class EmojiView: UIView {
    let emojilayers: [CALayer]
    
    override init(frame: CGRect) {
        let emojiList="😀😃😄😁😆🥹😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😒😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠"
        let screenScale = UIScreen.main.scale
        let cornerInset = 45 // starting x/y position for the grid
        let layerSize = 70 // Probably needs to be set by the client
        var index = 0 // to keep track of what column / row we're on
        var emojiLayers: [CALayer] = []
        for e in emojiList {
            let layer = CATextLayer()
            layer.string = String(e)
            layer.fontSize = 50
            layer.contentsScale = screenScale
            layer.bounds = CGRect (x: 0, y: 0, width: layerSize, height: layerSize)
            layer.alignmentMode = CATextLayerAlignmentMode.center
    
            let column = index % 4
            let row = (index - column) / 4
            layer.position = CGPoint (x: cornerInset + layerSize * column, y: cornerInset + layerSize * row)
            emojiLayers.append(layer)
            index = index + 1
        }
        self.emojilayers = emojiLayers
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

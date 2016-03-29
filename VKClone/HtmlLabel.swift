//
//  HtmlLabel.swift
//  VKClone
//
//  Created by Alexander Blokhin on 28.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

enum LinkType {
    case Hashtag
    case WebLink
}

struct Link {
    var linkType: LinkType
    var linkRange: NSRange
    var linkString: String
}

class HtmlLabel: UILabel {
    
    var links = [Link]()
    
    override var text: String! {
        didSet {
            setLabelDataWithText(text)
        }
    }

    // MARK: - Initializations
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    func setLabelDataWithText(text: String) {
        let firstStr = NSMutableString(string: text.stringByReplacingOccurrencesOfString("\n", withString: " "))
        let str = NSMutableString(string: firstStr.stringByReplacingOccurrencesOfString("<br>", withString: " "))
        
        let words = str.componentsSeparatedByString(" ")
        
        let attrStr = try! NSMutableAttributedString(
            data: text.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        links.removeAll()
        
        for word in words {
            if (word.containsString("#")) {
                let hashtagRange = str.rangeOfString(word)
                
                if (hashtagRange.location != NSNotFound) {
                
                    attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "#4F77B2"), range: hashtagRange)
                
                    let hashtag = Link(linkType: .Hashtag, linkRange: hashtagRange, linkString: word)
                    links.append(hashtag)
                }
            }
            
            if word.containsWords(["http", ".ru", ".com", ".net", "cc", "www"]) {
                let linkRange = str.rangeOfString(word)
                
                if (linkRange.location != NSNotFound) {
                
                    attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "#4F77B2"), range: linkRange)
                
                    let hashtag = Link(linkType: .WebLink, linkRange: linkRange, linkString: word)
                    links.append(hashtag)
                    
                }
            }
        }
        
        self.attributedText = attrStr
        self.font = UIFont.systemFontOfSize(14)
        
        makeTouchable()
    }
    
    func makeTouchable() {
        self.userInteractionEnabled = true
        
        if self.gestureRecognizers == nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapToWord:"))
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    
    func tapToWord(gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.locationOfTouch(0, inView: self)
        getLinkAtLocation(touchPoint)
    }

    
    private func getLinkAtLocation(location: CGPoint) -> Link? {
        
        let textContainer = NSTextContainer(size: self.frame.size)
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedText!)
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        var fractionOfDistance: CGFloat = 0.0
        let characterIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints: &fractionOfDistance)
        
        if characterIndex <= textStorage.length {
            for link in links {
                let rangeLocation = link.linkRange.location
                let rangeLength = link.linkRange.length
                
                if rangeLocation <= characterIndex &&
                    (rangeLocation + rangeLength - 1) >= characterIndex {
                        
                        let glyphRange = layoutManager.glyphRangeForCharacterRange(NSMakeRange(rangeLocation, rangeLength), actualCharacterRange: nil)
                        let boundingRect = layoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer)
                        
                        if CGRectContainsPoint(boundingRect, location) {
                            return link
                        }
                }
            }
        }
        
        return nil
    }
}










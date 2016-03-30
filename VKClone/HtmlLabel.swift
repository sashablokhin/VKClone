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

protocol HtmlLabelDelegate {
    func htmlLabel(label: HtmlLabel, didTouchTo link: Link)
}


extension HtmlLabelDelegate {
    func htmlLabel(label: HtmlLabel, didTouchTo link: Link) {
        
    }
}

class HtmlLabel: UILabel {
    
    var delegate: HtmlLabelDelegate?
    
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
                let hashtagRange = attrStr.mutableString.rangeOfString(word)
                
                if (hashtagRange.location != NSNotFound)  {
                
                    attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "#4F77B2"), range: hashtagRange)
                
                    let hashtag = Link(linkType: .Hashtag, linkRange: hashtagRange, linkString: word)
                    links.append(hashtag)
                }
            }
            
            if word.containsWords(["http", ".ru", ".com", ".net", ".cc", "www"]) {
                let linkRange = attrStr.mutableString.rangeOfString(word)
                
                if (linkRange.location != NSNotFound) {
                
                    attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "#4F77B2"), range: linkRange)
                
                    let weblink = Link(linkType: .WebLink, linkRange: linkRange, linkString: word)
                    links.append(weblink)
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
            let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapToLink:"))
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    
    func tapToLink(gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.locationOfTouch(0, inView: self)
        
        if let link = getLinkAtLocation(touchPoint) {
            delegate?.htmlLabel(self, didTouchTo: link)
        }
    }

    
    private func getLinkAtLocation(location: CGPoint) -> Link? {
        
        let textContainer = NSTextContainer(size: self.frame.size)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.maximumNumberOfLines = self.numberOfLines
        
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let textBoundingBox = layoutManager.usedRectForTextContainer(textContainer)
        let textContainerOffset = CGPointMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(textBoundingBox)) * 0.5 - CGRectGetMinX(textBoundingBox),
            (CGRectGetHeight(self.bounds) - CGRectGetHeight(textBoundingBox)) * 0.5 - CGRectGetMinY(textBoundingBox))
        
        let locationOfTouchInTextContainer = CGPointMake(location.x - textContainerOffset.x, location.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndexForPoint(locationOfTouchInTextContainer, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        for link in links {
            if (NSLocationInRange(indexOfCharacter, link.linkRange)) {
                return link
            }
        }
        
        return nil
    }
}











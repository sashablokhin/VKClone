//
//  PostTextView.swift
//  VKClone
//
//  Created by Alexander Blokhin on 01.04.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

enum LinkType {
    case Hashtag
    case WebLink
}

class Link: NSURL {
    var linkText: String?
    var linkType: LinkType?
    var linkRange: NSRange?
    
    init?(link: String, type: LinkType, range: NSRange) {
        switch type {
        case .Hashtag:  super.init(string: "http://", relativeToURL: nil)
            break
        case .WebLink:  super.init(string: link.containsString("http") ? link : "http://" + link, relativeToURL: nil)
            break
        }
        
        self.linkText = link
        self.linkType = type
        self.linkRange = range
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required convenience init(fileReferenceLiteral path: String) {
        fatalError("init(fileReferenceLiteral:) has not been implemented")
    }
}


class ReadMoreTextView: UITextView, UITextViewDelegate {
    
    var attrStr: NSMutableAttributedString!
    var links = [Link]()
    
    var trimText = "Показать полностью..."
    var shouldTrim = true
    
    var readMoreHandler: (() -> ())?
    
    private let readMoreLocation = 400
    
    override var text: String! {
        didSet {
            setTextViewDataWithText(text)
        }
    }
    
    func setTextViewDataWithText(text: String) {
        attrStr = getDefaultAttributedText(text)
        
        let firstStr = NSMutableString(string: text.stringByReplacingOccurrencesOfString("\n", withString: " "))
        let str = NSMutableString(string: firstStr.stringByReplacingOccurrencesOfString("<br>", withString: " "))
        
        let words = str.componentsSeparatedByString(" ")
        
        links.removeAll()
        
        for word in words {
            if word.containsWords(["http", ".ru", ".com", ".net", ".cc", "www"]) {
                let linkRange = attrStr.mutableString.rangeOfString(word)
                
                if (linkRange.location != NSNotFound) {
                    if let weblink = Link(link: word, type: .WebLink, range: linkRange) {
                        links.append(weblink)
                        attrStr.addAttribute(NSLinkAttributeName, value: weblink, range: linkRange)
                    }
                }
            } else if (word.containsString("#")) {
                let hashtagRange = attrStr.mutableString.rangeOfString(word)
                
                if (hashtagRange.location != NSNotFound)  {
                    if let hashtag = Link(link: word, type: .Hashtag, range: hashtagRange) {
                        links.append(hashtag)
                        attrStr.addAttribute(NSLinkAttributeName, value: hashtag, range: hashtagRange)
                    }
                }
            }
        }
        
        if attrStr.length > readMoreLocation && shouldTrim {
            if let shortAttrStr = attrStr.mutableCopy() as? NSMutableAttributedString {
                shortAttrStr.replaceCharactersInRange(NSMakeRange(readMoreLocation, attrStr.length - readMoreLocation), withAttributedString: getTrimAtrributedText())
                self.attributedText = shortAttrStr
            }
        } else {
            self.attributedText = attrStr
        }
    }
    
    
    func getTrimAtrributedText() -> NSAttributedString {
        let trimStr = NSMutableAttributedString(string: "...\n\(trimText)")
        trimStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.defaultLinkColor(), range: NSMakeRange(4, trimText.characters.count))
        trimStr.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(14), range: NSMakeRange(0, trimStr.length))
        
        return trimStr
    }
    
    func getReadMoreRange(leftOffset: Int = 0) -> NSRange {
        return NSMakeRange(readMoreLocation + leftOffset, getTrimAtrributedText().length - leftOffset)
    }
    
    func getDefaultAttributedText(text: String) -> NSMutableAttributedString {
        self.attributedText = try! NSMutableAttributedString(
            data: text.dataUsingEncoding(NSUTF8StringEncoding)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
            documentAttributes: nil)
        
        self.font = UIFont.systemFontOfSize(14)
        self.editable = false
        self.scrollEnabled = false
        self.userInteractionEnabled = true
        
        self.delegate = self
        
        return NSMutableAttributedString(attributedString: attributedText!)
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        for link in links {
            if link.linkRange!.intersects(characterRange) {
                if link.linkType == .Hashtag {
                    print(link.linkText)
                }
                
                if link.linkType == .WebLink {
                    UIApplication.sharedApplication().openURL(URL)
                }
            }
        }
        
        return false
    }
    
    func changeReadMoreColor(color: UIColor) {
        if let copyStr = self.attributedText.mutableCopy() as? NSMutableAttributedString {
            copyStr.removeAttribute(NSForegroundColorAttributeName, range: getReadMoreRange(4))
            copyStr.addAttribute(NSForegroundColorAttributeName, value: color, range: getReadMoreRange(4))
            attributedText = copyStr
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if shouldTrim && pointInTrimTextRange(touches.first!.locationInView(self)) {
            changeReadMoreColor(UIColor.highlightedLinkColor())
        }
        
        self.selectable = false
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if shouldTrim && pointInTrimTextRange(touches.first!.locationInView(self)) {
            self.attributedText = attrStr
            shouldTrim = false
            
            if let handler = readMoreHandler {
                handler()
            }
        }
        
        self.selectable = true
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if shouldTrim && pointInTrimTextRange(touches.first!.locationInView(self)) {
            changeReadMoreColor(UIColor.defaultLinkColor())
        }
    }
    
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if shouldTrim && pointInTrimTextRange(touches!.first!.locationInView(self)) {
            changeReadMoreColor(UIColor.defaultLinkColor())
        }
        
        self.selectable = true
    }
    
    private func pointInTrimTextRange(point: CGPoint) -> Bool {
        let offset = CGPointMake(textContainerInset.left, textContainerInset.top)
        var boundingRect = layoutManager.boundingRectForCharacterRange(getReadMoreRange(), inTextContainer: textContainer, textContainerOffset: offset)
        boundingRect = CGRectOffset(boundingRect, textContainerInset.left, textContainerInset.top)
        return CGRectContainsPoint(boundingRect, point)
    }
}





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
    
    init(link: String, type: LinkType, range: NSRange) {
        switch type {
        case .Hashtag:  super.init(string: "http://", relativeToURL: nil)!
            break
        case .WebLink:  super.init(string: link.containsString("http") ? link : "http://" + link, relativeToURL: nil)!
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


class ReadMoreTextView: UITextView, UITextViewDelegate {/*
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }
    
    convenience init() {
        self.init(frame: CGRectZero, textContainer: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }*/
    var attrStr: NSMutableAttributedString!
    var links = [Link]()
    
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
                    let weblink = Link(link: word, type: .WebLink, range: linkRange)
                    links.append(weblink)
                    attrStr.addAttribute(NSLinkAttributeName, value: weblink, range: linkRange)
                }
            } else if (word.containsString("#")) {
                let hashtagRange = attrStr.mutableString.rangeOfString(word)
                
                if (hashtagRange.location != NSNotFound)  {
                    let hashtag = Link(link: word, type: .Hashtag, range: hashtagRange)
                    links.append(hashtag)
                    attrStr.addAttribute(NSLinkAttributeName, value: hashtag, range: hashtagRange)
                }
            }
        }
        
        self.attributedText = attrStr
    }
    
    func getDefaultAttributedText(text: String) -> NSMutableAttributedString {
        self.attributedText = try! NSMutableAttributedString(
            data: text.dataUsingEncoding(NSUTF8StringEncoding)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
            documentAttributes: nil)
        
        self.font = UIFont.systemFontOfSize(14)
        self.editable = false
        self.scrollEnabled = false
        
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
}





/*
@IBDesignable
class ReadMoreTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        scrollEnabled = false
        editable = false
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }
    
    convenience init() {
        self.init(frame: CGRectZero, textContainer: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollEnabled = false
        editable = false
    }
    
    convenience init(maximumNumberOfLines: Int, trimText: NSString?, shouldTrim: Bool) {
        self.init()
        self.maximumNumberOfLines = maximumNumberOfLines
        self.trimText = trimText
        self.shouldTrim = shouldTrim
    }
    
    convenience init(maximumNumberOfLines: Int, attributedTrimText: NSAttributedString?, shouldTrim: Bool) {
        self.init()
        self.maximumNumberOfLines = maximumNumberOfLines
        self.attributedTrimText = attributedTrimText
        self.shouldTrim = shouldTrim
    }
    
    @IBInspectable
    var maximumNumberOfLines: Int = 0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    var trimText: NSString? {
        didSet { setNeedsLayout() }
    }
    
    var attributedTrimText: NSAttributedString? {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    var shouldTrim: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    var trimTextRangePadding: UIEdgeInsets = UIEdgeInsetsZero
    var appendTrimTextPrefix: Bool = true
    var trimTextPrefix: String = "..."
    
    private var originalText: String!
    
    override var text: String! {
        didSet {
            originalText = text
            originalAttributedText = nil
            if needsTrim() { updateText() }
        }
    }
    
    private var originalAttributedText: NSAttributedString!
    
    override var attributedText: NSAttributedString! {
        didSet {
            originalAttributedText = attributedText
            originalText = nil
            if needsTrim() { updateText() }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        needsTrim() ? updateText() : resetText()
    }
    
    func needsTrim() -> Bool {
        return shouldTrim && _trimText != nil
    }
    
    func updateText() {
        textContainer.maximumNumberOfLines = maximumNumberOfLines
        textContainer.size = CGSizeMake(bounds.size.width, CGFloat.max)
        
        let range = rangeToReplaceWithTrimText()
        if range.location != NSNotFound {
            let prefix = appendTrimTextPrefix ? trimTextPrefix : ""
            
            if let text = trimText?.mutableCopy() as? NSMutableString {
                text.insertString("\(prefix) ", atIndex: 0)
                textStorage.replaceCharactersInRange(range, withString: text as String) // !!!!!!!!!!!!!!!
            }
            else if let text = attributedTrimText?.mutableCopy() as? NSMutableAttributedString {
                text.insertAttributedString(NSAttributedString(string: "\(prefix) "), atIndex: 0)
                textStorage.replaceCharactersInRange(range, withAttributedString: text)
            }
        }
        invalidateIntrinsicContentSize()
    }
    
    func resetText() {
        
        print("!!!")
        textContainer.maximumNumberOfLines = 0
        if originalText != nil {
            textStorage.replaceCharactersInRange(NSMakeRange(0, text!.characters.count/*countElements(text!)*/), withString: originalText)
        }
        else if originalAttributedText != nil {
            textStorage.replaceCharactersInRange(NSMakeRange(0, text!.characters.count/*countElements(text!)*/), withAttributedString: originalAttributedText)
        }
        invalidateIntrinsicContentSize()
    }
    
    override func intrinsicContentSize() -> CGSize {
        textContainer.size = CGSizeMake(bounds.size.width, CGFloat.max)
        var intrinsicContentSize = layoutManager.boundingRectForGlyphRange(layoutManager.glyphRangeForTextContainer(textContainer), inTextContainer: textContainer).size
        intrinsicContentSize.width = UIViewNoIntrinsicMetric
        intrinsicContentSize.height += (textContainerInset.top + textContainerInset.bottom)
        return intrinsicContentSize
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        if needsTrim() && pointInTrimTextRange(point) {
            shouldTrim = false
            maximumNumberOfLines = 0
        }
        
        return super.hitTest(point, withEvent: event)
    }
    
    //MARK: Private methods
    
    private var _trimText: NSString? {
        get {
            return trimText ?? attributedTrimText?.string
        }
    }
    
    private var _trimTextPrefixLength: Int {
        get {
            return appendTrimTextPrefix ? trimTextPrefix.characters.count/*countElements(trimTextPrefix)*/ + 1 : 1
        }
    }
    
    private var _originalTextLength: Int {
        get {
            if originalText != nil {
                return originalText!.characters.count/*countElements(originalText!)*/
            }
            else  if originalAttributedText != nil {
                return originalAttributedText!.length
            }
            return 0
        }
    }
    
    private func rangeToReplaceWithTrimText() -> NSRange {
        let emptyRange = NSMakeRange(NSNotFound, 0)
        
        var rangeToReplace = layoutManager.characterRangeThatFits(textContainer)
        if NSMaxRange(rangeToReplace) == _originalTextLength {
            rangeToReplace = emptyRange
        }
        else {
            rangeToReplace.location = NSMaxRange(rangeToReplace) - _trimText!.length - _trimTextPrefixLength
            if rangeToReplace.location < 0 {
                rangeToReplace = emptyRange
            }
            else {
                rangeToReplace.length = textStorage.length - rangeToReplace.location
            }
        }
        return rangeToReplace
    }
    
    private func trimTextRange() -> NSRange {
        var trimTextRange = rangeToReplaceWithTrimText()
        if trimTextRange.location != NSNotFound {
            trimTextRange.length = _trimTextPrefixLength + _trimText!.length
        }
        return trimTextRange
    }
    
    private func pointInTrimTextRange(point: CGPoint) -> Bool {
        let offset = CGPointMake(textContainerInset.left, textContainerInset.top)
        var boundingRect = layoutManager.boundingRectForCharacterRange(trimTextRange(), inTextContainer: textContainer, textContainerOffset: offset)
        boundingRect = CGRectOffset(boundingRect, textContainerInset.left, textContainerInset.top)
        boundingRect = CGRectInset(boundingRect, -(trimTextRangePadding.left + trimTextRangePadding.right), -(trimTextRangePadding.top + trimTextRangePadding.bottom))
        return CGRectContainsPoint(boundingRect, point)
    }
}

//MARK: NSLayoutManager extension

extension NSLayoutManager {
    
    func characterRangeThatFits(textContainer: NSTextContainer) -> NSRange {
        var rangeThatFits = self.glyphRangeForTextContainer(textContainer)
        rangeThatFits = self.characterRangeForGlyphRange(rangeThatFits, actualGlyphRange: nil)
        return rangeThatFits
    }
    
    func boundingRectForCharacterRange(range: NSRange, inTextContainer textContainer: NSTextContainer, textContainerOffset: CGPoint) -> CGRect {
        let glyphRange = self.glyphRangeForCharacterRange(range, actualCharacterRange: nil)
        let boundingRect = self.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer)
        return boundingRect
    }
    
}*/
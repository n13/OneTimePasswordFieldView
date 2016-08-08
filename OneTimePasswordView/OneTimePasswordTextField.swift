//
//  OneTimePasswordTextField.swift
//
//  Created by Givi on 07/07/16.
//  Copyright © 2016 givip. All rights reserved.
//

import UIKit

class OneTimePasswordTextField: UIView {

    var numberWidth: CGFloat = 44
    
    @IBOutlet private weak var cstrUnderLineMarkWidth: NSLayoutConstraint!
    @IBOutlet private weak var cstrUnderLineMarkLeading: NSLayoutConstraint!
    
    @IBOutlet private weak var viewUnderLineMark: UIView!
    @IBOutlet private weak var lblNumber1: UILabel!
    @IBOutlet private weak var lblNumber2: UILabel!
    @IBOutlet private weak var lblNumber3: UILabel!
    @IBOutlet private weak var lblNumber4: UILabel!
    @IBOutlet private weak var lblNumber5: UILabel!
    @IBOutlet private weak var lblNumber6: UILabel!

    @IBOutlet weak var txtFakeTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        txtFakeTextField.delegate = self
        cstrUnderLineMarkWidth.constant = numberWidth
        frame = bounds
        autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        lblNumber1.text = ""
        lblNumber2.text = ""
        lblNumber3.text = ""
        lblNumber4.text = ""
        lblNumber5.text = ""
        lblNumber6.text = ""
    }
    
    // figure out width of view, adjust number widths
    override func layoutSubviews() {
        numberWidth = (self.bounds.width - 20 - 20) / 6
        cstrUnderLineMarkWidth.constant = numberWidth
        super.layoutSubviews()
    }

    // mainly to return minimum height to display numbers
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 100, height: 114)
    }
    
    private func underlinePosition(range: NSRange) {
        var position: Int
        
        if range.length == 0 {
            position = range.location + 1
        } else {
            position = range.location
        }
        if range.location == 5 && range.length == 0 {
            UIView.animateWithDuration(0.2) {
                self.viewUnderLineMark.alpha = 0.0
            }
        } else if range.location == 5 && range.length == 1 {
            UIView.animateWithDuration(0.2) {
                self.viewUnderLineMark.alpha = 1.0
            }
        } else {
            self.viewUnderLineMark.alpha = 1.0
        }
        
        let newPosition = (CGFloat(position) * self.cstrUnderLineMarkWidth.constant) + 20
        self.cstrUnderLineMarkLeading.constant = newPosition
        UIView.animateWithDuration(0.2) {
            self.layoutIfNeeded()
        }
    }
    
    private func inputToLabel(range: NSRange, string: String) {
        //MARK: - insert methods
        if NSEqualRanges(range, NSMakeRange(0, 0)) { lblNumber1.text = string }
        if NSEqualRanges(range, NSMakeRange(1, 0)) { lblNumber2.text = string }
        if NSEqualRanges(range, NSMakeRange(2, 0)) { lblNumber3.text = string }
        if NSEqualRanges(range, NSMakeRange(3, 0)) { lblNumber4.text = string }
        if NSEqualRanges(range, NSMakeRange(4, 0)) { lblNumber5.text = string }
        if NSEqualRanges(range, NSMakeRange(5, 0)) { lblNumber6.text = string }
        
        //MARK: - delete methods
        if NSEqualRanges(range, NSMakeRange(0, 1)) { lblNumber1.text = string }
        if NSEqualRanges(range, NSMakeRange(1, 1)) { lblNumber2.text = string }
        if NSEqualRanges(range, NSMakeRange(2, 1)) { lblNumber3.text = string }
        if NSEqualRanges(range, NSMakeRange(3, 1)) { lblNumber4.text = string }
        if NSEqualRanges(range, NSMakeRange(4, 1)) { lblNumber5.text = string }
        if NSEqualRanges(range, NSMakeRange(5, 1)) { lblNumber6.text = string }
    }
    
    @IBAction private func btnBeginType(sender: AnyObject) {
        self.txtFakeTextField.becomeFirstResponder()
    }

}

extension OneTimePasswordTextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        lblNumber1.text = ""
        lblNumber2.text = ""
        lblNumber3.text = ""
        lblNumber4.text = ""
        lblNumber5.text = ""
        lblNumber6.text = ""
        underlinePosition(NSMakeRange(-1, 0))
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard textField == self.txtFakeTextField else { return false }
        guard range.location < 6 && range.length <= 1 else { return false }
        guard string.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "0123456789")) != nil || string == "" else { return false }
        inputToLabel(range, string: string)
        underlinePosition(range)
        return true
    }
}

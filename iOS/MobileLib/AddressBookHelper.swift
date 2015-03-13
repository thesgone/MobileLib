/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.
MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

import UIKit

import Foundation
import AddressBook

public class AddressBookHelper : NSObject{
    
    public typealias ContactType = AddressBookContact
    public typealias ContactsList = [ContactType]
    
    
    private let allowedCharNumbers : [Character] = ["+","0","1", "2","3","4", "5","6","7", "8", "9"]
    
    public func autorizationStatus()-> ABAuthorizationStatus {
        return ABAddressBookGetAuthorizationStatus()
    }
    
    public func getAllPhoneNumbers(cantactList : ContactsList)->[MLString]{
        var numbers : [MLString] = [MLString]()
        for contact in cantactList{
            
            for number in contact.phones!{
                numbers.append(number.1.mlPhone)
            }
        }
        
        return numbers
    }
    
    public func getContacts(var prefix : MLString) -> ContactsList {
        
        var contacts : ContactsList = ContactsList()
        
        if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.NotDetermined) {
            
            var errorRef: Unmanaged<CFError>? = nil
            var addressBook: ABAddressBookRef?
            
            addressBook = extractUnmanagedObj(ABAddressBookCreateWithOptions(nil, &errorRef))
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    contacts = self.getContactsImpl(prefix)
                }
                else {
                    println("getContactNames: error in asking permission for address book")
                }
            })
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Denied || ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Restricted) {
            println("getContactNames: access denied")
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Authorized) {
            contacts = self.getContactsImpl(prefix)
        }
        
        return contacts
    }

    
    public func addContact(name : MLString?, surname : MLString?, phoneNumber : MLString?)->AddressBookContact{
        
        var addedContact : AddressBookContact = AddressBookContact()
        if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.NotDetermined) {
            
            var errorRef: Unmanaged<CFError>? = nil
            var addressBook: ABAddressBookRef?
            
            addressBook = extractUnmanagedObj(ABAddressBookCreateWithOptions(nil, &errorRef))
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    addedContact = self.addContactImpl(name, surname : surname, phoneNumber : phoneNumber)
                }
                else {
                    println("addContact: error in asking permission for address book")
                }
            })
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Denied || ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Restricted) {
            println("addContact: access denied")
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Authorized) {
            addedContact = self.addContactImpl(name, surname : surname, phoneNumber : phoneNumber)
        }
        
        return addedContact
    }
    
    private func addContactImpl(name : MLString?, surname : MLString?, phoneNumber : MLString?) -> AddressBookContact{
    
        var addedContact = AddressBookContact()
        addedContact.name = name
        addedContact.surname = surname
        
       

        let person: ABRecordRef = ABPersonCreate().takeRetainedValue()
        
        if(name != nil){
            let couldSetFirstName = ABRecordSetValue(person, kABPersonFirstNameProperty, name! as CFTypeRef, nil)
        }
        
        if(surname != nil){
            let couldSetLastName = ABRecordSetValue(person, kABPersonLastNameProperty, surname! as CFTypeRef, nil)
        }
        
        if(phoneNumber != nil){
            
            let phoneType = PhoneType()
            phoneType.mlPhone = phoneNumber!
            phoneType.systemPhone = phoneNumber!
            
            addedContact.phones = AddressBookContact.PhoneList()
            addedContact.phones!["Mobile"] = phoneType
            
            let phoneNumberMultiValue = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType))
            ABMultiValueAddValueAndLabel(extractUnmanagedObj(phoneNumberMultiValue), phoneNumber, kABPersonPhoneMobileLabel, nil)
            
            let couldSetPhoneNumber = ABRecordSetValue(person, kABPersonPhoneProperty, extractUnmanagedObj(phoneNumberMultiValue), nil);
        }
        
        var error: Unmanaged<CFErrorRef>? = nil
        
        var addressBook : ABAddressBookRef?
        addressBook = extractUnmanagedObj(ABAddressBookCreateWithOptions(nil, &error))
        
        let couldAddPerson = ABAddressBookAddRecord(addressBook, person, &error)
        
        if ABAddressBookHasUnsavedChanges(addressBook){
            let couldSaveAddressBook = ABAddressBookSave(addressBook, &error)
        }
        
        addedContact.contactId = ABRecordGetRecordID(person)
        return addedContact
    }
    
    
    public func cleanPhoneNumber(phone : MLString)->MLString{
        var output : MLString = MLString()
        for c : Character in phone{
            if(find(allowedCharNumbers, c) != nil){
                output.append(c)
            }
        }
        
        if(output.hasPrefix("00")){
            output = "+" + output.substringFromIndex(advance(output.startIndex, 2))
        }
        
        return output
    }
    
    private func getContactsImpl(var prefix : MLString) -> ContactsList {
        
        var contcts : ContactsList = ContactsList()
        
        var errorRef: Unmanaged<CFError>?
        
        var addressBook : ABAddressBookRef?
        addressBook = extractUnmanagedObj(ABAddressBookCreateWithOptions(nil, &errorRef))
        
        if let contactList : NSArray = extractUnmanagedObj(ABAddressBookCopyArrayOfAllPeople(addressBook)){
            
            for record : ABRecordRef in contactList {
                
                var contactName : MLString = ""
                if let stirnf = extractUnmanagedObj(ABRecordCopyCompositeName(record)){
                    contactName = stirnf as MLString
                }
                
                var contact : AddressBookContact = AddressBookContact()
                contact.compositeName = contactName
                contact.contactId = ABRecordGetRecordID(record)
                
                contact.phones = AddressBookContact.PhoneList()
                
                if let phoneList : ABMultiValueRef = extractUnmanagedObj(ABRecordCopyValue(record, kABPersonPhoneProperty)){
                    
                    let nbPhones = ABMultiValueGetCount(phoneList)
                    
                    for (var i : CFIndex = 0 ; i < nbPhones; ++i){
                        
                        
                        let phoneType : CFString = ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phoneList, i).takeRetainedValue()).takeRetainedValue() as CFString
                        
                        if let phone_i : MLString =
                            extractUnmanagedObj(ABMultiValueCopyValueAtIndex(phoneList, i))as? NSString{
                                
                                var cleanPhone = cleanPhoneNumber(phone_i)
                                
                                if( (!cleanPhone.hasPrefix("+")) &&  (!cleanPhone.hasPrefix("00"))){
                                    cleanPhone = prefix + cleanPhone
                                }
                                
                                var phone : PhoneType = PhoneType()
                                phone.systemPhone = phone_i
                                phone.mlPhone = cleanPhone
                                
                                let phoneTypeStr : MLString = phoneType as MLString
                                contact.phones![phoneTypeStr] = phone
                        }
                        
                    }
                }
                
                contcts.append(contact)
                
            }
        }
        
        return contcts
    }
    
    private func extractUnmanagedObj< T >(unmanagedObj: Unmanaged<T>!) -> T? {
        if let ab = unmanagedObj {
            return Unmanaged<T>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    
    
}

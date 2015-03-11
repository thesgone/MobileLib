package com.thesgone.mobilelib.addressBook;

import android.content.Context;
import android.content.CursorLoader;
import android.database.Cursor;
import android.provider.ContactsContract;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by stefanogiovannitti on 06/11/14.
 */
public class AddressBookHelper {

    Context context_;
    String prefix_;
    private final char[] allowedChar_ = new char[]{'+','0','1', '2','3','4', '5','6','7', '8', '9'};

    public AddressBookHelper(Context context, String prefix){
        context_ = context;
        prefix_ = prefix;
    }

    private String cleanPhoneNumber(String phoneNumber){

        String output = "";
        for (char c : phoneNumber.toCharArray()){
            for(char x : allowedChar_) {
                if (x == c) {
                    output += c;
                    break;
                }
            }
        }

        if(output.startsWith("00")){
            output = "+" + output.substring(2);
        }

        return output;
    }

    public List<String> getAllPhoneNumbers(List<MLContact> contacts){

        List<String> numbers = new ArrayList<String>();

        for (MLContact contact : contacts){

            if(contact.phoneNumbers == null)
                continue;

            for (MLPhoneNumber phoneNumber : contact.phoneNumbers){
                numbers.add(phoneNumber.number);
            }
        }

        return  numbers;
    }


    public List<MLContact> getAllContacts() {

        ArrayList<MLContact> listContacts = new ArrayList<MLContact>();

        CursorLoader cursorLoader = new CursorLoader(context_,
                ContactsContract.Contacts.CONTENT_URI, // uri
                null, // the columns to retrieve (all)
                null, // the selection criteria (none)
                null, // the selection args (none)
                null // the sort order (default)
        );
        // This should probably be run from an AsyncTask
        Cursor c = cursorLoader.loadInBackground();
        if (c.moveToFirst()) {
            do {
                MLContact contact = loadContactData(c);
                listContacts.add(contact);
            } while (c.moveToNext());
        }
        c.close();
        return listContacts;
    }

    private MLContact loadContactData(Cursor c) {
        // Get Contact ID
        int idIndex = c.getColumnIndex(ContactsContract.Contacts._ID);
        String contactId = c.getString(idIndex);
        // Get Contact Name
        int nameIndex = c.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME);
        String contactDisplayName = c.getString(nameIndex);
        MLContact contact = new MLContact();
        contact.id = contactId;
        contact.name = contactDisplayName;

        fetchContactNumbers(contact);
        fetchContactEmails(contact);
        return contact;
    }


    private void fetchContactNumbers(MLContact contact) {
        // Get numbers
        final String[] numberProjection = new String[] { ContactsContract.CommonDataKinds.Phone.NUMBER, ContactsContract.CommonDataKinds.Phone.TYPE, };
        Cursor phone = new CursorLoader(context_, ContactsContract.CommonDataKinds.Phone.CONTENT_URI, numberProjection,
                ContactsContract.CommonDataKinds.Phone.CONTACT_ID + "= ?",
                new String[] { String.valueOf(contact.id) },
                null).loadInBackground();

        if (phone.moveToFirst()) {
            final int contactNumberColumnIndex = phone.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER);
            final int contactTypeColumnIndex = phone.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE);

            contact.phoneNumbers = new ArrayList<MLPhoneNumber>();

            while (!phone.isAfterLast()) {
                final String number = phone.getString(contactNumberColumnIndex);
                final int type = phone.getInt(contactTypeColumnIndex);
                String customLabel = "Custom";
                CharSequence phoneType =
                        ContactsContract.CommonDataKinds.Phone.getTypeLabel(
                                context_.getResources(), type, customLabel);
                MLPhoneNumber phoneNb = new MLPhoneNumber();

                String cleanedPhoneNb = cleanPhoneNumber(number);
                if(!number.startsWith("+") && !number.startsWith("00"))
                    cleanedPhoneNb = prefix_ + cleanedPhoneNb;

                phoneNb.number = cleanedPhoneNb;
                phoneNb.type = phoneType.toString();
                contact.phoneNumbers.add(phoneNb);
                phone.moveToNext();
            }

        }
        phone.close();
    }

    private void fetchContactEmails(MLContact contact) {
        // Get email
        final String[] emailProjection = new String[] { ContactsContract.CommonDataKinds.Email.DATA, ContactsContract.CommonDataKinds.Email.TYPE };

        Cursor email = new CursorLoader(context_, ContactsContract.CommonDataKinds.Email.CONTENT_URI, emailProjection,
                ContactsContract.CommonDataKinds.Email.CONTACT_ID + "= ?",
                new String[] { String.valueOf(contact.id) },
                null).loadInBackground();

        if (email.moveToFirst()) {
            final int contactEmailColumnIndex = email.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA);
            final int contactTypeColumnIndex = email.getColumnIndex(ContactsContract.CommonDataKinds.Email.TYPE);

            contact.emails = new ArrayList<MLEmail>();

            while (!email.isAfterLast()) {
                final String address = email.getString(contactEmailColumnIndex);
                final int type = email.getInt(contactTypeColumnIndex);
                String customLabel = "Custom";
                CharSequence emailType =
                        ContactsContract.CommonDataKinds.Email.getTypeLabel(
                                context_.getResources(), type, customLabel);
                MLEmail mlEmail = new MLEmail();
                mlEmail.address = address;
                mlEmail.type = emailType.toString();
                contact.emails.add(mlEmail);
                email.moveToNext();
            }

        }

        email.close();
    }
}

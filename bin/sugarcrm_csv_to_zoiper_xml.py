#!/usr/bin/env python3
#
# Copyright (C) 2019 Kevin Funk <kevin.funk@kdab.com>
#
# Converts a SugarCRM Contacts.csv file to a suitable Zoiper contact database format
# Supports both:
# - zoiper3's Contacts.xml contact database
# - zoiper5's XML format for the XML Contact Service

import argparse
import csv

from enum import IntEnum, auto
from xml.sax.saxutils import escape

class AutoNumber(IntEnum):
    def __new__(cls):
        value = len(cls.__members__)
        obj = int.__new__(cls, value)
        obj._value_ = value
        return obj

class Columns(AutoNumber):
    # Note: Could just auto-generate that based on the first line of the .csv but oh well...
    FirstName=()
    LastName=()
    ID=()
    Salutation=()
    Title=()
    Department=()
    AccountName=()
    EmailAddress=()
    NonPrimaryEmails=()
    Mobile=()
    OfficePhone=()
    Home=()
    OtherPhone=()
    Fax=()
    PrimaryAddressStreet=()
    PrimaryAddressCity=()
    PrimaryAddressState=()
    PrimaryAddressPostalCode=()
    PrimaryAddressCountry=()
    AlternateAddressStreet=()
    AlternateAddressCity=()
    AlternateAddressState=()
    AlternateAddressPostalCode=()
    AlternateAddressCountry=()
    Description=()
    Birthdate=()
    LeadSource=()
    CampaignID=()
    DoNotCall=()
    PortalName=()
    portal_active=()
    PortalApplication=()
    ReportstoID=()
    Assistant=()
    AssistantPhone=()
    Assignedto=()
    AssignedUser=()
    DateCreated=()
    DateModified=()
    ModifiedBy=()
    CreatedBy=()
    Deleted=()
    JoomlaAccountID=()
    AccountDisabled=()
    PortalUserType=()
    Photo=()
    MailChimpRating=()
    LawfulBasis=()
    LawfulBasisDateReviewed=()
    LawfulBasisSource=()
    Blacklist=()
    Longitude=()
    Latitude=()
    GeocodeStatus=()

def convert_sugarcrm_contacts_csv_to_zoiper_contacts_xml(contactsFile: str, zoiperFormat: str):
    data = []

    with open(contactsFile) as f:
        csv_f = csv.reader(f)
        for row in csv_f:
           data.append(row)

    if zoiperFormat == "zoiper3":
        def convert_row(row):
            return f"""\
<contact>
    <first_name>{row[Columns.FirstName]}</first_name>
    <last_name>{row[Columns.LastName]}</last_name>
    <work_phone>{row[Columns.OfficePhone]}</work_phone>
    <cell_phone>{row[Columns.Mobile]}</cell_phone>
</contact>"""

        contactsXml = '\n'.join([convert_row(row) for row in data[1:]])
        xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<contacts>
{contactsXml}
</contacts>"""

    elif zoiperFormat == "zoiper5":
        idCounter = 0

        def convert_row(row):
            nonlocal idCounter

            idCounter += 1

            displayName = f"{row[Columns.FirstName]} {row[Columns.LastName]}"
            accountName = row[Columns.AccountName]
            if accountName:
                displayName += f" ({accountName})"

            phonesXml = ""
            if row[Columns.OfficePhone]:
                phonesXml += f"""\
    <Phone>
        <Type>Work</Type>
        <Type>Phone</Type>
        <Phone>{escape(row[Columns.OfficePhone])}</Phone>
    </Phone>"""
            if row[Columns.Mobile]:
                phonesXml += f"""\
    <Phone>
        <Type>Work</Type>
        <Type>Cell</Type>
        <Phone>{escape(row[Columns.Mobile])}</Phone>
    </Phone>"""
            if row[Columns.Home]:
                phonesXml += f"""\
    <Phone>
        <Type>Home</Type>
        <Type>Phone</Type>
        <Phone>{escape(row[Columns.Home])}</Phone>
    </Phone>"""

            # see the following link for the XML format specification (download the PDF)
            #   https://www.zoiper.com/en/support/home/article/201/XML%20Contact%20Service%20in%20Zoiper%205%20PRO#linux
            return f"""\
<Contact id='{idCounter}'>
    <Name>
        <First>{escape(row[Columns.FirstName])}</First>
        <Last>{escape(row[Columns.LastName])}</Last>
        <Display>{escape(displayName)}</Display>
    </Name>
{phonesXml}
</Contact>"""

        contactsXml = '\n'.join([convert_row(row) for row in data[1:]])
        xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<Contacts>
{contactsXml}
</Contacts>"""
    else:
        raise NotImplementedError(f"Unknown format: {zoiperFormat}")

    print(xml)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Convert a SugarCRM Contacts.csv file to Zoiper\'s Contacts.xml format')
    parser.add_argument('contactsFile', metavar='FILE', type=str, nargs=1,
                        help='The path to the Contacts.csv as exported from the SugarCRM web interface')
    parser.add_argument('exportFormat', choices=['zoiper3', 'zoiper5'], help="""
                        'zoiper3' will generate a Contacts.xml file which can be placed into the Zoiper settings dir (for example ~/.Zoiper),
                        'zoiper5' will generate a Contacts.xml which can used as source for XML Contact Service in Zoiper5""")

    args = parser.parse_args()
    convert_sugarcrm_contacts_csv_to_zoiper_contacts_xml(args.contactsFile[0], args.exportFormat)

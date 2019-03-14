#!/usr/bin/env python3
#
# Copyright (C) 2019 Kevin Funk <kevin.funk@kdab.com
#
# Converts a SugarCRM Contacts.csv file to Zoiper's Contacts.xml format

import argparse
import csv

from enum import IntEnum, auto

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

def convert_sugarcrm_contacts_csv_to_zoiper_contacts_xml(contactsFile):
    data = []

    with open(contactsFile) as f:
        csv_f = csv.reader(f)
        for row in csv_f:
           data.append(row)

    def convert_row(row):
        return f"""<contact>
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

    print(xml)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Convert a SugarCRM Contacts.csv file to Zoiper\'s Contacts.xml format')
    parser.add_argument('contactsFile', metavar='FILE', type=str, nargs=1,
                        help='The path to the Contacts.csv as exported from the SugarCRM web interface')

    args = parser.parse_args()
    convert_sugarcrm_contacts_csv_to_zoiper_contacts_xml(args.contactsFile[0])

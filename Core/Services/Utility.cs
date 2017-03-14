using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using lssCore.Services;
using lssCore.Database;

namespace lssCore.Services
{
    public static class Utility
    {
        public static string getMessage() { return "hello world"; }

        public static string GetPersonName(long ? id)
        {
            string retVal = "";
            AddressBookRepository addressBookRepository = new AddressBookRepository();
            AddressBook addressBook = addressBookRepository.GetAddressBook(id);
            retVal = addressBook.Name;
            return retVal;
        }
        public static string GetUDCValue(long ? id) {
            string retVal = "";
            UDCRepository udcRepository = new UDCRepository();
            UDC udc = udcRepository.GetUdcById(id);
            if (udc != null)
            {
                retVal=udc.Value;
            }
            return retVal;
        }
    }
}
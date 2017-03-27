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
            if (addressBook != null)
            {
                retVal = addressBook.Name;
            }
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
        public static string GetContract(long? id)
        {
            string retVal = "";
            ContractRepository contractRepository = new ContractRepository();
            Contract contract = contractRepository.GetContractsById(id);
            if (contract != null)
            {
                retVal = String.Format( "{0: MM/dd/yyyy}", contract.StartDate) + " " + String.Format("{0: MM/dd/yyyy}", contract.EndDate);
            }
            return retVal;
        }
    }
}
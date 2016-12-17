﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebApi1.Models;
using System.Web.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Reflection;




namespace WebApi1.Services
{
    public class AddressBookRepository
    {
        void SetParameter(ref SqlCommand selectCommand,

string paramType, string paramValue, string paramName)
        {
            try
            {
                SqlParameter parameter = new

        SqlParameter();
                if (paramType == "Int32")
                {
                    parameter.DbType = DbType.Int32;
                    parameter.Value = paramValue;
                    parameter.ParameterName = paramName;
                }
                else if (paramType == "String")
                {
                    parameter.DbType = DbType.String;
                    parameter.Value = paramValue;
                    parameter.ParameterName = paramName;
                }
                else if (paramType == "DateTime")
                {
                    parameter.DbType = DbType.DateTime;
                    parameter.Value = Convert.ToDateTime

          (paramValue);
                    parameter.ParameterName = paramName;
                }

                selectCommand.Parameters.Add(parameter);
            }
            catch (Exception ex)
            {

            }
        }//SetParameter
        public void AddAdressBook(AddressBook addressBook)
        {
            using (var db = new EFAddressBookContext())
            {
                db.AddressBooks.Add(addressBook);
                db.SaveChanges();
            }
        }
        public void DeleteAddressBook(int paramId)
        {
            using (var db = new EFAddressBookContext())
            {
                var addressBookDelete = db.AddressBooks.Single(e => e.Id == paramId);

                db.AddressBooks.Remove(addressBookDelete);
                db.SaveChanges();
            }
        }
        public void UpdateAddressBook(AddressBook addressBookUpdate)
        {
            try
            {
                using (var db = new EFAddressBookContext())
                {
                    AddressBook original = new AddressBook { Id = addressBookUpdate.Id };   /// stub model, only has Id

                    var entry = db.Entry(original);
                    entry.State = System.Data.Entity.EntityState.Modified;
                    entry.CurrentValues.SetValues(addressBookUpdate);

                    //var inspectionFields = addressBookUpdate.GetType().GetProperties();

                    PropertyInfo propertyInfo = addressBookUpdate.GetType().GetProperty("item");

                    //PropertyInfo prop = typeof(Foo).GetProperty("Bar");
                    var vals = GetPropertyAttributes(propertyInfo);

                    //foreach (var field in inspectionFields)
                    //{
                      //  var value = field.GetValue(null);
                    
                    //}


                    db.SaveChanges();
                }
            }
            catch (Exception ex)
            {
            }
        }
        public static Dictionary<string, object> GetPropertyAttributes(PropertyInfo property)
        {
            Dictionary<string, object> attribs = new Dictionary<string, object>();
            // look for attributes that takes one constructor argument
            foreach (CustomAttributeData attribData in property.GetCustomAttributesData())
            {

                if (attribData.ConstructorArguments.Count == 1)
                {
                    string typeName = attribData.Constructor.DeclaringType.Name;
                    if (typeName.EndsWith("Attribute")) typeName = typeName.Substring(0, typeName.Length - 9);
                    attribs[typeName] = attribData.ConstructorArguments[0].Value;
                }

            }
            return attribs;
        }

        public void UpdateAddressBook(int paramId, string name)
        {
            using (var db = new EFAddressBookContext())
            {
                var addressBookUpdate = db.AddressBooks.Single(e => e.Id == paramId);
                addressBookUpdate.Name = name;
                db.SaveChanges();
            }
        }

        public List<AddressBook> GetAddressBook(int paramId)
        { 
            List<AddressBook> resultList = null;
            try
            {
                resultList = new List<AddressBook>();
                using (var db = new EFAddressBookContext())
                {
                    //var query = from b in db.AddressBooks
                    //            orderby b.Name
                    //            select b;

                    AddressBook item = db.AddressBooks.Single(e => e.Id == paramId);
                    //var item = db.AddressBooks.Find(paramId);

                    AddressBook addressBook = new AddressBook();

                    if (item != null)
                    {
                        addressBook.Id = item.Id;
                        addressBook.Name = item.Name;
                        addressBook.FirstName = item.FirstName;
                        addressBook.LastName = item.LastName;
                        addressBook.Company = item.Company;
                        addressBook.CellPhone = item.CellPhone;
                        addressBook.MailingCity = item.MailingCity;

                        addressBook.MailingState = item.MailingState;
                        addressBook.MailingAddress = item.MailingAddress;
                        addressBook.MailingZipcode = item.MailingZipcode;
                        addressBook.BillingCity = item.BillingCity;
                        addressBook.BillingState = item.BillingState;
                        addressBook.BillingZipcode = item.BillingZipcode;
                        addressBook.BillingAddress = item.BillingAddress;

                        resultList.Add(addressBook);
                    }
                }
            }
            catch (Exception ex)
            {

            }
            return (resultList);
        }
        
public List<AddressBook> GetAllAddressBooks()
{
    List<AddressBook> resultList = new List<AddressBook>();
    //string connectionString = WebConfigurationManager.ConnectionStrings["lssDBConnectionString"].ConnectionString;
    //SqlConnection conn = new SqlConnection(connectionString);
    //conn.Open();
    //string sql = "usp_addressbook";

    //SqlCommand command = new SqlCommand(sql, conn);
    //command.CommandType = CommandType.StoredProcedure;

    //SetParameter(ref command, "Int32", "2", "@Id");
    //SqlDataReader reader = command.ExecuteReader();

    //while (reader.Read() == true)
    /*{
        AddressBook addressBook = new AddressBook();


        addressBook.name = reader["Name"].ToString();
        addressBook.firstName = reader["FirstName"].ToString();
        addressBook.lastName = reader["LastName"].ToString();
        addressBook.company = reader["Company"].ToString();
        addressBook.cellPhone = reader["CellPhone"].ToString();
        addressBook.mailingCity = reader["mailingCity"].ToString();

        addressBook.mailingState = reader["mailingState"].ToString();
        addressBook.mailingAddress = reader["mailingAddress"].ToString();
        addressBook.mailingZipcode = reader["mailingZipCode"].ToString();
        addressBook.billingCity = reader["billingCity"].ToString();
        addressBook.billingState = reader["billingState"].ToString();
        addressBook.billingZipcode = reader["billingZipCode"].ToString();
        addressBook.billingAddress = reader["billingAddress"].ToString();

        resultList.Add(addressBook);
    }
    */
    using (var db = new EFAddressBookContext())
    {
        var query = from b in db.AddressBooks
                    orderby b.Name
                    select b;

        AddressBook addressBook = new AddressBook();

        foreach (var item in query)
        {

            addressBook.Name = item.Name;
            addressBook.FirstName = item.FirstName;
            addressBook.LastName = item.LastName;
            addressBook.Company = item.Company;
            addressBook.CellPhone = item.CellPhone;
            addressBook.MailingCity = item.MailingCity;

            addressBook.MailingState = item.MailingState;
            addressBook.MailingAddress = item.MailingAddress;
            addressBook.MailingZipcode = item.MailingZipcode;
            addressBook.BillingCity = item.BillingCity;
            addressBook.BillingState = item.BillingState;
            addressBook.BillingZipcode = item.BillingZipcode;
            addressBook.BillingAddress = item.BillingAddress;

            resultList.Add(addressBook);
        }


    }
    /*
   {
     new AddressBook {
        name="David Nishimoto",
        firstName ="David",
        lastName ="Nishimoto",
        company ="Listen Software Solutions",
        cellPhone="Phone",
        mailingCity ="Caldwell",

        mailingState ="Idaho",
        mailingAddress="20094 Winslow Dr",
        mailingZipcode= "83607",
        billingCity ="Caldwell",
        billingState= "Idaho",
        billingZipcode ="83607"

        }

   };
   */



    return (resultList);
}
    }
}
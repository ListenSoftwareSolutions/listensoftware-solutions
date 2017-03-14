using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using lssCore.Database;
using System.Web.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Reflection;
using Newtonsoft.Json;

namespace lssCore.Services
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
        public void AddAddressBook(AddressBook addressBook)
        {
            using (var db = new DatabaseContext())
            {
                db.AddressBooks.Add(addressBook);
                db.SaveChanges();
            }
        }
        public string GetCustomerName(int addressId)
        {
            string retVal = "";

            try
            {
                using (var db = new DatabaseContext())
                {
                    var query = (from b in db.AddressBooks
                                 where (b.AddressId == addressId)
                                 select b).FirstOrDefault();

                    retVal = query.Name;


                }
            }
            catch (Exception ex)
            {

            }
            return retVal;
        }
        public void DeleteAddressBook(int paramAddressId)
        {
            using (var db = new DatabaseContext())
            {
                var addressBookDelete = db.AddressBooks.Single(e => e.AddressId == paramAddressId);

                db.AddressBooks.Remove(addressBookDelete);
                db.SaveChanges();
            }
        }

        public void UpdateAddressBook(AddressBook addressBookUpdate)
        {
            try
            {
                using (var db = new DatabaseContext())
                {

                    AddressBook original = new AddressBook { AddressId = addressBookUpdate.AddressId };   /// stub model, only has Id

                    var entry = db.Entry(original);
                    entry.State = System.Data.Entity.EntityState.Modified;
                    entry.CurrentValues.SetValues(addressBookUpdate);

                    db.SaveChanges();
                }
            }
            catch (Exception ex)
            {
            }
        }
        public IEnumerable<PropertyInfo> GetProperties()
        {
            Type t = this.GetType();

            return t.GetProperties()
                .Where(p => (p.Name != "EntityKey" && p.Name != "EntityState"))
                .Select(p => p).ToList();
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

        public void UpdateAddressBook(int paramAddressId, string name)
        {
            using (var db = new DatabaseContext())
            {
                var addressBookUpdate = db.AddressBooks.Single(e => e.AddressId == paramAddressId);
                addressBookUpdate.Name = name;
                db.SaveChanges();
            }
        }

        public List<AddressBook> GetAddressBook(int paramAddressId)
        {
            List<AddressBook> resultList = null;
            try
            {
                resultList = new List<AddressBook>();
                using (var db = new DatabaseContext())
                {
                    //var query = from b in db.AddressBooks
                    //            orderby b.Name
                    //            select b;

                    AddressBook item = db.AddressBooks.Single(e => e.AddressId == paramAddressId);

                    resultList.Add(item);
                  
                }
            }
            catch (Exception ex)
            {

            }
            return (resultList);
        }

        public List<AddressBook> GetAllAddressBooks(string searchString)
        {
            List<AddressBook> resultList = new List<AddressBook>();
        
            using (var db = new DatabaseContext())
            {
                var query = from b in db.AddressBooks select b;
       
                if (!String.IsNullOrEmpty(searchString))
                {
                    query = query.Where(s => s.Name.Contains(searchString) || s.FirstName.Contains(searchString) || s.LastName.Contains(searchString));

                }
              
                query=query.OrderBy(s => s.Name);


                foreach (var item in query)
                {
                   resultList.Add(item);
                }


            }
            return (resultList);
        }
    }
}
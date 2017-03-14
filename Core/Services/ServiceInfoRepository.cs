using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using lssCore.Database;
using System.Data.Entity;

namespace lssCore.Services
{
    public class ServiceInformationRepository
    {
        public bool DeleteServiceInformation(int paramId)
        {
            bool retVal = false;
            try
            {
                using (var db = new DatabaseContext())
                {
                    var serviceInformationDelete = db.ServiceInformations.Single(e => e.ServiceId == paramId);

                    db.ServiceInformations.Remove(serviceInformationDelete);
                    db.SaveChanges();
                    retVal = true;
                }
            }

            catch (Exception ex)
            {
                retVal = false;
            }
            return retVal;
        }
        public void AddServiceInformation(ServiceInformation serviceInformation)
        {
            try
            {
                using (var db = new DatabaseContext())
                {
                    db.ServiceInformations.Add(serviceInformation);
                    db.SaveChanges();
                }
            }

            catch (Exception ex)
            {
            }
        }
        public void UpdateServiceInformation(ServiceInformation serviceInformationUpdate)
        {
            try
            {
                using (var db = new DatabaseContext())
                {
                    var serviceInformationOriginal = db.ServiceInformations.Find(serviceInformationUpdate.ServiceId);

                    var entry = db.Entry(serviceInformationOriginal);
                    entry.State = System.Data.Entity.EntityState.Modified;
                    entry.CurrentValues.SetValues(serviceInformationUpdate);
                    db.SaveChanges();

                }
            }
            catch (Exception ex)
            {
            }
        }
       
        public IList<ServiceInformation> GetServiceInformation(int paramServiceId)
        {
            IList<ServiceInformation> resultList=null;
            //List<ServiceInformation> resultList = null;
            try
            {
                resultList = new List<ServiceInformation>();
                using (var db = new DatabaseContext())
                {
          
                    ServiceInformation item = db.ServiceInformations.Include(s1 => s1.ScheduleEvents).Single(e => e.ServiceId == paramServiceId);
                    ServiceInformation serviceInformation= new ServiceInformation();

                    if (item != null)
                    {
                             
                        resultList.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {

            }
            return (resultList);
        }
     
       
        public List<AddressBook> GetAddressBook(string type)
        {
            List<AddressBook> resultList = null;
            try
            {
                resultList = new List<AddressBook>();
                using (var db = new DatabaseContext())
                {
                    var query = from b in db.AddressBooks
                                where(b.Type==type)
                                select b;

                    foreach (var item in query)
                    {
                        resultList.Add(item);
                    }


                }
            }
            catch (Exception ex)
            {

            }
            return (resultList);

        }
        public List<ServiceInformation> GetServiceInformationByAddressId(int addressId)
        {
            List<ServiceInformation> resultList = null;
            try
            {
                resultList = new List<ServiceInformation>();
                using (var db = new DatabaseContext())
                {
                    var query = from b in db.ServiceInformations
                                where (b.Status == null && b.AddressId==addressId)
                                select b;

                    foreach (var item in query)
                    {
                        resultList.Add(item);
                    }


                }
            }
            catch (Exception ex)
            {

            }
            return (resultList);
        }
        public List<ServiceInformation> GetAllServiceInformation()
        {
            List<ServiceInformation> resultList = null;
            try
            {
                resultList = new List<ServiceInformation>();
                using (var db = new DatabaseContext())
                {
                    var query =from b in db.ServiceInformations
                        where (b.Status == null)
                        select b;

                    foreach (var item in query)
                    {
                        resultList.Add(item);
                    }
                        
                    
                }
            }
            catch (Exception ex)
            {

            }
            return (resultList);
        }
    }
}
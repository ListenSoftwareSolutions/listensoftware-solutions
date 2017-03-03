﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using lssCore.Models;

namespace lssCore.Services
{
    public class ServiceInformationRepository
    {
        public bool DeleteServiceInformation(int paramId)
        {
            bool retVal = false;
            try
            {
                using (var db = new databaseContext())
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
                using (var db = new databaseContext())
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
                using (var db = new databaseContext())
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
       
        public List<ServiceInformation> GetServiceInformation(int paramServiceId)
        {
            List<ServiceInformation> resultList = null;
            try
            {
                resultList = new List<ServiceInformation>();
                using (var db = new databaseContext())
                {
                    ServiceInformation item = db.ServiceInformations.Single(e => e.ServiceId == paramServiceId);
                    ServiceInformation serviceInformation= new ServiceInformation();

                    if (item != null)
                    {
                        var entry = db.Entry(item);
                        entry.CurrentValues.SetValues(serviceInformation);
                        
                        resultList.Add(serviceInformation);
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
                using (var db = new databaseContext())
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
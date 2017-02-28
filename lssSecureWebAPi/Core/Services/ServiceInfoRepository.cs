using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using lssCore.Models;

namespace lssCore.Services
{
    public class ServiceInformationRepository
    {
        public void DeleteServiceInformation(int paramId)
        {
            try
            {
                using (var db = new databaseContext())
                {
                    var serviceInformationDelete = db.ServiceInformations.Single(e => e.ServiceId == paramId);

                    db.ServiceInformations.Remove(serviceInformationDelete);
                    db.SaveChanges();
                }
            }

            catch (Exception ex)
            {
            }
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
    }
}
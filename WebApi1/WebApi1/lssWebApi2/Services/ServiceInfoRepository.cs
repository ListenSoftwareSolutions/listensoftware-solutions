using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebApi1.Models;

namespace WebApi1.Services
{
    public class ServiceInformationRepository
    {
        public List<ServiceInformation> GetServiceInformation(int paramServiceId)
        {
            List<ServiceInformation> resultList = null;
            try
            {
                resultList = new List<ServiceInformation>();
                using (var db = new listensoftwareDBContext())
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
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using lssWebApi2.Models;
using WebApi1.Services;

namespace WebApi1.Controllers
{
    public class ServiceInformationController : ApiController
    {
        private ServiceInformationRepository serviceInformationRepository;
        public ServiceInformationController()
        {
            this.serviceInformationRepository = new ServiceInformationRepository();
        }
        public List<ServiceInformation> Get(int Id)
        {
            return serviceInformationRepository.GetServiceInformation(Id);
        }
        [HttpPut]
        public void PutServiceinformation(ServiceInformation serviceInformation)
        {
            serviceInformationRepository.UpdateServiceInformation(serviceInformation);
        }
        [HttpPost]
        public void PostServiceinformation(ServiceInformation serviceInformation)
        {
            serviceInformationRepository.AddServiceInformation(serviceInformation);
        }


    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using lssCore.Models;
using lssCore.Services;

namespace lssSecureWeb.Controllers
{
    [RoutePrefix("serviceInformation")]
    public class ServiceInformationController : Controller
    {
        private ServiceInformationRepository serviceInformationRepository;
        // GET: ServiceInformationMVC

        public ServiceInformationController()
        {
            this.serviceInformationRepository = new ServiceInformationRepository();
        }
        public ActionResult Index()
        {
            List<ServiceInformation> serviceList = serviceInformationRepository.GetAllServiceInformation();
            return View("Index", serviceList);
         
        }

        // GET: ServiceInformationMVC/Details/5
        public ActionResult Details(int id)
        {
            List<ServiceInformation> serviceList = serviceInformationRepository.GetServiceInformation(id);
            return View("Details", serviceList[0]);

        }

        // GET: ServiceInformationMVC/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: ServiceInformationMVC/Create
        [HttpPost]
        public ActionResult Create(ServiceInformation serviceInformation)
        {
            try
            {
                // TODO: Add insert logic here
                serviceInformationRepository.AddServiceInformation(serviceInformation);
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: ServiceInformationMVC/Edit/5
        public ActionResult Edit(int id)
        {
            List<ServiceInformation> serviceList = serviceInformationRepository.GetServiceInformation(id);
            return View("Edit", serviceList[0]);
        }

        // POST: ServiceInformationMVC/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, ServiceInformation serviceInformation)
        {
            try
            {
                // TODO: Add update logic here

                serviceInformationRepository.UpdateServiceInformation(serviceInformation);

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: ServiceInformationMVC/Delete/5
        public ActionResult Delete(int id)
        {
            List<ServiceInformation> serviceList = serviceInformationRepository.GetServiceInformation(id);
            return View("Delete", serviceList[0]);
        }

        // POST: ServiceInformationMVC/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here
                bool status=serviceInformationRepository.DeleteServiceInformation(id);

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}

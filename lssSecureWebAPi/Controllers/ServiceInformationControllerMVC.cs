using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using lssCore.Database;
using lssCore.Services;

namespace lssSecureWeb.Controllers
{
    [RoutePrefix("ServiceInformation")]
    public class ServiceInformationController : Controller
    {
        private ServiceInformationRepository serviceInformationRepository;
        private static int _addressId;
        // GET: ServiceInformationMVC

        public ServiceInformationController()
        {
            this.serviceInformationRepository = new ServiceInformationRepository();
        }
        public ActionResult Index()
        {
            List<ServiceInformation> serviceList = serviceInformationRepository.GetAllServiceInformation();
            ViewBag.AddressId = _addressId;
            return View("Index", serviceList);
        }
        public ActionResult ServiceList(int addressId)
        {
        
            _addressId = addressId;
            ViewBag.AddressId = _addressId;
            List<ServiceInformation> serviceList = serviceInformationRepository.GetServiceInformationByAddressId(_addressId);
            return View("Index", serviceList);
         
        }

        // GET: ServiceInformationMVC/Details/5
        public ActionResult Details(int id)
        {
            IList<ServiceInformation> serviceList = serviceInformationRepository.GetServiceInformation(id);
            return View("Details", serviceList[0]);

        }

        // GET: ServiceInformationMVC/Create
        public ActionResult Create()
        {
            ViewBag.AddressId = _addressId;
            LoadCustomerName();
            LoadServiceTypeDropDown();
            LoadContractDropDown();
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
        void LoadCustomerName()
        {
            AddressBookRepository addressBookRepository = new AddressBookRepository();
            ViewBag.CustomerName = addressBookRepository.GetCustomerName(_addressId);
        }
        void LoadCustomerDropDown()
        {
            var customer = serviceInformationRepository.GetAddressBook("customer");

            ViewBag.Customers = customer.ToList().Select(c => new SelectListItem
            {
                Text = c.Name,
                Value = c.AddressId.ToString()
            }).ToList();
        }
        void LoadServiceTypeDropDown()
        {
            UDCRepository udcRepository = new UDCRepository();
            List<UDC> udc_list = udcRepository.GetUdcList("SERVICE_Type").ToList<UDC>();
            ViewBag.Type = udc_list.ToList().Select(c => new SelectListItem
            {
                Text = c.Value,
                Value = c.XRefId.ToString()
            }).ToList();
        }
        void LoadContractDropDown()
        {
            ContractRepository contractRepository = new ContractRepository();
            var contracts = contractRepository.GetContractsByAddressId(_addressId);
            ViewBag.Contracts = contracts.ToList().Select(c => new SelectListItem
            {
                Text = c.StartDate.ToString(),
                Value = c.ContractId.ToString()
            }).ToList();
        }
        // GET: ServiceInformationMVC/Edit/5
        public ActionResult Edit(int id)
        {
            ViewBag.AddressId = _addressId;
            IList<ServiceInformation> serviceList = serviceInformationRepository.GetServiceInformation(id);
            LoadCustomerDropDown();
            LoadContractDropDown();
            LoadServiceTypeDropDown();
              
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
            IList<ServiceInformation> serviceList = serviceInformationRepository.GetServiceInformation(id);
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

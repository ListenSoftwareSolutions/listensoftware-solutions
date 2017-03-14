using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using lssCore.Database;
using lssCore.Services;

namespace lssSecureWeb.Controllers
{
    [RoutePrefix("Contract")]
    public class ContractController : Controller
    {
        private static int _addressId;
        private ContractRepository contractRepository;
        public ContractController()
        {
            contractRepository = new ContractRepository();
        }
        // GET: Contract
        public ActionResult Index()
        {
            ViewBag.AddressId = _addressId;
            List<Contract> contractList = contractRepository.GetContractsByAddressId(_addressId);

            return View(contractList);
        }
        public ActionResult ContractList(int addressId)
        {
            _addressId = addressId;
            ViewBag.AddressId = _addressId;
            List<Contract> contractList = contractRepository.GetContractsByAddressId(_addressId);
            return View("Index", contractList);

        }

        // GET: Contract/Details/5
        public ActionResult Details(int id)
        {
            ViewBag.AddressId = _addressId;
            Contract contract = contractRepository.GetContractsById(id);
            return View(contract);
        }

        // GET: Contract/Create
        public ActionResult Create()
        {
            AddressBookRepository addressBookRepository = new AddressBookRepository();

            UDCRepository udcRepository = new UDCRepository();
          
            List<UDC> udc_list = udcRepository.GetUdcList("SERVICE_Type").ToList<UDC>();
            ViewBag.Type = udc_list.ToList().Select(c => new SelectListItem
            {
                Text = c.Value,
                Value = c.XRefId.ToString()
            }).ToList();
          

            ViewBag.AddressId = _addressId;
            ViewBag.CustomerName = addressBookRepository.GetCustomerName(_addressId);
            return View();
        }

        // POST: Contract/Create
        [HttpPost]
        public ActionResult Create(Contract contract)
        {
            try
            {
                // TODO: Add insert logic here
                contractRepository.AddContract(contract);
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Contract/Edit/5
        public ActionResult Edit(int id)
        {
            AddressBookRepository addressBookRepository = new AddressBookRepository();
            UDCRepository udcRepository = new UDCRepository();

            List<UDC> udc_list = udcRepository.GetUdcList("SERVICE_Type").ToList<UDC>();
            ViewBag.Type = udc_list.ToList().Select(c => new SelectListItem
            {
                Text = c.Value,
                Value = c.XRefId.ToString()
            }).ToList();
            
            ViewBag.AddressId = _addressId;
            ViewBag.CustomerName = addressBookRepository.GetCustomerName(_addressId);
            Contract contract = contractRepository.GetContractsById(id);
            return View(contract);
        }

        // POST: Contract/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, Contract contract)
        {
            try
            {
                // TODO: Add update logic here
                contractRepository.UpdateContract(contract);
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Contract/Delete/5
        public ActionResult Delete(int id)
        {
           
            ViewBag.AddressId = _addressId;
      
          
            Contract contract = contractRepository.GetContractsById(id);

            return View(contract);
        }

        // POST: Contract/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            bool status = false;
            try
            {
                ViewBag.AddressId = _addressId;
                // TODO: Add delete logic here
                status = contractRepository.DeleteContract(id);

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}

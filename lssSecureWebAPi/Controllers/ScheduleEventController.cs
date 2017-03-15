using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using lssCore.Database;
using lssCore.Services;

namespace lssSecureWeb.Controllers
{

    [RoutePrefix("ScheduleEvent")]
    public class ScheduleEventController : Controller
    {
        private static long _serviceId;
        private static long _addressId;
        private ScheduleEventRepository scheduleEventRepository = null;

        public ScheduleEventController()
        {
            scheduleEventRepository = new ScheduleEventRepository();
        }
        // GET: ScheduleEvent
        public ActionResult Index(long serviceId,long addressId)
        {
            _serviceId = serviceId;
            _addressId = addressId;
            IList<ScheduleEvent> scheduleEventList = scheduleEventRepository.GetAllScheduleEvents(_serviceId);
            ViewBag.ServiceId = _serviceId;
           
            return View(scheduleEventList);
        }

        // GET: ScheduleEvent/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }
        private void LoadEmployeeList()
        {
            AddressBookRepository addressBookRepository = new AddressBookRepository();
            
            List<AddressBook> employee_list = addressBookRepository.GetPersonList("employee").ToList<AddressBook>();
            ViewBag.Employees = employee_list.ToList().Select(c => new SelectListItem
            {
                Text = c.Name,
                Value = c.AddressId.ToString()
            }).ToList();
        }
    // GET: ScheduleEvent/Create
    public ActionResult Create()
        {
          
            ViewBag.ServiceId = _serviceId;
            ViewBag.AddressId = _addressId;
            LoadEmployeeList();
            return View();
        }

        // POST: ScheduleEvent/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: ScheduleEvent/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: ScheduleEvent/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: ScheduleEvent/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: ScheduleEvent/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using lssCore.Services;
using lssCore.Database;
using PagedList;

namespace lssSecureWeb.Controllers
{
     
    [RoutePrefix("people")]
    public class PeopleController : Controller
    {
        private AddressBookRepository addressBookRepository;

        public PeopleController()
        {
            this.addressBookRepository = new AddressBookRepository();
        }
        // GET: People
       [Authorize]
        //public ActionResult Index()
        //{
     
        //}
        public ViewResult Index(string currentFilter, string searchString, int? page)
        {

            if (searchString != null)
            {
                page = 1;
            }
            else
            {
                searchString = currentFilter;
            }
            ViewBag.CurrentFilter = searchString;

            List<AddressBook> listPeople = addressBookRepository.GetAllAddressBooks(searchString);

          
            //return View("index", listPeople);

            int pageSize = 3;
            int pageNumber = (page ?? 1);

            return View("index",listPeople.ToPagedList(pageNumber, pageSize));
        }
        public ActionResult AddressBook()
        {
            return View();
        }

        // GET: People/Details/5
        public ActionResult Details(int id)
        {
            AddressBook person;
            List<AddressBook> listPeople = addressBookRepository.GetAddressBook(id);

            person = listPeople[0];
            return View(person);
        }

        // GET: People/Create
        public ActionResult Create()
        {
            UDCRepository udcRepository = new UDCRepository();
            List<UDC> udc_list = udcRepository.GetUdcList("AB_Type").ToList<UDC>();
            ViewBag.Type = udc_list.ToList().Select(c => new SelectListItem
            {
                Text = c.KeyCode,
                Value = c.Value
            }).ToList();
            ;
            return View();
        }

        // POST: People/Create
        [HttpPost]
        public ActionResult Create(AddressBook addressBook)
        {
            try
            {
                // TODO: Add insert logic here

                addressBookRepository.AddAddressBook(addressBook);

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
        //[HttpPost]
        //public ActionResult Edit()
        //{
        //    try
        //    {
        //        // TODO: Add update logic here

        //        return RedirectToAction("addressBook");
        //    }
        //    catch
        //    {
        //        return View();
        //    }
        //}

       
        // GET: People/Edit/5
        public ActionResult Edit(int id)
        {
            AddressBook person;
            List<AddressBook> listPeople= addressBookRepository.GetAddressBook(id);
            UDCRepository udcRepository = new UDCRepository();
            person = listPeople[0];

            List<UDC> udc_list = udcRepository.GetUdcList("AB_Type").ToList<UDC>();
            ViewBag.Type = udc_list.ToList().Select(c => new SelectListItem
            {
                 Text=c.Value,
                 Value=c.XRefId.ToString()
            }).ToList();
           
            return View("Edit",person);
        }

        

       
        public ActionResult Update(AddressBook addressBook)
        {

            addressBookRepository.UpdateAddressBook(addressBook);


            return RedirectToAction("index");
        }

        // POST: People/Edit/5
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
        
        // GET: People/Delete/5
        public ActionResult Delete(int id)
        {
            AddressBook person;
            List<AddressBook> listPeople = addressBookRepository.GetAddressBook(id);

            person = listPeople[0];
            return View(person);
        }

        // POST: People/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                addressBookRepository.DeleteAddressBook(id);

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}

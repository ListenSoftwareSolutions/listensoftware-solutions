﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using lssCore.Services;
using lssSecureWebApi2.Models;
using lssCore.Database;

namespace lssSecureWebApi2.Controllers
{
    [RoutePrefix("Api/People")]
    public class PeopleController : Controller
    {
        private AddressBookRepository addressBookRepository;

        public PeopleController()
        {
            this.addressBookRepository = new AddressBookRepository();
        }
        // GET: People
        
        public ActionResult Index()
        {
            List<AddressBook> listPeople = addressBookRepository.GetAllAddressBooks("","customer");

            return View(listPeople);
        }
        public ActionResult AddressBook()
        {
            return View();
        }

        // GET: People/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: People/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: People/Create
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
        [HttpPost]
        public ActionResult Edit()
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("addressBook");
            }
            catch
            {
                return View();
            }
        }

        // GET: People/Edit/5
        public ActionResult Edit(int id)
        {
        
            AddressBook person= addressBookRepository.GetAddressBook(id);
      

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
            return View();
        }

        // POST: People/Delete/5
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

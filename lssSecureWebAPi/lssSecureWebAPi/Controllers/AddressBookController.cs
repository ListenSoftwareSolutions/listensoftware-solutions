﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using lssCore.Services;
using lssCore.Models;



namespace lssSecureWeb.Controllers
{

        public class AddressBookController : ApiController
    {
        private AddressBookRepository addressBookRepository;
        public AddressBookController()
        {
            this.addressBookRepository = new AddressBookRepository();
        }
        public List<AddressBook>  Get()
        {
            return addressBookRepository.GetAllAddressBooks("");
        }
        public List<AddressBook> Get(int Id)
        {
            return addressBookRepository.GetAddressBook(Id);
        }

        [HttpPost]
        public IHttpActionResult Add(AddressBook addressBook)
        {
            addressBookRepository.AddAddressBook(addressBook);
            return Ok();
        }
       
        [HttpPut]
        public void PutAddressBook(AddressBook addressBook)
        //public void PutAddressBook(string addressBookJson)

        {
            // addressBookRepository.UpdateAddressBook(addressBookJson);
            addressBookRepository.UpdateAddressBook(addressBook);
        } 
        [HttpDelete]
        public void DeleteAddressBook(int Id)
        {

            addressBookRepository.DeleteAddressBook(Id);
        }

        [HttpPut]
        public IHttpActionResult UpdateName(int Id, string Name)
        {
            addressBookRepository.UpdateAddressBook(Id, Name);
            return Ok();
        }
      
    }

}

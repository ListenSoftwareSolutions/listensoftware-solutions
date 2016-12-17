namespace WebApi1.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("AddressBook")]
    public partial class AddressBook 
    {
        [Key]
        [Column(Order = 0)]
        public long Id { get; set; }

       
        [StringLength(255)]
        public string Name { get; set; }

       
        [StringLength(50)]
        public string FirstName { get; set; }

       
        [StringLength(50)]
        public string LastName { get; set; }

        [StringLength(255)]
        public string Company { get; set; }

        [StringLength(10)]
        public string CellPhone { get; set; }

        [StringLength(50)]
        public string MailingCity { get; set; }

        [StringLength(50)]
        public string MailingState { get; set; }

        [StringLength(255)]
        public string MailingAddress { get; set; }

        [StringLength(50)]
        public string MailingZipcode { get; set; }

        [StringLength(50)]
        public string BillingCity { get; set; }

        [StringLength(50)]
        public string BillingState { get; set; }

        [StringLength(50)]
        public string BillingZipcode { get; set; }

        [StringLength(255)]
        public string BillingAddress { get; set; }

        [StringLength(10)]
        public string Type { get; set; }

        public void CopyFromData(AddressBook addressBookSource)
        {
            this.Id = addressBookSource.Id;
            this.Name = addressBookSource.Name;
            this.FirstName = addressBookSource.FirstName;
            this.LastName = addressBookSource.LastName;
            this.Company = addressBookSource.Company;
            this.CellPhone = addressBookSource.CellPhone;
            this.MailingCity = addressBookSource.MailingCity;
            this.MailingState = addressBookSource.MailingState;
            this.MailingAddress = addressBookSource.MailingAddress;
            this.MailingZipcode = addressBookSource.MailingZipcode;
            this.BillingCity = addressBookSource.BillingCity;
            this.BillingState = addressBookSource.BillingState;
            this.BillingZipcode = addressBookSource.BillingZipcode;
            this.BillingAddress = addressBookSource.BillingAddress;
            this.Type = addressBookSource.Type;

    }
    }
   
}

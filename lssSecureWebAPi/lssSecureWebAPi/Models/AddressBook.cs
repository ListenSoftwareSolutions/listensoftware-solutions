namespace lssWebApi2.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("AddressBook")]
    public partial class AddressBook
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public AddressBook()
        {
            ScheduleEvents = new HashSet<ScheduleEvent>();
            ServiceInformations = new HashSet<ServiceInformation>();
        }

        [Key]
        public long AddressId { get; set; }

        [StringLength(255)]
        public string Name { get; set; }

        [StringLength(50)]
        public string FirstName { get; set; }

        [StringLength(50)]
        public string LastName { get; set; }

        [StringLength(255)]
        public string Company { get; set; }

        [StringLength(20)]
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

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ScheduleEvent> ScheduleEvents { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ServiceInformation> ServiceInformations { get; set; }
    }
}

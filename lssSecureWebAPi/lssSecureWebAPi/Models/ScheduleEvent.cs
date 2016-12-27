namespace lssWebApi2.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("ScheduleEvent")]
    public partial class ScheduleEvent
    {
        public long Id { get; set; }

        public long? EmployeeAddressId { get; set; }

        public DateTime? EventDateTime { get; set; }

        public long? ServiceId { get; set; }

        public long? DurationMinutes { get; set; }

        public long? CustomerAddressId { get; set; }

        [StringLength(2000)]
        public string Comments { get; set; }

        public virtual AddressBook AddressBook { get; set; }

        public virtual AddressBook AddressBook1 { get; set; }

        public virtual ServiceInformation ServiceInformation { get; set; }
    }
}

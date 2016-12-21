namespace lssWebApi2.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("ServiceInformation")]
    public partial class ServiceInformation
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ServiceInformation()
        {
            ScheduleEvents = new HashSet<ScheduleEvent>();
        }

        [Key]
        public long ServiceId { get; set; }

        [StringLength(255)]
        public string ServiceDescription { get; set; }

        [Column(TypeName = "money")]
        public decimal? Price { get; set; }

        public long? AddOnsXRefId { get; set; }

        public long? ServiceTypeXRefId { get; set; }

        public int? MinEmployeeCount { get; set; }

        public int? MaxEmployeeCount { get; set; }

        public DateTime? StartDate { get; set; }

        public long? AddressId { get; set; }

        public long? ContractId { get; set; }

        public int? SquareFeetOfStructure { get; set; }

        [StringLength(255)]
        public string LocationDescription { get; set; }

        [StringLength(255)]
        public string LocationGPS { get; set; }

        [StringLength(20)]
        public string ProcessStage { get; set; }

        public virtual AddressBook AddressBook { get; set; }

        public virtual Contract Contract { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ScheduleEvent> ScheduleEvents { get; set; }

        public virtual UDC UDC { get; set; }
    }
}

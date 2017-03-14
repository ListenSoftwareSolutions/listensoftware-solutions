//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace lssCore.Database
{
    using System;
    using System.Collections.Generic;
    
    public partial class ServiceInformation
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ServiceInformation()
        {
            this.ScheduleEvents = new HashSet<ScheduleEvent>();
        }
    
        public long ServiceId { get; set; }
        public string ServiceDescription { get; set; }
        public Nullable<decimal> Price { get; set; }
        public string AddOns { get; set; }
        public Nullable<long> ServiceTypeXRefId { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<long> AddressId { get; set; }
        public Nullable<long> ContractId { get; set; }
        public Nullable<int> SquareFeetOfStructure { get; set; }
        public string LocationDescription { get; set; }
        public string LocationGPS { get; set; }
        public string Comments { get; set; }
        public Nullable<int> Status { get; set; }
    
        public virtual AddressBook AddressBook { get; set; }
        public virtual Contract Contract { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ScheduleEvent> ScheduleEvents { get; set; }
        public virtual UDC UDC { get; set; }
    }
}

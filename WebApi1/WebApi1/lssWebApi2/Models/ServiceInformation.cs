//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebApi1.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class ServiceInformation
    {
        public long ServiceId { get; set; }
        public string ServiceDescription { get; set; }
        public Nullable<decimal> Price { get; set; }
        public Nullable<long> AddOnsXRefId { get; set; }
        public Nullable<long> ServiceTypeXRefId { get; set; }
        public Nullable<int> MinEmployeeCount { get; set; }
        public Nullable<int> MaxEmployeeCount { get; set; }
        public Nullable<System.DateTime> StartDate { get; set; }
        public Nullable<long> CustomerAddressId { get; set; }
        public Nullable<long> ContractId { get; set; }
        public Nullable<int> SquareFeetOfStructure { get; set; }
        public string LocationDescription { get; set; }
        public string LocationGPS { get; set; }
        public string ProcessStage { get; set; }
    }
}
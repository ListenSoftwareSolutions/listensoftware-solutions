﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class EntitiesContext : DbContext
    {
        public EntitiesContext()
            : base("name=Entities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<AcctRec> AcctRecs { get; set; }
        public virtual DbSet<AddressBook> AddressBooks { get; set; }
        public virtual DbSet<ChartOfAcct> ChartOfAccts { get; set; }
        public virtual DbSet<Contract> Contracts { get; set; }
        public virtual DbSet<GeneralLedger> GeneralLedgers { get; set; }
        public virtual DbSet<ScheduleEvent> ScheduleEvents { get; set; }
        public virtual DbSet<ServiceInformation> ServiceInformations { get; set; }
        public virtual DbSet<UDC> UDCs { get; set; }
    }
}

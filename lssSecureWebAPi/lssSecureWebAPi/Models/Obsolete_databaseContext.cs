namespace lssSecureWeb.Models
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;
    using lssCore.Models;

    public partial class databaseContextArchive: DbContext
    {
        public databaseContextArchive()
            : base("name=databaseContext")
        {
        }

        public virtual DbSet<AddressBook> AddressBooks { get; set; }
        public virtual DbSet<Contract> Contracts { get; set; }
        public virtual DbSet<ScheduleEvent> ScheduleEvents { get; set; }
        public virtual DbSet<ServiceInformation> ServiceInformations { get; set; }
        public virtual DbSet<UDC> UDCs { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AddressBook>()
                .Property(e => e.Name)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.FirstName)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.LastName)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.Company)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.CellPhone)
                .IsFixedLength();

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.MailingCity)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.MailingState)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.MailingAddress)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.MailingZipcode)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.BillingCity)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.BillingState)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.BillingZipcode)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.BillingAddress)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .Property(e => e.Type)
                .IsUnicode(false);

            modelBuilder.Entity<AddressBook>()
                .HasMany(e => e.ScheduleEvents)
                .WithOptional(e => e.AddressBook)
                .HasForeignKey(e => e.CustomerAddressId);

            modelBuilder.Entity<Contract>()
                .Property(e => e.Cost)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Contract>()
                .Property(e => e.RemainingBalance)
                .HasPrecision(19, 4);

            modelBuilder.Entity<ScheduleEvent>()
                .Property(e => e.Comments)
                .IsUnicode(false);

            modelBuilder.Entity<ServiceInformation>()
                .Property(e => e.ServiceDescription)
                .IsUnicode(false);

            modelBuilder.Entity<ServiceInformation>()
                .Property(e => e.Price)
                .HasPrecision(19, 4);

            modelBuilder.Entity<ServiceInformation>()
                .Property(e => e.LocationDescription)
                .IsUnicode(false);

            modelBuilder.Entity<ServiceInformation>()
                .Property(e => e.LocationGPS)
                .IsUnicode(false);

            modelBuilder.Entity<ServiceInformation>()
                .Property(e => e.Comments)
                .IsUnicode(false);

            modelBuilder.Entity<UDC>()
                .Property(e => e.ProductCode)
                .IsUnicode(false);

            modelBuilder.Entity<UDC>()
                .Property(e => e.KeyCode)
                .IsUnicode(false);

            modelBuilder.Entity<UDC>()
                .Property(e => e.Value)
                .IsUnicode(false);

            modelBuilder.Entity<UDC>()
                .HasMany(e => e.ServiceInformations)
                .WithOptional(e => e.UDC)
                .HasForeignKey(e => e.ServiceTypeXRefId);
        }
    }
}

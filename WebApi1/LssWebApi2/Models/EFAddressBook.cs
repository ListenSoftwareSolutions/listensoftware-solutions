namespace WebApi1.Models
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class EFAddressBookContext : DbContext
    {
        public EFAddressBookContext()
            : base("name=EFAddressBookContext")
        {
        }

        public virtual DbSet<AddressBook> AddressBooks { get; set; }

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
        }
    }
}

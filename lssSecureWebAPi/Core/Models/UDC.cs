namespace lssCore.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("UDC")]
    public partial class UDC
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public UDC()
        {
            ServiceInformations = new HashSet<ServiceInformation>();
        }

        [Key]
        public long XRefId { get; set; }

        [StringLength(20)]
        public string ProductCode { get; set; }

        [StringLength(50)]
        public string KeyCode { get; set; }

        [StringLength(255)]
        public string Value { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ServiceInformation> ServiceInformations { get; set; }
    }
}

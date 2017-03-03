using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace lssCore.Models
{
    using System;
    using System.Collections.Generic;

    public partial class GeneralLedger
    {
        public long Id { get; set; }
        public long DocNumber { get; set; }
        public string DocType { get; set; }
        public decimal Amount { get; set; }
        public string LedgerType { get; set; }
        public System.DateTime GLDate { get; set; }
        public long AccountId { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public long AddressId { get; set; }
        public string Comment { get; set; }
    }
}
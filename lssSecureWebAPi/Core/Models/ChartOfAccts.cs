using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace lssCore.Models
{
    using System;
    using System.Collections.Generic;

    public partial class ChartOfAccts
    {
        public long AccountId { get; set; }
        public string Location { get; set; }
        public string BusUnit { get; set; }
        public string Subsidiary { get; set; }
        public string SubSub { get; set; }
        public string Account { get; set; }
        public string Description { get; set; }
        public string CompanyNumber { get; set; }
    }
}
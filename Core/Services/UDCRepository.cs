using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using lssCore.Database;

namespace lssCore.Services
{
    public class UDCRepository
    {
        public IEnumerable<UDC> GetUdcList(string product_code)
        {
            try
            {
                using (var db = new DatabaseContext())
                {

                    var udc_list = from p in db.UDCs
                                   where p.ProductCode == product_code
                                   orderby p.KeyCode
                                   select p;

                    var x = udc_list.ToList<UDC>();

                    return (x);
                }
            }
            catch (Exception ex)
            {
            }
            return (null);
        }
    }
}
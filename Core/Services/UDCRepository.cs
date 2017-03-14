using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using lssCore.Database;

namespace lssCore.Services
{
    public class UDCRepository
    {
        public UDC GetUdcById(long ? id)
        {
            UDC udc = null;
            try
            {
                using (var db = new DatabaseContext())
                {
                     udc = (from p in db.UDCs
                              where p.XRefId == id
                              select p).FirstOrDefault();

                   
                }
            }
            catch (Exception ex)
            {

            }
            return udc;
        }
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
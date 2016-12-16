using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WebApi1.Services;


namespace WebApi1.Controllers
{
    public class ValuesController : ApiController
    {
        // GET api/values
       


        public IEnumerable<string> Get()
        {
            return new string[] { "Hello World 1", "Hello World 2" };
        }

        // GET api/values/5
        public string Get(int id)
        {
            return "Hello World from David Nishimoto " + id;
        }

        // POST api/values
        public void Post([FromBody]string value)
        {
        }

        // PUT api/values/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        public void Delete(int id)
        {
        }
    }
}

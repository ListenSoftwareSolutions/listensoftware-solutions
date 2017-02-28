using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(tempMVC.Startup))]
namespace tempMVC
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}

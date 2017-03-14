using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using lssSecureWebApi2;
using lssSecureWebApi2.Controllers;

namespace lssSecureWebAPi.Tests.Controllers
{
    [TestClass]
    public class HomeControllerTest
    {
        [TestMethod]
        public void Index()
        {
            // Arrange
            HomeApiController controller = new HomeApiController();

            // Act
            ViewResult result = controller.Index() as ViewResult;

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("Home Page", result.ViewBag.Title);
        }
    }
}

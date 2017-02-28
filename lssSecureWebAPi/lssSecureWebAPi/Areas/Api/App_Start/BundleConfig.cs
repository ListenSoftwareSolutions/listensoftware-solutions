﻿using System.Web;
using System.Web.Optimization;

namespace lssSecureWebApi2
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"
                        //,"~/Scripts/jquery-{version}.slim.min.js"
                        //,"~/Scripts/jquery-{version}.slim.min.map"
                        ));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new Bundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new Bundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new Bundle("~/bundles/angular").Include(
                      "~/Scripts/angular.js",
                      "~/Scripts/angular.min.js"
                      //"~/Scripts/angular.min.js.map"
                      ));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                    "~/Content/bootstrap.css",
                    "~/Content/site.css"));


            bundles.Add(new Bundle("~/bundles/custom").Include(
                      //"~/Scripts/MyScripts/AddressBookApp.js",
                      "~/Scripts/MyScripts/Module.js",
                      "~/Scripts/MyScripts/AddressBook.js",
                      "~/Scripts/MyScripts/LoginLogic.js"));

          
            bundles.Add(new Bundle("~/bundles/app").Include(
          "~/Scripts/knockout-{version}.js",
          "~/Scripts/app.js"));
        }
    }
}
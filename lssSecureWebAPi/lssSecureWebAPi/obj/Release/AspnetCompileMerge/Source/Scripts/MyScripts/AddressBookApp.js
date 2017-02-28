
(function ()
{
    'use strict'
    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('addressBookApp', ['ngRoute', 'AddressBookServices']).config(config);

    function config($routeProvider, $locationProvider)
    {
        $routeProvider.when('/addressBook/edit/:id',
        {
            templateUrl: 'addressBook/edit.cshtml',
            controller: 'addressBookEditController'
        })
        .when('/addressBook/delete/:id',
        {
            templateUrl : 'addressBook/edit.cshtml',
            controller: 'addressBook/delete.cshtml'
        });
    }
 });
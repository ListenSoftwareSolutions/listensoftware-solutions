var myApp=angular.module('lssFamilyTreeApp', []);

myApp.controller('lssFamilyTreeController', function ($scope,$http) {
   
    $scope.loadView = function (paramValue) {
        //alert(paramValue);

        $scope.family_page=paramValue;
        //var oViewer = document.getElementById("viewer").contentWindow;
        //oViewer.src=paramValue;
    };

   // window.location.href ="http://www.listensoftware.com/lssfamilytree.html";
    


  });

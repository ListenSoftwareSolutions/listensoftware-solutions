var myApp=angular.module('lssFamilyTreeApp', []);

myApp.controller('lssFamilyTreeController', function ($scope,$http) {
   
    $scope.loadView = function (paramValue) {
        //alert(paramValue);

        //var elements=paramValue.split("=");
        //$scope.family_page="family"+elements[1]+".json";
        $scope.family_page=paramValue;
        

        //alert($scope.family_page);
        
        //var oViewer = document.getElementById("viewer").contentWindow;
        //oViewer.src=paramValue;
    };

   // window.location.href ="http://www.listensoftware.com/lssfamilytree.html";
    


  });

var myApp=angular.module('LinksApp', []);

myApp.controller('LinksController', function ($scope,$http,$interval) {

        var sUrl = "GuestBook.asmx/GetLinksList";


    /*
    $http({
  method: 'POST',
  url: sUrl,
  headers: {
   'Content-Type': 'application/json;'
 }
}).then(function successCallback(response) {
            var myjson = JSON.parse(oReq.responseText);
            alert(oReq.responseText);
            var myjson2=JSON.parse(myjson.d);
            var sMessage='';
            for (i=0;  i<= myjson2.length-1; i++)
            {
                sMessage=sMessage + "<li><article><header><h3><a href='" + myjson2[i].key + "'>" + myjson2[i].data + "</a></header></article></li>";
            }
            lblLinks=document.getElementById('lblLinks');
            lblLinks.innerHTML="<ul class='posts'>" + sMessage + "</ul>";
    
  }, function errorCallback(response) {
    alert('error with http post');
   
  });

*/

var promise;

/*
var oReq = getXMLHttpRequest();

//************Greeting**************
if (oReq != null) {
    oReq.open("POST", sUrl, true);
    oReq.setRequestHeader("Content-type", "application/json; charset=utf-8");
    oReq.onreadystatechange = handler;
    oReq.send();
}
else {
    window.console.log("AJAX (XMLHTTP) not supported.");
}

function handler()
{
    if (oReq.readyState == 4 ) {
        if (oReq.status == 200) {
            console.log(oReq.responseText);
            var myjson = JSON.parse(oReq.responseText);
            var myjson2=JSON.parse(myjson.d);
            var sMessage='';
            for (i=0;  i<= myjson2.length-1; i++)
            {
                sMessage=sMessage + "<li><article><header><h3><a href='" + myjson2[i].key + "'>" + myjson2[i].data + "</a></header></article></li>";
            }
            lblLinks=document.getElementById('lblLinks');
            lblLinks.innerHTML="<ul class='posts'>" + sMessage + "</ul>";
        }
    }
}
*/

function getXMLHttpRequest() 
{
    if (window.XMLHttpRequest) {
        return new window.XMLHttpRequest;
    }
    else {
        try {
            return new ActiveXObject("MSXML2.XMLHTTP.3.0");
        }
        catch(ex) {
            return null;
        }
    }
}

    $scope.tickInterval = 1000;
    var iStopWatchSeconds = 1;
    var tick=function(){
        $scope.clock = Date.now();
    }
    tick();
    $interval(tick, $scope.tickInterval);

    var stopWatch = function () {
        $scope.stopWatchDisplay = iStopWatchSeconds;
        iStopWatchSeconds++;
    }
    $scope.startTimer = function () {
        promise=$interval(stopWatch, 1000);
    }

    $scope.stopTimer = function () {
        if(angular.isDefined(stopWatch)){
        $interval.cancel(promise);
        }
    }
    $scope.resetTimer = function () {
        $scope.stopTimer();
        iStopWatchSeconds=1
        $scope.stopWatchDisplay = '';

    }

  });

                      
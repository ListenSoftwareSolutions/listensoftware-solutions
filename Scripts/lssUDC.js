var myApp=angular.module('UdcApp', []);

myApp.controller('UdcController', function ($scope,$http) {
        //var UDCs;

        var sUrl = "GuestBook.asmx/GetUDCList";

var oReq = getXMLHttpRequest();

//************Greeting**************

var params = JSON.stringify({ sSystem: 'BD' });

if (oReq != null) {
    oReq.open("POST", sUrl, true);
    oReq.setRequestHeader("Content-type", "application/json; charset=utf-8");
    //oReq.setRequestHeader("Content-length", params.length);
    //oReq.setRequestHeader("Connection", "close");
    oReq.onreadystatechange = handler;
    oReq.send(params);
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
            console.log(myjson2);
            $scope.UDCs=myjson2;


            var table="<table class='table'><tr><th>Action</th><th>Key</th><th>Description</th></tr>";

            var i=0;
            angular.forEach($scope.UDCs, function (obj) {
                table += "<tr>";
                table += "<td><button class='btn btn-primary' id='cmdEdit'" + i + " onclick='callJavascriptFunction(" + obj["key"] + ")' >Edit</button></td>"
                table += "<td>" + obj["key"] + "</td>"
                table += "<td>" + obj["description1"] + "</td>"
                table += "</tr>";
                i++;
               });
                table+="</table>";
        
            /*for (i = 0; i <=myjson2.length-1; i++) {
                table += "<tr>";
                table += "<td><button class='btn btn-primary'>Edit</button></td>"
                table += "<td>" +
                myjson2[i].key +
                "</td><td>" +
                myjson2[i].description1 +
                "</td></tr>";
            }
            table+="</table>";
             */
             var tblUDC=document.getElementById('tblUDC');
            tblUDC.innerHTML=table;
            $('#myId').modal();
         
          
            //var sMessage='';
            //for (i=0;  i<= myjson2.length-1; i++)
            //{
            //    sMessage=sMessage + "<li><article><header><h3><a href='" + myjson2[i].key + "'>" + myjson2[i].description1 + "</a></header></article></li>";
            //}
            //alert(sMessage);
            //lblLinks=document.getElementById('lblLinks');
            //lblLinks.innerHTML="<ul class='posts'>" + sMessage + "</ul>";

            $scope.loadForm = function () {
                alert("reached");
            }
            

        }
    }
}

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


  });
function callJavascriptFunction(sKey)
{
    alert(sKey);
     //var inputForm=document.getElementById('myId');
     //inputForm.modal();
    //$('#myId').modal();
}
                      
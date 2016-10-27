var myApp=angular.module('FamilyTreeApp', []);

myApp.controller('FamilyTreeController', function ($scope,$http) {
    var iMemberId;
    var Person = function()
    {
        sName;
        sBirthLocation;
        sBurialDate;
        sDeathDate;
        sPlaceOfDeath;
        sBirthDate;
        sMarriageDate;
        sMarriageLocation;
        sSpouse;
        sJournalEntry;
        sFather;
        sMother;
    }

    $(document).ready(function () {
        //iMemberId = document.URL.indexOf('?memberid=');
        //alert(iMemberId);
    });
    //iMemberId = document.URL.indexOf('?memberid=');
    //alert(document.URL);
    var sURL = document.URL;
//alert(sURL)
    //alert(sURL.indexOf('=') + 1)
    iMemberId = sURL.substring(sURL.indexOf('=') + 1);
    //alert('reached' + iMemberId);
//alert("family" + iMemberId +".json");

var req = {
                method: 'GET',
                url: "family" + iMemberId +".json",
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
                data: ""
            };

  $http(req).then(function(response) {


     //$http.get("family" + iMemberId +".json").then(function(response) {
       //$http.get("family" + iMemberId +".json").success(function (data, status, headers, config){
        $scope.myData = response.data;

        //alert(response.data);
        lblReportView.innerHTML='';
       
       angular.forEach($scope.myData, function(value,key){

        
            if (Person.sName==undefined)
            {
                Person.sName=value.sName;
            }
            if ((value.sMyLabel=='Birth Date') && ((value.sMyText!=undefined) || (value.sMyDate!=undefined)))
            {
                if (value.sMyText!=undefined)
                Person.sBirthDate=value.sMyText;
                if (value.sMyDate!=undefined)
                Person.sBirthDate=value.sMyDate;
            }
            if ((value.sMyLabel=='Birth Location') && (value.sMyText!=undefined))
            {
                Person.sBirthLocation=value.sMyText;
            }
            if ((value.sMyLabel=='Burial Date') && ((value.sMyText!=undefined) || (value.sMyDate!=undefined)))
            {
                if (value.sMyText!=undefined)
                    Person.sBurialDate=value.sMyText;
                if (value.sMyDate!=undefined)
                    Person.sBurialDate=value.sMyDate;
            }
            if ((value.sMyLabel=='Burial Location') && (value.sMyText!=undefined))
            {
                Person.sBurialLocation=value.sMyText;
            }
             if ((value.sMyLabel=='Death Date') && ((value.sMyText!=undefined) || (value.sMyDate!=undefined)))
            {
                if (value.sMyText!=undefined)
                Person.sDeathDate=value.sMyText;
                if (value.sMyDate!=undefined)
                Person.sDeathDate=value.sMyDate;
            }
            if ((value.sMyLabel=='Place of Death') && (value.sMyText!=undefined))
            {
                Person.sPlaceOfDeath=value.sMyText;
            }
              if ((value.sMyLabel=='Marriage Date') && ((value.sMyText!=undefined) || (value.sMyDate!=undefined)))
            {
                if (value.sMyText!=undefined)
                Person.sMarriageDate=value.sMyText;
                if (value.sMyDate!=undefined)
                Person.sMarriageDate=value.sMyDate;
            }
            if ((value.sMyLabel=='Marriage Location') && (value.sMyText!=undefined))
            {
                Person.sMarriageLocation=value.sMyText;
            }
            if ((value.sMyLabel=='Spouse') && (value.sToName!=undefined))
            {
                
                Person.sSpouse=value.sToName;
            }
            if (((value.sMyLabel=='Journal Entry') || (value.sMyLabel=='Research Note'))&& (value.sMyMemo!=undefined))
            {
                if (Person.sJournalEntry!=undefined)
                    {
                        Person.sJournalEntry+='<H3>Note</h3>' + value.sMyMemo.replace("<br>","");
                    }
                    else
                    {
                        Person.sJournalEntry='<h3>Note</h3>' + value.sMyMemo.replace("<br>","");
                    }
                
            }
           if ((value.sMyLabel=='Father') && (value.sToName!=undefined))
           {
             if ((value.sToName!=Person.sMother) && (Person.sFather==undefined))
             {
               Person.sFather=value.sToName;
             }
           }
           if ((value.sMyLabel=='Mother') && (value.sToName!=undefined))
           {
                if ((value.sToName!=Person.sFather) && (Person.sMother==undefined))
                {
               Person.sMother=value.sToName;
                }
           }
          
        });

       lblReportView=document.getElementById('lblReportView');
  
        lblReportView.innerHTML='';     
        lblReportView.innerHTML+="<form class='form-horizontal' role='form'>"
        lblReportView.innerHTML+="<div class='form-group'>"
        lblReportView.innerHTML+="<label for='lbl1' class='col-lg-3 control-label'>Name</label><span placeholder='lbl1' class='col-lg-8'>" + Person.sName + "</span>";
        lblReportView.innerHTML+="</div>"

        if (Person.sBirthLocation != undefined)   
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Birth Location</label><span class='col-lg-8'> " + Person.sBirthLocation + "</span>";
            lblReportView.innerHTML+="</div>"
        }
        if (Person.sBirthDate != undefined)   
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Birth Date</label><span class='col-lg-8'> " + Person.sBirthDate + "</span>";
            lblReportView.innerHTML+="</div>"
        }
        if (Person.sBurialLocation!=undefined)
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Burial Location</label><span class='col-lg-8'> " + Person.sBurialLocation + "</span>";
            lblReportView.innerHTML+="</div>"
        }
        if (Person.sBurialDate!=undefined)
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Burial Date</label><span class='col-lg-8'> " + Person.sBurialDate + "</span>";
            lblReportView.innerHTML+="</div>"
        }
        if(Person.sPlaceOfDeath!=undefined)
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Place of Death</label> <span class='col-lg-8'>" + Person.sPlaceOfDeath + "</span>";
            lblReportView.innerHTML+="</div>"
        }
        if(Person.sDeathDate!=undefined)
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Death Date</label><span class='col-lg-8'> " + Person.sDeathDate + "</span>";
            lblReportView.innerHTML+="</div>"
        }
       if (Person.sMarriageLocation != undefined)   
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Marriage Location</label> <span class='col-lg-8'>" + Person.sMarriageLocation + "</span>";
            lblReportView.innerHTML+="</div>"
        }
        if (Person.sMarriageDate != undefined)   
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Marriage Date</label> <span class='col-lg-8'>" + Person.sMarriageDate + "</span>";
            lblReportView.innerHTML+="</div>"
        }
        if (Person.sSpouse != undefined)
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Spouse</label><span class='col-lg-8'>" + Person.sSpouse + "</span>";
            lblReportView.innerHTML+="</div>"
        }
        if (Person.sFather !=undefined)
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Father</label> <span class='col-lg-8'>" + Person.sFather + "</span>";   
            lblReportView.innerHTML+="</div>"
        }
        if (Person.sMother !=undefined)
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Mother</label> <span class='col-lg-8'>" + Person.sMother + "</span>" ;
            lblReportView.innerHTML+="</div>"
        }
        if (Person.sJournalEntry !=undefined)
        {
            lblReportView.innerHTML+="<div class='form-group'>"
            lblReportView.innerHTML+="<label class='col-lg-3 control-label'>Journal Entry</label><span class='col-lg-8'> " + Person.sJournalEntry + "</span>";
            lblReportView.innerHTML+="</div>"
        }
        lblReportView.innerHTML+="</div>"
      
       //alert(Person.sName + 'Birth Location' + Person.sBirthLocation);

    });

$scope.buttonClick = function (paramValue) {
    if (paramValue=='Back')
    window.location.href ="http://www.listensoftware.com/lssfamilytree.html";
    if (paramValue=='Close')
    {
        alert('reached');
        window.opener = self;
        window.close();    
    }
    
};

     $scope.parseJSON = function (json) {
        return JSON.parse(json);
    }

  });

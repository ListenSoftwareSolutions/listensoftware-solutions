var sUrl = "GuestBook.asmx/GetLinksList";

var oReq = getXMLHttpRequest();

//************Greeting**************
if (oReq != null) {
    oReq.open("POST", sUrl, true);
    oReq.setRequestHeader("Content-type", "application/json; charset=utf-8");
    //oReq.setRequestHeader("Content-length", params.length);
    oReq.setRequestHeader("Connection", "close");
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
                      
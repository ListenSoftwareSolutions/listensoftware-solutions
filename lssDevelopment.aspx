<%@ Page Language="VB" MasterPageFile="~/lssMasterPage.master" Title="LSS Web Development" %>
<%@ MasterType virtualPath="~/lssMasterPage.master"%>
<script runat="server">
Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Master.developmentDown()
End Sub
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<!--
<font size=5>Database</font><br />
   <font size=4>Move your data online into an Microsoft SQL server</font><br />
           <font size=2>Microsoft SQL server 2005 or Microsoft Access</font>

<p></p>
<font size=5>Microsoft Asp.net</font><br />
   <font size=4>Gain the advantages of reliable Microsoft compiled language</font><br />
            <font size=2>HTML, CSS, asp.net 3.5</font>
<p></p>
<font size=5>Reports</font><br />
    <font size=4>Access information online and secure server protection optional</font><br />
            <font size=2>HTML, iTextSharp</font>
    <p></p>
<font size=5>Email</font><br />
     <font size=4>Communicate using email notification</font><br />
         <font size=2>Smtp email communication</font>
-->

<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td valign=top>
<asp:image runat="server" BorderWidth="0" ImageUrl="images/lssDatabase.png" />
</td>
<td valign=top>
<asp:image runat="server" BorderWidth="0" ImageUrl="images/lssAsp.net.png" />
</td>
</tr>
<tr>
<td valign=top>
<asp:image ID="Image1" runat="server" BorderWidth="0" ImageUrl="images/lssReports.png" />
</td>
<td valign=top>
<asp:image ID="Image2" runat="server" BorderWidth="0" ImageUrl="images/lssEmail.png" />
</td>
</tr>
</table>

</asp:Content>


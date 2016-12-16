<%@ Page Language="VB" MasterPageFile="~/lssMasterPage.master" Title="LSS Graphics" %>
<%@ MasterType virtualPath="~/lssMasterPage.master"%>
<script runat="server">
Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Master.graphicsDown()
End Sub
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<table cellspacing="0" cellpadding="0">
<tr>
<td align=center>
    <asp:Imagebutton ID="Image1" runat="server"  PostBackUrl="http://www.calebwellsphotography.com" ImageUrl="images/lssBasic-Web-Photo.png" Borderwidth=0 /><br />
</td></tr>
<tr>
    <td>
    <asp:ImageButton ID="Image5" runat="server" ImageUrl="images/lss-custom-ui.png" BorderWidth="0"   />
    </td>
</tr>
<tr>
    <td>
    <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="images/lss-logo-design.png" BorderWidth="0"   />
    </td>
</tr>
</table>
</asp:Content>


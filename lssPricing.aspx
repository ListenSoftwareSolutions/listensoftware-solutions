<%@ Page Language="VB" MaintainScrollPositionOnPostback="true" MasterPageFile="~/lssMasterPage.master" Title="Listen Software Solutions" %>
<%@ MasterType virtualPath="~/lssMasterPage.master"%>
<%@import Namespace="system.data" %>


<script runat="server">
    Sub QueryDS()
        Dim dt As New DataTable
        Dim dr As DataRow
        
        Dim dcTheBasics As New DataColumn("TheBasics", GetType(String))
        dt.Columns.Add(dcTheBasics)
        Dim dcPages As New DataColumn("Pages", GetType(String))
        dt.Columns.Add(dcPages)
        Dim dcPrice As New DataColumn("Price", GetType(String))
        dt.Columns.Add(dcPrice)

        If Session("TheButton") = "Basics" Then
            dr = dt.NewRow()
            dr("TheBasics") = "We Code and design your website"
            dr("pages") = 5
            dr("price") = "$250"
            dt.Rows.Add(dr)
        
            dr = dt.NewRow()
            dr("TheBasics") = "We Code and design your website"
            dr("pages") = 10
            dr("price") = "$300"
            dt.Rows.Add(dr)

            dr = dt.NewRow()
            dr("TheBasics") = "We Code and design your website"
            dr("pages") = 15
            dr("price") = "$350"
            dt.Rows.Add(dr)
        ElseIf Session("TheButton") = "Premium" Then
            dr = dt.NewRow()
            dr("TheBasics") = "Development"
            dr("pages") = "Unlimited"
            dr("price") = "$85/hr"
            dt.Rows.Add(dr)
        
            dr = dt.NewRow()
            dr("TheBasics") = "Graphics"
            dr("pages") = "Unlimited"
            dr("price") = "$50/hr"
            dt.Rows.Add(dr)
        ElseIf Session("TheButton") = "Logo" Then
            dr = dt.NewRow()
            dr("TheBasics") = "Text, and some simple graphics"
            dr("pages") = ""
            dr("price") = "Free with Site"
            dt.Rows.Add(dr)
        
            dr = dt.NewRow()
            dr("TheBasics") = "More emphasis on graphics"
            dr("pages") = ""
            dr("price") = "$250"
            dt.Rows.Add(dr)

            dr = dt.NewRow()
            dr("TheBasics") = "A beautiful integration of text, and graphics"
            dr("pages") = ""
            dr("price") = "$350"
            dt.Rows.Add(dr)
        End If
        
        grdPayOptions.DataSource = dt
        grdPayOptions.DataBind()


    End Sub
Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Master.PricingDown
        If IsPostBack = False Then
            If Session("TheButton") Is Nothing Then
                Session("TheButton") = "Basics"
            End If
            QueryDS()
        End If
    End Sub
    Sub Basics_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("TheButton") = "Basics"
        ImageBanner.ImageUrl="images/lss-Basic-Web.png"
        imagebuttonBasics.ImageUrl="images/lss-Basic-Websites-ON.png"
        imagebuttonPremium.ImageUrl="images/lss-Premium-Websites.png"
        imagebuttonLogo.ImageUrl="images/lss-Logo.png"
        QueryDS()
    End Sub
    Sub Premium_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("TheButton") = "Premium"
        ImageBanner.ImageUrl="images/lss-Premium-Web.png"
        imagebuttonPremium.ImageUrl="images/lss-Premium-Websites-ON.png"
        imagebuttonBasics.ImageUrl="images/lss-Basic-Websites.png"
        imagebuttonLogo.ImageUrl="images/lss-Logo.png"
        QueryDS()
    End Sub
    Sub Logo_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("TheButton") = "Logo"
        ImageBanner.ImageUrl="images/lss-logo-design-banner.png"
        imagebuttonPremium.ImageUrl="images/lss-Premium-Websites.png"
        imagebuttonBasics.ImageUrl="images/lss-Basic-Websites.png"
        imagebuttonLogo.ImageUrl="images/lss-Logo-On.png"
        QueryDS()
    End Sub
    Sub grdPayOptions_DataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        Dim lblHeaderTitle As Label
        lblHeaderTitle = e.Row.FindControl("lblHeaderTitle")
        If Not lblHeaderTitle Is Nothing Then
            If Session("TheButton") = "Basics" Then
                lblHeaderTitle.Text = "The Basics"
            ElseIf Session("TheButton") = "Premium" Then
                lblHeaderTitle.Text = "Premium"
            ElseIf Session("TheButton") = "Logo" Then
                lblHeaderTitle.Text = "Logo"
                Dim lblHeaderPages As Label = e.Row.FindControl("lblHeaderPages")
                lblHeaderPages.Text = ""
            End If
        End If
        
    End Sub
    Sub Submit_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim row As GridViewRow
        Dim myCheckBox As CheckBox
        Dim lblTheBasics As Label
        Dim lblPages As Label
        Dim lblPrice As Label
        
        Session("TheBasics") = "You ordered:"
        For Each row In grdPayOptions.Rows
        
            myCheckBox = CType(row.FindControl("chkSelected"), CheckBox)
 
            If myCheckBox.Checked = True Then
                lblTheBasics = CType(row.FindControl("lblTheBasics"), Label)
                lblPages = CType(row.FindControl("lblPages"), Label)
                lblPrice = CType(row.FindControl("lblPrice"), Label)
                Session("TheBasics") = Session("TheBasics") & "[" & lblTheBasics.Text & " " & lblPages.Text & " pages " & lblPrice.Text & "]" & Chr(13) & Chr(10) 
            End If
        Next
        Response.Redirect("lsscontact.aspx")
        

    End Sub
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<table cellpadding="0" cellspacing="0" width="1140">
<tr>
<td valign=top>
    <table border=0 cellspacing=0 cellpadding=0>
    <tr><td>
    <asp:Image ID="Image2" runat="server" ImageUrl="images/lss-C-A-P.png" Borderwidth=0 />
    </td></tr>
    <tr><td>
    <asp:imagebutton id="imagebuttonBasics" runat="server" BorderWidth="0" ImageUrl="images/lss-Basic-Websites-on.png" OnClick="Basics_Click"  />
    </td></tr>
    <tr><td>
    <asp:imagebutton ID="ImagebuttonPremium" BorderWidth="0" runat="server"  ImageUrl="images/lss-Premium-Websites.png" OnClick="Premium_Click"  />
    <tr><td>
    <asp:imagebutton ID="ImagebuttonLogo" BorderWidth="0" runat="server" ImageUrl="images/lss-Logo.png" onclick="Logo_click"  />
    </td></tr>
    </table>
</td>
<td valign=top align="right">
<asp:Image ID="ImageBanner" runat="server" ImageUrl="images/lss-Basic-Web.png" Borderwidth=0 /><br />
<br />
      <asp:ImageButton ID=cmdSubmit runat="server" imageurl="images/lss-Submit-Button.png" OnClick="Submit_Click" />

    <asp:GridView ID="grdPayOptions" runat="server" Width="850"
       DataKeyNames="thebasics"
        AllowPaging="false" Height="212px" 
        PageSize="100" 
        AutoGenerateColumns="False" 
        AllowSorting="True" 
        
        BorderWidth="0px" 
      
        
        HeaderStyle-BackColor="#666666"
         HeaderStyle-ForeColor="#e6e6e6"
          HeaderStyle-Height="33"
        ForeColor="black"
        CellPadding="3" 
        OnRowDataBound="grdPayOptions_DataBound"
    >
        <Columns>
            <asp:CommandField ShowSelectButton="false" Visible=false />
            <asp:CommandField ShowEditButton="false" Visible=false />
            <asp:CommandField ShowDeleteButton="false" Visible=false />
            <asp:TemplateField ItemStyle-BackColor="silver" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" HeaderText="The Basics" ItemStyle-Width="500" Visible="true">
                <HeaderTemplate>
                    <asp:Label ID="lblHeaderTitle" Font-Bold="true" Text='' runat="server"/>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblTheBasics" Text='<%# bind("thebasics")%>' runat="server"/>
                </itemtemplate>
             </asp:TemplateField>
            <asp:TemplateField ItemStyle-BackColor="silver"  ItemStyle-HorizontalAlign="center"   HeaderStyle-HorizontalAlign="center" ItemStyle-Width="50" Visible="true">
                <HeaderTemplate>
                    <asp:Label ID="lblHeaderPages" Text='Pages' runat="server"/>
                </HeaderTemplate>
                <ItemTemplate>
                <asp:Label ID="lblPages" Text='<%# bind("pages")%>' runat="server"/>
                </itemtemplate>
             </asp:TemplateField>
            <asp:TemplateField  ItemStyle-BackColor="silver"  HeaderText="Price" ItemStyle-HorizontalAlign="Right"   HeaderStyle-HorizontalAlign="right" ItemStyle-Width="150" Visible="true">
                <ItemTemplate>
                <asp:Label ID="lblPrice" Text='<%# bind("price")%>' runat="server"/>
                </itemtemplate>
             </asp:TemplateField>
            <asp:TemplateField  ItemStyle-BackColor="silver"  ItemStyle-HorizontalAlign="right"   HeaderStyle-HorizontalAlign="center" ItemStyle-Width="50" Visible="true">
                <HeaderTemplate>
                Select
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="chkSelected" runat="server" />
                </itemtemplate>
             </asp:TemplateField>
        </Columns>
    </asp:GridView>

</td>
</tr>
<tr>
<td colspan="2" align="center">
    <asp:Image ID="imageFooter" runat="server" ImageUrl="images/lssdivider.png" border=0 />
</td>
</tr>
</table>
</asp:Content>


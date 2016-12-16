<%@ Page Language="VB" MaintainScrollPositionOnPostback=true ValidateRequest=false MasterPageFile="~/lssMasterPage.master" Title="Customer" %>
<%@ import namespace="system.data" %>
<%@ import namespace="system.data.oledb" %>

<script runat=server>
    Dim dbconn As OleDbConnection
    Dim cmdSelect As OleDbCommand
    Dim cmdUpdate As OleDbCommand
    Dim datareader As OleDbDataReader

 
    Sub connectToContentMDB()
        Dim sConnectionString As String
        sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("app_data/sweeter.mdb")
        dbconn = New OleDbConnection(sConnectionString)
        dbconn.Open()

    End Sub
    Sub closeContentMDB()
        dbconn.Close()
    End Sub
    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs)
        'closeContentMDB()
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        
        'connectToContentMDB()
        'If Not IsPostBack Then
        'BuildList()
        'End If
        
        If Session("SecurityKeyOk") = False Then
            Response.Redirect("mtdefault.aspx")
        End If

    End Sub
    
    Protected Sub cmdQueryHeadline_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        'Dim sql As String
        'sql = "SELECT id ,microtheoryitem, contentid ,hits FROM microtheory"
        'If txtQueryHeadline.Text <> "" Then
        'Sql = Sql & " where ucase(microtheoryitem) like '%" & UCase(txtQueryHeadline.Text) & "%'"
        'End If
        'Sql = Sql & " order by hits desc"
        'dsWebsite.SelectCommand = Sql
        'dsWebsite.Select(DataSourceSelectArguments.Empty)
        dsWebsite.DataBind()
        grdWebsite.DataBind()
    End Sub

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table width="100%">
        <tr>
        <td align=center>
                    <font size=4>Customer Administration</font>     
                    <br />   
        </td>
        </tr>
        <tr>
        <td align=center>
    
    <asp:GridView ID="grdWebsite" runat="server"        DataKeyNames="id"
        DataSourceID="dsWebsite" 
        AllowPaging="True" width="900" PageSize="10" AutoGenerateColumns="False" AllowSorting="True" 
    >
        <Columns>
            <asp:CommandField ShowSelectButton="false" Visible=false />
            <asp:CommandField ShowEditButton="true" ItemStyle-VerticalAlign="top" />
            <asp:CommandField ShowDeleteButton="true" ItemStyle-VerticalAlign="top" />
            <asp:BoundField DataField="id"  ItemStyle-VerticalAlign="top"  ReadOnly=true AccessibleHeaderText="Id" HeaderText="Id" />
            <asp:BoundField DataField="LastVisited" ItemStyle-VerticalAlign="top" AccessibleHeaderText="Visited" HeaderText="Visited" />
            <asp:BoundField DataField="Name" ItemStyle-VerticalAlign="top" AccessibleHeaderText="Name" HeaderText="Name" />
            <asp:BoundField DataField="Email" ItemStyle-VerticalAlign="top" AccessibleHeaderText="Email" HeaderText="Email" />
            <asp:BoundField DataField="Article"  ItemStyle-Width="200" ItemStyle-VerticalAlign="top" AccessibleHeaderText="Article" HeaderText="Article" />
            <asp:BoundField DataField="Notes"  ItemStyle-VerticalAlign="top" AccessibleHeaderText="Notes" HeaderText="Notes" />
            <asp:BoundField DataField="IPAddress"  ItemStyle-VerticalAlign="top" AccessibleHeaderText="IP Address" HeaderText="IP Address" />
            <asp:BoundField DataField="BotName"  ItemStyle-VerticalAlign="top" AccessibleHeaderText="Bot Name" HeaderText="Bot Name" />
        </Columns>
        <PagerSettings PageButtonCount="1000" Position="TopAndBottom" />
    </asp:GridView>
    <asp:AccessDataSource ID="dsWebsite" runat="server" DataFile="APP_DATA/sweeter.mdb"
        SelectCommand="SELECT ipaddress,botname,id,name,email,format(lastvisited,'mm/dd/yyyy') as lastvisited, article, notes,contentid FROM users order by lastvisited desc"
        UpdateCommand="update users set [name]=@Name, [email]=@Email,[Article]=@Article, [Notes]=@Notes, [LastVisited]=@LastVisited, [IPAddress]=@IpAddress,[BotName]=@BotName where [id]=@Id"
        DeleteCommand="delete * from users where id=@Id"
        >
       <UpdateParameters>
           <asp:ControlParameter ControlID="grdWebsite" Name="Name" PropertyName="SelectedValue"
               Type="String" />
           <asp:ControlParameter ControlID="grdWebsite" Name="Email" PropertyName="SelectedValue"
               Type="String" />
           <asp:ControlParameter ControlID="grdWebsite" Name="Article" PropertyName="SelectedValue"
               Type="String" />
           <asp:ControlParameter ControlID="grdWebsite" Name="Notes" PropertyName="SelectedValue"
               Type="String" />
           <asp:ControlParameter ControlID="grdWebsite" Name="LastVisited" PropertyName="SelectedValue"
               Type="String" />
          <asp:ControlParameter ControlID="grdWebsite" Name="Id" PropertyName="SelectedValue"
               Type="Int32" />
           <asp:ControlParameter ControlID="grdWebsite" Name="IpAddress" PropertyName="SelectedValue"
               Type="String" />
           <asp:ControlParameter ControlID="grdWebsite" Name="BotName" PropertyName="SelectedValue"
               Type="String" />
    </UpdateParameters>
       <DeleteParameters>
        <asp:ControlParameter ControlID="grdWebsite" Name="Id" PropertyName="SelectedValue"  Type="Int32" />
    </DeleteParameters>

</asp:AccessDataSource>

        </td></tr>
    </table>
</asp:Content>


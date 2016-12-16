<%@ Page Language="VB" MaintainScrollPositionOnPostback=true MasterPageFile="~/lssMasterPage.master" Title="Listen Software Solutions" %>
<%@ import namespace="system.data" %>
<%@ import namespace="system.data.oledb" %>
<%@import Namespace="Microtheory"%>
<%@import Namespace="System.Net.Mail" %>
<%@ Import Namespace="system.xml" %>
<%@ Import Namespace="System.Xml.XmlNode" %>
<%@ Import Namespace="System.Xml.XmlDocument" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<%@ Import Namespace="System.Xml.XPath" %>

<%@ Import Namespace="System.Text.RegularExpressions" %>
<script runat="server">
    Dim dbconn As OleDbConnection
    Dim dbsqlserverconn As OleDbConnection
    Dim dbMT As OleDbConnection
    Dim dbsweeter As OleDbConnection
    Dim cmdSelect As OleDbCommand
    Dim cmdUpdate As OleDbCommand
    Dim cmdInsert As OleDbCommand
    Dim datareader As OleDbDataReader
    Dim objMTFunc As New cMT_Functions
    
    Sub OpenSQLServer()
        Dim sParameter As String

        sParameter = "Provider=sqloledb; Data Source=davepamn2.db.2594332.hostedresource.com; Initial Catalog=davepamn2; User ID=davepamn2; Password=Kristal7258;"

        dbsqlserverconn = New OleDbConnection(sParameter)
        dbsqlserverconn.Open()
    End Sub

    Sub CloseSQLServer()
        If Not dbsqlserverconn Is Nothing Then
            dbsqlserverconn.Close()
        End If
    End Sub
    Sub connectToMicrotheory()
        Dim sConnectionString As String
        sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("app_data/microtheory.mdb")
        dbMT = New OleDbConnection(sConnectionString)
        dbMT.Open()
    End Sub
    Sub CloseMicrotheory()
        If Not dbMT Is Nothing Then
            dbMT.Close()
        End If
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        connectToContentMDB()
        'Session("SweetKeyOk")=true
        'If Session("SweetKeyOk") Is Nothing Or Session("SweetKeyOk") <> True Then
        'panelDisplayContent.Visible = False
        'panelRegister.Visible = True

        'If lblContentId.Text = "" Then
        'lblContentId.Text = Request("txtContentId")
        'End If

        'If Request("txtContentId") <> lblContentId.Text Then
        ' LoadContentView2(lblContentId.Text)
        ' Else
        'LoadContentView2(Request("txtContentId"))
        'End If
           
        'Else
        'panelDisplayContent.Visible = True
        'panelRegister.Visible = False
        'End If

        'If Session("SecurityKeyOk") Is Nothing Or Session("SecurityKeyOk") <> True Then
        'lblErrorMessage.Text = "&nbsp;&nbsp;&nbsp;Email dnishimoto@listensoftware.com for access"
        'txtQueryHeadline.Visible = False
        'cmdQueryHeadline.Visible = False
        'Exit Sub
        'End If
        'Response.Write(Session("SecurityKeyOk"))
        If Request("txtContentId") = 3253 Then
            Response.Redirect("http://www.google.com")
        End If
        'If Request("process") = "LoadView" Then
        'If grdContent.PageIndex = 1 Then
        'If lblContentId.Text = "" Then
        'lblContentId.Text = Request("txtContentId")
        'End If
        'If Request("txtContentId") <> lblContentId.Text Then
        'LoadContentView(lblContentId.Text)
        'Else
        'LoadContentView(Request("txtContentId"))
        'End If
        'Else
        'lblView1.Text = ""
        'End If
        'End If

        If Not IsPostBack Then
            getRegisterCount()
            'If lblSiteId.Text <> "" Or Request("SiteId") <> "" Then
            'If Request("SiteId") <> "" Then
            'lblSiteId.Text = Request("SiteId")
            'End If
            'If Request("SiteId") <> "" Then
            'dsContent.SelectCommand = "SELECT [contentid], mid(trim([headline]),1,100) as headline, [hits],[siteid] FROM [content] where approved=1 order by hits desc"
            'dsContent.SelectParameters.Add(New Parameter("@SiteId", TypeCode.Int32, Request("SiteId")))
            'lblSiteId.Text = Request("SiteId")
            'Else
            'dsContent.SelectParameters.Add(New Parameter("@SiteId", TypeCode.Int32, CLng(lblSiteId.Text)))
            'dsContent.SelectCommand = "select contentid,trim(headline) as headline,hits,siteid from content where approved=1 and siteid=" & lblSiteId.Text & " order by hits desc"
            'End If
            'dsContent.Select(DataSourceSelectArguments.Empty)
            'End If
            'grdContent.DataBind()
            If lblSiteId.Text <> "" Then
                lblSiteName.Text = "<font size=4>" & SiteName(CInt(lblSiteId.Text)) & "</font>"
            End If
            
            If lblContentId.Text = "" Then
                lblContentId.Text = Request("txtContentId")
            End If

            If Request("txtContentId") <> lblContentId.Text Then
                LoadContentView2(lblContentId.Text)
            Else
                LoadContentView2(Request("txtContentId"))
            End If

        End If
        DSQuery()
        
    End Sub
    Function OverLayMicrotheory(ByVal iContentId As Integer, ByRef sContent As String) As String
        Dim sRetVal As String
        Dim sql As String
        Dim dr As OleDbDataReader
        Dim sSearchPhrase As String
        'Dim ht As New Hashtable
        Dim i As Integer = 0
        
        sql = "SELECT "
        sql = sql & " distinct microtheoryitem,hits"
        sql = sql & " FROM microtheory "
        sql = sql & " where contentid=" & iContentId
        
        OpenSQLServer()
               
        cmdSelect = New OleDbCommand(sql, dbsqlserverconn)
        dr = cmdSelect.ExecuteReader
        
        Do While dr.Read
            sSearchPhrase = Left(trim(dr("microtheoryitem")), 35)
            'sSearchPhrase = dr("microtheoryitem")
            sContent = Replace(sContent, sSearchPhrase, "<font color=red>Hits=" & dr("hits") & "</font>&nbsp;" & sSearchPhrase)
            i += 1
        Loop
        dr.Close()
        
        sRetVal = sContent
        CloseSQLServer()
        Return (sRetVal)
    End Function
    Sub LoadContentView2(ByVal iContentId As Integer)
        Dim sql As String
        Dim sHeadline As String
        Dim iIP_Hits As Integer
        Dim mst As DateTime

        If Session("SweetKeyOk") = True Then
            panelDisplayContent.Visible = True
            panelRegister.Visible = False
        Else
            panelDisplayContent.Visible = True
            panelRegister.Visible = True
        End If
        
        sql = "select * from content where contentid=@contentid"
        sql = sql & " and approved=1"
        
        Session("PageNumber") = Nothing
        
        cmdSelect = New OleDbCommand(sql, dbconn)
        cmdSelect.Parameters.AddWithValue("@contentid", iContentId)
        datareader = cmdSelect.ExecuteReader
        sHeadline = ""
        mst = DateTime.Now().ToUniversalTime().AddHours(-6.0).ToUniversalTime()

        If datareader.Read Then
            iIP_Hits = IP_Counter(Left(datareader("headline"), 100), iContentId, datareader("siteid"))
            sHeadline = datareader("headline")
            lblSiteId2.Text = datareader("siteid")
            lblSiteName2.Text = "<font size=4>" & SiteName(datareader("siteid")) & "</font>"
            'If Session("SweetKeyOk") = True Then
            'lblView2.Text = "<h3>" & sHeadline & "</h3>" & " (" & datareader("hits") & " hits) " & "<table width='100%'><tr><td>" & OverLayMicrotheory(datareader("contentid"), datareader("content")) & "<P HEIGHT=10></p></td></tr></table><P></P>"
            'Else
            'If Hour(mst) > 23 And Hour(mst) < 24 Then
            'lblView2.Text = "<h3>" & sHeadline & "</h3>" & " (" & datareader("hits") & " hits) " & "<table width='100%'><tr><td>" & OverLayMicrotheory(datareader("contentid"), datareader("content")) & "<P HEIGHT=10></p><CENTER><font color=blue><b>&LT;&LT;&LT;Register to read&GT;&GT;&GT;</b></font></CENTER>" & "</td></tr></table><P></P>"
            'Else
            lblView2.Text = "<h3>" & sHeadline & "</h3>" & " (" & datareader("hits") & " hits) " & "<table width='100%'><tr><td>" & OverLayMicrotheory(datareader("contentid"), datareader("content")) & "....<P HEIGHT=10></p><CENTER>...<font color=blue><b>&LT;&LT;&LT;Register to correspond&GT;&GT;&GT;</b></font> ...</CENTER>" & "</td></tr></table><P></P>"
            'End If
            'End If
        Else
        lblView2.Text = "<h3>&lt;&lt;&lt;Document is no longer available&gt;&gt;&gt;(Request the missing document me-@dnishimoto@listensoftware.com)</h3>"
        End If
    
        sql = "update content set hits=hits+1 where contentid=@contentId"
        cmdUpdate = New OleDbCommand(sql, dbconn)
        cmdUpdate.Parameters.AddWithValue("@contentid", iContentId)
        cmdUpdate.ExecuteNonQuery()
    
    End Sub
    'Sub LoadContentView(ByVal iContentId As Integer)
    'Dim sql As String
    'Dim sHeadline As String
    'Dim iIP_Hits As Integer
    '    sql = "select * from content where contentid=@contentid"
    '    sql = sql & " and approved=1"
        
    '    Session("PageNumber") = Nothing
        
    '    cmdSelect = New OleDbCommand(sql, dbconn)
    '    cmdSelect.Parameters.AddWithValue("@contentid", iContentId)
    '    datareader = cmdSelect.ExecuteReader
    '    sHeadline = ""
    '    If datareader.Read Then
    '        If datareader("siteid") = 5 Then
    '            lblView1.Text = "<<Document is no longer available. Contact dnishimoto@listensoftware.com to restore.>>"
    '        Else
    '            iIP_Hits = IP_Counter(Left(datareader("headline"), 100), iContentId, datareader("siteid"))
    '            sHeadline = datareader("headline")
    '            lblHeadline.Text = "<h3>" & sHeadline & "</h3>"
    '            lblSiteId.Text = datareader("siteid")
    '            lblSiteName.Text = "<font size=4>" & SiteName(datareader("siteid")) & "</font>"
    '            lblView1.Text = " (" & datareader("hits") & " hits) " & "<table><tr><td>" & OverLayMicrotheory(datareader("contentid"), datareader("content")) & "</td></tr></table>"
    '        End If
    '    Else
    '        lblView1.Text = "<h3>&lt;&lt;&lt;Document is no longer available&gt;&gt;&gt;</h3>"
    '    End If
        
    '    sql = "update content set hits=hits+1 where contentid=@contentId"
    '    cmdUpdate = New OleDbCommand(sql, dbconn)
    '    cmdUpdate.Parameters.AddWithValue("@contentid", iContentId)
    '    cmdUpdate.ExecuteNonQuery()
    
        
    'End Sub
    Function IP_Counter(ByVal sTitle As String, ByVal iContentId As Integer, ByVal iSiteId As Integer) As Integer
	
        Dim sql, sURL, sIP As String
        Dim sTemp As String
	
        sURL = "http://www.listensoftware.com/lssContent.aspx?process=LoadView&txtContentId=" & iContentId & "&SiteId=" & iSiteId
        sIP = Request.ServerVariables("Remote_Addr")
        sTemp = sURL
        sTemp = objMTFunc.IsNvlString(sTemp)
	
        sql = "INSERT INTO Counters (URL,TITLE,HITS,DateHit,IP) VALUES ("
        sql = sql & "'" & sURL & "',"
        sql = sql & objMTFunc.IsNvlString(sTitle) & ","
        sql = sql & "1,"
        sql = sql & "#" & FormatDateTime(Now(), 2) & "#,"
        sql = sql & objMTFunc.IsNvlString(sIP)
        sql = sql & ")"
        cmdInsert = New OleDbCommand(sql, dbconn)
        cmdInsert.ExecuteNonQuery()
	
    End Function

   
    Protected Sub grdContent_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim iContentId As Integer
        Dim row As GridViewRow = grdContent.SelectedRow

        iContentId = CInt(row.Cells(1).Text)
        lblContentId.Text = iContentId
        'LoadContentView2(iContentId)
        LoadContentView2(iContentId)
        PanlGridView.Visible = False
    End Sub
    Sub connectToContentMDB()
        Dim sConnectionString As String
        sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("hrxp/content.mdb")
        dbconn = New OleDbConnection(sConnectionString)
        dbconn.Open()
    End Sub
    Sub closeContentMDB()
        If Not dbconn Is Nothing Then
            dbconn.Close()
        End If
    End Sub

    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs)
        closeContentMDB()
    End Sub
    Function SiteName(ByVal iSiteId As Integer) As String
        Dim sName As String
        sName = ""
        Select Case iSiteId
            Case 1
                sName = "Karate, Tai Chi, Health"
            Case 2
                sName = "Oracle, JDE, Kronos"
            Case 3
                sName = "ASP.Net, ADO, MS Access"
            Case 4
                sName = "Books, Movies"
            Case 5
                sName = "Acct,eBus,eCom, ERP, Supply, CRM, MRP, HR, PO"
            Case 6
                sName = "Javascript, XML, XSL"
            Case 7
                sName = "DirectX, OpenGL, MFC VC++"
        End Select
        Return (sName)
    End Function

    Sub DSQuery()
        Dim sql As String
        sql = "select contentid,mid(trim(headline),1,100) as headline,hits,siteid from content "
        sql = sql & " where approved=1 "
        If txtQueryHeadline.Text <> "" Then
            'Dim cprViewState As ControlParameter = New ControlParameter()
            'cprViewState.ControlID = txtQueryHeadline.ID.ToString()
            'cprViewState.PropertyName = "QueryHeadline"
            'cprViewState.Name = "ViewState"
            'cprViewState.Type = TypeCode.String
            'dsContent.FilterExpression = "Status = {0}"
            'dsContent.FilterParameters.Add(cprViewState)

            sql = sql & " and ucase(headline) like '%" & UCase(txtQueryHeadline.Text) & "%'"
            
            'sql = sql & " and ucase(headline) like '%'+ @QueryHeadline + '%'"
            
        End If
        If lblSiteId.Text <> "" Then
            sql = sql & " and siteid=" & lblSiteId.Text
        End If
        sql = sql & " order by hits desc"
        
        'dsContent.SelectCommandType = SqlDataSourceCommandType.StoredProcedure
        
        dsContent.SelectCommand = sql
        'If txtQueryHeadline.Text = "" Then
        dsContent.SelectCommandType = SqlDataSourceCommandType.Text
        dsContent.Select(DataSourceSelectArguments.Empty)
        'End If
        grdContent.DataBind()
    End Sub
    Protected Sub cmdQueryHeadline_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("cmwebsite.aspx?txtSearch=" & Replace(txtQueryHeadline.Text, " ", "+"))
        'PanlGridView.Visible = True
        'DSQuery()
    End Sub
    Sub getRegisterCount()
        Dim dr As OleDbDataReader
        Dim sql As String
        connectToMDB()
        sql = "select count(*) as total_members from users"
        cmdSelect = New OleDbCommand(sql, dbsweeter)
        dr = cmdSelect.ExecuteReader
        If dr.Read Then
            lblTotalRegisteredMembers.Text = dr("total_members")
        End If
        dr.Close()
        closeMDB()
    End Sub
    Sub Save_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sql As String
        Dim dr As OleDbDataReader
        Dim bProcessFlag As Boolean = True
        Dim sIPAddress As String
        Dim sAgent As String
        lblErrorRegisteration.Text = ""
              
        If Trim(txtEmail.Text) = "" Then
            lblErrorRegisteration.Text = "Email required"
            Exit Sub
        End If
        If trim(txtName.text) = "" Then
            lblErrorRegisteration.Text = "Name Required"
            Exit Sub
        End If
		
		'dim regx as System.Text.RegularExpressions.Regexregex = System.Text.RegularExpressions.Regex("\w+@\w+?\.[a-zA-Z]{2,3}?\.*\w*$")

	
	'bPass=regx.test(sVal)
	'if bPass=false then
	'		lblErrorRegisteration.Text = "Not an Email"
    '        Exit Sub
	'end if
        
        sIPAddress = Trim(Request.ServerVariables("Remote_Addr"))
        sAgent = Request.ServerVariables("HTTP_USER_AGENT")

        
        If sIPAddress = "94.100.22.210" Or sIPAddress = "188.143.233.111" Then
            Response.Redirect("http://www.google.com")
        End If
        If Page.IsValid = True Then
            connectToMDB()
            sql = "select * from users where ucase(trim(name))='" & UCase(Trim(txtName.Text)) & "'"
            cmdSelect = New OleDbCommand(sql, dbsweeter)
            dr = cmdSelect.ExecuteReader
            If dr.HasRows = False Then
                sql = "Insert into users "
                sql += " ("
                sql += " email"
                sql += ",name"
                sql += ",lastvisited"
                sql += ",contentid"
                sql += ",article"
                sql = sql & ",ipaddress"
                sql = sql & ",botname"
                sql += ")"
                sql += " values ("
                sql += "'" & txtEmail.Text & "'"
                sql += ",'" & Replace(txtName.Text, "'", "''") & "'"
                sql += ",#" & FormatDateTime(Now, 2) & "#"
                sql += "," & lblContentId.Text
                sql += ",'" & Replace(Left(lblHeadline.Text, 90), "'", "''") & "'"
                sql = sql & ",'" & Left(sIPAddress, 45) & "'"
                sql = sql & ",'" & Left(sAgent, 45) & "'"
                sql += ")"
            
                cmdInsert = New OleDbCommand(sql, dbsweeter)
                cmdInsert.ExecuteNonQuery()
    
                'lblErrorRegisteration.Text = "[I will contact you for approval]"
                ProcessCollaboration(lblHeadline.Text, lblContentId.Text, txtEmail.Text, txtName.Text)

                'closeMDB()
                'Exit Sub
            End If
            'Else
            '    dr.Read()
            '    If IsDBNull(dr("notes")) = False Then
            '        If UCase(Trim(dr("notes"))) = "BAD" Then
            '            lblErrorRegisteration.Text = "This email is not valid"
            '            closeMDB()
            '            Exit Sub
            '        End If
            '    ElseIf IsDBNull(dr("notes")) = True Then
            '        lblErrorRegisteration.Text = "[I will contact you for approval]"
            '        closeMDB()
            '        Exit Sub
            '    Else
            '        sql = " update users set"
            '        sql += " email='" & txtEmail.Text & "'"
            '        sql += " ,name='" & Replace(txtName.Text, "'", "''") & "'"
            '        sql += " ,lastvisited=#" & FormatDateTime(Now, 2) & "#"
            '        sql += " ,contentid=" & lblContentId.Text
            '        sql += " ,article='" & Replace(Left(lblHeadline.Text, 90), "'", "''") & "'"
            '        sql += " where id=" & dr("id")

            '                 cmdUpdate = New OleDbCommand(sql, dbconn)
            '                 cmdUpdate.ExecuteNonQuery()
            '             End If
            '             ProcessCollaboration(lblHeadline.Text, lblContentId.Text, txtEmail.Text, txtName.Text)
            
            '        End If
            
        
            Session("SweetKeyOk") = True
cleanup:
            panelDisplayContent.Visible = True
            panelRegister.Visible = False
            LoadContentView2(lblContentId.Text)
            closeMDB()
        End If
        
    End Sub
    Sub ProcessCollaboration(ByVal sHeadline As String, ByVal sContentId As String, ByVal sEmail As String, ByVal sName As String)
        Dim sMessageContent As String

        sMessageContent = " LSS Registration" & "<br>"
        sMessageContent = sMessageContent & "<b>Headline:</b>" & sHeadline & "<br>"
        sMessageContent = sMessageContent & "<b>Id:</b>" & sContentId & "<br>"
        sMessageContent = sMessageContent & "<b>Name:</b>" & sName & "<br>"
        sMessageContent = sMessageContent & "<b>Email:</b>" & sEmail & "<br>"

        Call SendEmail("dnishimoto@listensoftware.com", "dnishimoto@listensoftware.com", sMessageContent)

    End Sub
    Sub SendEmail(ByVal sToEmail As String, ByVal sFromEmail As String, ByVal sMessageContent As String)
        
        Dim oFromAddress As New MailAddress(sFromEmail)
        Dim oToAddress As New MailAddress(sToEmail)
        Dim Mail As New MailMessage(oFromAddress, oToAddress)
        
 	
        'Mail.From = sFromEmail
        Mail.Subject = "LSS Registration (Contact User)"
			
        Mail.Body = sMessageContent
        Mail.IsBodyHtml = True
        
        Dim smtp As New System.Net.Mail.SmtpClient
        Try
            smtp.Send(Mail)
        Catch ex As Exception
        End Try
    End Sub
    Sub EmailValidate(ByVal objSource As Object, ByVal objArgs As ServerValidateEventArgs)
        Dim mRetVal As Match
	
        Dim regx As Regex = New Regex("\w+@{1,1}[\w-]+?\.{1,1}w*?\.*\w*?\.*\w*?\.*\w*$", RegexOptions.IgnoreCase)

        'lblMessage.text=objArgs.value
	
        mRetVal = regx.Match(objArgs.Value)
	
        If mRetVal.Success Then
            objArgs.IsValid = True
        Else
            objArgs.IsValid = False
        End If

    End Sub
    Sub connectToMDB()
        Dim sConnectionString As String
        sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("app_data/sweeter.mdb")
        
        dbsweeter = New OleDbConnection(sConnectionString)
        dbsweeter.Open()
    End Sub
    Sub closeMDB()
        dbsweeter.Close()
    End Sub
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:label ID=lblErrorMessage runat="server" ForeColor="Red"></asp:label>
    <!-- Begin Official PayPal Seal --><a href="https://www.paypal.com/us/verified/pal=dnishimoto%40listensoftware%2ecom" target="_blank"><img src="https://www.paypal.com/en_US/i/icon/verification_seal.gif" border="0" alt="Official PayPal Seal"></A><!-- End Official PayPal Seal -->
    <asp:HyperLink ID=paypal NavigateUrl="https://www.paypal.com/cgi-bin/webscr?hosted_button_id=DA94QZJ8CH3CY&cmd=_s-xclick" ImageUrl="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" runat="server"></asp:HyperLink>

    <table runat=server>
    <tr>
    <td style="width:auto" align=right>
    
    <asp:TextBox ID=txtQueryHeadline runat=server Visible="false" ></asp:TextBox>
    <asp:button ID=cmdQueryHeadline runat=server Visible="false" Text="Query" OnClick="cmdQueryHeadline_Click" CausesValidation=false />
    
    <asp:Panel ID="PanlGridView" visible=false runat="server" Height="100%" ScrollBars="Vertical" Width="95%">
    <asp:GridView ID="grdContent" runat="server" Width="95%"
       DataKeyNames="contentid"
        DataSourceID="dsContent" 
        AllowPaging="True" 
        OnSelectedIndexChanged="grdContent_SelectedIndexChanged" 
        PageSize="10" 
        AutoGenerateColumns="False" 
        AllowSorting="True" 
    >
        <Columns>
            <asp:CommandField ItemStyle-Width=40 ShowSelectButton="True" />
            <asp:BoundField DataField="contentid" ItemStyle-Width=40 AccessibleHeaderText="Id" HeaderText="Id" Visible=true />
            <asp:BoundField DataField="Headline" AccessibleHeaderText="Headline" HeaderText="Headline" />
            <asp:BoundField DataField="Hits" ItemStyle-Width=40 AccessibleHeaderText="Hits" HeaderText="Hits" />
            <asp:BoundField DataField="SiteId" ItemStyle-Width=40 AccessibleHeaderText="SiteId" Visible=false HeaderText="SiteId" />
        </Columns>
        <PagerSettings PageButtonCount="500" Position="TopAndBottom" />
    </asp:GridView>
    </asp:Panel>
    
    <asp:AccessDataSource ID="dsContent" runat="server" DataFile="~/hrxp/content.mdb"
        SelectCommand="SELECT [contentid], mid(trim([headline]),1,100) as headline, [hits],[siteid] FROM [content] where ucase(headline) like ''+ @QueryHeadline + '%' amd approved=1 order by hits desc"
        >
      <SelectParameters>
         <asp:ControlParameter controlid="txtQueryHeadline" name="QueryHeadline"  Type="String" DefaultValue="" />
        </SelectParameters>

</asp:AccessDataSource>


    </td></tr>
    </table>


    <asp:Panel ID=panelDisplayContent Visible="false" runat="server">
    <center>
    <a href="http://www.amazon.com/exec/obidos/ISBN=B00L05JYWY/listensoftwareso/">
    <asp:image Width="120" runat=server ImageUrl="http://www.listensoftware.com/images/200px.jpg" BorderWidth=0 />
          </a>
    <br />Scott Harrison - The golden apples
        <br />Henry Parker's Robot Wars
    </center>
  
    <table bgcolor="white" width="1000">
    <tr>
    <td style="width:auto">
    <asp:Label ID="lblSiteId" visible=false runat="server"></asp:Label> <asp:Label visible=false ID="lblContentId" runat="server" ></asp:Label>
    <asp:label ID="lblHeadline" runat="server"></asp:label>
    <asp:Label ID="lblSiteName" runat="server" Width="470px"></asp:Label><br />
            <a name="DisplayOutput"></a>
        <asp:Label ID="lblSiteId2" visible=false runat="server"></asp:Label> <asp:Label ID="Label2" runat="server" Visible="false" ></asp:Label>
        <asp:Label ID="lblSiteName2" runat="server" Width="470px"></asp:Label><br />
        <asp:Label ID="lblView2" runat="server" Height="100%" Width="95%" ></asp:Label>
    </td>
    </tr>
    </table>
    </asp:Panel>    
    <asp:Panel id=panelRegister runat="server" Width="1000">
        <center>
         <table border=0 cellpadding=1 cellspacing=1>
         <tr>
         <td colspan=2 align=center valign="middle">
            Members : <asp:Label ID="lblTotalRegisteredMembers" runat="server"></asp:Label><br />
         </td>
         </tr>
        <tr>
            <td valign=top width="200" align=right>Name:</td>
            <td valign=top align=left colspan=2>
                <asp:TextBox TabIndex=2 ID=txtName size="30" MaxLength=100 runat="server"></asp:TextBox>        
            </td>
        </tr>
        <tr>
            <td valign=top width="200" align=right>
            Email:
            </td>
            <td valign=top align=left>
                <asp:TextBox tabindex=1 ID=txtEmail size="30" MaxLength=100 runat="server"></asp:TextBox> 
            </td>
        </tr>

        <tr>
            <td align=center colspan=2>
                <asp:ImageButton tabindex=3 ID=cmdSubmit runat="server" ImageUrl="images/registration.jpg" OnClick="Save_Click"  /><br />
                Register to View<br />
                <asp:Label ID=lblErrorRegisteration runat=server Font-Size=X-Large ForeColor="red"></asp:Label>
            </td>
        </tr>
        </table>
        </center>
    </asp:Panel>
</asp:Content>


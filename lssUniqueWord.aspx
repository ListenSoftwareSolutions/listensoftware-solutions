<%@ Page Language="VB" MasterPageFile="lssMasterPage.master" Title="Unique Word" %>

<%@ Import Namespace="system.data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="Microtheory" %>

<script runat="server">
    Public SelectCommand As OleDbCommand
    Public insertCommand As OleDbCommand
    Public updateCommand As OleDbCommand
    Public deleteCommand As OleDbCommand
    Public ofnc As New cMT_Functions
    Dim dbsqlserverconn As OleDbConnection

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


    Function GetSQL() As String
        Dim SQL As String

        SQL = ""
        If txtSearch.Text <> "" Then
            SQL = "SELECT "
            SQL = SQL & " distinct associatedlinks.uniqueword"
            SQL = SQL & " FROM AssociatedLinks "
            SQL = SQL & " where upper(associatedlinks.uniqueword) like '" & UCase(Trim(txtSearch.Text)) & "%'"
            SQL = SQL & " group by associatedlinks.uniqueword"
            SQL = SQL & " order by associatedlinks.uniqueword"
        Else
            SQL = "SELECT "
            SQL = SQL & " distinct associatedlinks.uniqueword"
            SQL = SQL & " FROM AssociatedLinks "
            SQL = SQL & " group by associatedlinks.uniqueword"
            SQL = SQL & " having count(*)>0"
            SQL = SQL & " order by associatedlinks.uniqueword"
        End If
	
        Return (SQL)
    End Function

    Sub QueryDS()
        dsTransactions.SelectCommand = GetSQL()
        dsTransactions.DataBind()
        dgTransactions.DataBind()
    End Sub
    Sub cmdSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("GridPageIndex") = Nothing
        QueryDS()
        panelAddURL.Visible = False
        panelGrid.Visible = True
    End Sub
    'Sub connectToSpiderMDB()
    '    Dim sConnectionString As String
    '    sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("hrxp/spider.mdb")
    '    dbconn = New OleDbConnection(sConnectionString)
    '    dbconn.Open()
    'End Sub
    'Sub closeSpiderMDB()
    '    If Not dbconn Is Nothing Then
    '        dbconn.Close()
    '    End If
    'End Sub
    Sub BuildUniqueWordList
        dim sql as string
        Dim sb As StringBuilder = New StringBuilder
        Dim dr As OleDbDataReader
        
                sql = "select distinct uniqueword from associatedlinks"
                sql = sql & " order by uniqueword"

        SelectCommand = New OleDbCommand(sql, dbsqlserverconn)
        dr = selectcommand.ExecuteReader
        sb.Append("<ul>")
        Do While dr.Read
                    sb.Append("<li><a href='lssUniqueword.aspx?txtSearch=" & replace(dr("uniqueword")," ","+") & "#Data'>" & ucase(dr("uniqueword")) & "</a>" & "<br><br>")
        loop
        dr.close
        sb.Append("</ul>")

        lblUniqueWord.text=sb.ToString
    end sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sql As String
        Dim sUrl As String
        'Session("SecurityKeyOk") = True
      
        'connectToSpiderMDB()
        Opensqlserver
        If Session("SecurityKeyOk") Is Nothing Then
            
            Response.Redirect("cmwebsite.aspx?txtSearch=" & Request("txtSearch"))
        End If
        panelAddURL.Enabled = True
        

        dsTransactions.SelectCommand = GetSQL()
        
        If IsPostBack = False Then
            Page.SetFocus(cmdSearch)
            BuildUniqueWordList()
            If Request("process") = "UserClick" Then
                sql = "update associatedlinks"
                sql = sql & " set hits=hits+1"
                sql = sql & " where id=" & Request("lssid")
                updateCommand = New OleDbCommand(sql, dbsqlserverconn)
                updateCommand.ExecuteNonQuery()
                sUrl = UCase(Replace(Request("url"), "#", "&"))
                'sUrl = UCase(Request("url"))
                'Response.Write(sUrl)
                'Response.End()
                'If sUrl.Contains("HTTP://") = True Then
                'Response.Redirect("http://" & sUrl)
                'Else
                Response.Redirect(sUrl)
                'End If

            End If
            If Request("process") = "DeleteUrl" Then
                sql = "delete from associatedLinks where id=" & Request("lssid")
                dsTransactions.DeleteCommand = sql
                dsTransactions.Delete()
                'deleteCommand = New OleDbCommand(sql, dbsqlserverconn)
                'deleteCommand.ExecuteNonQuery()
                txtSearch.Text = Request("txtSearch")
                QueryDS()
            End If
            If Not Session("GridPageIndex") Is Nothing Then
                dgTransactions.PageIndex = Session("GridPageIndex")
                dgTransactions.DataBind()
                Session("GridPageIndex") = Nothing
            End If
        End If

        

    End Sub
    Sub Transactions_PageIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("GridPageIndex") = dgTransactions.PageIndex
    End Sub

    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs)
        closesqlserver
        'closeSpiderMDB()
    End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs)
        if Request("txtSearch")<>"" and request("process")="ADD" then
            txtSearch.Text = Request("txtSearch")
            txtUniqueWord.Text = Request("txtSearch")
            panelAddURL.Visible = True
            panelGrid.Visible = False

        elseIf Request("txtSearch") <> "" Then
            txtSearch.Text = Request("txtSearch")
        End If
    End Sub
    Function GenerateLinks(ByVal sUniqueWord As String) As string
        Dim sql As String
        Dim dr As OleDbDataReader
        Dim sb As New StringBuilder
        
        sql = "SELECT "
        sql = sql & " associatedlinks.id,"
        sql = sql & " associatedlinks.uniqueword,"
        sql = sql & " AssociatedLinks.URL,"
        sql = sql & " AssociatedLinks.Description,"
        sql = sql & " AssociatedLinks.Hits"
        sql = sql & " FROM AssociatedLinks "
        sql = sql & " where upper(associatedlinks.uniqueword) like '" & UCase(sUniqueWord) & "%'"
        'sql = sql & " order by uniqueword.uniqueword,associatedlinks.hits desc"
        sql = sql & " order by associatedlinks.description"

        SelectCommand = New OleDbCommand(sql, dbsqlserverconn)
        dr = SelectCommand.ExecuteReader
        
        
        sb.Append("<ul>")
        Do While dr.Read
            If IsDBNull(dr("description")) = False Then
                'sb.Append("<li><a target=_blank href='lssUniqueWord.aspx?lssid=" & dr("id") & "&process=UserClick&url=" & Replace(dr("url"), "&", "#") & "'><font size=-1>" & Left(dr("description"), 100) & "</a>&nbsp;(" & dr("hits") & ")</font>")
                sb.Append("<li><a target=_blank href='" & dr("url") & "'><font size=-1>" & Left(dr("description"), 100) & "</a></font>")
                If Session("SecurityKeyOk") = True Then
                    sb.Append(" <a href='lssuniqueword.aspx?lssid=" & dr("id") & "&txtSearch=" & Replace(txtSearch.Text, " ", "+") & "&process=DeleteUrl&value=" & Request("value") & "'>[X]</a></font>")
                End If
            End If
        Loop
        dr.close
        sb.Append("</ul>")

        
        Return (sb.ToString)
    End Function
    'Sub AddUniqueWord(ByVal sUniqueWord As String)
    '    Dim sql As String
    '    Dim dr As OleDbDataReader

    '    sql = "SELECT "
    '    sql = sql & " associatedlinks.uniqueword"
    '    sql = sql & " FROM associatedlinks"
    '    sql = sql & " where upper(associatedlinks.uniqueword) =" & ofnc.IsNvlString(UCase(sUniqueWord))

    '    SelectCommand = New OleDbCommand(sql, dbsqlserverconn)
    '    dr = SelectCommand.ExecuteReader

    '    If dr.HasRows = False Then
    '        sql = "insert into uniqueword"
    '        sql = sql & " ( uniqueword,category ) "
    '        sql = sql & " values "
    '        sql = sql & " ("
    '        sql = sql & ofnc.IsNvlString(UCase(sUniqueWord))
    '        sql = sql & ",'GENERAL'"
    '        sql = sql & " )"
    '        insertCommand = New OleDbCommand(sql, dbsqlserverconn)
    '        insertCommand.ExecuteNonQuery()
    '    End If
    '    dr.Close()

    'End Sub

    Sub SaveURL_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sql As String
        Dim sUniqueWord As String
        Dim sURL As String
        Dim sDescription As String
        Dim dr As OleDbDataReader
        
        sUniqueWord = txtUniqueWord.Text
        sURL = txtURL.Text
        sDescription = txtDescription.Text
        If sUniqueWord = "" Or sDescription = "" Then
            lblURLErrorMsg.Text = "Unique Word and Description required!"
            Exit Sub
        End If
        'Call AddUniqueWord(sUniqueWord)
        sql = "select * from associatedlinks"
        sql = sql & " where uniqueword=" & ofnc.IsNvlString(sUniqueWord)
        sql = sql & " and url=" & ofnc.isnvlstring(sURL) 

        SelectCommand = New OleDbCommand(sql, dbsqlserverconn)
        dr = SelectCommand.ExecuteReader

        If dr.HasRows = False Then
            sql = "insert into associatedlinks"
            sql = sql & " (uniqueword,description,hits,url,category,generated)"
            sql = sql & " values("
            sql = sql & ofnc.IsNvlString(UCase(sUniqueWord))
            sql = sql & "," & ofnc.IsNvlString(sDescription)
            sql = sql & ",1"
            sql = sql & "," & ofnc.IsNvlString(sURL)
            sql = sql & ",'GENERAL'"
            sql = sql & ",0"
            sql = sql & ")"
            
            dsTransactions.InsertCommand = sql
            dsTransactions.Insert()
            'insertCommand = New OleDbCommand(sql, dbsqlserverconn)
            'insertCommand.ExecuteNonQuery()
        End If
        QueryDS()
        txtURL.Text = "http://"
        txtDescription.Text = ""
        panelAddURL.Visible = False
        panelGrid.Visible = True
        lblURLErrorMsg.Text = ""
        if not Session("ReturnPage") is nothing then
            response.Redirect(Session("ReturnPage"))
        end if
    End Sub
    Sub AddURL_Click(ByVal sender As Object, ByVal e As CommandEventArgs)
        txtUniqueWord.Text = e.CommandArgument
        panelAddURL.Visible = True
        panelGrid.Visible = False
    End Sub
    Sub CancelURL_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        panelAddURL.Visible = False
        panelGrid.Visible = True
        if not Session("ReturnPage") is nothing then
            response.Redirect(Session("ReturnPage"))
        end if
    End Sub
    Function GetHits(ByVal iHits As Integer) As String
        Dim sRetVal As String
       
        sRetVal = FormatNumber(iHits, 0)
        Return (sRetVal)
    End Function

Protected Sub Page_PreInit(ByVal sender As Object, ByVal e As System.EventArgs)

End Sub
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblMessage" runat="server" ForeColor="red"></asp:Label>
    <table width="1200" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td align="right" valign="bottom">
                <asp:TextBox ID="txtSearch" width=300 runat="server"></asp:TextBox>
                &nbsp;
                <asp:Button CausesValidation="false" ID="cmdSearch" OnClick="cmdSearch_Click" runat="server"
                    Text="Search" />
            </td>
        </tr>
    </table>
    <asp:Panel ID="panelAddURL" Visible="false" runat="server">
        <asp:Label ID="lblURLErrorMsg" runat="server" ForeColor="red"></asp:Label>
        <table>
            <tr>
                <td>
                    Unique Word
                </td>
                <td>
                    <asp:TextBox ID="txtUniqueWord" Width="300" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    URL
                </td>
                <td>
                    <asp:TextBox ID="txtURL" Text="http://" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Title/Description
                </td>
                <td>
                    <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="cmdSaveURL" Text="Save" runat="server" OnClick="SaveURL_Click" /><asp:Button
                        ID="cmdCancelURL" CausesValidation="false" Text="Cancel" runat="server" OnClick="CancelURL_Click" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="panelGrid" runat="server">
    
    <asp:HyperLink ID=paypal NavigateUrl="https://www.paypal.com/cgi-bin/webscr?hosted_button_id=DA94QZJ8CH3CY&cmd=_s-xclick" ImageUrl="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" runat="server"></asp:HyperLink>

    <table>
    <tr>
    <td valign=top>
        <h3>Search Words</h3>
        <asp:Label ID=lblUniqueWord runat="server"></asp:Label>
    </td>
    <td valign="top">
        <a name="Data"></a>
        <asp:GridView ID="dgTransactions" DataKeyNames="uniqueword" DataSourceID="dsTransactions"
            BorderColor="Black" BorderWidth="1px" CellPadding="3" Font-Names="Verdana" Width="700px"
            PageSize="5" HeaderStyle-BackColor="#aaaadd" runat="server" AllowPaging="True"
            AllowSorting="True" AutoGenerateColumns="False" OnPageIndexChanged="Transactions_PageIndexChanged"
            Font-Size="10pt">
            <Columns>
                <asp:CommandField ShowEditButton="false" Visible="false" />
                <asp:CommandField ShowDeleteButton="false" Visible="false" />
                <asp:TemplateField HeaderText="Data">
                    <ItemTemplate>
                        <asp:Label ID="lblData" ForeColor="#993300" runat="server" Text='<%#Eval("uniqueword")%>'></asp:Label>
                        <asp:LinkButton ID="lnkbttnAddURL" CommandArgument='<%#Eval("uniqueword")%>' runat="server"
                            Text=" [Add URL]" OnCommand="AddURL_Click"></asp:LinkButton>
                        <br />
                        <asp:Label ID="lblLinks" runat="server" Text='<%#GenerateLinks(Eval("uniqueword"))%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle BackColor="#AAAADD" />
            <PagerSettings Position="TopAndBottom" />
        </asp:GridView>

            <asp:sqldataSource ID="dsTransactions" runat="server" 
ConnectionString="Data Source=davepamn2.db.2594332.hostedresource.com; Initial Catalog=davepamn2; User ID=davepamn2; Password=Kristal7258;"
                SelectCommand=""
                InsertCommand=""
                DeleteCommand="">
            </asp:sqldatasource>
    </td>
    </tr>
    </table>
    </asp:Panel>

</asp:Content>

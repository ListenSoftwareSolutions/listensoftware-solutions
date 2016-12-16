<%@ Page Language="VB" MasterPageFile="~/lssMasterPage.master" Title="Untitled Page" %>
<%@import Namespace="system" %>
<%@ import Namespace="system.data" %>
<%@import namespace="system.data.oledb" %>
<%@import Namespace="system.web" %>
<%@import Namespace="Microtheory"%>

<script runat=server>
    Dim dbconn As OleDbConnection
    Dim cmdSelect As OleDbCommand
    Dim cmdInsert As OleDbCommand
    Dim cmdUpdate As OleDbCommand
    Sub connectToMDB()
        Dim sConnectionString As String
        sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("app_data/feedback.mdb")
        
        dbconn = New OleDbConnection(sConnectionString)
        dbconn.Open()
    End Sub
    Sub closeMDB()
        dbconn.Close()
    End Sub

    Protected Sub cmdLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sql As String
        Dim dr As OleDbDataReader
        Dim sIP As String
        Dim sEmail As String

        
        sql = "select * from [user] where trim(ucase(email))='" & Trim(UCase(txtEmail.Text)) & "'"

        sEmail = UCase(Trim(txtEmail.Text))
        Dim httpEmailCookie As HttpCookie = New HttpCookie("EmailCookies")
        httpEmailCookie.Value = sEmail
        httpEmailCookie.Expires = DateAdd(DateInterval.Day, 60, Now)
        Response.Cookies.Add(httpEmailCookie)
        
        If sEmail <> "" Then
 
                       
            cmdSelect = New OleDbCommand(sql, dbconn)
            dr = cmdSelect.ExecuteReader
        
            sIP = Request.ServerVariables("Remote_Addr")
            If dr.Read Then
                sql = "update [user] set hits=hits+1, ip='" & sIP & "' where ucase(email)='" & Trim(UCase(sEmail)) & "'"
                cmdUpdate = New OleDbCommand(sql, dbconn)
                cmdUpdate.ExecuteNonQuery()
            Else
                sql = "insert into [user] (email,hits,ip) values ('" & Trim(UCase(sEmail)) & "',0,'" & sIP & "')"
                cmdInsert = New OleDbCommand(sql, dbconn)
                cmdInsert.ExecuteNonQuery()
            End If
            
            Session("UserSecurityKeyOk") = True
        End If
        If Request("url") = "" Then
            Response.Redirect("mtdefault.aspx")
        Else
            Response.Redirect(Request("url"))
        End If
    End Sub

    Protected Sub cmdLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("UserSecurityKeyOk") = False
        Response.Cookies("EmailCookies").Expires = DateTime.Now.AddDays(-1)

        Response.Redirect("mtdefault.aspx")
    End Sub

    Protected Sub txtUser_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        connectToMDB()
        If Session("UserSecurityKeyOk") = True Then
            tblLogin.Visible = False
            tblLogout.Visible = True
        Else
            tblLogin.Visible = True
            tblLogout.Visible = False
        End If

    End Sub
    Sub Page_unload(ByVal sender As Object, ByVal e As System.EventArgs)
        closeMDB()
    End Sub
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<table>
<tr>
                <td valign=top>
                       <table id=tblLogin visible=true runat=server>
                       <tr>
                          <td style="font-size:small" valign=top>
                          Email:<asp:TextBox ID=txtEmail runat=server OnTextChanged="txtUser_TextChanged" Width="150px" ></asp:TextBox>
                          <asp:Button ID=cmdLogin text="Login" runat=server OnClick="cmdLogin_Click" />
                          <p>
                          Register and login with your email.  Login gives you login privileges to all services.
                          </p>
                          </td></tr>
                          </table>
                          <table id=tblLogout visible=false runat=server>
                          <tr>
                          <td>
                          <asp:Button ID=cmdLogout text="Signout" runat=server OnClick="cmdLogout_Click" />
                           </td>
                          </tr>
                         </table>
                </td>
</tr>
</table>

</asp:Content>


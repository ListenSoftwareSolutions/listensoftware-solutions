<%@ Page Language="VB" MasterPageFile="~/lssMasterPage.master" Title="Untitled Page" %>
<script runat=server>
    Protected Sub cmdLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If UCase(txtUser.Text) = "DAVEPAMN" And UCase(txtPassword.Text) = "WIN" Then
            Session("SecurityKeyOk") = True
            Response.Redirect("mtdefault.aspx")
        End If
    End Sub

    Protected Sub cmdLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("SecurityKeyOk") = False
        Session("SecurityKeyOk")=nothing
        Response.Redirect("mtdefault.aspx")
    End Sub

    Protected Sub txtUser_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If Session("SecurityKeyOk") = True Then
            tblLogin.Visible = False
            tblLogout.Visible = True
        Else
            tblLogin.Visible = True
            tblLogout.Visible = False
        End If

    End Sub
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<table width="100%">
<tr>
                <td valign="middle" align="center">
                        <asp:Panel ID="Panel1" borderwidth=1 Height=100 width=300 runat="server">

                                    <table id=tblLogin visible=true runat=server>
                                    <tr>
                                    <td style="font-size:small" valign=top>
                                        User:
                                    </td>
                                    <td>
                                        <asp:TextBox ID=txtUser runat=server OnTextChanged="txtUser_TextChanged" Width="75px" ></asp:TextBox>
                                    </td>
                                    </tr>
                                    <tr>
                                    <td style="font-size:small" valign=top>
                                        Password:
                                    </td>
                                    <td>
                                        <asp:TextBox ID=txtPassword  TextMode="password" runat=server Width="79px" ></asp:TextBox>
                                    </td>
                                    </tr>
                                    <tr>
                                        <td colspan=2 align="center">
                                            <asp:Button ID=cmdLogin text="Login" runat=server OnClick="cmdLogin_Click" />
                                        </td>
                                    </tr>
                                    </table>
                                    <table id=tblLogout visible=false runat=server>
                                    <tr>
                                    <td>
                                    <asp:Button ID=cmdLogout text="Signout" runat=server OnClick="cmdLogout_Click" />
                                    </td>
                                    </tr>
                                    </table>
                    </asp:Panel>
                </td>
</tr>
</table>

</asp:Content>


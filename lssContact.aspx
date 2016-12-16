<%@ Page Language="VB" MasterPageFile="~/lssMasterPage.master" Title="LSS Contact" %>
<%@import Namespace="system.data"%>
<%@import Namespace="System.Net.Mail"%>
<%@ MasterType virtualPath="~/lssMasterPage.master"%>
<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        If IsPostBack = False Then
            txtMessage.Text = Session("TheBasics")
        End If

    End Sub
    Public Class cEmail
        public txtName as string
        Public txtEmail As String
        Public txtMessage As String
    End Class
    Sub send_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        lblErrorName.text=""
        if txtName.Text=""
            lblErrorName.text="Name required"
            exit Sub
        end if

        lblErrorEmail.Text = ""
        If txtEmail.Text = "" Then
            lblErrorEmail.Text = "Email required"
            Exit Sub
        End if

        Dim oEmail As New cEmail

        With oEmail
            .txtName=txtName.text
            .txtEmail = txtEmail.Text
            .txtMessage = Left(txtMessage.Text, 2000)
        End With
        ProcessEmail(oEmail)
        Response.Redirect("lssConfirmed.aspx")
    End Sub
    Sub ProcessEmail(ByVal oEmail As cEmail)
        Dim sMessageContent As String = ""
        sMessageContent = " LSS Order:" & "<br>"
        With oEmail
            sMessageContent = sMessageContent & "<b>Name: </b>" & .txtName & "<br>"
            sMessageContent = sMessageContent & "<b>Email: </b>" & .txtEmail & "<br>"
            sMessageContent = sMessageContent & "<b>Message: </b>" & .txtMessage & "<br>"
        End With
        Call SendEmail("dnishimoto@listensoftware.com", "dnishimoto@listensoftware.com", sMessageContent)
    End Sub

    Sub SendEmail(ByVal sFromEmail As String, ByVal sToEmail As String, ByVal sMessageContent As String)

        Dim oFromAddress As New MailAddress(sFromEmail)
        Dim oToAddress As New MailAddress(sToEmail)
        Dim Mail As New MailMessage(oFromAddress, oToAddress)


        'Mail.From = sFromEmail
        Mail.Subject = "LSS Contact"

        Mail.Body = sMessageContent
        Mail.IsBodyHtml = True
        Mail.Bcc.Add("dnishimoto@listensoftware.com")

        Dim smtp As New System.Net.Mail.SmtpClient
        smtp.Host = "relay-hosting.secureserver.net"
        smtp.Credentials = New System.Net.NetworkCredential("davepamn", "nishimoto7258")
        smtp.Send(Mail)
    End Sub



</script>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div class="container-fluid">
    <div class="panel panel-default">
        <div class="panel-heading">Getting Started</div>
        <div class="panel-body">
        
             
            <div class="form-group">
                <label class="control-label col-sm-2" for="Name">Name:</label>
                <asp:TextBox CssClass="col-sm-10" ID="txtName" runat="server" maxlength="100"/>
                        <br />
                        <asp:Label ID="lblErrorName" runat="server" ForeColor="red"></asp:Label>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="Email">Email:</label>
                <asp:TextBox CssClass="col-sm-10" ID="txtEmail" runat="server"  maxlength="100"/>
                        <br />
                        <asp:Label ID="lblErrorEmail" runat="server" ForeColor="red"></asp:Label>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2" for="Message">Message:</label>   
                <asp:TextBox CssClass="col-sm-10" ID="txtMessage" runat="server" Columns=30 Rows=10 TextMode=multiline/>
            </div>
            <div class="form-group text-center">
                        <asp:imagebutton CssClass="btn btn-default" ID="cmdSave" runat="server" imageurl="images/send.jpg" Text="Submit" OnClick="Send_Click" />
            </div>


        </div>
        <div class="panel-footer">We will be contacting you soon</div>
    </div>
   
 
</div>
</asp:Content>


<%@ Page Language="VB" Debug="false" AutoEventWireup="True" MaintainScrollPositionOnPostback="true" MasterPageFile="~/lssMasterPage.master"
    Title="Order Form" %>

<%@import Namespace="System.Net.Mail"%>


    <script runat="server">
        Sub Submit_Click(ByVal sender As Object, ByVal e As EventArgs)
            Dim sMessageContent As String
            sMessageContent = "Email: " & Request("txtEmail") & "<br>"
            sMessageContent = sMessageContent & " Name: " & Request("txtName") & "<br>"
            sMessageContent = sMessageContent & " Message: " & Request("txtMessage") & "<br>"
            sMessageContent = sMessageContent & " Address: " & Request("txtAddress") & "<br>"
            SendEmail(Request("txtEmail"), "dnishimoto@listensoftware.com", sMessageContent)
        End Sub
        Sub SendEmail(ByVal sFromEmail As String, ByVal sToEmail As String, ByVal sMessageContent As String)

            Dim oFromAddress As New MailAddress(sFromEmail)
            Dim oToAddress As New MailAddress(sToEmail)
            Dim Mail As New MailMessage(oFromAddress, oToAddress)


            'Mail.From = sFromEmail
            Mail.Subject = "LSS Image Order Form"

            Mail.Body = sMessageContent
            Mail.IsBodyHtml = True
            Mail.Bcc.Add("dnishimoto@listensoftware.com")

            Dim smtp As New System.Net.Mail.SmtpClient
            smtp.Host = "relay-hosting.secureserver.net"
            smtp.Credentials = New System.Net.NetworkCredential("davepamn", "nishimoto7258")
            Try
                smtp.Send(Mail)
                panelForm.Visible = False
                lblMessage.Text = "I will contact you by email to confirm order"
            Catch ex As Exception

            End Try
        End Sub
    </script>
 <asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="container-fluid">
        <div class="jumbotron">
            <h3>Images will be printed on Cosco Canvas</h3>
            <div class="list-group">
                <div class="list-group-item">1. Select image - Provide me the ID (I will determine, if the photo is for sale)</div>
                <div class="list-group-item">2. You Send $200 to my address</div>
                <div class="list-group-item">3. Cosco will send the canvas by mail to your mailing address</div>
                <div class="list-group-item">Album pictures for Sales: Flowers, Patterns, Places, Travel, and Food</div>
                <div class="list-group-item"><a href="lssImages.aspx">Back to Images</a></div>
            </div>
        </div>
        <asp:label ID="lblMessage" runat="server" ForeColor="Blue" Font-Size="Large"></asp:label>
        <asp:PANEL ID="panelForm" runat="server">
	        <div class="form-group">
		        <label for="name" class="col-sm-2 control-label">Name</label>
		        <div class="col-sm-10">
			        <input type="text" class="form-control" id="txtName" name="txtName" placeholder="First & Last Name" value="">
		        </div>
	        </div>
	        <div class="form-group">
		        <label for="email" class="col-sm-2 control-label">Email</label>
		        <div class="col-sm-10">
			        <input type="email" class="form-control" id="txtEmail" name="txtEmail" placeholder="example@domain.com" value="">
		        </div>
	        </div>
	        <div class="form-group">
		        <label for="message" class="col-sm-2 control-label">Description of Image you want printed</label>
		        <div class="col-sm-10">
			        <textarea class="form-control" rows="4" name="txtMessage"></textarea>
		        </div>
	        </div>
	        <div class="form-group">
		        <label for="message" class="col-sm-2 control-label">Address</label>
		        <div class="col-sm-10">
			        <textarea class="form-control" rows="4" name="txtAddress"></textarea>
		        </div>
	        </div>

	        <div class="form-group">
		        <div class="col-sm-10 col-sm-offset-2">
			        <asp:button CssClass="btn btn-default" runat="server" id="txtSubmit" text="Send" OnClick="Submit_Click" />
		        </div>
	        </div>
            </asp:PANEL>
</div>

    </asp:Content>


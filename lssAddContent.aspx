<%@ Page Language="VB" MasterPageFile="lssMasterPage.master" Title="Add Content" %>
<%@ import namespace="system.data" %>
<%@ import namespace="system.data.oledb" %>
<%@import Namespace="Microtheory"%>
<script runat="server">
    Dim dbconn As OleDbConnection
    Dim cmdSelect As OleDbCommand
    Dim cmdUpdate As OleDbCommand
    Dim cmdInsert As OleDbCommand
    Dim objMTFunc As New cMT_Functions
    
    Sub LoadListBox(ByRef lbxDropDownList As DropDownList, ByVal sql As String, ByVal sTextField As String, ByVal sValueField As String)
        Dim dr As OleDbDataReader
        
        cmdSelect = New OleDbCommand(sql, dbconn)
        dr = cmdSelect.ExecuteReader

        With lbxDropDownList
            .AutoPostBack = True
            .DataTextField = sTextField
            .DataValueField = sValueField
            .DataSource = dr
            .DataBind()
        End With
        dr.Close()

    End Sub
    Sub LoadParameters()
        Dim sql As String
        
        sql = "select * from sitemanager"
        
        LoadListBox(lbxSiteId, sql, "name", "Siteid")
        
        sql = "select * from content"
        If chkFilter.Checked = True Then
            sql = sql & " where (approved=0 or approved is null)"
        Else
            sql = sql & " where approved=1"
        End If
        If lbxSiteId.SelectedValue <> "" Then
            sql = sql & " and siteid=" & lbxSiteId.SelectedValue
        End If

        LoadListBox(lbxContentId, sql, "headline", "contentid")

        
        
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        OpenMDB(Server.MapPath("hrxp/content.mdb"))
        If IsPostBack = False Then
            LoadParameters()
        End If
    End Sub
    Protected Sub Page_UnLoad(ByVal sender As Object, ByVal e As System.EventArgs)
        closeMDB()
    End Sub
    Public Sub OpenMDB(ByVal sDB As String)
        Dim sConnectionString As String
        sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & sDB

        dbconn = New OleDbConnection(sConnectionString)
        dbconn.Open()
    End Sub
    Public Sub closeMDB()
        If Not dbconn Is Nothing Then
            dbconn.Close()
        End If
    End Sub


</script>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<TABLE cellSpacing=1 cellPadding=1 width="500" border=1 bgcolor="#F7EEBB">
  <TR>
    <TD style="WIDTH: 130px" width=130 valign=top>Content Id:		
		<asp:dropdownlist id=lbxContentId Width=300 runat=server/>
     </TD>
    <TD>
			Filter On (Awaiting) <asp:checkbox id=chkFilter runat=server checked=false />
			<asp:button id=cmdApplyFilter text="Apply Filter" runat=server/>
    </TD>
    <td>Site Id</td>
    <td>
			<asp:dropdownlist id="lbxSiteId" runat=server/>
		<asp:button ID=cmdSetup text="Setup" runat=server />
    </td>
  </TR>

  <TR>
    <TD colspan=4>Headline: 
    <asp:textbox id=txtHeadline runat=server width=100 maxlength=255 />
    </TD>
  </TR>

  <TR>
    <TD colspan=4 valign=top>Overview: 
    <asp:textbox id=txtOverview TextMode=MultiLine rows=4 columns=40 width=100 maxlength=255 runat=server/>
    </TD>
  </TR>
 
  <TR>
    <TD>Author</TD>
    <TD>
    <asp:textbox id=txtAuthor maxlength=80 runat=server/>
    </TD>
    <TD>Web Site</TD>
    <TD>
    <asp:textbox ID=txtWebUrl maxlength=80 runat=server/>
    </TD>
  </TR>
  <TR>
    <TD>TypeId</TD>
    <TD colspan=3>
		<asp:dropdownlist id="lbxTypeId" runat=server />
	</td>
   </tr>
   <tr>
	<td colspan=4>
		Approved <asp:checkbox id=chkApproved runat=server  checked=true />
	</td>
   </tr>
   <tr>
		<td colspan=4>
   
			<table border="1" width="100%">
				<tr>
					<td align="right" bgcolor="#d3d3d3">
						<font size="4" color="black" face="arial,helvetica"><b>Category</b></font>
					</td>
					<td>
						<asp:dropdownlist id="xmlSoftware_Type" runat=server>
						<asp:listitem value="Application" text="Application"></asp:listitem>
						<asp:listitem value="Content Management" text="Content Management"></asp:listitem>
						<asp:listitem value="DBMS/SQL" text="DBMS/SQL"></asp:listitem>
						<asp:listitem VALUE="Components" text="Java/ActiveX Components"></asp:listitem>
						<asp:listitem VALUE="Enterprise" text="Enterprise Tools"></asp:listitem>
						<asp:listitem VALUE="Internet" text="Internet"></asp:listitem>
						<asp:listitem value="Networking" text="Networking"></asp:listitem>
						<asp:listitem VALUE="Operating Systems" text="Operating Systems"></asp:listitem>
						<asp:listitem VALUE="Tools" text="Tools"></asp:listitem>
						<asp:listitem VALUE="Utilities" text="Utilities"></asp:listitem>
						</asp:dropdownlist>
					</td>
				</tr>
				<tr>
					<td align="right" bgcolor="#d3d3d3">
						<font size="4" color="black" face="arial,helvetica"><b>Company</b></font>
					</td>
					<td>
						<asp:textbox id="xmlCompany_Name" width="30" runat=server />
					</td>
				</tr>
				<tr>
					<td align="right" bgcolor="#d3d3d3">
						<font size="4" color="black" face="arial,helvetica"><b>Software Name</b></font>
					</td>
					<td>
						<asp:textbox id="xmlSoftware_Name" width="30" runat=server />
					</td>
				</tr>
				<tr>
					<td align="right" bgcolor="#d3d3d3">
						<font size="4" color="black" face="arial,helvetica"><b>Price</b></font>
					</td>
					<td>
						<asp:textbox id="xmlPrice" runat=server width="30" />
					</td>
				</tr>
				<tr>
					<td align="right" bgcolor="#d3d3d3">
						<font size="4" color="black" face="arial,helvetica"><b>eMail</b></font>
					</td>
					<td>
						<asp:textbox id="xmlEmail" width="30" runat=server />
					</td>
				</tr>
				<tr>
					<td align="right" bgcolor="#d3d3d3">
						<font size="4" color="black" face="arial,helvetica"><b>Phone</b></font>
					</td>
					<td>
						<asp:textbox id="xmlPhone" runat=server width="30" />
					</td>
				</tr>
				<tr>
					<td align="right" bgcolor="#d3d3d3">
						<font size="4" color="black" face="arial,helvetica"><b>Website URL</b></font>
					</td>
					<td>
						<asp:textbox id="xmlWebsite_Url" runat=server width="30"/>
					</td>		
				</tr>
				<tr>
					<td align="right" bgcolor="#d3d3d3">
						<font size="4" color="black" face="arial,helvetica"><b>Image URL</b></font>
					</td>
					<td>
						<asp:textbox id="xmlImage_Url" runat=server />
					</td>		
				</tr>
				<tr>
					<td align="right" bgcolor="#d3d3d3">
						<font size="4" color="black" face="arial,helvetica"><b>Describe the Software?</b></font>
					</td>
					<td>
						<asp:textbox id="xmlSoftware_Description" TextMode=multiline columns="20" rows="5" Wrap=true runat=server/>	
					</td>
				</tr>
				<tr>
					<td align="right" bgcolor="#d3d3d3">
						<font size="4" color="black" face="arial,helvetica"><b>Feature List</font><br><font size="4" color="green">(Comma Separate)</b></font>
					</td>
					<td>
						<asp:textbox id="xmlFeature_List" columns="20" rows="5" wrap=true runat=server />	
					</td>
				</tr>

				<tr>
					<td align="right" bgcolor="#d3d3d3">
						<font size="4" color="black" face="arial,helvetica"><b>Software Requirements</font><br><font size="4" color="green">(Comma Separate)</b></font>
					</td>
					<td>
						<asp:textbox id="xmlSoftware_Requirements" columns="20" rows="5" wrap=true runat=server/>	
					</td>
				</tr>

	      </table>
	   </td>
   </tr>
   <tr>
		<td colspan=4 valign=top>Content: (HTML)
			<asp:button id="cmdPreview" text="Preview" runat=server/>
			<asp:button id=cmdParse text="< > Convert" runat=server/>
			<asp:button ID=cmdSave text="Save" runat=server />
			<asp:button ID=cmdDelete text="Delete" runat=server />
			<asp:textbox id=txtContent TextMode=multiline rows=15 columns=75 runat=server/>
		</TD>
      </TR>
  
   </TABLE>

</asp:Content>


<%@ Page Language="VB" MasterPageFile="~/lssMasterPage.master" Title="Add Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
	<table width="100%" border=0>
	
	
	<tr>
		<td valign="top" align="center" colspan="2">
			<asp:button runat=server id="submit" text="Send" />
				<asp:button runat=server text="Delete" id=cmdAction />
		</td>
	</tr>

	<tr>
		<td>
		</td>
		<TD>
		Filter On (Awaiting) <asp:checkbox runat=server id=chkFilterOn text="1" checked=true />
		</TD>
		<td>
		Approved <asp:checkbox runat=server id=chkApproved text=1 checked=true />
		</td>
	</tr>
	<tr>
		<td>
			Business Name
		</td>
		<td>
			<asp:textbox runat=server ID="txtBusinessName" MAXLENGTH=100 />
		</td>
		<td bgcolor="#99cc99">* Not in ALL CAPS</td>
	</tr>
	<tr>
		<td>
			Website Name
		</td>
		<td>
			<asp:textbox runat=server ID="WebsiteName" MAXLENGTH=100 />
		</td>
		<td bgcolor="#99cc99">
			* Not in ALL CAPS
		</td>
	</tr>
	<tr>
		<td>
			Website url
		</td>
		<td>
			<asp:textbox runat=server ID="txtWebsiteURL"  MAXLENGTH=100 />
		</td>
		<td bgcolor="#99cc99">
			* Website url
		</td>
	</tr>
	<tr>
		<td>
			Overview
		</td>
		<td>
			<asp:textbox runat=server ID="txtOverview"  maxlength=255 />
		</td>
		<td bgcolor="#99cc99">
			* 255 characters
		</td>
	</tr>
	<tr>
		<td>
			Webmaster
		</td>
		<td>
			<asp:textbox runat=server id="txtAuthor" MAXLENGTH=100 />
		</td>
		<td bgcolor="#99cc99">
			* Web Master
		</td>
	</tr>
	<tr>
		<td>
			Banner url
		</td>
		<td>
			<asp:textbox runat=server id="txtBannerUrl" MAXLENGTH=100 />
		</td>
		<td bgcolor="#99cc99">
			* Banner url
		</td>
	</tr>
	<tr>
		<td>
			Site Classification
		</td>
		<td>
			<asp:dropdownlist runat=server id="lbxTypeId" />
		</td>
		<td bgcolor="#99cc99">
			* <br><a href="mailto:dnishimoto@listensoftware.com">New category?
		</td>	
	</tr>
	<tr>
		<td>
			Phone   
		</td>
		<td>
			<asp:textbox runat=server ID="txtPhone" />
		</td>
		<td bgcolor="#99cc99">
			* Include Area/International Code
		</td>
	</tr>
	<tr>
		<td>
			Fax     
		</td>
		<td>
			<asp:textbox runat=server ID="txtFax"    />
		</td>
		<td bgcolor="#99cc99">
			* Include Area/International Code
		</td>
	</tr>
	<tr>
		<td>
			Email   
		</td>
		<td>
			<asp:textbox runat=server ID="txtEmail"  />
		</td>
		<td bgcolor="#99cc99">
			* Preferred Email</a>
		</td>
	</tr>
	<tr>
		<td>
			Address Line 1
		</td>
		<td>
			<asp:textbox runat=server ID="txtAddress1"  />
		</td>
		<td bgcolor="#99cc99">
			* Street Address 1
		</td>
	</tr>
	<tr>
		<td>
			Address Line 2
		</td>
		<td>
			<asp:textbox runat=server ID="txtAddress2"  />
		</td>
		<td bgcolor="#99cc99">
			* Street Address 2
		</td>
	</tr>
	<tr>
		<td>
			City    
		</td>
		<td>
			<asp:textbox runat=server ID="txtCity"  />
		</td>
		<td bgcolor="#99cc99">
			* City
		</td>
	</tr>
	<tr>
		<td>
			State   
		</td>
		<td>
		<asp:textbox runat=server ID="txtState"  />
		<asp:DropDownList id="lbxState" runat=server >
 		<asp:ListItem value="None">None</asp:listitem>
 		<asp:listitem value="Alabama">Alabama</asp:listitem>
        <asp:listitem value="Alaska">Alaska</asp:listitem>
        <asp:listitem value="Arizona">Arizona</asp:listitem>
        <asp:listitem value="Arkansas">Arkansas</asp:listitem>
        <asp:listitem value="California">California</asp:listitem>
        <asp:listitem value="Colorado">Colorado</asp:listitem>
        <asp:listitem value="Connecticut">Connecticut</asp:listitem>
        <asp:listitem value="Delaware">Delaware</asp:listitem>
        <asp:listitem value="District of Columbia">District of Columbia</asp:listitem>
        <asp:listitem value="Florida">Florida</asp:listitem>
        <asp:listitem value="Georgia">Georgia</asp:listitem>
        <asp:listitem value="Hawaii">Hawaii</asp:listitem>
        <asp:listitem value="Idaho">Idaho</asp:listitem>
        <asp:listitem value="Illinois">Illinois</asp:listitem>
        <asp:listitem value="Indiana">Indiana</asp:listitem>
        <asp:listitem value="Iowa">Iowa</asp:listitem>
        <asp:listitem value="Kansas">Kansas</asp:listitem>
        <asp:listitem value="Kentucky">Kentucky</asp:listitem>
        <asp:listitem value="Louisiana">Louisiana</asp:listitem>
        <asp:listitem value="Maine">Maine</asp:listitem>
        <asp:listitem value="Maryland">Maryland</asp:listitem>
        <asp:listitem value="Massachusetts">Massachusetts</asp:listitem>
        <asp:listitem value="Michigan">Michigan</asp:listitem>
        <asp:listitem value="Minnesota">Minnesota</asp:listitem>
        <asp:listitem value="Mississippi">Mississippi</asp:listitem>
        <asp:listitem value="Missouri">Missouri</asp:listitem>
        <asp:listitem value="Montana">Montana</asp:listitem>
        <asp:listitem value="Nebraska">Nebraska</asp:listitem>
        <asp:listitem value="Nevada">Nevada</asp:listitem>
        <asp:listitem value="New Hampshire">New Hampshire</asp:listitem>
        <asp:listitem value="New Jersey">New Jersey</asp:listitem>
        <asp:listitem value="New Mexico">New Mexico</asp:listitem>
        <asp:listitem value="New York">New York</asp:listitem>
        <asp:listitem value="North Carolina">North Carolina</asp:listitem>
        <asp:listitem value="North Dakota">North Dakota</asp:listitem>
        <asp:listitem value="Ohio">Ohio</asp:listitem>
        <asp:listitem value="Oklahoma">Oklahoma</asp:listitem>
        <asp:listitem value="Oregon">Oregon</asp:listitem>
        <asp:listitem value="Pennsylvania">Pennsylvania</asp:listitem>
        <asp:listitem value="Puerto Rico">Puerto Rico</asp:listitem>
        <asp:listitem value="Rhode Island">Rhode Island</asp:listitem>
        <asp:listitem value="South Carolina">South Carolina</asp:listitem>
        <asp:listitem value="South Dakota">South Dakota</asp:listitem>
        <asp:listitem value="Tennessee">Tennessee</asp:listitem>
        <asp:listitem value="Texas">Texas</asp:listitem>
        <asp:listitem value="Utah">Utah</asp:listitem>
        <asp:listitem value="Vermont">Vermont</asp:listitem>
        <asp:listitem value="Virgin Islands">Virgin Islands</asp:listitem>
        <asp:listitem value="Virginia">Virginia</asp:listitem>
        <asp:listitem value="Washington">Washington</asp:listitem>
        <asp:listitem value="West Virginia">West Virginia</asp:listitem>
        <asp:listitem value="Wisconsin">Wisconsin</asp:listitem>
        <asp:listitem value="Wyoming">Wyoming</asp:listitem>
		</asp:dropdownlist>
		</td>
		<td bgcolor="#99cc99">
			* (US) State
		</td>
	</tr>
	<tr>
		<td>
			Zipcode
		</td>
		<td>
			<asp:textbox runat=server ID="txtZipcode"  />
		</td>
		<td bgcolor="#99cc99">
			* Zipcode
		</td>
	</tr>
	<tr>
		<td>
			Country
		</td>
		<td>
			<asp:textbox runat=server ID="txtCountry" />
		</td>
		<td bgcolor="#99cc99">
			* Non Abbrevated
		</td>
	</tr>
	<tr>
		<td>
			Product or Service Title
		</td>
		<td>
			<asp:textbox runat=server ID="txtProductLine1"  />
		</td>
		<td bgcolor="#99cc99">
			* Product or Service - Title 1 of 3
		</td>
	</tr>
	<tr>
		<td>
			Product or Service <b>URL</b> 
		</td>
		<td>
			<asp:textbox runat=server ID="txtProductUrlLine1"  />
		</td>
		<td bgcolor="#99cc99">
			* Product or Service - Url 1 of 3
		</td>
	</tr>
	<tr>
		<td>
			Product or Service Title
		</td>
		<td>
			<asp:textbox runat=server ID="txtProductLine2"  />
		</td>
		<td bgcolor="#99cc99">
			* Product or Service - Title 2 of 3
		</td>
	</tr>
	<tr>
		<td>
			Product or Service <b>URL</b>
		</td>
		<td>
			<asp:textbox runat=server ID="txtProductUrlLine2"  />
		</td>
		<td bgcolor="#99cc99">
			* Product or Service - Url 2 of 3
		</td>
	</tr>
	<tr>
		<td>
			Product or Service Title
		</td>
		<td>
			<asp:textbox runat=server ID="txtProductLine3"  />
		</td>
		<td bgcolor="#99cc99">
			* Product or Service - Title 3 of 3
		</td>
	</tr>
	<tr>
		<td>
			Product or Service <b>URL</b>
		</td>
		<td>
			<asp:textbox runat=server ID="txtProductUrlLine3"  />
		</td>
		<td bgcolor="#99cc99">
			* Product or Service - Url 3 of 3
		</td>
	</tr>
</table>

</asp:Content>


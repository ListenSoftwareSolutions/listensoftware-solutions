<%@ Page Language="VB" MasterPageFile="lssMasterPage.master" Title="LSS" %>
<%@import namespace="system.data" %>
<%@import namespace="system.data.oledb" %>

<script runat=server>

public sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
  If IsPostBack = False Then  
    queryDS
  end if
end sub
sub queryDS()
    dim sql as string=""

    sql="select * from keyudc"

    With dsForm
            .SelectCommand = sql
            .Select(DataSourceSelectArguments.Empty)
            .DataBind()
    End With
    dgform.databind()
end sub

sub cmdQuery_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    queryDS
end sub
sub Edit_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    Dim mylinkButton As LinkButton
    dim selectOleCommand as OleDbCommand
    dim dr as oledbdatareader
    dim sql as string=""
    static iErrorCount as integer=0

    lblErrorMessage.text=""
    pnlInputForm.visible=true
    pnlGrid.visible=false
    cmdDelete.visible=true

    txtInputKey.enabled=false
    txtInputDescription1.enabled=true
    txtinputSystem.enabled=false
       
    mylinkButton = sender
    lblId.text= mylinkButton.CommandArgument

     Try
            Using conn As OleDbConnection = New OleDbConnection(ConfigurationManager.ConnectionStrings("DataStoreConnectionString").ConnectionString)
                conn.Open()
                sql="select * from keyudc where id=?" 
       
                selectOleCommand = New OleDbCommand(sql, conn)
                selectOleCommand.CommandType = CommandType.Text
                SetParameter(selectOleCommand, "Int32", lblId.text, "@Id")
                dr = selectOleCommand.ExecuteReader

                Do While dr.Read
                        txtInputKey.text = dr("key")
                        txtInputDescription1.text=nullstring(dr("description1"))
                        txtInputSystem.text=nullstring(dr("system"))
                Loop
                dr.Close()



            End Using
        Catch ex As Exception
            If iErrorCount = 0 Then
                'EmailError(ex.Message.ToString)
            End If
            iErrorCount += 1
        End Try
end sub
function NullString(oVal as object) as string
        dim sRetVal as string=""
        if isdbnull(oVal)=true then
            sRetVal=""
        else
            sRetVal=oVal
        end if
        return(sRetVal)
    end function
    function NullNumber(oVal as object) as double
        dim iRetVal as double=0
        if isdbnull(oVal)=true then
            iRetVal=0
        else
            iRetVal=oVal
        end if
        return(iRetVal)
    end function
    function NullDate(oVal as object) as date
        dim dRetVal as date
        if isdbnull(oVal)=true then
            dRetVal=nothing
        else
            dRetVal=oVal
        end if
        return(dRetVal)
    end function
 Sub SetParameter(ByRef oSelectCommand As oleDBCommand, sType As String, sValue As String, sName As String)
        Static iErrorCount As Integer = 0

        Try
            Dim oParameter As OleDBParameter = oSelectCommand.CreateParameter

            With oParameter
                If sType = "Int32" Then
                    .DbType = DbType.Int32
                    .Value = sValue
                    .ParameterName = sName
                ElseIf sType = "String" Then
                    .DbType = DbType.String
                    .Value = sValue
                    .ParameterName = sName
                Elseif sType="Date" then
                    .DbType = DbType.Date
                    .Value=sValue
                    .ParameterName = sName
                End If

            End With
            oSelectCommand.Parameters.Add(oParameter)
        Catch ex As Exception
            If iErrorCount = 0 Then
                'Error handler
            End If
            iErrorCount += 1
        End Try
    End Sub
sub Save_OnClick(ByVal sender As Object, ByVal e As System.EventArgs)
    dim UpdateOleCommand as OleDbCommand
    dim InsertOleCommand as OleDbCommand

    dim sql as string=""
    static iErrorCount as integer=0

    lblErrorMessage.text=""
    if txtINputKey.text="" then
        lblErrorMessage.text+="Key is Required<br>"
    end if
    if txtInputDescription1.text="" then
        lblErrorMessage.text+="Description 1 is Required<br>" 
    end if
    if txtInputSystem.text="" then
        lblErrorMessage.text+="System is Required<br>"
    end if
    if lblErrorMessage.text<>"" then
         exit sub
    end if


      Try
            Using conn As OleDbConnection = New OleDbConnection(ConfigurationManager.ConnectionStrings("DataStoreConnectionString").ConnectionString)
                conn.Open()

                if lblId.text="Add New" then
                    sql="insert into keyudc ("
                    sql = sql & " [key] "
                    sql = sql & " ,[system]"
                    sql = sql & " ,[description1]"
                    sql = sql & " )"
                    sql=sql & " values("
                    sql=sql & " ?" 
                    sql=sql & " ,?"
                    sql=sql & " ,?"
                    sql=sql & ")"
                    
                    InsertOleCommand = New OleDbCommand(sql, conn)
    
                    SetParameter(InsertOleCommand, "String", txtInputKey.text, "@Key")
                    SetParameter(InsertOleCommand, "String", txtInputSystem.text, "@System")
                    SetParameter(InsertOleCommand, "String", txtInputDescription1.text, "@Description1")
                          
                    InsertOleCommand.executeNonQuery()
                else
                    sql="update keyudc Set"
                    sql=sql & " description1=?"
                    sql=sql & " where id=?" 
        
                    UpdateOleCommand = New OleDbCommand(sql, conn)
    
                    SetParameter(UpdateOleCommand, "String", txtInputDescription1.text, "@Description1")
                    SetParameter(UpdateOleCommand, "Int32", lblId.text, "@Id")
        
                    UpdateOleCommand.executeNonQuery()
                end if

                QueryDS()

            End Using
        Catch ex As Exception
            If iErrorCount = 0 Then
                lblErrorMessage.text=ex.Message.ToString
            End If
            iErrorCount += 1
        End Try
        if lblErrorMessage.text="" then
            pnlInputForm.visible=false
            pnlGrid.visible=true
        end if
end sub
sub Delete_OnClick(ByVal sender As Object, ByVal e As System.EventArgs)
    pnlInputForm.visible=false
    pnlGrid.visible=true

     dim DeleteOleCommand as OleDbCommand
   
    dim sql as string=""
    static iErrorCount as integer=0

    lblErrorMessage.text=""
    if isnumeric(lblId.text)=false then
        lblErrorMessage.text="ID must be numeric<br>"
    end if
    if lblId.text="" then
        lblErrorMessage.text="Id is missing<br>"
    end if
    if lblErrorMessage.text<>"" then
        exit sub
    end if


      Try
            Using conn As OleDbConnection = New OleDbConnection(ConfigurationManager.ConnectionStrings("DataStoreConnectionString").ConnectionString)
                conn.Open()

               
                    sql="delete from keyudc "
                    sql=sql & " where id=?"
                    
                    
                    DeleteOleCommand = New OleDbCommand(sql, conn)
    
                    SetParameter(DeleteOleCommand, "Int32", lblId.text, "@Id")
                                   
                    DeleteOleCommand.executeNonQuery()
               

                QueryDS()

            End Using
        Catch ex As Exception
            If iErrorCount = 0 Then
                lblErrorMessage.text=ex.Message.ToString
            End If
            iErrorCount += 1
        End Try
end sub
sub Cancel_OnClick(ByVal sender As Object, ByVal e As System.EventArgs)
    pnlInputForm.visible=false
    pnlGrid.visible=true
end sub
sub InsertRow_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    pnlInputForm.visible=true
    pnlGrid.visible=false
    lblId.text="Add New"
    txtInputKey.enabled=true
    txtInputDescription1.enabled=true
    txtinputSystem.enabled=true
    txtInputKey.text=""
    txtINputDescription1.text=""
    txtInputSystem.text=""
    cmdDelete.visible=false
end sub
      
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<h3>UDC</h3>

<asp:panel id="pnlInputForm" visible=false runat=server>
<table>
		<tr>
		<td>Id</td>
		<td>
		    <asp:label id=lblId runat=server />
        </td>
		</tr>
		<tr>
		<td>Key</td>
		<td>
		    <asp:textbox id=txtInputKey runat=server/>
		</td>
		</tr>
        <tr>
		<td>Description 1</td>
		<td>
		    <asp:textbox id=txtInputDescription1 runat=server/>
		</td>
		</tr>
        <tr>
		<td>System</td>
		<td>
		    <asp:textbox id=txtInputSystem runat=server/>
		</td>
		</tr>
		<tr>
        <td colspan=2>
        <asp:Button ID=cmdSave runat=server Text="Save" OnClick="Save_OnClick" />
        <asp:Button ID=cmdDelete visible=false runat=server Text="Delete" OnClick="Delete_OnClick" />
        <asp:Button ID=cmdCancel runat=server  CausesValidation=false Text="Cancel" OnClick="Cancel_OnClick" />
        <br><asp:label id="lblErrorMessage" runat=server forecolor=red/>
        </td>
        </tr>
</table>
</asp:panel>


<asp:Panel ID="pnlGrid" runat=server>
    <table width="700px" border=1>
    <tr>
        <td>
            <asp:LinkButton CssClass="btn btn-primary" OnClick="InsertRow_Click" visible=true Text="Insert" runat="server" ID="btInsert" ></asp:LinkButton> 
            <asp:label ID=lblUserCreateMessage runat=server ></asp:label>
        </td>
        <td align=right>
            Query:<asp:TextBox ID=txtQuery runat=server Width="298px" ></asp:TextBox>
            <asp:button ID=cmdQuery runat=server Text="Query" OnClick="cmdQuery_Click" />
        </td>
    </tr>
    <tr>
    <td colspan=2>
    
    
    <asp:GridView id="dgForm" 
			DataKeyNames="Id"
			DataSourceId="dsForm"
			BorderColor="Black"
            BorderWidth="1px"
            CellPadding="3"
            Font-Names="Verdana"
            Font-Size="12pt"
            Width="100%"
            PageSize=10
            CssClass="table"
            HeaderStyle-BackColor="#aaaadd"
            runat="server"
            AllowPaging="True"
            AllowSorting="True"
            AutogenerateColumns="False" 
            
            >
            <columns>
            <asp:CommandField  SelectText="Definitions" ShowSelectButton="False" Visible="False" />
            <asp:CommandField ShowEditButton="false" visible="false" />
            <asp:CommandField ShowDeleteButton="false" visible="false" />
            <asp:TemplateField HeaderText="Action" >
                <ItemTemplate>
                    <asp:linkbutton ID="cmdEdit" runat="server" CommandArgument='<%#Eval("id")%>' onclick="Edit_Click" Text="Edit" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Id" >
                <ItemTemplate>
                    <asp:Label ID="lblId" runat="server" Text='<%# Bind("Id") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Key">
                <ItemTemplate>
                    <asp:Label ID="lblKey" runat="server" Text='<%# Bind("key") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="System">
                <ItemTemplate>
                    <asp:Label ID="lblSystem" runat="server" Text='<%# Bind("system") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Description 1">
                <ItemTemplate>
                    <asp:Label ID="lblDescription1" runat="server" Text='<%# Bind("description1") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
           
        </columns>
        <HeaderStyle BackColor="#AAAADD" />
        <PagerSettings Position="TopAndBottom" />
</asp:GridView>

<asp:sqlDataSource id="dsForm" RunAt="Server"
    ConnectionString="<%$ appSettings:GridConnectionString %> " 
    ProviderName="System.Data.SqlClient" 
    selectcommand="" 
    DeleteCommand=""
    UpdateCommand=""
    InsertCommand=""
>
    <DeleteParameters>
        <asp:Parameter name="@Id" Type="Int32" />
    </DeleteParameters>

    <UpdateParameters>
        <asp:Parameter name="@Key" Type="String" />
        <asp:Parameter name="@Description1" Type="String" />
       
        <asp:Parameter name="@Id" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:Parameter name="@Key" Type="String" />
        <asp:Parameter name="@Description1" Type="String" />
    </InsertParameters>
</asp:sqlDataSource>
	</td>
	</tr>
    </table>
</asp:panel>

</asp:Content>
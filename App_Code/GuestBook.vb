Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports System.Collections.Generic
Imports system.data
Imports system.data.oledb


' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://www.listensoftware.com/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class GuestBook
    Inherits System.Web.Services.WebService

    Public  dbconn As OleDbConnection

    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function HelloWorld() As String
      dim TheSerializer as JavaScriptSerializer  = new JavaScriptSerializer()
        dim oData as new cData
        oData.element="Hello World"
        Return TheSerializer.serialize(oData)
    End Function

    <WebMethod()> _
    Function GetObjectList(sCommand As String) As String
        Dim oList As New List(Of cData)
        Dim oData As cData
        Dim TheSerializer As JavaScriptSerializer = New JavaScriptSerializer()

        oData = New cData
        oData.element = "Thanks for visiting Listen Software Solutions. We hope you will become one of our valued customers, in the future."
        oList.Add(oData)

        oData = New cData
        oData.element = "We like to see our customers satisified as the watch their data reliabily being gathered."
        oList.Add(oData)

        Return (TheSerializer.serialize(oList))

    End Function

    <WebMethod()> _
    Function GetLinksList() As String
        Dim oList As New List(Of cData)
        Dim TheSerializer As JavaScriptSerializer = New JavaScriptSerializer()

        oList.Add(CreateLink("Ado.htm", "Ado"))
        oList.Add(CreateLink("Android.htm", "Android"))
        oList.Add(CreateLink("Apple.htm", "Apple"))
        oList.Add(CreateLink("ArtificialIntelligence.htm", "Artificial Intelligence"))
        oList.Add(CreateLink("Asp.htm ", "Asp"))
        oList.Add(CreateLink("Asp.Net.htm", "Asp.Net"))
        oList.Add(CreateLink("Bionics.htm", "Bionics"))
        oList.Add(CreateLink("BusinessIntelligence.htm", "Business Intelligence"))
        oList.Add(CreateLink("CognitiveComputing.htm ", "cognitive Computing"))
        oList.Add(CreateLink("Computer.htm", "computer"))
        oList.Add(CreateLink("Consulting.htm", "consulting"))
        oList.Add(CreateLink("ContentManagement.htm", "content Management"))
        oList.Add(CreateLink("Crm.htm ", "Crm"))
        oList.Add(CreateLink("CssStyleSheets.htm", "Css Style Sheets"))
        oList.Add(CreateLink("Erp.htm", "Erp"))
        oList.Add(CreateLink("Innovation.htm", "Innovation"))
        oList.Add(CreateLink("Internet.htm", "Internet"))
        oList.Add(CreateLink("Java.htm", "Java"))
        oList.Add(CreateLink("Javascript.htm", "Javascript"))
        oList.Add(CreateLink("Jquery.htm", "Jquery"))
        oList.Add(CreateLink("Manufacturer.htm", "Manufacturer"))
        oList.Add(CreateLink("Microrobot.htm", "Microrobot"))
        oList.Add(CreateLink("Microsoft.htm", "Microsoft"))
        oList.Add(CreateLink("Mobile.htm", "Mobile"))
        oList.Add(CreateLink("Outsourcing.htm", "Outsourcing"))
        oList.Add(CreateLink("Programming.htm", "Programming"))
        oList.Add(CreateLink("QuantumComputer.htm", "Quantum Computer"))
        oList.Add(CreateLink("QuantumComputing.htm", "Quantum Computing"))
        oList.Add(CreateLink("Robot.htm", "Robot"))
        oList.Add(CreateLink("Robotics.htm", "Robotics"))
        oList.Add(CreateLink("Robots.htm", "Robots"))
        oList.Add(CreateLink("Sap.htm", "Sap"))
        oList.Add(CreateLink("SpeechProcessing.htm", "Speech Processing"))
        oList.Add(CreateLink("Sql.htm", "Sql"))
        oList.Add(CreateLink("Ssrs.htm", "Ssrs"))
        oList.Add(CreateLink("Vb.htm", "Vb"))
        oList.Add(CreateLink("VisionChip.htm", "Vision Chip"))
        oList.Add(CreateLink("VoiceRecognition.htm", "Voice Recognition"))
        oList.Add(CreateLink("WebDesign.htm", "Web Design"))
        oList.Add(CreateLink("Wired.htm", "Wired"))

        Return (TheSerializer.Serialize(oList))

    End Function

    Function CreateLink(sLink As String, sDescription As String) As cData
        Dim oData As New cData
        With oData
            .key = sLink
            .data = sDescription
        End With
        Return oData
    End Function
    <WebMethod()> _
    Function GetGuestBookMessage() As string
        Dim oList As New List(Of cData)
        dim TheSerializer as JavaScriptSerializer  = new JavaScriptSerializer()
        dim dr as oledbDataReader
        dim selectCommand as oledbCommand
        dim sql as string=""

        sql="Select KeyValue.KeyName, "
        sql=sql & " KeyValue.ValueItem, " 
        sql=sql & " KeyType.[TypeDescription], "
        sql=sql & " KeyEntity.EntityName"
        sql=sql & " FROM KeyValue "
        sql=sql & " INNER JOIN ((KeyValueTemplate INNER JOIN KeyType On KeyValueTemplate.TypeId = KeyType.ID) "
        sql=sql & " INNER JOIN KeyEntity On KeyValueTemplate.EntityId = KeyEntity.ID) On (KeyValue.KeyName = "
        sql=sql & " KeyValueTemplate.KeyName) And (KeyValue.TypeId = KeyValueTemplate.TypeId) "
        sql=sql & " And (KeyValue.EntityId = KeyValueTemplate.EntityId)"
        sql=sql & " And keyvalue.entityid=1"


        try
            OpenSQLServer()

            selectCommand = New OleDbCommand(sql, dbconn)
            dr = selectCommand.ExecuteReader

            do while dr.read
                dim oData as new cData
                with oData
                    .key=dr("keyname")
                    .value=dr("valueitem")
                    .element=dr("TypeDescription")
                end with
                oList.Add(oData)
            loop
            dr.close

            CloseSQLServer()

        catch ex as exception

        end try


        Return (TheSerializer.serialize(oList))

    end function

    <WebMethod()> _
    Function PostGuestBookMessage(sName as string, sState as string, sMessage As String) As string
        dim sRetVal as string=""
        dim iCount as integer=0
        dim bRetVal as boolean=false
        Dim oList As New List(Of cData)
        dim TheSerializer as JavaScriptSerializer  = new JavaScriptSerializer()

        bRetVal=InsertKeyValue("NAME", sName,1,1)
        if bRetVal=true then
            iCount+=1
        end if
        bRetVal=InsertKeyValue("STATE", sState,1,1)
        if bRetVal=true then
            iCount+=1
        end if
        bRetVal=InsertKeyValue("MESSAGE", sMessage,1,1)
        if bRetVal=true then
            iCount+=1
        end if

        dim oData as new cData
        if iCount>=3 then
            oData.data="Message: Thanks for commenting"
            oData.element="Success"
        else
            oData.data="Message: Error - send your comment by email"
            oData.element="Failed"
        end if
        
        oList.Add(oData)

        Return (TheSerializer.serialize(oList))
    end Function
    Sub OpenSQLServer()
        'Dim sParameter As String

        dim connString as string = ConfigurationManager.ConnectionStrings("DataStoreConnectionString").ConnectionString

        'dbconn = New OleDbConnection(sParameter)
        dbconn = New OleDbConnection(connString)
        dbconn.Open()
    End Sub

    Sub CloseSQLServer()
        If Not dbconn Is Nothing Then
            dbconn.Close()
        End If
    End Sub

    function InsertKeyValue(sKey as string, sValueItem as string,iEntityId as integer,iTypeId as integer) as boolean
        
            dim bRetVal as boolean
            dim insertupdate As OleDbCommand
            dim sql as string=""

        try
            OpenSQLServer()
            sql="insert into KeyValue"
            sql=sql & " ("
            sql=sql & " EntityId,"
            sql=sql & " KeyName,"
            sql=sql & " ValueItem,"
            sql=sql & " TypeId"
            sql=sql & " )"
            sql=sql & " values"
            sql=sql & " ("
            sql=sql &  iEntityId 
            sql=sql & "," & isnvlstring(sKey)
            sql=sql & "," & isnvlstring(sValueItem)
            sql=sql & "," & iTypeId
            sql=sql & " )"

            insertupdate = New OleDbCommand(sql, dbconn)
            insertupdate.ExecuteNonQuery()


            CloseSQLServer()
        bRetVal=true

        catch ex as exception
            bRetVal=false        
        end try
        return(bRetVal)
    end function

Function IsNvlString(v as object) as string
    Dim v1 as string=""
  If isdbnull(v) = true Then
     v1 = ""
  Else
      v1 = Replace(v, "'", "''")
    v1 = "'" & v1 & "'"
  End If
  return(v1)

End Function

    Public Class cData
        Private privateElement As String=""
        Private privateData as String=""
        Private privateKey as string=""
        Private privateValue as string=""

        Public Property key() As String
            Get
                Return Me.privateKey
            End Get
            Set(ByVal sValue As String)
                Me.privateKey = sValue
            End Set
        end Property

        Public Property value() As String
            Get
                Return Me.privateValue
            End Get
            Set(ByVal sValue As String)
                Me.privateValue = sValue
            End Set
        end Property

        Public Property data() As String
            Get
                Return Me.privateData
            End Get
            Set(ByVal sValue As String)
                Me.privateData = sValue
            End Set
        end Property
        Public Property element() As String
            Get
                Return Me.privateElement
            End Get
            Set(ByVal sValue As String)
                Me.privateElement = sValue
            End Set
        End Property
    End Class
End Class


<%@ Page Language="VB" MasterPageFile="lssMasterPage.master" validateRequest="false"
 Title="Media" %>
<%@import Namespace="system.data" %>
<%@import Namespace="System.Net.Mail" %>
<%@import Namespace="System.Data.OleDb" %>

<script runat="server">
    Public Class cEmail
        Public txtEmail As String
        Public txtMessage As String
    End Class
    Public dbconn As OleDbConnection
	Public dbMDBconn As OleDbConnection
    Dim cmdSelect As OleDbCommand
    Dim cmdUpdate As OleDbCommand
    Dim cmdDelete As OleDbCommand
    Dim cmdInsert As OleDbCommand

    Sub OpenSQLServer()
        Dim sParameter As String

        sParameter = "Provider=sqloledb; Data Source=davepamn2.db.2594332.hostedresource.com; Initial Catalog=davepamn2; User ID=davepamn2; Password=Kristal7258;"

        dbconn = New OleDbConnection(sParameter)
        dbconn.Open()
    End Sub
	 Function IsBot(ByVal Request As System.Web.HttpRequest) As Boolean
        If (Request.Browser.Crawler) Then Return True
        Dim myUserAgent As String = Request.UserAgent.ToLower
 
        Dim sIPAddress As String = Trim(Request.ServerVariables("Remote_Addr"))
        
		'Call SendEmail("dnishimoto@listensoftware.com", "dnishimoto@listensoftware.com", myUserAgent & " " & sIPAddress)

        If  sIPAddress="91.109.91.34" or sIPAddress="85.87.228.161" or sIPAddress="83.28.217.206" or sIPAddress="199.58.86.211 " and sIPAddress="201.243.197.236" or sIPAddress="62.219.8.239" or sIPAddress = "27.251.83.216" Or sIPAddress = "195.52.192.109" Or sIPAddress = "66.194.55.249" Or sIPAddress = "173.193.219.168" Then
            Return (True)
        End If
        If myUserAgent.Contains("googlebot") = True Then
            Return (True)
        End If
        
        Dim myArray() As String = New String() {"daum","abonti","daumoa","majestic12","mojeekbot","meanpathbot","linkdexbot","openwebspider","baidu", "java", "bot", "wotbox", "teoma", "alexa", "froogle", "gigabot", _
        "inktomi", "siteexplorer", "majestic12", "looksmart", "url_spider_sql", "firefly", "nationaldirectory", _
        "ask jeeves", "tecnoseek", "infoseek", "webfindbot", "girafabot", "crawler", _
        "www.galaxy.com", "googlebot", "scooter", "slurp", "msnbot", "appie", "fast", _
        "webbug", "spade", "zyborg", "rabaz", "baiduspider", "feedfetcher-google", _
        "technoratisnoop", "rankivabot", "mediapartners-google", "sogou web spider", _
        "http_requester", "webalta crawler", "ezoom", "yandex", "bingbot", "baidu", "linkdex", "ahrefs", "ahrefsbot", "facebookexternalhit"}
 
        For Each _Item As String In myArray
            If (myUserAgent.Contains(_Item)) Then Return True
        Next
        
        
        Return False
    End Function
    Sub CloseSQLServer()
        If Not dbconn Is Nothing Then
            dbconn.Close()
        End If
    End Sub
    Function GetNextNumber(ByVal sNextNumberName As String) As Long
        Dim iRetVal As Long
        Dim dr As OleDbDataReader
        Dim SQL As String
        Dim bProcess As Boolean = False

        SQL = "select * from nextnumber where nnname='" & sNextNumberName & "'"

        'response.write sSQL

        iRetVal = -1

        cmdSelect = New OleDbCommand(Sql, dbconn)
        dr = cmdSelect.ExecuteReader

        If dr.HasRows = False Then
            bProcess = True
            dr.Close()
        End If

        If bProcess = True Then
            SQL = "Insert into nextnumber"
            SQL = SQL & "("
            SQL = SQL & " nnname"
            SQL = SQL & " ,nnnumber"
            SQL = SQL & ")"
            SQL = SQL & " values"
            SQL = SQL & " ("
            SQL = SQL & IsNvlString(sNextNumberName)
            SQL = SQL & ",1"
            SQL = SQL & ")"

            'response.write sql
            cmdInsert = New OleDbCommand(SQL, dbconn)
            cmdInsert.ExecuteNonQuery()

            iRetVal = 1
        Else


            If dr.Read Then
                iRetVal = dr("nnnumber")
                SQL = "update nextnumber set nnnumber=nnnumber+1 where nnname='" & sNextNumberName & "'"
                cmdUpdate = New OleDbCommand(SQL, dbconn)
                cmdUpdate.ExecuteNonQuery()
            End If
            dr.Close()
        End If


        GetNextNumber = iRetVal

    End Function
    Public Function IsNvlString(ByRef v As String) As String
        Dim t As String
        If v.ToString.Length = 0 Then
            t = "NULL"
        ElseIf v Is Nothing Then
            t = "NULL"
        Else
            t = Replace(v, "'", "''")
            t = "'" & Trim("" & t) & "'"
        End If
        IsNvlString = t

    End Function


    Sub ProcessEmail(ByVal oEmail As cEmail)
        Dim sMessageContent As String = ""
        sMessageContent = " Feedback" & "<br>"
        With oEmail
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
        Mail.Subject = "Media Center"

        Mail.Body = sMessageContent
        Mail.IsBodyHtml = True
        Mail.Bcc.Add("dnishimoto@listensoftware.com")

        Dim smtp As New System.Net.Mail.SmtpClient
        smtp.Host = "relay-hosting.secureserver.net"
        smtp.Credentials = New System.Net.NetworkCredential("davepamn", "nishimoto7258")
        smtp.Send(Mail)
    End Sub


    Sub ScoreResults(ByVal sPatternBuffer As String, ByRef iRowCount As Integer, ByVal sIP As String, ByVal iId As Integer, ByVal iSearchCount As Integer, ByRef arrSearchFound As Array, ByRef arrSearchIndexFound As Array, ByVal iMaxHits As Integer, ByRef dbconn As OleDbConnection)
        Dim iValue As Integer
        'Dim i As Integer
        Dim bSearchPoints As Boolean
        Dim arrOccurrences As Array
        Dim iOccurrence As Integer
        Dim sql As String
        Dim sDateTime As String
        Dim iOccurrences As Integer
        Dim bFound As Boolean
        Dim cmdInsert As OleDbCommand

        'Dim iHits
        'Dim dr As OleDbDataReader
        'Dim sMicrotheoryItem As String

        'sql = "select hits,microtheoryitem from microtheory where id=@id"

        'cmdSelect = New OleDbCommand(sql, dbconn)
        'cmdSelect.Parameters.AddWithValue("@id", iMicrotheoryId)
        'dr = cmdSelect.ExecuteReader
        'iHits = 0
        'If dr.Read Then
        ' iHits = dr("hits")
        ' sMicrotheoryItem = dr("microtheoryItem")
        'End If


        iOccurrences = 0
        sDateTime = FormatDateTime(Now, DateFormat.GeneralDate)
        '----------------------Score the Results-------------------
        'Response.write ivalue & "," & iSearchCount & "<BR>"
        iValue = 0
        'Response.write "<hr width=300>"
        'iValue = iHits
        'For i = 0 To iSearchCount
        'If arrSearchFound(i) = "X" Then
        'Response.Write arrSearch(i) & "," & sSearchFound(i) & "<P>"
        'iValue = iValue + 1
        'End If
        'Next

        'iHits = 0
        bFound = False
        bSearchPoints = sPatternBuffer.Contains("XXO")
        If bSearchPoints = True And bFound = False Then
            bFound = True
            arrOccurrences = sPatternBuffer.Split("XXO")
            iOccurrence = UBound(arrOccurrences)
            iValue = iValue + 10 * iOccurrence * iMaxHits
        End If
        bSearchPoints = sPatternBuffer.Contains("XXX")
        If bSearchPoints = True And bFound = False Then
            bFound = True
            arrOccurrences = sPatternBuffer.Split("XXO")
            iOccurrence = UBound(arrOccurrences)
            iValue = iValue + 20 * iOccurrence * iMaxHits
        End If
        bSearchPoints = sPatternBuffer.Contains("OXX")
        If bSearchPoints = True And bFound = False Then
            bFound = True
            arrOccurrences = sPatternBuffer.Split("XXO")
            iOccurrence = UBound(arrOccurrences)
            iValue = iValue + 10 * iOccurrence * iMaxHits
        End If
        bSearchPoints = sPatternBuffer.Contains("XOX")
        If bSearchPoints = True And bFound = False Then
            bFound = True
            arrOccurrences = sPatternBuffer.Split("XXO")
            iOccurrence = UBound(arrOccurrences)
            iValue = iValue + 2 * iOccurrence * iMaxHits
        End If
        bSearchPoints = sPatternBuffer.Contains("XOO")
        If bSearchPoints = True And bFound = False Then
            bFound = True
            arrOccurrences = sPatternBuffer.Split("XXO")
            iOccurrence = UBound(arrOccurrences)
            iValue = iValue + (iMaxHits) + iOccurrence
        End If
        bSearchPoints = sPatternBuffer.Contains("OXO")
        If bSearchPoints = True And bFound = False Then
            bFound = True
            arrOccurrences = sPatternBuffer.Split("XXO")
            iOccurrence = UBound(arrOccurrences)
            iValue = iValue + (iMaxHits) + iOccurrence
        End If
        bSearchPoints = sPatternBuffer.Contains("OOX")
        If bSearchPoints = True And bFound = False Then
            bFound = True
            arrOccurrences = sPatternBuffer.Split("XXO")
            iOccurrence = UBound(arrOccurrences)
            iValue = iValue + (iMaxHits) + iOccurrence
        End If

        sql = "insert into workfile"
        sql = sql & "("
        sql = sql & " ip"
        sql = sql & " ,date_time"
        sql = sql & " ,score"
        sql = sql & " ,id"
        sql = sql & " )"
        sql = sql & " values"
        sql = sql & " ("
        sql = sql & IsNvlString(sIP)
        sql = sql & " ," & IsNvlString(sDateTime)
        sql = sql & " ," & iValue
        sql = sql & " ," & iID
        sql = sql & " )"
        'Response.Write sql

        cmdInsert = New OleDbCommand()
        cmdInsert.Connection = dbconn
        cmdInsert.CommandText = sql
        'cmdInsert.Parameters.AddWithValue("@IP", sIP)
        'cmdInsert.Parameters.AddWithValue("@DateTime", sDateTime)
        'cmdInsert.Parameters.AddWithValue("@Score", iValue)
        'cmdInsert.Parameters.AddWithValue("@Id", iMicrotheoryId)
        cmdInsert.ExecuteNonQuery()
        iRowCount = iRowCount + 1
        'End If

    End Sub
    Sub SetPattern(ByVal iID As Integer, ByRef sPatternBuffer As String, ByVal iPatternLimit As Integer, ByRef arrSearch As Array, ByRef dbconn As OleDbConnection)
        Dim sql As String
        Dim dr As OleDbDataReader
        Dim cmdObj As New OleDbCommand
        Dim i As Integer


        sql = " select "
        sql = sql & " a.positionindex"
        sql = sql & " from wordindex as a"
        sql = sql & " where a.microtheoryid=@microtheoryid"
        sql = sql & " and a.positionindex<=" & iPatternLimit
        If arrSearch.Length > 0 Then
            sql = sql & " and wordvalue in ("
            For i = 0 To arrSearch.Length - 1
                If arrSearch(i) <> "" Then
                    If i = 0 Then
                        sql = sql & "'" & arrSearch(i) & "'"
                    Else
                        sql = sql & ",'" & arrSearch(i) & "'"
                    End If
                End If
            Next
            sql = sql & " )"
        End If

        cmdObj.Connection = dbconn
        cmdObj.CommandText = sql
        cmdObj.Parameters.AddWithValue("@microtheoryid", iID)

        dr = cmdObj.ExecuteReader()
        Do While dr.Read
            sPatternBuffer = sPatternBuffer.Insert(dr("positionindex"), "X")
        Loop
        dr.Close()
    End Sub


    Function GetSimilarWords(ByVal iApplicationId As String, ByVal sWordValue As String, ByRef dbconn As OleDbConnection) As String
        Dim sRetVal As String
        Dim SQL As String
        Dim iLength As Integer
        Dim iThreshhold As Integer
        Dim bFound As Boolean
        Dim dr As OleDbDataReader
        Dim cmdSelect As OleDbCommand

        iLength = sWordValue.Length
        SQL = "select distinct wordvalue from wordindex"
        SQL = SQL & " where wordvalue=" & IsNvlString(sWordValue)
        SQL = SQL & " and applicationid=" & iApplicationId
        If sWordValue.Length >= 6 Then
            SQL = SQL & " or wordvalue like '" & Left(sWordValue, sWordValue.Length - 1) & "%'"
        End If

        cmdSelect = New OleDbCommand(SQL, dbconn)
        dr = cmdSelect.ExecuteReader

        sRetVal = ""
        If sWordValue.Length >= 6 Then
            iThreshhold = 6
        Else
            iThreshhold = 0
        End If

        bFound = False
        Do While dr.Read
            If dr("wordvalue").ToString.Length <= iLength + iThreshhold Then
                If sRetVal = "" Then
                    sRetVal = "'" & dr("wordvalue") & "'"
                Else
                    sRetVal = sRetVal & ",'" & dr("wordvalue") & "'"
                End If
                bFound = True
            End If
        Loop
        If bFound = False Then
            sRetVal = "'" & Replace(sWordValue, "'", "''") & "'"
        End If
        dr.Close()
        Return (sRetVal)

    End Function
    Function highlight(ByVal sSearchPhrase As String, ByVal sPhrase As String, ByRef arrSearch As Array) As String
        Dim arrWords As Array
        Dim iWordCount As Integer
        Dim iSearchCount As Integer
        Dim i, j As Integer
        Dim bFound As Boolean
        Dim sRetVal As String

        sPhrase = stripSpecialCharacters(sPhrase & " ")
        'sPhrase=replace(sPhrase,","," ")
        'sPhrase=replace(sPhrase,"."," ")
        'sPhrase=replace(sPhrase,"?"," ")
        'sPhrase=replace(sPhrase,"!"," ")
        arrWords = Split(sPhrase, " ")

        sRetVal = ""
        iWordCount = UBound(arrWords)
        iSearchCount = UBound(arrSearch)
        For i = 0 To iWordCount - 1
            bFound = False
            For j = 0 To iSearchCount - 1
                'if trim(ucase(arrwords(i)))=trim(ucase(arrSearch(j))) then
                If MatchPattern(arrWords(i), arrSearch(j)) = True Then
                    bFound = True
                    Exit For
                End If
            Next
            'bFound=true
            If bFound = False Then
                sRetVal = sRetVal & arrWords(i) & " "
            Else
                sRetVal = sRetVal & "<font color=blue>" & arrWords(i) & "</font> "
            End If
        Next
        highlight = sRetVal
    End Function


    Function MatchPattern(ByVal sParamPattern As String, ByVal sParamWord As String) As Boolean
        Dim sPattern, sWord As String
        Dim iPatternLength As Integer
        Dim iWordLength As Integer
        Dim iCount As Integer
        Dim sChar1, sChar2 As String
        Dim bRetVal As Boolean
        Dim iPatternPercent As Integer
        Dim iWordPercent As Integer
        Dim i As Integer

        sPattern = Trim(UCase(sParamPattern))
        sWord = Trim(UCase(sParamWord))
        'If InStr(sPattern, sWord) > 0 Then
        ' bRetVal = True
        'Else
        'bRetVal = False
        'End If
        'MatchPattern = bRetVal
        'Exit Function

        bRetVal = False
        If sPattern <> "" And sWord <> "" Then

            iPatternLength = Len(sPattern)
            iWordLength = Len(sWord)
            iCount = 0

            If iWordLength < 7 Then
                If sWord = sPattern Then
                    bRetVal = True
                Else
                    bRetVal = False
                End If
            Else
                For i = 1 To iPatternLength + 1
                    If i > iWordLength Then
                        Exit For
                    End If
                    sChar1 = Mid(sPattern, i, 1)
                    sChar2 = Mid(sWord, i, 1)
                    If sChar1 = sChar2 Then
                        iCount = iCount + 1
                    End If
                Next
                iPatternPercent = iCount / iPatternLength * 100
                iWordPercent = iCount / iWordLength * 100
                If (iPatternPercent > 80) And (iWordPercent > 70) Then
                    bRetVal = True
                Else
                    bRetVal = False
                End If
            End If
        End If
        MatchPattern = bRetVal
    End Function

    Public Function ignoreCertainWords(ByVal sPhrase As String) As String
        Dim regx As Regex = New Regex(RegexOptions.Singleline Or RegexOptions.IgnoreCase)

        sPhrase = Replace(sPhrase, "-", " ")
        'Conjunction
        sPhrase = Replace(UCase(sPhrase), " IF ", " ")
        sPhrase = Replace(UCase(sPhrase), " OR ", " ")
        sPhrase = Replace(UCase(sPhrase), " AND ", " ")
        sPhrase = Replace(UCase(sPhrase), " NOT ", " ")
        sPhrase = Replace(UCase(sPhrase), " BECAUSE ", " ")
        sPhrase = Replace(UCase(sPhrase), " ALTHOUGH ", " ")
        sPhrase = Replace(UCase(sPhrase), " WHILE ", " ")
        sPhrase = Replace(UCase(sPhrase), " FOR ", " ")
        sPhrase = Replace(UCase(sPhrase), " HOWEVER ", " ")
        'Response.Write sPhrase

        'Adverbs
        sPhrase = Replace(UCase(sPhrase), " MORE ", " ")
        sPhrase = Replace(UCase(sPhrase), " MOST ", " ")
        sPhrase = Replace(UCase(sPhrase), " WHY ", " ")
        sPhrase = Replace(UCase(sPhrase), " FASTER ", " ")
        sPhrase = Replace(UCase(sPhrase), " QUICKER ", " ")
        sPhrase = Replace(UCase(sPhrase), " CHEAPER ", " ")
        sPhrase = Replace(UCase(sPhrase), " SMARTER ", " ")
        sPhrase = Replace(UCase(sPhrase), " THERE ", " ")
        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*LY") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*LY", "")
        End If

        'Adjective
        sPhrase = Replace(UCase(sPhrase), " IMPORTANT ", " ")
        sPhrase = Replace(UCase(sPhrase), " WELL ", " ")
        sPhrase = Replace(UCase(sPhrase), " HIGHER ", " ")
        sPhrase = Replace(UCase(sPhrase), " POSSIBLE ", " ")
        sPhrase = Replace(UCase(sPhrase), " EXPENSIVE ", " ")
        sPhrase = Replace(UCase(sPhrase), " COMPETITIVE ", " ")
        sPhrase = Replace(UCase(sPhrase), " MASSIVE ", " ")
        sPhrase = Replace(UCase(sPhrase), " EFFECTIVE ", " ")
        sPhrase = Replace(UCase(sPhrase), " STRONG ", " ")
        sPhrase = Replace(UCase(sPhrase), " ENOUGH ", " ")

        'Verbs
        sPhrase = Replace(UCase(sPhrase), " SEEK ", " ")
        sPhrase = Replace(UCase(sPhrase), " LEARN ", " ")
        sPhrase = Replace(UCase(sPhrase), " COMPREHEND ", " ")
        sPhrase = Replace(UCase(sPhrase), " STUDY ", " ")
        sPhrase = Replace(UCase(sPhrase), " DISCOVER ", " ")
        sPhrase = Replace(UCase(sPhrase), " CONTEMPLATE ", " ")
        sPhrase = Replace(UCase(sPhrase), " TELL ", " ")
        sPhrase = Replace(UCase(sPhrase), " REQUIRE ", " ")
        sPhrase = Replace(UCase(sPhrase), " NEED ", " ")
        sPhrase = Replace(UCase(sPhrase), " SUMMON ", " ")
        sPhrase = Replace(UCase(sPhrase), " INQUIRE ", " ")
        sPhrase = Replace(UCase(sPhrase), " PREDICT ", " ")
        sPhrase = Replace(UCase(sPhrase), " ESTIMATE ", " ")
        sPhrase = Replace(UCase(sPhrase), " FORCAST ", " ")
        sPhrase = Replace(UCase(sPhrase), " UNDERSTOOD ", " ")
        sPhrase = Replace(UCase(sPhrase), " DETERMINE ", " ")
        sPhrase = Replace(UCase(sPhrase), " HELP ", " ")
        sPhrase = Replace(UCase(sPhrase), " INSERT ", " ")
        sPhrase = Replace(UCase(sPhrase), " ACQUIRE ", " ")
        sPhrase = Replace(UCase(sPhrase), " ACQUIRING ", " ")
        sPhrase = Replace(UCase(sPhrase), " ATTEND ", " ")
        sPhrase = Replace(UCase(sPhrase), " INCREASE ", " ")
        sPhrase = Replace(UCase(sPhrase), " INCREASING ", " ")
        sPhrase = Replace(UCase(sPhrase), " CREATE ", " ")
        sPhrase = Replace(UCase(sPhrase), " CREATES ", " ")
        sPhrase = Replace(UCase(sPhrase), " CREATED ", " ")
        sPhrase = Replace(UCase(sPhrase), " CREATING ", " ")
        sPhrase = Replace(UCase(sPhrase), " CHANGE ", " ")
        sPhrase = Replace(UCase(sPhrase), " CALLED ", " ")
        sPhrase = Replace(UCase(sPhrase), " INCREASED ", " ")
        sPhrase = Replace(UCase(sPhrase), " INCREASES ", " ")
        sPhrase = Replace(UCase(sPhrase), " RETURN ", " ")
        sPhrase = Replace(UCase(sPhrase), " UNDERSTAND ", " ")
        sPhrase = Replace(UCase(sPhrase), " PROVIDE ", " ")
        sPhrase = Replace(UCase(sPhrase), " PROVIDES ", " ")
        sPhrase = Replace(UCase(sPhrase), " CAUSES ", " ")
        sPhrase = Replace(UCase(sPhrase), " PRODUCES ", " ")
        sPhrase = Replace(UCase(sPhrase), " YIELDS ", " ")
        sPhrase = Replace(UCase(sPhrase), " BUY ", " ")
        sPhrase = Replace(UCase(sPhrase), " BUYS ", " ")
        sPhrase = Replace(UCase(sPhrase), " REMAIN ", " ")
        sPhrase = Replace(UCase(sPhrase), " DIRECT ", " ")
        sPhrase = Replace(UCase(sPhrase), " ACHIEVE ", " ")
        sPhrase = Replace(UCase(sPhrase), " ALLOW ", " ")
        sPhrase = Replace(UCase(sPhrase), " ALLOWS ", " ")
        sPhrase = Replace(UCase(sPhrase), " OCCUR ", " ")
        sPhrase = Replace(UCase(sPhrase), " OCCURS ", " ")
        sPhrase = Replace(UCase(sPhrase), " BELIEVE ", " ")
        sPhrase = Replace(UCase(sPhrase), " BELIEVES ", " ")
        sPhrase = Replace(UCase(sPhrase), " ARGUED ", " ")
        sPhrase = Replace(UCase(sPhrase), " ADJUST ", " ")
        sPhrase = Replace(UCase(sPhrase), " REDUCE ", " ")

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*ING\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*ING\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*CED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*CED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*DED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*DED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*GED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*GED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*LED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*LED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*MED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*MED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*NED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*NED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*PED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*PED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*RED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*RED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*SED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*SED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*TED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*TED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*VED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*VED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*WED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*WED\s+", "")
        End If

        If regx.IsMatch(sPhrase, "\s*[A-Z,0-9]*ZED\s+") = True Then
            sPhrase = regx.Replace(sPhrase, "\s*[A-Z,0-9]*ZED\s+", "")
        End If

        'Nouns
        sPhrase = Replace(UCase(sPhrase), " PROBLEM ", " ")
        sPhrase = Replace(UCase(sPhrase), " PROBLEMS ", " ")
        sPhrase = Replace(UCase(sPhrase), " BEHAVIOR ", " ")
        sPhrase = Replace(UCase(sPhrase), " HISTORY ", " ")
        sPhrase = Replace(UCase(sPhrase), " THINGS ", " ")
        sPhrase = Replace(UCase(sPhrase), " COMMENT ", " ")
        sPhrase = Replace(UCase(sPhrase), " COMMENTS ", " ")
        sPhrase = Replace(UCase(sPhrase), " BILLION ", " ")
        sPhrase = Replace(UCase(sPhrase), " RESULT ", " ")
        sPhrase = Replace(UCase(sPhrase), " RESULTS ", " ")
        sPhrase = Replace(UCase(sPhrase), " SOMETHING ", " ")
        sPhrase = Replace(UCase(sPhrase), " NOTHING ", " ")
        sPhrase = Replace(UCase(sPhrase), " RESULTS ", " ")
        sPhrase = Replace(UCase(sPhrase), " CHANGES ", " ")
        sPhrase = Replace(UCase(sPhrase), " NUMBER ", " ")

        'Pronoun
        sPhrase = Replace(UCase(sPhrase), " IT ", " ")
        sPhrase = Replace(UCase(sPhrase), " ITS ", " ")
        sPhrase = Replace(UCase(sPhrase), " I ", " ")
        sPhrase = Replace(UCase(sPhrase), " WE ", " ")
        sPhrase = Replace(UCase(sPhrase), " HE ", " ")
        sPhrase = Replace(UCase(sPhrase), " HIM ", " ")
        sPhrase = Replace(UCase(sPhrase), " SHE ", " ")
        sPhrase = Replace(UCase(sPhrase), " HER ", " ")
        sPhrase = Replace(UCase(sPhrase), " YOU ", " ")
        sPhrase = Replace(UCase(sPhrase), " THEY ", " ")
        sPhrase = Replace(UCase(sPhrase), " THEM ", " ")
        sPhrase = Replace(UCase(sPhrase), " THEIR ", " ")
        sPhrase = Replace(UCase(sPhrase), " ME ", " ")
        sPhrase = Replace(UCase(sPhrase), " MINE ", " ")
        sPhrase = Replace(UCase(sPhrase), " US ", " ")
        sPhrase = Replace(UCase(sPhrase), " BECOME ", " ")
        sPhrase = Replace(UCase(sPhrase), " BEST ", " ")
        sPhrase = Replace(UCase(sPhrase), " BETTER ", " ")
        sPhrase = Replace(UCase(sPhrase), " THEMSELVE ", " ")
        sPhrase = Replace(UCase(sPhrase), " THEMSELVES ", " ")

        'Response.Write sPhrase

        'Preposition	
        sPhrase = Replace(UCase(sPhrase), " ON ", " ")
        sPhrase = Replace(UCase(sPhrase), " BENEATH ", " ")
        sPhrase = Replace(UCase(sPhrase), " AGAINST ", " ")
        sPhrase = Replace(UCase(sPhrase), " BESIDE ", " ")
        sPhrase = Replace(UCase(sPhrase), " OVER ", " ")
        sPhrase = Replace(UCase(sPhrase), " DURING ", " ")
        sPhrase = Replace(UCase(sPhrase), " ABOUT ", " ")
        sPhrase = Replace(UCase(sPhrase), " ABOVE ", " ")
        sPhrase = Replace(UCase(sPhrase), " ACROSS ", " ")
        sPhrase = Replace(UCase(sPhrase), " AFTER ", " ")
        sPhrase = Replace(UCase(sPhrase), " ALONG ", " ")
        sPhrase = Replace(UCase(sPhrase), " AMONG ", " ")
        sPhrase = Replace(UCase(sPhrase), " AROUND ", " ")
        sPhrase = Replace(UCase(sPhrase), " AT ", " ")
        sPhrase = Replace(UCase(sPhrase), " BEFORE ", " ")
        sPhrase = Replace(UCase(sPhrase), " BUT ", " ")
        sPhrase = Replace(UCase(sPhrase), " BY ", " ")
        sPhrase = Replace(UCase(sPhrase), " DESPITE ", " ")
        sPhrase = Replace(UCase(sPhrase), " DOWN ", " ")
        sPhrase = Replace(UCase(sPhrase), " EXCEPT ", " ")
        sPhrase = Replace(UCase(sPhrase), " FOR ", " ")
        sPhrase = Replace(UCase(sPhrase), " FROM ", " ")
        sPhrase = Replace(UCase(sPhrase), " IN ", " ")
        sPhrase = Replace(UCase(sPhrase), " INSIDE ", " ")
        sPhrase = Replace(UCase(sPhrase), " INTO ", " ")
        sPhrase = Replace(UCase(sPhrase), " LIKE ", " ")
        sPhrase = Replace(UCase(sPhrase), " NEAR ", " ")
        sPhrase = Replace(UCase(sPhrase), " OF ", " ")
        sPhrase = Replace(UCase(sPhrase), " OFF ", " ")
        sPhrase = Replace(UCase(sPhrase), " ON ", " ")
        sPhrase = Replace(UCase(sPhrase), " ONTO ", " ")
        sPhrase = Replace(UCase(sPhrase), " OUT ", " ")
        sPhrase = Replace(UCase(sPhrase), " OUTSIDE ", " ")
        sPhrase = Replace(UCase(sPhrase), " PAST ", " ")
        sPhrase = Replace(UCase(sPhrase), " SINCE ", " ")
        sPhrase = Replace(UCase(sPhrase), " THROUGH ", " ")
        sPhrase = Replace(UCase(sPhrase), " TILL ", " ")
        sPhrase = Replace(UCase(sPhrase), " TO ", " ")
        sPhrase = Replace(UCase(sPhrase), " TOWARD ", " ")
        sPhrase = Replace(UCase(sPhrase), " UNDER ", " ")
        sPhrase = Replace(UCase(sPhrase), " UNDERNEATH ", " ")
        sPhrase = Replace(UCase(sPhrase), " UNTIL ", " ")
        sPhrase = Replace(UCase(sPhrase), " UP ", " ")
        sPhrase = Replace(UCase(sPhrase), " UPON ", " ")
        sPhrase = Replace(UCase(sPhrase), " WITH ", " ")
        sPhrase = Replace(UCase(sPhrase), " WITHIN ", " ")
        sPhrase = Replace(UCase(sPhrase), " WITHOUT ", " ")
        sPhrase = Replace(UCase(sPhrase), " BETWEEN ", " ")

        'Response.Write sPhrase

        sPhrase = Replace(UCase(sPhrase), " A ", " ")

        'Articles and Be Verbs
        sPhrase = Replace(UCase(sPhrase), " IS ", " ")
        sPhrase = Replace(UCase(sPhrase), " ARE ", " ")
        sPhrase = Replace(UCase(sPhrase), " WILL ", " ")
        sPhrase = Replace(UCase(sPhrase), " WILLING ", " ")
        sPhrase = Replace(UCase(sPhrase), " WAS ", " ")
        sPhrase = Replace(UCase(sPhrase), " HAD ", " ")
        sPhrase = Replace(UCase(sPhrase), " HAS ", " ")
        sPhrase = Replace(UCase(sPhrase), " HAVE ", " ")
        sPhrase = Replace(UCase(sPhrase), " WERE ", " ")
        sPhrase = Replace(UCase(sPhrase), " DO ", " ")
        sPhrase = Replace(UCase(sPhrase), " DOES ", " ")
        sPhrase = Replace(UCase(sPhrase), " DID ", " ")
        sPhrase = Replace(UCase(sPhrase), " CAN ", " ")
        sPhrase = Replace(UCase(sPhrase), " BE ", " ")
        sPhrase = Replace(UCase(sPhrase), " BEEN ", " ")

        sPhrase = Replace(UCase(sPhrase), " AS ", " ")
        sPhrase = Replace(UCase(sPhrase), " MANY ", " ")
        sPhrase = Replace(UCase(sPhrase), " FIND ", " ")
        sPhrase = Replace(UCase(sPhrase), " SOME ", " ")
        sPhrase = Replace(UCase(sPhrase), " USE ", " ")
        sPhrase = Replace(UCase(sPhrase), " MAY ", " ")
        sPhrase = Replace(UCase(sPhrase), " THE ", " ")

        'Demonstrative Pronouns
        sPhrase = Replace(UCase(sPhrase), " THAT ", " ")
        sPhrase = Replace(UCase(sPhrase), " THIS ", " ")
        sPhrase = Replace(UCase(sPhrase), " THESE ", " ")
        sPhrase = Replace(UCase(sPhrase), " THOSE ", " ")

        'Interrogative Pronouns
        sPhrase = Replace(UCase(sPhrase), " WHO ", " ")
        sPhrase = Replace(UCase(sPhrase), " WHOM ", " ")
        sPhrase = Replace(UCase(sPhrase), " WHICH ", " ")
        sPhrase = Replace(UCase(sPhrase), " WHAT ", " ")
        sPhrase = Replace(UCase(sPhrase), " WHOMEVER ", " ")
        sPhrase = Replace(UCase(sPhrase), " WHICHEVER ", " ")
        sPhrase = Replace(UCase(sPhrase), " WHATEVER ", " ")
        sPhrase = Replace(UCase(sPhrase), " HOW ", " ")
        sPhrase = Replace(UCase(sPhrase), " WHERE ", " ")
        sPhrase = Replace(UCase(sPhrase), " WHEN ", " ")
        sPhrase = Replace(UCase(sPhrase), " HOW ", " ")

        'Indefinite Pronouns
        sPhrase = Replace(UCase(sPhrase), " ALL ", " ")
        sPhrase = Replace(UCase(sPhrase), " ANY ", " ")
        sPhrase = Replace(UCase(sPhrase), " ANOTHER ", " ")
        sPhrase = Replace(UCase(sPhrase), " ANYBODY ", " ")
        sPhrase = Replace(UCase(sPhrase), " ANYTHING ", " ")
        sPhrase = Replace(UCase(sPhrase), " EACH ", " ")
        sPhrase = Replace(UCase(sPhrase), " EVERYBODY ", " ")
        sPhrase = Replace(UCase(sPhrase), " EVERYONE ", " ")
        sPhrase = Replace(UCase(sPhrase), " FEW ", " ")
        sPhrase = Replace(UCase(sPhrase), " MANY ", " ")
        sPhrase = Replace(UCase(sPhrase), " NOBODY ", " ")
        sPhrase = Replace(UCase(sPhrase), " NONE ", " ")
        sPhrase = Replace(UCase(sPhrase), " ONE ", " ")
        sPhrase = Replace(UCase(sPhrase), " SEVERAL ", " ")

        sPhrase = Replace(UCase(sPhrase), " SOME ", " ")
        sPhrase = Replace(UCase(sPhrase), " SOMEBODY ", " ")
        sPhrase = Replace(UCase(sPhrase), " WHEN ", " ")

        'Determiner
        sPhrase = Replace(UCase(sPhrase), " MUCH ", " ")
        sPhrase = Replace(UCase(sPhrase), " A ", " ")
        sPhrase = Replace(UCase(sPhrase), " SOME ", " ")
        sPhrase = Replace(UCase(sPhrase), " ALL ", " ")

        'Modals
        sPhrase = Replace(UCase(sPhrase), " SHOULD ", " ")
        sPhrase = Replace(UCase(sPhrase), " COULD ", " ")
        sPhrase = Replace(UCase(sPhrase), " MAY ", " ")

        sPhrase = Replace(UCase(sPhrase), " , ", " ")
        sPhrase = Replace(UCase(sPhrase), ".", " ")
        sPhrase = Replace(UCase(sPhrase), ":", " ")
        sPhrase = Replace(UCase(sPhrase), "_", " ")
        sPhrase = Replace(UCase(sPhrase), "!", " ")
        sPhrase = Replace(UCase(sPhrase), "~", " ")
        sPhrase = Replace(UCase(sPhrase), "@", " ")
        sPhrase = Replace(UCase(sPhrase), "+", " ")
        sPhrase = Replace(UCase(sPhrase), "=", " ")
        sPhrase = Replace(UCase(sPhrase), ",", " ")
        sPhrase = Replace(UCase(sPhrase), "|", " ")
        sPhrase = Replace(UCase(sPhrase), "[", " ")
        sPhrase = Replace(UCase(sPhrase), "]", " ")
        sPhrase = Replace(UCase(sPhrase), "{", " ")
        sPhrase = Replace(UCase(sPhrase), "}", " ")
        sPhrase = Replace(UCase(sPhrase), "?", " ")
        sPhrase = Replace(UCase(sPhrase), "/", " ")
        sPhrase = Replace(UCase(sPhrase), " WANT ", " ")
        sPhrase = Replace(UCase(sPhrase), " LEARN ", " ")
        sPhrase = Replace(UCase(sPhrase), " FIND ", " ")
        sPhrase = Replace(UCase(sPhrase), " DESCRIBE ", " ")
        sPhrase = Replace(UCase(sPhrase), " EXPLAIN ", " ")
        sPhrase = Replace(UCase(sPhrase), " GIVE ", " ")
        sPhrase = Replace(UCase(sPhrase), " TEACH ", " ")
        sPhrase = Replace(UCase(sPhrase), " LOOKING ", " ")
        sPhrase = Replace(UCase(sPhrase), " UNDERSTANDING ", " ")
        sPhrase = Replace(UCase(sPhrase), " MEANING ", " ")
        sPhrase = Replace(UCase(sPhrase), " AFFECTING ", " ")
        sPhrase = Replace(UCase(sPhrase), " RESULTING ", " ")
        sPhrase = Replace(UCase(sPhrase), " IMPACTING ", " ")
        sPhrase = Replace(UCase(sPhrase), " MEAN ", " ")
        sPhrase = Replace(UCase(sPhrase), " LEARNING ", " ")
        sPhrase = Replace(UCase(sPhrase), " USING ", " ")
        sPhrase = Replace(UCase(sPhrase), " NEEDED ", " ")
        sPhrase = Replace(UCase(sPhrase), " NEEDING ", " ")
        sPhrase = Replace(UCase(sPhrase), " NEED ", " ")
        sPhrase = Replace(UCase(sPhrase), " SEE ", " ")
        sPhrase = Replace(UCase(sPhrase), " TELL ", " ")
        sPhrase = Replace(UCase(sPhrase), " LIST ", " ")
        sPhrase = Replace(UCase(sPhrase), " INFORM ", " ")
        sPhrase = Replace(UCase(sPhrase), " INFORMATION ", " ")
        sPhrase = Replace(UCase(sPhrase), " DATA ", " ")
        sPhrase = Replace(UCase(sPhrase), " DIFFERENT ", " ")
        sPhrase = Replace(UCase(sPhrase), " MUST ", " ")


        ignoreCertainWords = sPhrase
    End Function
    Public Function stripSpecialCharacters(ByVal sPhrase)

        If IsNumeric(sPhrase) = True Then
            sPhrase = Replace(sPhrase, ",", "")
            sPhrase = Replace(sPhrase, ".", "")
            sPhrase = Replace(sPhrase, "$", "")
            sPhrase = Replace(sPhrase, "(", "")
            sPhrase = Replace(sPhrase, ")", "")
        Else
            sPhrase = Replace(sPhrase, ",", " , ")
            sPhrase = Replace(sPhrase, ".", " . ")
            sPhrase = Replace(sPhrase, "?", " ? ")
            sPhrase = Replace(sPhrase, "!", " ! ")
            sPhrase = Replace(sPhrase, "(", " ( ")
            sPhrase = Replace(sPhrase, ")", " ) ")
            sPhrase = Replace(sPhrase, ";", " ; ")
            sPhrase = Replace(sPhrase, "-", " - ")
            sPhrase = Replace(sPhrase, ":", " : ")
            sPhrase = Replace(sPhrase, "'", " ' ")
            sPhrase = Replace(sPhrase, "/", " / ")
            sPhrase = Replace(sPhrase, Chr(10), " ")
            sPhrase = Replace(sPhrase, Chr(13), " ")
            sPhrase = Replace(sPhrase, Chr(34), " " & Chr(34) & " ")
        End If
        stripSpecialCharacters = sPhrase
    End Function
    Public Function IsAlphaNumeric(ByVal sVal) As Boolean
        Dim regx As Regex
        Dim mRetVal
        Dim bPass As Boolean
        Dim iOccurence As Integer
        Dim iPosition As Integer

        regx = New Regex("^[a-z,A-Z,0-9,\',\.,\?,\-,\%,\$,\!,\#,\&,\(,\),\',\*,\:,\@,\s]*(<BR>)*(<br>)*$", RegexOptions.IgnoreCase)

        'With regx
        '.IgnoreCase = True
        '.Global = True
        'End With
        '(^[(]{0,1}) the first character maybe a "(" 
        '\s*([0-9]{3,3})\s strip whitespace and allow three numbers
        '*([)]{0,1}) the previous three numbers may be enclosed with a ")"
        '\s*([-]{0,1})\s*  a "-" may follow the suffix
        '([0-9]{3,3}) three numbers are required
        '\s*([-]*)\s* a "-" may follow 
        '([0-9]{4,4}$) four numbers are required
        '$ matches the position at the end of the input string

        'regx.Pattern = "^[a-z,A-Z,0-9,\.,\?,\-,\%,\$,\!,\#,\&,\(,\),\',\*,\:,\@,\s]*(<BR>)*(<br>)*$"

        'bPass = regx.test(sVal)

        mRetVal = regx.Match(sVal)

        If mRetVal.success Then
            bPass = True
        Else
            bPass = False
        End If

        iPosition = 0
        Do
            iPosition = InStr(iPosition + 1, sVal, "'")
            If iPosition > 0 Then
                iOccurence += 1
            End If
        Loop Until iPosition = 0
        If iOccurence > 1 Then
            bPass = False
        End If

        'if bPass=false then
        'regx.pattern="\s*([0-9]{3,3})\s*([-]*)\s*([0-9]{4,4}$)"
        'bPass=regx.test(sVal)
        'end if	

        IsAlphaNumeric = bPass

    End Function

    Function GetSimilarWords(ByVal sWordValue As String) As String
        Dim sRetVal As String
        Dim SQL As String
        Dim iLength As Integer
        Dim iThreshhold As Integer
        Dim bFound As Boolean
        Dim dr As OleDbDataReader

        iLength = sWordValue.Length
        SQL = "select distinct wordvalue from wordindex"
        SQL = SQL & " where wordvalue=" & IsNvlString(sWordValue)
        If sWordValue.Length >= 6 Then
            SQL = SQL & " or wordvalue like '" & Left(sWordValue, sWordValue.Length - 1) & "%'"
        End If

        cmdSelect = New OleDbCommand(SQL, dbconn)
        dr = cmdSelect.ExecuteReader

        sRetVal = ""
        If sWordValue.Length >= 6 Then
            iThreshhold = 6
        Else
            iThreshhold = 0
        End If

        bFound = False
        Do While dr.Read
            If dr("wordvalue").ToString.Length <= iLength + iThreshhold Then
                If sRetVal = "" Then
                    sRetVal = "'" & dr("wordvalue") & "'"
                Else
                    sRetVal = sRetVal & ",'" & dr("wordvalue") & "'"
                End If
                bFound = True
            End If
        Loop
        If bFound = False Then
            sRetVal = "'" & Replace(sWordValue, "'", "''") & "'"
        End If
        dr.Close()
        Return (sRetVal)

    End Function

    Sub SaveMessage_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sql As String
        Dim sMedia As String
        Dim iParentId As Integer
        Dim sTitle As String
        Dim sMessage As String
        Dim sPosition As String
        Dim sId As String

        sMedia = txtMedia.Text & " "
        iParentId = lblParentId.Text
        sTitle = txtTitle.Text & " "
        sMessage = Replace(txtMessage.Text, vbCrLf, "<p>")
        sPosition = txtPosition.Text
        If txtPosition.Text = "" Then
            sPosition = 0
        End If
        

        lblErrorAddMedia.Text = ""
        If sTitle = "" And iParentId = "-1" Then
            lblErrorAddMedia.Text = "Please add a title<br>"
        ElseIf sMessage = "" Then
            lblErrorAddMedia.Text = "Please add a message<br>"
        ElseIf sMedia = "" And iParentId = "-1" Then
            lblErrorAddMedia.Text = "Please add a Media<br>"
        ElseIf IsNumeric(sPosition) = False And iParentId = "-1" Then
            lblErrorAddMedia.Text = "Please change position to a number<br>"
        End If
        If lblErrorAddMedia.Text <> "" Then
            Exit Sub
        End If
		
        'sData = Replace(Replace(txtMessage.Text, ">", "&gt;"), "<", "&lt;")
        'Response.Write iParentId
	
        sId = GetNextNumber("Media")
        If iParentId <> -1 Then
            sql = "insert into messages ("
            sql = sql & " id"
            sql = sql & ",parentid"
            sql = sql & ",media"
            sql = sql & ",title"
            sql = sql & ",message"
            sql = sql & ",lastupdated"
            sql = sql & ",applicationid"
            sql = sql & ",position"
            sql = sql & ")"
            sql = sql & " values("
            sql = sql & sId
            sql = sql & "," & iParentId
            sql = sql & "," & IsNvlString(sMedia)
            sql = sql & "," & IsNvlString(sTitle)
            sql = sql & "," & IsNvlString(sMessage)
            sql = sql & "," & "'" & FormatDateTime(Now, 2) & "'"
            sql = sql & ",2"
            sql = sql & "," & sPosition
            sql = sql & ")"

            cmdInsert = New OleDbCommand(sql, dbconn)
            cmdInsert.ExecuteNonQuery()
            ReDatabind(iParentId)
            ShowDetail()
        Else
            With dsGridFeedback
                '.InsertCommand = sql
                '.InsertParameters("@ParentId").DefaultValue = iParentId
                '.InsertParameters("@Title").DefaultValue = "" & sTitle
                '.InsertParameters("@Message").DefaultValue = "" & sMessage
                '.InsertParameters("@Media").DefaultValue = ""
                '.InsertParameters("@LastUpdated").DefaultValue = CDate(Now)
                '.InsertParameters("@ApplicationId").DefaultValue = 1
                '.InsertParameters("@Position").DefaultValue = sPosition
                '.Insert()

                sql = "update messages set position=position+1 where applicationid=2 and position >" & sPosition
                .UpdateCommand = sql
                .Update()
                
                
                sql = "insert into messages ("
                sql = sql & " id"
                sql = sql & ",parentid"
                sql = sql & ",media"
                sql = sql & ",title"
                sql = sql & ",message"
                sql = sql & ",lastupdated"
                sql = sql & ",applicationid"
                sql = sql & ",position"
                sql = sql & ")"
                sql = sql & " values("
                sql = sql & sId
                sql = sql & "," & iParentId
                sql = sql & "," & IsNvlString(sMedia)
                sql = sql & "," & IsNvlString(sTitle)
                sql = sql & "," & IsNvlString(sMessage)
                sql = sql & "," & "'" & FormatDateTime(Now, 2) & "'"
                sql = sql & ",2"
                sql = sql & "," & sPosition
                sql = sql & ")"
                
                .InsertCommand = sql
                .Insert()



                'Response.Redirect("sweeterdefault.aspx")
                .DataBind()
            End With
            
            Dim oEmail As New cEmail
        
            With oEmail
                .txtEmail = "dnishimoto@listensoftware.com"
                .txtMessage = "Media Post " & sMessage
            End With
            ProcessEmail(oEmail)
            pnlInputQuestion.Visible = False
            pnlDisplayQuestionGrid.Visible = True

        End If
        
        ProcessWordIndex("1", sId, sTitle & " " & sMessage & " ")

        txtTitle.Text = ""
        txtMedia.Text = ""
        txtMessage.Text = ""
        txtPosition.Text = ""


    End Sub
    Function linksToUrl(ByVal sMessage As String) As String
        Dim sRetVal As String
        'sRetVal = sMessage
        sRetVal = System.Text.RegularExpressions.Regex.Replace(sMessage, "\b(((http|https)+\:\/\/)[-a-zA-Z0-9+&@?#/%=~_|!:,.;]+)", "<a href='$1' target=_blank>$1</a>")
        Return (sRetVal)
    End Function

    Sub ReDatabind(ByVal iId As Integer)
        Dim sql As String

        sql = "SELECT "
        sql = sql & " id, "
        sql = sql & " title, "
        sql = sql & " Message, "
        sql = sql & " media, "
        sql = sql & " applicationid"
        sql = sql & " position"
        sql = sql & " FROM messages"
        sql = sql & " where messages.parentid = -1"
        sql = sql & " and applicationid=" & "2"
        sql = sql & " and id=" & iId
        sql = sql & " order by id desc"

        With dsFeedback
            .SelectCommand = sql
            .Select(DataSourceSelectArguments.Empty)
        End With
        
        repeaterFeedback.DataBind()
        
    End Sub
	
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        'If Session("SecurityKeyOk") = True Then
        '    linkLogin.Text = "Logout"
        'End If
		  If IsBot(Request) = True Then
            'Response.Redirect("http://www.google.com")
            Response.End()
        End If
        If Session("SecurityKeyOk") = True Then
            linkAddQuestion.Enabled = True
        Else
            linkAddQuestion.Enabled = False
        End If
        OpenSQLServer()
        If Request("txtQueryHeadline") <> "" Then
            txtQuery.Text = Request("txtQueryHeadline")
        End If
        If IsPostBack = False Then
            LoadParameters()
			outputarticles("GOLD")
            If Request("process") = "delete" Then
                DeleteReply()
            End If
            DSQuery()
        End If
    End Sub
    Sub LoadParameters()

        lblParentId.Text = -1

    End Sub
	Protected Sub Blog_Click(ByVal sender As Object, ByVal e As System.EventArgs)
		response.redirect("sweeterdefault.aspx")
	end sub

    Protected Sub AddQuestion_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sql As String
        Dim dr As OleDbDataReader

        rowTitle.Visible = True
        rowReplyTo.Visible = False
        rowMedia.Visible = True
        rowPosition.Visible = True

        txtTitle.Text = ""
        lblParentId.Text = -1
        txtMedia.Text = ""
        txtMessage.Text = ""
        Sql = "SELECT "
        sql = sql & " max(position) as max_position "
        Sql = Sql & " from Messages "
        sql = sql & " where applicationid = 2"

        cmdSelect = New OleDbCommand(sql, dbconn)
        dr = cmdSelect.ExecuteReader
        If dr.Read Then
            if isdbnull(dr("max_position"))=False then
            txtPosition.Text = dr("max_position") + 1
            else
            txtPosition.Text=1
            end if
        End If
        dr.Close()
        
        'txtPosition.Text = "0"
        pnlInputQuestion.Visible = True
        pnlDisplayQuestionGrid.Visible = False
    End Sub

    Protected Sub Cancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        rowReplyTo.Visible = False
        lblParentId.Text = -1
        pnlDisplayQuestionGrid.Visible = True
        pnlDisplayQuestion.Visible = False
        pnlInputQuestion.Visible = False

    End Sub
    Protected Sub Back_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        pnlDisplayQuestionGrid.Visible = True
        pnlDisplayQuestion.Visible = False
        pnlInputQuestion.Visible = False
        'Response.Redirect("sweeterdefault.aspx")
    End Sub
    
    Sub ReplyForm(ByVal iMessageId As Integer)
        Dim sql As String
        Dim dr As OleDbDataReader
        
        rowMedia.Visible = False
        rowTitle.Visible = False
        rowReplyTo.Visible = True
        rowPosition.Visible = False
        
        sql = "SELECT "
        sql = sql & " Messages.title "
        sql = sql & " from Messages "
        sql = sql & " where messages.id = " & iMessageId
        
        lblParentId.Text = iMessageId
        
        cmdSelect = New OleDbCommand(sql, dbconn)
        dr = cmdSelect.ExecuteReader
        If dr.Read Then
            lblReplyToTitle.Text = "<b>Title</b>:" & dr("title")
        End If
        dr.Close()
        pnlDisplayQuestionGrid.Visible = False
        pnlDisplayQuestion.Visible = False
        pnlInputQuestion.Visible = True

    End Sub

    Protected Sub DeleteReply()
        Dim iId As Integer
        Dim iParentId As Integer
        Dim sql As String
        
        iId = Request("id")
        iParentId = Request("parentid")
        sql = "delete from messages where id=" & iId

        cmdDelete = New OleDbCommand(sql, dbconn)
        cmdDelete.ExecuteNonQuery()

        ReDatabind(iParentId)
        ShowDetail()

    End Sub

    Protected Sub Reply_Click(ByVal sender As Object, ByVal e As CommandEventArgs)
        Dim iMessageId As Integer

        pnlInputQuestion.Visible = True
        pnlDisplayQuestionGrid.Visible = False
        pnlDisplayQuestion.Visible = False
        rowMedia.Visible = False
        
        txtTitle.Text = ""
        txtMedia.Text = ""
        txtMessage.Text = ""
        
        iMessageId = e.CommandArgument
        ReplyForm(iMessageId)
        'MsgBox(e.CommandArgument)
        lblParentId.Text = e.CommandArgument
        rowReplyTo.Visible = True
    End Sub
    Function GetResponse(ByVal iParentid As Integer, ByVal sMessage As String) As String
        Dim sql As String
        Dim dr As OleDbDataReader
        Dim sRetVal As String
        Dim iCount As Integer

        sql = "SELECT "
        sql = sql & " count(*) as total_count "
        sql = sql & " from Messages "
        sql = sql & " where parentid = " & iParentid

        cmdSelect = New OleDbCommand(sql, dbconn)
        dr = cmdSelect.ExecuteReader
        iCount = 0
        If dr.Read Then
            iCount = dr("total_count") + 1
        End If
        dr.Close()
        
        sql = "SELECT "
        sql = sql & " Messages.title "
        sql = sql & " ,Messages.media"
        sql = sql & " ,Messages.message "
        sql = sql & " from Messages "
        sql = sql & " where parentid = " & iParentid
        sql = sql & " order by id desc"

        cmdSelect = New OleDbCommand(sql, dbconn)
        dr = cmdSelect.ExecuteReader
        sRetVal = ""
        If dr.Read Then
            sRetVal = "<font color=blue>" & iCount & " <b>Posts</b></font><br> " & Left(dr("message"), 200) & "..."
        Else
            sRetVal = "<font color=blue>" & iCount & " <b>Posts</b></font><br> " & Left(sMessage, 200) & "..."
        End If
        dr.Close()
        Return (sRetVal)
    End Function
    Function ReplyMessages(ByVal iParentId As Integer) As String
        Dim sql As String
        Dim dr As OleDbDataReader
        Dim sRetVal As String
        
        sql = "SELECT "
        sql = sql & " messages.id"
        sql = sql & " ,Messages.title "
        sql = sql & " ,Messages.media"
        sql = sql & " ,Messages.message "
        sql = sql & " from Messages "
        sql = sql & " where parentid = " & iParentId
        sql = sql & " order by id desc"

        cmdSelect = New OleDbCommand(sql, dbconn)
        dr = cmdSelect.ExecuteReader
        sRetVal = ""
        Do While dr.Read
            sRetVal += "<tr><td valign=top bgcolor=azure>"
            If Session("SecurityKeyOk") = True Then
                sRetVal += "<a href='lssmedia.aspx?process=delete&id=" & dr("id") & "&parentid=" & iParentId & "&txtQueryHeadline=" & Replace(txtQuery.Text, " ", "+") & "'>Delete</a>"
            End If
            'sRetVal += " <b>From:</b>" & dr("media") & "</td>"
            sRetVal += "<td valign=top bgcolor=azure><b>Title</b>:" & dr("title") & "<br><b>Message:</b>" & linksToUrl(dr("message")) & "</td>"
            sRetVal += "</tr>"
        Loop
        dr.Close()

        Return sRetVal
    End Function
    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs)
        CloseSQLServer()
    End Sub
    Sub ShowDetail()
        pnlDisplayQuestionGrid.Visible = False
        pnlDisplayQuestion.Visible = True
        pnlInputQuestion.Visible = False
        'RegisterClientScriptBlock("myscript", "location.href='#DisplayQuestion';")
        'ClientScript.RegisterClientScriptBlock(Me.GetType(), "myscript", "window.scrollTo(0, 0);", True)
        ClientScript.RegisterStartupScript(Me.GetType(), "myscript", "window.scrollTo(100, 400); ", True)

        
    End Sub
    Sub dgFeedback_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "lnkTitle" Then
            Dim iId As Integer = Convert.ToInt32(e.CommandArgument)
            ReDatabind(iId)
            ShowDetail()
        ElseIf e.CommandName = "lnkReply" Then
            Dim iId As Integer = Convert.ToInt32(e.CommandArgument)
            ReDatabind(iId)
            ReplyForm(iId)
            Session("ReplyId") = iId
        ElseIf e.CommandName = "lnkDelete" Then
            DeleteReply(e.CommandArgument)
        End If
    End Sub
    Sub DeleteReply(ByVal sID As String)

        With dsGridFeedback
            .DeleteCommand = "delete from messages where id=" & sID
            .Delete()
        End With

       
    End Sub
    Sub DSQuery()
        Dim sql As String
        Dim sSearchPhrase As String
        Dim arrSearch As Array
        Dim sSearchPattern As String
        Dim sCriteria As String
        Dim iCriteriaCount As Integer
        Dim iSearchCount As Integer
        Dim sWordValue As String
        Dim j As Integer
        'sql = "select id,media,title,message from messages where parentid=-1 and media is not null and applicationid=1 "
        'If txtQueryHeadline.Text <> "" Then
        'sql = sql & " and ucase(title) like '%" & UCase(txtQueryHeadline.Text) & "%'"
        'End If
        'sql = sql & " order by id desc"
        
        sql = "select id,media,title,message from messages as a where parentid=-1 and applicationid=2"
        If txtQuery.Text <> "" Then
            sSearchPhrase = txtQuery.Text
            sSearchPattern = ignoreCertainWords(" " & sSearchPhrase & " ") & " "
            arrSearch = Split(Trim(sSearchPattern) & " ", " ")

            sCriteria = ""
            iCriteriaCount = 0
            iSearchCount = UBound(arrSearch)
            For j = 0 To iSearchCount And j < 20
                If Trim(arrSearch(j)) <> "" Then
                    sWordValue = UCase(Replace(arrSearch(j), "'", "''"))
                    sCriteria = sCriteria & " and EXISTS"
                    sCriteria = sCriteria & " (SELECT     '' "
                    sCriteria = sCriteria & " FROM          WordIndex as b" & j
                    sCriteria = sCriteria & " WHERE      (a.id = b" & j & ".wordid) "
                    sCriteria = sCriteria & " AND b" & j & ".wordValue in (" & GetSimilarWords(sWordValue) & ") ) "
                    iCriteriaCount += 1
                End If
            Next
            sql = sql & sCriteria
        End If
        sql = sql & " order by a.position desc"

        dsGridFeedback.SelectCommand = sql
        dsGridFeedback.Select(DataSourceSelectArguments.Empty)
        dsGridFeedback.DataBind()
        dgFeedback.DataBind()

    End Sub
    Protected Sub cmdQueryHeadline_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        DSQuery()
    End Sub
    Sub Login_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("lsslogin.aspx")
    End Sub

    Protected Sub dgFeedback_RowCreated(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            e.Row.Attributes.Add("onmouseover", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='silver'")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=this.originalstyle;")
        End If
    End Sub
    Sub ProcessWordIndex(ByVal sApplicationId As String, ByVal iId As Integer, ByVal sMessage As String)
        Dim sql As String
        Dim sMicrotheoryItem As String
        Dim sMicrotheoryItems As String
        Dim i As Integer
        Dim arrWords As Array
        Dim iCount As Integer
        Dim sWord As String
        Dim iFoundCount As Integer
        Dim dr As OleDbDataReader

        sMicrotheoryItem = stripSpecialCharacters(sMessage & " ")
        sMicrotheoryItems = ignoreCertainWords(sMicrotheoryItem)
        arrWords = Split(sMicrotheoryItems, " ")
        iCount = UBound(arrWords)
        iFoundCount = 0
        For i = 0 To iCount
            sWord = arrWords(i)
            If Len(sWord) > 2 And Trim(sWord) <> "" And IsAlphaNumeric(sWord) = True Then
                sql = "select '' from wordindex where upper(rtrim(wordvalue))=rtrim(upper(" & UCase(IsNvlString(sWord)) & "))"
                sql = sql & " and wordid=" & iId
                sql = sql & " and positionindex=" & i
                sql = sql & " and applicationid=" & sApplicationId

                cmdSelect = New OleDbCommand(sql, dbconn)
                'cmdSelect.Parameters.AddWithValue("@wordvalue", UCase(Trim(sWord)))
                'cmdSelect.Parameters.AddWithValue("@messageid", iId)
                'cmdSelect.Parameters.AddWithValue("@positionindex", i)
                        
                dr = cmdSelect.ExecuteReader

                If dr.HasRows = False Then
                    sql = "insert into wordindex "
                    sql = sql & "("
                    sql = sql & "wordid"
                    sql = sql & ",positionindex"
                    sql = sql & ",wordvalue"
                    sql = sql & ",applicationid"
                    sql = sql & ")"
                    sql = sql & " values"
                    sql = sql & "("
                    sql = sql & iId
                    sql = sql & "," & i
                    sql = sql & "," & IsNvlString(sWord)
                    sql = sql & "," & sApplicationId
                    sql = sql & ")"
                    'Response.Write sql & "<P>"
                    'Response.end
                    cmdInsert = New OleDbCommand(sql, dbconn)
                    'cmdInsert.Parameters.AddWithValue("@messageid", iId)
                    'cmdInsert.Parameters.AddWithValue("@positionindex", i)
                    'cmdInsert.Parameters.AddWithValue("@wordvalue", UCase(Trim(sWord)))
                    cmdInsert.ExecuteNonQuery()

                    'Response.Write sql & "<P>"			
                    iFoundCount = iFoundCount + 1
                End If
            End If
        Next
			
    End Sub
	    Sub connectToContentMDB()
        Dim sConnectionString As String
        sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("hrxp/content.mdb")
        dbMDBconn = New OleDbConnection(sConnectionString)
        dbMDBconn.Open()

    End Sub
    Sub closeContentMDB()
        dbMDBconn.Close()
    End Sub

	 Sub outputarticles(ByVal sCategoryName As String)
		Dim sql As String
        Dim drlocal As OleDbDataReader
        Dim sHTML As String
        Dim iCount As Integer
        
		connectToContentMDB()
        sql = "select b.siteid"
        sql = sql & ",b.headline"
        sql = sql & ",b.contentid"
        sql = sql & ",b.websitename"
        sql = sql & ",b.businessname"
        sql = sql & ",b.hits "
        sql = sql & ",b.helpfulvotes"
        sql = sql & ",b.unhelpfulvotes"
        sql = sql & " from "
        sql = sql & " content as b "
        sql = sql & " where "
        sql = sql & " ucase(b.headline) like '%" & ucase(scategoryname) & "%'"
        sql = sql & " and SiteId in (1,2,3,4,6,7)"
        sql = sql & " and approved=1"
        sql = sql & " order by b.hits desc"
	
        cmdSelect = New OleDbCommand(sql, dbMDBconn)
        drlocal = cmdSelect.ExecuteReader

        sHTML = "<ul>"
        iCount = 1
        Do While drlocal.Read
            sHTML = sHTML & "<ol>" & "<a target=_blank href='lsscontent.aspx?process=LoadView&SiteId=" & drlocal("SiteId") & "&txtContentId=" & drlocal("contentid") & "#DisplayOutput'><font size=1>" & Left(drlocal("headline"), 100) & " </font></a></ol>"
            iCount = iCount + 1
        Loop
		sHTML=sHTML & "</ul>"
        drlocal.Close()        
        lblLinks.Text = sHTML
        closeContentMDB

    End Sub
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <center>
    <a href="http://www.amazon.com/exec/obidos/ISBN=B00L05JYWY/listensoftwareso/">
    <img src="http://www.listensoftware.com/images/200px.jpg" BorderWidth=0 ></a>
    <br />Scott Harrison - The golden apples
        <br />Henry Parker's Robot Wars
		<asp:panel id=panelLinks runat=server scrollbars="vertical" height=100 backcolor="#FEF3DD">
		<asp:label id="lblLinks" runat="server"></asp:label>
		</asp:panel>
    </center>
	<br>
    <table width="100%">
    <tr>
    <td align=center>
    
    <!---------------------Input Question Panel------------------------------------->
    <asp:Panel ID="pnlInputQuestion" runat="server" Visible="false">
        <table width="640">
            <tr>
                <td valign="top" align="center">
                    <asp:Label ID="lblErrorAddMedia" runat="server" ForeColor="Red"></asp:Label>
                    <table cellspacing="0" cellpadding="0" border="1">
                        <tr id="rowReplyTo" runat="server" visible="false">
                            <td class=smallFont12>
                                Title
                            </td>
                            <td class=smallFont12>
                                <asp:Label ID="lblReplyToTitle" runat="server" CssClass="smallFont12"/>
                                <asp:Label Visible="true" ID="lblParentId" runat="server" />
                            </td>
                        </tr>
                        <tr id="rowMedia" runat="server" visible="true">
                            <td align="left" class=smallFont12>
                                Media
                            </td>
                            <td align="left">
                                (Youtube embedded html)
                                <asp:RequiredFieldValidator CssClass=smallFont12 ControlToValidate="txtMedia" ID="RequiredFieldValidator1"
                                    runat="server" ErrorMessage="Media HTML required"></asp:RequiredFieldValidator>
                                <br />
                                <asp:TextBox ID="txtMedia" Rows="5" Columns="60" CssClass=smallFont12Black TextMode="MultiLine" runat="server" />
                            </td>
                        </tr>
                        <tr id="rowTitle" runat="server" visible="true">
                            <td align="left" class=smallFont12>
                                Title
                            </td>
                            <td align="left">
                                <asp:RequiredFieldValidator ControlToValidate="txtTitle" ID="RequiredFieldValidator2"
                                    runat="server" ErrorMessage="Headline required"></asp:RequiredFieldValidator>
                                <br />
                                <asp:TextBox ID="txtTitle" Width="400px" CssClass=smallFont12Black MaxLength="100" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td align="left" class="smallFont12">
                                Message
                            </td>
                            <td align="left">
                                <asp:RequiredFieldValidator ControlToValidate="txtMessage" ID="RequiredFieldValidator3"
                                    runat="server" ErrorMessage="Message required"></asp:RequiredFieldValidator>
                                <br />
                                <asp:TextBox ID="txtMessage" Font-Size="Medium" CssClass=smallFont12Black MaxLength="2000" TextMode="multiLine"
                                    Rows="5" Columns="60" runat="server" />
                            </td>
                        </tr>
                        <tr id="rowPosition" runat="server" visible="true">
                            <td align="left" class="smallFont12">
                                Position
                            </td>
                            <td align="left">
                                <asp:RequiredFieldValidator ControlToValidate="txtPosition" ID="RequiredFieldValidator4"
                                    runat="server" ErrorMessage="Position required"></asp:RequiredFieldValidator>
                                <br />
                                <asp:TextBox ID="txtPosition" Font-Size="Medium" CssClass=smallFont12Black maxlength=10 runat="server" />
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2">
                                <asp:Button ID="btnAction" Text="Save Message" OnClick="savemessage_click" runat="server"
                                    ValidationGroup="Message" />
                                <asp:Button ID="btnCancel" Text="Cancel" CausesValidation="false" OnClick="cancel_click"
                                    ValidationGroup="Message" runat="server" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <!---------------------Display Question Panel------------------------------------->
    <asp:Panel ID="pnlDisplayQuestion" Visible="false" runat="server">
        <a name="DisplayQuestion"></a>
        <table border="0" style="font-size: medium" cellpadding="0" cellspacing="0" width="500">
            <tr>
		          <td valign="top" align="left">
                    <asp:Repeater ID="repeaterFeedback" runat="server" DataSourceID="dsFeedback">
                        <HeaderTemplate>
                            <table border="1" cellspacing="0" cellpadding="0" width="500">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td align="left" width="100" class=smallFont12>
                                    Title
                                </td>
                                <td align="left" width="400" class=smallFont12>
                                    <b><font size="4">
                                        <%#DataBinder.Eval(Container.DataItem, "title")%></font></b>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" width="100" class=smallFont12>
                                    Description
                                </td>
                                <td align="left" width="400" class=smallFont12>
                                    <%#linksToUrl(DataBinder.Eval(Container.DataItem, "message"))%>
                                </td>
                            </tr>
                            <%#ReplyMessages(DataBinder.Eval(Container.DataItem, "id"))%>
                            <tr>
                                <td colspan="2" align="center">
                                    <asp:LinkButton runat="server" ID="lnkReply" CommandArgument='<%#DataBinder.Eval(Container.DataItem, "id")%>'
                                        Text="Reply" CausesValidation="false" OnCommand="Reply_click">
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server" ID="lnkBack" Text="Back" CausesValidation="false"
                                        OnClick="back_click">
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource 
                        ID="dsFeedback" 
                        runat="server" 
                        ConnectionString="Data Source=davepamn2.db.2594332.hostedresource.com; Initial Catalog=davepamn2; User ID=davepamn2; Password=Kristal7258;"
                        >
                    </asp:SqlDataSource>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <!---------------------Question Grid Panel------------------------------------->
    <asp:Panel ID="pnlDisplayQuestionGrid" Visible="true" runat="server">
        <table width="400" border="0">
            <tr>
                <td>
                    <asp:LinkButton Font-Size="14 pt" ID="linkAddQuestion" runat="server" Text="Add Media"
                        CausesValidation="false" OnClick="AddQuestion_Click" CssClass=smallFont12></asp:LinkButton>
                </td>
				<td>
						 <asp:LinkButton Font-Size="14 pt" ID="linkBlog" runat="server" Text="Blog"
                        CausesValidation="false" OnClick="Blog_Click" CssClass=smallFont12></asp:LinkButton>
				</td>
				<td>
				     <asp:LinkButton Font-Size="14 pt" visible=false ID="linkLogin" runat="server" Text="Login"
                        CausesValidation="false" OnClick="Login_Click" CssClass=smallFont12></asp:LinkButton>
                
                    &nbsp; &nbsp;
                    <asp:TextBox ID="txtQuery" runat="server" CssClass=smallFont12Black></asp:TextBox><asp:Button ID="cmdQueryHeadline"
                        runat="server" CausesValidation="false" Text="Query" OnClick="cmdQueryHeadline_Click" />
				</td>
            </tr>
        </table>
		 <p>
		 <table>
		 <tr>
		 		<TD valign="top" width=300 align="left">
				</td>
			<td valign=top>
            <asp:GridView ID="dgFeedback" DataKeyNames="Id" DataSourceID="dsGridFeedback" BorderColor="Black"
                BorderWidth="1px" CellPadding="3" Font-Names="Verdana" Font-Size="12pt" Width="800px"
                HeaderStyle-BackColor="white" runat="server" AllowPaging="True" AllowSorting="True"
                AutoGenerateColumns="False" PageSize="5" OnRowCommand="dgFeedback_RowCommand"
                OnRowCreated="dgFeedback_RowCreated">
                <Columns>
                    <asp:CommandField ShowSelectButton="false" Visible="false" />
                    <asp:CommandField ShowEditButton="false" Visible="false" />
                    <asp:CommandField ShowDeleteButton="false" Visible="false" />
                    <asp:TemplateField HeaderText="Video" ItemStyle-Width="100px" ItemStyle-VerticalAlign="top">
                        <EditItemTemplate>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label Font-Size="Medium" ID="lblMedia" runat="server" Text='<%# eval("media") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Description" ItemStyle-Width="500px" ItemStyle-Wrap="true"
                        ItemStyle-VerticalAlign="top" ItemStyle-BackColor="silver">
                        <EditItemTemplate>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:LinkButton Font-Size="Medium" CausesValidation="false" CommandName="lnkTitle"
                                CommandArgument='<%# Eval("id") %>' ID="lnkTitle" Text='<%# Bind("Title") %>'
                                runat="server"></asp:LinkButton>
                            <p>
                                <i><font size="2">
                                    <%#GetResponse(Eval("id"), Eval("message"))%></font></i>
                                <p align="right">
                                    <asp:LinkButton Font-Size="Medium" CausesValidation="false" CommandName="lnkReply"
                                        CommandArgument='<%# Eval("id") %>' ID="LinkButton1" Text='Reply' runat="server"></asp:LinkButton>
                                    <%If Session("SecurityKeyOk") = True Then%>
                                    <asp:LinkButton Font-Size="Medium" CausesValidation="false" CommandName="lnkDelete"
                                        CommandArgument='<%# Eval("id") %>' ID="LinkButton2" Text='Delete' runat="server"></asp:LinkButton>
                                    <%End If%>
                                </p>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle BackColor="white" />
                <PagerSettings Position="TopAndBottom" />
            </asp:GridView>
            <asp:sqldataSource ID="dsGridFeedback" runat="server" 
ConnectionString="Data Source=davepamn2.db.2594332.hostedresource.com; Initial Catalog=davepamn2; User ID=davepamn2; Password=Kristal7258;"

                SelectCommand="select id,media,title,message,applicationid from messages where parentid=-1 and applicationid=2 order by position desc"
                InsertCommand=""
                DeleteCommand="">

                <InsertParameters>
                    <asp:Parameter Name="@ParentId" Type="Int32" />
                    <asp:Parameter Name="@Media" Type="String" />
                    <asp:Parameter Name="@Title" Type="String" />
                    <asp:Parameter Name="@Message" Type="String" />
                    <asp:Parameter Name="@LastUpdated" Type="String" />
                    <asp:Parameter Name="@ApplicationId" Type="Int32" />
                    <asp:Parameter Name="@Position" Type="Int32" />
                </InsertParameters>
                <DeleteParameters>
                    <asp:Parameter Name="@Id" Type="Int32" />
                </DeleteParameters>
            </asp:sqldatasource>
			</td>
			</tr>
			</table>
    </asp:Panel>
</td></tr></table>

</asp:Content>


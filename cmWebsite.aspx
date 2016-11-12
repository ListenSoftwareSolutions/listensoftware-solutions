<%@ Page Language="VB" maintainscrollpositiononpostback=true MasterPageFile="~/lssMasterPage.master" Title="Website Directory" %>

<%@ Import Namespace="system.data" %>
<%@ Import Namespace="system.data.oledb" %>
<%@ Import Namespace="system.IO" %>
<%@ Import Namespace="system.xml" %>
<%@ Import Namespace="System.Xml.XmlNode" %>
<%@ Import Namespace="System.Xml.XmlDocument" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<%@ Import Namespace="System.Xml.XPath" %>
<%@ import Namespace="Microtheory"%>
<%@import Namespace="System.Net.Mail"%>


<script runat="server">

    Dim dbconn As OleDbConnection
    Dim dbsqlserverconn As OleDbConnection
    'Dim dbconnurl As OleDbConnection
    Dim dbconnAd As OleDbConnection
    Dim cmdSelect As OleDbCommand
    Dim cmdUpdate As OleDbCommand
    Dim cmdInsert As OleDbCommand
    Dim cmdDelete As OleDbCommand
    Dim cmdinsertupdate As OleDbCommand
    Dim dr As OleDbDataReader
    Dim objMTFunc As New cMT_Functions

    Class cProfile
        Public iContentId As Integer
        Public sContent As String
        Public sApproved As String
        Public sSiteId As String
        Public sAuthor As String
        Public sOverview As String
        Public sWebsiteName As String
        Public sWebsiteURL As String
        Public sBannerURL As String
        Public sService As String
        Public sEmail As String
        Public sPhone As String
        Public sFax As String
        Public sAddress1 As String
        Public sAddress2 As String
        Public sState As String
        Public sCity As String
        Public sZipcode As String
        Public sCountry As String
        Public sDescriptionParagraph1 As String
        Public sDescriptionParagraph2 As String
        Public sDescriptionParagraph3 As String
        Public sProductLine1 As String
        Public sProductUrlLine1 As String
        Public sProductLine2 As String
        Public sProductUrlLine2 As String
        Public sProductLine3 As String
        Public sProductUrlLine3 As String
        Public sType As String
        Public sBusinessName As String
        Public sTypeId As String
        Public iHits As Integer
    End Class
    Dim oProfile As New cProfile
    Sub connectADMDB()
        Dim sConnectionString As String
        sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("hrxp/ad.mdb")
        dbconnAd = New OleDbConnection(sConnectionString)
        dbconnAd.Open()
    End Sub
    Sub closeADMDB()
        dbconnAd.Close()
    End Sub
    'Sub connectURLMDB()
    '    Dim sConnectionString As String
    '    sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("hrxp/spider.mdb")
    '    dbconnurl = New OleDbConnection(sConnectionString)
    '    dbconnurl.Open()
    'End Sub
    'Sub closeURLMDB()
    '    dbconnurl.Close()
    'End Sub
    Function Introspective(ByVal sPhrase As String) As String
        Dim sRetVal As String
        Dim bRetVal As Boolean

        Dim regx As Regex = New Regex(RegexOptions.Multiline Or RegexOptions.IgnoreCase)

        sRetVal = ""
        sPhrase = UCase(Trim(sPhrase))

        'Interrogative
        'bRetVal = regx.IsMatch(sPhrase, "^(WILL YOU|WHAT DO YOU|WHAT IS|WHAT ARE)[\s\w\b]*[\s,/?]*$")
        'If bRetVal = True Then
        '    sRetVal = sRetVal & objMTFunc.microtheory(sPhrase, dbsqlserverconn)
        'End If

        bRetVal = regx.IsMatch(sPhrase, "^(WHY)[\s\w\b]*[\s,/?]*$")
        If bRetVal = True Then
            sRetVal = sRetVal & objMTFunc.CauseAndAffect(sPhrase, dbsqlserverconn)
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(HOW)[\s\w\b]*[\s,/?]*$")
        If bRetVal = True Then
            sRetVal = sRetVal & objMTFunc.HowTo(sPhrase, dbsqlserverconn)
        End If


        'bRetVal = regx.IsMatch(sPhrase, "^(WHAT DO YOU DO|WHAT DO YOU FEEL|ARE|WHATS UP|WHAT/'S UP)(GO|GOTO|SHOW|GET|DISPLAY)*[\s\w\b]*[\s,/?]*$")
        'If bRetVal = True Then
        '    sRetVal = sRetVal & objMTFunc.Articles(sPhrase, dbsqlserverconn)
        'End If
        'bRetVal = regx.IsMatch(sPhrase, "^(SHOW|LIST|GIVE|PROVIDE)\s*(ME)\s*[\s\w\b/.]*$")
        'If bRetVal = True Then
        '    sRetVal = sRetVal & objMTFunc.VERB(sPhrase, dbsqlserverconn)
        'End If

        'bRetVal = regx.IsMatch(sPhrase, "^(I WANT|MY GOAL IS|I BELIEVE)\s+[\s\w\b]*[\s,/?]*$")
        'If bRetVal = True Then
        '    sRetVal = objMTFunc.AskHowTheyDid(sPhrase, dbsqlserverconn)
        '    Return (sRetVal)
        'End If

        'bRetVal = regx.IsMatch(sPhrase, "^(I AM|WE|WE ARE|OUR|MINE)\s+[\s\w\b]*[\s,/?]*$")
        'If bRetVal = True Then
        '    sRetVal = objMTFunc.LookForAPattern(sPhrase, dbsqlserverconn)
        '    Return (sRetVal)
        'End If

        'bRetVal = regx.IsMatch(sPhrase, "^(I WOULD)\s+[\s\w\b]*[\s,/?]*$")
        'If bRetVal = True Then
        '    sRetVal = objMTFunc.WordsOfWisdom(sPhrase)
        '    Return (sRetVal)
        'End If

        'bRetVal = regx.IsMatch(sPhrase, "^(THEY)\s+[\s\w\b]*[\s,/?]*$")
        'If bRetVal = True Then
        '    sRetVal = "Who are they?"
        '    Return (sRetVal)
        'End If

        'bRetVal = regx.IsMatch(sPhrase, "^(YOU)\s+(SHOULD)[\s\w\b]*[\s,/?]*$")
        'If bRetVal = True Then
        '    sRetVal = objMTFunc.formatAnswer(sPhrase, Replace(UCase(sPhrase), "YOU SHOULD", "WHY SHOULD I"), dbsqlserverconn)
        '    Return (sRetVal)
        'End If


        'bRetVal = regx.IsMatch(sPhrase, "^(HOW DO YOU DO|GREETINGS|HELLO|HI|GREETING|GOOD MORNING|GOOD EVENING|GOOD NIGHT)$")
        'If bRetVal = True Then
        '    sRetVal = sRetVal & objMTFunc.Articles(sPhrase, dbsqlserverconn)
        '    'sRetVal = sRetVal & objMTFunc.formatAnswer(sPhrase, "Hi, how are you?", dbsqlserverconn)
        '    Return (sRetVal)
        'End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(QUESTIONS|WHY)\s*\w*$")
        If bRetVal = True Then
            Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
            Response.Redirect("lssWhyQuestions.html")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(THEORIES|MICROTHEORIES)\s*\w*$")
        If bRetVal = True Then
            Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
            Response.Redirect("lssMicrotheories.html")
        End If


        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(MONEY|VALUE|VALUATION)\s*(TO DO)\w*$")
        If bRetVal = True Then
            Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
            Response.Redirect("tdldefault.aspx")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(MONEY|VALUE|VALUATION)\s*(CHECKLIST|TASKS|CHECK LIST|THINGS|THINGS TO DO)\w*$")
        If bRetVal = True Then
            Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
            Response.Redirect("checklist.aspx")
        End If


        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(ARTICLES|BOOKS|REVIEW)\s*\w*$")
        If bRetVal = True Then
            Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
            Response.Redirect("lssArticleList.html")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(IMAGES|PICTURES|ALBUMS)\s*\w*$")
        If bRetVal = True Then
            Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
            Response.Redirect("lssImages.aspx")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(PUNCH|PUNCHIN|TIME EDITOR)\s*\w*$")
        If bRetVal = True Then
            Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
            Response.Redirect("timedefault.aspx")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(BLOG|THOUGHT|RESEARCH|NOTES)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("ebdefault.aspx")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(SOFTWARE|CODE|APPLICATIONS)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("http://www.listensoftware.com/hrxp/cmmain.asp?siteid=5")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(ADMIN|LOGIN|SECURITY|ADMINISTRATION)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("lsslogin.aspx")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(SWEETER)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("sweeterdefault.aspx")
        End If

     bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(FAMILY|FAMILY TREE|GENEALOGY)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("lssfamilytree.html")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)*\s*(WEBSITES|WEBSITE|BUSINESSES|DIRECTORY)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("websitesetup.aspx")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)\s*(LINKS|LINK|URL|URLS)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("lssuniqueword.aspx")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)\s*(QUESTIONS|PHRASES|SEARCHES|INQUIRIES)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("searchphrase.aspx")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)\s*(MEDIA|SILVER|GOLD)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("lssMedia.aspx")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)\s*(SEARCH|SEARCH ENGINE|QUERY|FIND|LOOKUP)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("cmwebsite.aspx")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)\s*(AGENT|ROBOT)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("rpet.aspx")
        End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO|GOTO|GET|DISPLAY)\s*(HELP|MAP|SITE MAP)\s*\w*$")
        If bRetVal = True Then
            Response.Redirect("lssHelp.aspx")
        End If

        'bRetVal = regx.IsMatch(sPhrase, "^(DESCRIBE|INSTRUCT|INFORM|TELL|EXPLAIN|GIVE|PROVIDE)[\s\w\b]*(XCODE|APPLE|OBJECTIVE C|PROGRAMMING)+(\b)*[\s,/?]*$")
        'If bRetVal = True Then
        '    Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
        '    Response.Redirect("ebformeditdisplay.aspx?txtApplicationId=93")
        '    Return (sRetVal)
        'End If

        'bRetVal = regx.IsMatch(sPhrase, "^(DESCRIBE|INSTRUCT|INFORM|TELL|EXPLAIN|GIVE|PROVIDE)[\s\w\b]*(FED|BANKS|FINANCE|ECB|IMF|STOCK MARKET|CRASH)+(\b)*[\s,/?]*$")
        'If bRetVal = True Then
        '    Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
        '    Response.Redirect("ebformeditdisplay.aspx?txtApplicationId=39")
        '    Return (sRetVal)
        'End If

        'bRetVal = regx.IsMatch(sPhrase, "^(DESCRIBE|INSTRUCT|INFORM|TELL|EXPLAIN|GIVE|PROVIDE)[\s\w\b]*(STOCKS|BONDS|COMMODITIES|INDEXES|TRADING)+(\b)*[\s,/?]*$")
        'If bRetVal = True Then
        '    Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
        '    Response.Redirect("ebformeditdisplay.aspx?txtApplicationId=20")
        '    Return (sRetVal)
        'End If


        'bRetVal = regx.IsMatch(sPhrase, "^(DESCRIBE|INSTRUCT|INFORM|TELL|EXPLAIN|GIVE|PROVIDE)[\s\w\b]*(STOCKS|BONDS|COMMODITIES|INDEXES|TRADING)+(\b)*[\s,/?]*$")
        'If bRetVal = True Then
        '    Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
        '    Response.Redirect("ebformeditdisplay.aspx?txtApplicationId=20")
        '    Return (sRetVal)
        'End If

        'bRetVal = regx.IsMatch(sPhrase, "^(DESCRIBE|INSTRUCT|INFORM|TELL|EXPLAIN|GIVE|PROVIDE)[\s\w\b]*(SHALE|FUSION|ENERGY|OIL|SOLAR|WIND|SHALE|NATURAL GAS)+(\b)*[\s,/?]*$")
        'If bRetVal = True Then
        '    Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
        '    Response.Redirect("ebformeditdisplay.aspx?txtApplicationId=50")
        '    Return (sRetVal)
        'End If

        'bRetVal = regx.IsMatch(sPhrase, "^(DESCRIBE|INSTRUCT|INFORM|TELL|EXPLAIN|GIVE|PROVIDE)[\s\w\b]*(EV|EVS|FCV|FUEL CELL|FUEL CELL VEHICLES|HYBRIDS|PLUGIN|PLUG IN|PLUGINS)+(\b)*[\s,/?]*$")
        'If bRetVal = True Then
        '    Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
        '    Response.Redirect("ebformeditdisplay.aspx?txtApplicationId=70")
        '    Return (sRetVal)
        'End If

        'bRetVal = regx.IsMatch(sPhrase, "^(DESCRIBE|INSTRUCT|INFORM|TELL|EXPLAIN|GIVE|PROVIDE)[\s\w\b]*(SWEDEN|RUSSIA|CHINA|GEORGIA|NORWAY|FINLAND|DENMARK|EUROPE|INDIA|SHENZHEN|GUANGHOU|CANDA|KAZAHKSTAN|BRAZIL|VENEZUELA|ECUDAOR|ARGENTINA)+(\b)*[\s,/?]*$")
        'If bRetVal = True Then
        '    Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
        '    Response.Redirect("ebformeditdisplay.aspx?txtApplicationId=51")
        '    Return (sRetVal)
        'End If

        'bRetVal = regx.IsMatch(sPhrase, "^(DESCRIBE|INSTRUCT|INFORM|TELL|EXPLAIN|GIVE|PROVIDE)[\s\w\b]*(AUTOMOTIVE|CARS|VEHICLES)+(\b)*[\s,/?]*$")
        'If bRetVal = True Then
        '    Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
        '    Response.Redirect("ebformeditdisplay.aspx?txtApplicationId=45")
        '    Return (sRetVal)
        'End If

        bRetVal = regx.IsMatch(sPhrase, "^(GO SCHEDULE|GOTO SCHEDULE|SCHEDULE|SCHEDULING)\s*(EXTREME|SOFTWARE)*\s*(PRO)*[\s,/?]*$")
        If bRetVal = True Then
            Response.AppendHeader("Content-disposition", "inline; target=" & "_blank")
            Response.Redirect("sxpDefault.aspx")
            Return (sRetVal)
        End If

        If sRetVal = "" Then
            Dim arrElement As Array
            Dim iUpperBound As Integer
            Dim i As Integer
            Dim sBuffer As String = ""
            Dim sWord As String

            arrElement = Split(UCase(sPhrase) & " ", " ")
            iUpperBound = UBound(arrElement)

            'Search Previous Questions
            If iUpperBound > 3 And iUpperBound < 10 Then
                sRetVal = objMTFunc.GetFeedback(sPhrase, dbsqlserverconn)
            End If
        End If

        Return (sRetVal)

    End Function
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
    Sub connectToContentMDB()
        Dim sConnectionString As String
        sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("hrxp/content.mdb")
        dbconn = New OleDbConnection(sConnectionString)
        dbconn.Open()
    End Sub
    Sub closeContentMDB()
        If Not dbconn Is Nothing Then
            dbconn.Close()
        End If
    End Sub
    Sub displayPage(ByVal oProfile As cProfile)
        Dim sHTML As String

        'panelView2.Visible = True
        sHTML = "<table bgcolor=#ffffcc>"
        With oProfile

            If .sBusinessName <> "" Then
                sHTML = sHTML & "<tr><td><b>Name</b></td><td>" & .sBusinessName & " </td></tr>"
            End If
            'If .sWebsiteName <> "" Then
            'sHTML = sHTML & "<tr><td>Business Name</td><td>" & .sWebsiteName & "</td></tr>"
            'End If
            If .sBannerURL <> "http://" And .sBannerURL <> "" Then
                sHTML = sHTML & "<tr><td><b>Banner</b></td><td><img src='" & .sBannerURL & "' border=0></td></tr>"
            End If
            If .sWebsiteURL <> "" Then
                sHTML = sHTML & "<tr><td><b>URL</b></td><td><a target=_blank href='" & .sWebsiteURL & "'>Click Here</a></td></tr>"
            End If
            If .sOverview <> "" Then
                sHTML = sHTML & "<tr><td><b>Overview</b></td><td>" & .sOverview & "</td></tr>"
            End If
            If .sAuthor <> "" Then
                sHTML = sHTML & "<tr><td>Author</td><td>" & .sAuthor & "</td></tr>"
            End If
            If .sPhone <> "" Then
                sHTML = sHTML & "<tr><td>Phone</td><td>" & .sPhone & "</td></tr>"
            End If
            If .sFax <> "" Then
                sHTML = sHTML & "<tr><td>Fax</td><td>" & .sFax & "</td></tr>"
            End If
            If .sEmail <> "" And UCase(.sEmail) = "NA" Then
                sHTML = sHTML & "<tr><td>Email</td><td>" & .sEmail & "</td></tr>"
            End If
            If .sAddress1 <> "" Then
                sHTML = sHTML & "<tr><td>Address1</td><td>" & .sAddress1 & "</td></tr>"
            End If
            If .sAddress2 <> "" Then
                sHTML = sHTML & "<tr><td>Address2</td><td>" & .sAddress2 & "</td></tr>"
            End If
            If .sCity <> "" Then
                sHTML = sHTML & "<tr><td>City</td><td>" & .sCity & "</td></tr>"
            End If
            If .sState <> "" Then
                sHTML = sHTML & "<tr><td><b>State</b></td><td>" & .sState & "</td></tr>"
            End If
            If .sZipcode <> "" Then
                sHTML = sHTML & "<tr><td>Zip</td><td>" & .sZipcode & "</td></tr>"
            End If
            If .sCountry <> "" Then
                sHTML = sHTML & "<tr><td>Country</td><td>" & .sCountry & "</td></tr>"
            End If
            If .sProductUrlLine1 <> "http://" And .sProductUrlLine1 <> "" Then
                If .sProductLine1 <> "" Then
                    sHTML = sHTML & "<tr><td>URL</td><td><a target=_blank href='" & .sProductUrlLine1 & "'>" & .sProductLine1 & "</a></td></tr>"
                Else
                    sHTML = sHTML & "<tr><td>URL</td><td><a target=_blank href='" & .sProductUrlLine1 & "'>Click Here</a></td></tr>"
                End If
            End If
            If .sProductUrlLine2 <> "http://" And .sProductUrlLine2 <> "" Then
                If .sProductLine2 <> "" Then
                    sHTML = sHTML & "<tr><td>URL</td><td><a target=_blank href='" & .sProductUrlLine2 & "'>" & .sProductLine2 & "</a></td></tr>"
                Else
                    sHTML = sHTML & "<tr><td>URL</td><td><a target=_blank href='" & .sProductUrlLine2 & "'>Click Here</a></td></tr>"
                End If

            End If
            If .sProductUrlLine3 <> "http://" And .sProductUrlLine3 <> "" Then
                If .sProductUrlLine3 <> "" Then
                    sHTML = sHTML & "<tr><td>URL</td><td><a target=_blank href='" & .sProductUrlLine3 & "'>" & .sProductLine3 & "</a></td></tr>"
                Else
                    sHTML = sHTML & "<tr><td>URL</td><td><a target=_blank href='" & .sProductUrlLine3 & "'>Click Here</a></td></tr>"
                End If
            Else
            End If

        End With
        sHTML = sHTML & "</table>"

        lblView2.Text = sHTML

        Dim sql As String
        sql = "update content set hits=hits+1 where contentid=" & oProfile.iContentId

        cmdUpdate = New OleDbCommand(sql, dbconn)
        cmdUpdate.ExecuteNonQuery()


    End Sub

    'Sub loadContent(ByRef oProfile As cProfile, ByVal iContentId As Integer)
    'Dim sql As String
    'Dim doc As New XmlDocument
    'Dim oNodes As XmlNodeList
    'Dim oNode As XmlNode
    'Dim oRootNode As XmlNode
    'Dim dr2 As OleDbDataReader
    'Dim namespaceManager As XmlNamespaceManager

    '    sql = "select "
    '    sql = sql & " [content]"
    '    sql = sql & " ,[approved]"
    '    sql = sql & " ,[siteid]"
    '    sql = sql & " ,[author]"
    '    sql = sql & " ,[hits]"
    '    sql = sql & " from [content] as contentsource "
    '    sql = sql & " where siteid=-2"
    '    sql = sql & " and [contentid]=@contentId"

    '    cmdSelect = New OleDbCommand(sql, dbconn)
    '    cmdSelect.Parameters.AddWithValue("@contentid", iContentId)
    '    dr = cmdSelect.ExecuteReader

    '    If dr.Read Then
    'sTypeId=rs("type")
    '        oProfile.iHits = dr("hits")
    '        oProfile.iContentId = iContentId
    '        oProfile.sContent = dr("content")
    '        oProfile.sApproved = "" & dr("approved")
    '        oProfile.sSiteId = "" & dr("siteid")
    '        oProfile.sAuthor = "" & dr("author")

    '        If oProfile.sContent <> "" Then
    '-----------Open the XML content as a DOM object
    '            doc.LoadXml(oProfile.sContent)

    'namespaceManager = New XmlNamespaceManager(doc.NameTable)

    '            oNodes = doc.SelectNodes("//site/*")

    'oRootNode = doc.FirstChild.FirstChild
    'oNodes = oRootNode.ChildNodes

    '            For Each oNode In oNodes
    '                Select Case oNode.Name
    '                    Case "headline"
    '                        oProfile.sOverview = oNode.FirstChild.Value
    '                    Case "business_name"
    '                        oProfile.sBusinessName = oNode.FirstChild.Value
    '                    Case "website_name"
    '                        oProfile.sWebsiteName = oNode.FirstChild.Value
    '                    Case "website_url"
    '                        oProfile.sWebsiteURL = oNode.FirstChild.Value
    '                    Case "banner_url"
    '                        oProfile.sBannerURL = oNode.FirstChild.Value
    '                    Case "service"
    '                        oProfile.sService = oNode.FirstChild.Value
    '                        sql = "select * from wscategories where name=@Service"

    'Response.Write "<font color=white>"&sql&"</font>"

    '                        cmdSelect = New OleDbCommand(sql, dbconn)
    '                        cmdSelect.Parameters.AddWithValue("@Service", oProfile.sService)
    '                        dr2 = cmdSelect.ExecuteReader

    '                        If dr2.Read Then
    '                            oProfile.sTypeId = dr2("categoryid")
    '                        End If
    '                        dr2.Close()


    '                    Case "email"
    '                       oProfile.sEmail = oNode.FirstChild.Value
    '                    Case "phone"
    '                        oProfile.sPhone = oNode.FirstChild.Value
    '                    Case "fax"
    '                        oProfile.sFax = oNode.FirstChild.Value
    '                    Case "address1"
    '                        oProfile.sAddress1 = oNode.FirstChild.Value
    '                    Case "address2"
    '                        oProfile.sAddress2 = oNode.FirstChild.Value
    '                    Case "state"
    '                        oProfile.sState = oNode.FirstChild.Value
    '                    Case "city"
    '                        oProfile.sCity = oNode.FirstChild.Value
    '                    Case "zipcode"
    '                        oProfile.sZipcode = oNode.FirstChild.Value
    '                    Case "country"
    '                        oProfile.sCountry = oNode.FirstChild.Value
    '                    Case "description_paragraph1"
    '                        oProfile.sDescriptionParagraph1 = oNode.FirstChild.Value
    '                    Case "description_paragraph2"
    '                        oProfile.sDescriptionParagraph2 = oNode.FirstChild.Value
    '                    Case "description_paragraph3"
    '                        oProfile.sDescriptionParagraph3 = oNode.FirstChild.Value
    '                    Case "product_line1"
    '                        oProfile.sProductLine1 = oNode.FirstChild.Value
    '                    Case "product_url_line1"
    '                        oProfile.sProductUrlLine1 = oNode.FirstChild.Value
    '                    Case "product_line2"
    '                        oProfile.sProductLine2 = oNode.FirstChild.Value
    '                    Case "product_url_line2"
    '                        oProfile.sProductUrlLine2 = oNode.FirstChild.Value
    '                    Case "product_line3"
    '                        oProfile.sProductLine3 = oNode.FirstChild.Value
    '                    Case "product_url_line3"
    '                        oProfile.sProductUrlLine3 = oNode.FirstChild.Value
    '                End Select
    '            Next
    '            doc = Nothing

    '       End If

    '  End If

    '  dr.Close()

    'End Sub
    Sub LoadParameters()
        'Dim lItem As New ListItem
        'Dim dr As OleDbDataReader
        'Dim sql As String

        'connectADMDB()

        'sql = "select ucase(word) & ' hits=' & format(hits,'###,###,###') as worddisplay, word from keyword where trim(word)<>'' "
        'sql = sql & " and lastupdated>=#" & FormatDateTime(DateAdd(DateInterval.Day, -7, Now), 2) & "#"
        'sql = sql & " and hits > 5000"
        'sql = sql & " order by hits desc"

        'cmdSelect = New OleDbCommand(sql, dbconnAd)
        'dr = cmdSelect.ExecuteReader

        'lItem.Text = "Select One"
        'lItem.Value = ""
        'With lbxPopularWords
        '.DataSource = dr
        '.AutoPostBack = True
        '.DataTextField = "worddisplay"
        '.DataValueField = "word"
        '.DataBind()
        '.Items.Insert(0, lItem)
        'End With
        'dr.Close()
        'closeADMDB()

        Dim sql As String
        Dim sb As StringBuilder = New StringBuilder

        Sql = "SELECT "
        sql = sql & " distinct uniqueword, count(*) as SumCount "
        sql = sql & " FROM AssociatedLinks "
        sql = sql & " where len(uniqueword)<20"
        sql = sql & " group by uniqueword"
        sql = sql & " having count(*)>50"
        sql = sql & " order by uniqueword"

        'cmdSelect = New OleDbCommand(sql, dbconnurl)
        cmdSelect = New OleDbCommand(Sql, dbsqlserverconn)
        dr = cmdSelect.ExecuteReader
        'sb.Append("<hr>")
        'sb.Append("<table border=1><tr>")
        sb.append("<h3>Keyword Search</h3>")
        Do While dr.Read

            sb.Append("<a href='cmwebsite.aspx?txtSearch=" & Replace(dr("uniqueword"), " ", "+") & "'>" & Strings.StrConv(dr("uniqueword"), VbStrConv.ProperCase) & "</a>&nbsp;(" & dr("SumCount") & ")&nbsp;&nbsp;&nbsp;<br>")
        Loop
        ' sb.Append("</tr></table>")
        lblUniqueWordList.Text = sb.ToString


    End Sub
    Public Class cEmail
        Public txtEmail As String
        Public txtMessage As String
    End Class
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
        Mail.Subject = "LSS Website Search"

        Mail.Body = sMessageContent
        Mail.IsBodyHtml = True
        Mail.Bcc.Add("dnishimoto@listensoftware.com")

        Dim smtp As New System.Net.Mail.SmtpClient
        smtp.Host = "relay-hosting.secureserver.net"
        smtp.Credentials = New System.Net.NetworkCredential("davepamn", "nishimoto7258")
        Try
            smtp.Send(Mail)
        Catch ex As Exception

        End Try
    End Sub
    Function IsBot(ByVal Request As System.Web.HttpRequest) As Boolean
        If (Request.Browser.Crawler) Then Return True
        Dim myUserAgent As String = Request.UserAgent.ToLower

        Dim sIPAddress As String = Trim(Request.ServerVariables("Remote_Addr"))

        If  sIPAddress="91.109.91.34" or sIPAddress="85.87.228.161" or sIPAddress="83.28.217.206" or sIPAddress="62.219.8.239" or sIPAddress = "27.251.83.216" Or sIPAddress = "195.52.192.109" Or sIPAddress = "66.194.55.249" Or sIPAddress = "173.193.219.168" Then
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

        Call SendEmail("dnishimoto@listensoftware.com", "dnishimoto@listensoftware.com", myUserAgent & " " & sIPAddress)

        Return False
    End Function
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        connectToContentMDB()
        OpenSQLServer()

        'If Not Request.Cookies("EmailCookies") Is Nothing Then
        'Session("Email") = Request.Cookies("EmailCookies").Value
        'Session("UserSecurityKeyOk") = True
        'End If

        If IsPostBack = False Then
            LoadParameters()
        End If


        'If Session("SecurityKeyOk") = True Or Session("UserSecurityKeyOk") = True Then
        'cmdQuery.Enabled = True
        lblLoginMessage.Text = ""
        'Else
        'lblLoginMessage.Text = "<a href='lssUserLogin.aspx?url=cmwebsite.aspx'>Login Required:</a>"
        'cmdQuery.Enabled = False
        'End If
        If Request("txtSearch") <> "" And txtSearch.Text = "" Then
            txtSearch.Text = Request("txtSearch")
            If Not IsPostBack Then
                QueryList()
            End If
        ElseIf txtSearch.Text <> "" Then
            'QueryList()
        Else
            If Not IsPostBack Then
                'loadTreeView()
            End If
        End If

    End Sub

    '    Sub loadTreeView()
    'Dim sql As String
    'Dim drLocal As OleDbDataReader
    'Dim iCount As Integer
    '    sql = "SELECT categoryid, sitecount, "
    '    sql = sql & " Name"
    '    sql = sql & " FROM WSCategories a"
    '    sql = sql & " WHERE EXISTS"
    '    sql = sql & " ("
    '    sql = sql & " SELECT '' as expr1 "
    '    sql = sql & " FROM          Content b"
    '    sql = sql & " WHERE (a.categoryid = type)"
    '    sql = sql & " and siteid=-2"
    '    sql = sql & " )"
    '    sql = sql & " order by name"

    '    cmdSelect = New OleDbCommand(sql, dbconn)
    '    drLocal = cmdSelect.ExecuteReader
    '    treeDirectory.Nodes.Clear()
    '    iCount = 0
    '    Do While drLocal.Read
    'If drLocal.Read Then
    'Dim oNode As New TreeNode
    '        oNode.Value = "CATEGORY=" & drLocal("categoryid")
    'oNode.Text = drLocal("Name") & " <font color=red>(" & drLocal("sitecount") & ")" & "</font>"
    '        oNode.Text = drLocal("Name")
    '        oNode.PopulateOnDemand = False
    '        treeDirectory.Nodes.Add(oNode)
    'End If
    '        iCount += 1
    '        If iCount > 25 Then
    '            Exit Do
    '        End If
    '    Loop
    '    drLocal.Close()

    'End Sub

    'Sub AddChildNodeToTree(ByRef oRootNode As TreeNode, ByVal iContentId As Integer, ByVal sText As String)
    'Dim oNode As New TreeNode

    '   With oNode
    '       .Value = "PROFILE=" & iContentId
    '       .Text = sText
    '   End With

    '   oRootNode.ChildNodes.Add(oNode)
    '   treeDirectory.ExpandAll()

    'End Sub

    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs)
        closeContentMDB()
        CloseSQLServer()

    End Sub
    Sub outputassociatedurl(ByVal sCategoryName As String)
        Dim sql As String
        Dim sb As StringBuilder = New StringBuilder
        Dim iCount As Integer

        'connectURLMDB()

        'panelView3.Visible = True

        'sql = "SELECT "
        'sql = sql & " hits,id,uniqueword,URL,Description"
        'sql = sql & " FROM AssociatedLinks "
        'sql = sql & " where uniqueword like '" & Replace(UCase(sCategoryName), "'", "''") & "%'"
        'sql = sql & " order by id desc"

        'cmdSelect = New OleDbCommand(sql, dbconnurl)
        'dr = cmdSelect.ExecuteReader

        'sb.Append("<table><tr><td><center><a href='http://www.listensoftware.com/hrxp/cmUniqueWord.asp?txtCategory=&process=AddUrl&txtUniqueWord=" & sCategoryName & "'>Add URL</a></center><p><hr>")
        'sb.Append("<font size=5>Recently Added</font><br>")
        'iCount = 0
        'Do While dr.Read
        'sb.Append("<a target=_blank href='" & dr("url") & "'>" & dr("description") & "</a>" & "<br><br>")
        'iCount += 1
        'If iCount > 10 Then
        'Exit Do
        'End If
        'Loop
        'sb.Append("</td></tr></table>")

        sql = "SELECT "
        sql = sql & " hits,id,uniqueword,URL,Description"
        sql = sql & " FROM AssociatedLinks "
        sql = sql & " where uniqueword like '" & Replace(UCase(sCategoryName), "'", "''") & "%'"
        sql = sql & " order by id desc"
        'cmdSelect = New OleDbCommand(sql, dbconnurl)
        cmdSelect = New OleDbCommand(sql, dbsqlserverconn)
        dr = cmdSelect.ExecuteReader
        'sb.Append("<hr>")
        sb.Append("<table><tr><td>")
        iCount = 0
        Do While dr.Read
            'lblView3.Text += "<a target=_blank href='" & dr("url") & "'>" & dr("description") & "(" & dr("hits") & ")" & "</a><br>"
            'sb.Append("<a target=_blank href='hrxp/cmUniqueWord.asp?id=" & dr("id") & "&process=UserClick&url=" & dr("url") & "'>" & dr("description") & "</a>&nbsp;(" & dr("hits") & ")" & "<br><br>")
            sb.Append("<a target=_blank href='" & dr("url") & "'>" & dr("description") & "</a>" & "<br><br>")
            iCount += 1
            If iCount > 1000 Then
                Exit Do
            End If
        Loop
        sb.Append("</td></tr></table>")

        lblView3.Text = sb.ToString
        dr.Close()
        'closeURLMDB()

    End Sub
    Function GetCategoryName(ByVal iType As Integer) As String
        Dim sql As String
        Dim sRetVal As String
        Dim drLocal As OleDbDataReader

        sRetVal = ""
        sql = "select name from wscategories where categoryid=" & iType
        cmdSelect = New OleDbCommand(sql, dbconn)
        drLocal = cmdSelect.ExecuteReader
        If drLocal.Read Then
            sRetVal = drLocal("name")
        End If
        drLocal.Close()
        Return sRetVal
    End Function
    'Sub loadChildrenProfiles(ByVal itype As Integer)
    'Dim sql As String
    'Dim drlocal As OleDbDataReader
    'Dim oNodes As TreeNodeCollection
    'Dim oNode As TreeNode

    'panelView1_1.Visible = False
    'panelView1_2.Visible = True

    '------------Clear the Sub Directory Tree------
    '    oNodes = TreeSubDirectory.Nodes
    '    If oNodes.Count > 0 Then
    '        oNode = oNodes.Item(0)
    '        TreeSubDirectory.Nodes.Remove(oNode)
    '    End If
    '------------Add Parent Node--------------------
    '    oNode = New TreeNode
    '    oNode.Value = "ROOT"
    '    oNode.Text = "Profiles"
    '    TreeSubDirectory.Nodes.Add(oNode)

    '--------------Load Children Profiles
    '    sql = "select businessname,contentid,headline from content where type=" & itype & " and siteid=-2"
    '    sql = sql & " and trim(businessname)<>''"
    '    sql = sql & " order by businessname"
    '    cmdSelect = New OleDbCommand(sql, dbconn)
    '    drlocal = cmdSelect.ExecuteReader
    '    Do While drlocal.Read
    '        AddChildNodeToTree(oNode, drlocal("contentId"), "" & Left(drlocal("businessname"), 20))
    '    Loop
    '    drlocal.Close()
    '    TreeSubDirectory.ExpandAll()
    'End Sub
    'Protected Sub treeDirectory_SelectedNodeChanged(ByVal sender As Object, ByVal e As System.EventArgs)
    'Dim sResult As String
    'Dim oTreeNode As TreeNode
    'Dim sql As String
    'Dim iType As Integer
    'Dim sKeyValue As String
    'Dim sCategoryName As String
    '    oTreeNode = treeDirectory.SelectedNode
    '
    '    txtSearch.Text = ""
    '    lblView2.Text = ""
    '
    '    sCategoryName = ""
    '    If InStr(oTreeNode.Value, "CATEGORY=") > 0 Then
    '        sKeyValue = oTreeNode.Value
    '        iType = CInt(Mid(sKeyValue, 10, Len(sKeyValue) - 9))
    '        sCategoryName = GetCategoryName(iType)
    '        lblCategory.Text = oTreeNode.Text
    '        OutputArticles(sCategoryName)
    '        outputassociatedurl(sCategoryName)
    '        linkButtonBackButton.Visible = True
    '        loadChildrenProfiles(iType)
    '    End If
    'End Sub

    'Protected Sub treeSubDirectory_SelectedNodeChanged(ByVal sender As Object, ByVal e As System.EventArgs)
    ' Dim oTreeNode As TreeNode
    ' Dim oCheckedNode As TreeNode
    ' Dim iContentId As Integer
    'Dim sKeyValue As String
    '    oTreeNode = TreeSubDirectory.SelectedNode
    '    sKeyValue = oTreeNode.Value
    '    If sKeyValue <> "ROOT" Then
    '        iContentId = CInt(Mid(sKeyValue, 9, Len(sKeyValue) - 8))
    '        For Each oCheckedNode In TreeSubDirectory.Nodes(0).ChildNodes
    '            oCheckedNode.Checked = False
    '            oCheckedNode.ShowCheckBox = False
    '        Next
    '        oTreeNode.Checked = True
    '        oTreeNode.ShowCheckBox = True
    '        loadContent(oProfile, iContentId)
    '        displayPage(oProfile)
    '        lblView2.Focus()
    '    End If
    'End Sub

    'Protected Sub treeDirectory_TreeNodePopulate(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs)
    'Dim oNode As TreeNode
    'Dim sKeyValue As String
    'Dim iType As Integer

    '   oNode = e.Node
    '   sKeyValue = oNode.Value
    '   iType = CInt(Mid(sKeyValue, 10, Len(sKeyValue) - 9))
    '   If oNode.ChildNodes.Count = 0 Then
    '      loadChildrenProfiles(iType)
    ' End If

    'End Sub

    'Protected Sub BackButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    'panelView1_1.Visible = True
    'panelView1_2.Visible = False
    'panelView2.Visible = False
    '    loadTreeView()
    'End Sub
    Sub SaveSearchStat()
        Dim dr As OleDbDataReader
        Dim sql As String
        Dim sSearch As String

        sSearch = UCase(Trim(txtSearch.Text))
        sSearch = "'" & Replace(sSearch, "'", "''") & "'"

        connectADMDB()
        sql = "select id,ucase(word) & ' hits=' & hits as worddisplay, word from keyword where trim(ucase(word))=" & sSearch
        cmdSelect = New OleDbCommand(sql, dbconnAd)
        dr = cmdSelect.ExecuteReader
        If dr.Read Then
            sql = "update keyword set hits=hits+1 where id=" & dr("id")
        Else
            sql = "insert into keyword(word,hits,siteid,lastupdated) values(" & sSearch & ",1,0," & "#" & FormatDateTime(Now, 2) & "#)"
        End If
        cmdinsertupdate = New OleDbCommand(sql, dbconnAd)
        cmdinsertupdate.ExecuteNonQuery()

        dr.Close()
        closeADMDB()


    End Sub
    Const constPatternSize As Integer = 300
    Sub SearchList(ByVal iCategoryId As Integer, ByVal sSearchPhrase As String)
        Dim arrSearch As Array
        Dim iPatternLimit As Integer
        Dim iSearchCount As Integer
        Dim i, j As Integer
        Dim iValue As Integer
        Dim iRowCount As Integer
        Dim sSearchPattern As String
        Dim arrSearchFound(constPatternSize + 10) As Array
        Dim arrSearchIndexFound(constPatternSize + 10) As Array
        Dim iCount As Integer
        Dim iMaxHit As Integer
        Dim sql As String
        Dim sb As StringBuilder = New StringBuilder
        Dim sIP As String
        Dim sDateTime As String
        Dim bOldCodeFlag As Boolean
        Dim datareader2 As OleDbDataReader
        Dim randomNumber As New Random
        Dim iID As Integer
        Dim iOldID As Integer
        Dim iOutputCount As Integer
        Dim iHits As Integer
        Dim iOldHits As Integer
        Dim iScore As Integer
        Dim iContentId As Integer
        Dim iThreshHold As Integer
        Dim sMicrotheoryItem As String
        Dim iPosition As Integer
        'Dim sConnectionString As String
        Dim datareader As OleDbDataReader
        'sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("app_data/microtheory.mdb")
        'dbMTconn = New OleDbConnection(sConnectionString)
        'dbMTconn.Open()

        iPosition = 0
        iPatternLimit = constPatternSize
        sSearchPhrase = Replace(sSearchPhrase, "_", "'")
        iID = 0
        iOutputCount = 0
        iHits = 0

        If sSearchPhrase = "" Then
            Exit Sub
        End If


        If InStr(1, sSearchPhrase, "=") > 0 Or InStr(1, sSearchPhrase, "+") > 0 Or InStr(1, sSearchPhrase, "http:") > 0 Or objMTFunc.IsAlphaNumeric(sSearchPhrase) = False Then
            Response.End()
        End If

        objMTFunc.PostQuestion(sSearchPhrase, dbsqlserverconn, iCategoryId)

        'Response.Write REQUEST("TXTSEARCH")&"<p>"
        sb.Append("<a name='#output_section'></a>")
        sSearchPattern = objMTFunc.ignoreCertainWords(" " & sSearchPhrase & " ") & " "
        sb.Append("<h3>Search <b>for</b>:" & sSearchPhrase & "</h3><font size=1>words:" & sSearchPattern & "</font>")
        If Session("MemberId") = "-1" Then
            sb.Append(sSearchPattern & "<p>")
        End If
        'lblWordList.Text = "<b>Word List</b>:" & sSearchPattern
        arrSearch = Split(Trim(sSearchPattern) & " ", " ")
        iCount = UBound(arrSearch)

        iSearchCount = 0
        For i = 0 To iCount - 1
            If Trim(arrSearch(i)) <> "" Then
                iSearchCount = iSearchCount + 1
                'Response.Write arrSearch(i) & "<p>"
            End If
        Next

        bOldCodeFlag = False
        iRowCount = 0
        iValue = 0
        sIP = randomNumber.Next(1, 1000000)

        'cmdInsert = New OleDbCommand()

        If Trim(sSearchPattern) <> "" Then

            Dim sCriteria As String
            Dim iCriteriaCount As Integer
            Dim sWordValue As String

            sCriteria = ""
            iCriteriaCount = 0
            For j = 0 To iSearchCount And j < 20
                If Trim(arrSearch(j)) <> "" Then
                    sWordValue = UCase(Replace(arrSearch(j), "'", "''"))
                    'sCriteria = sCriteria & " wordvalue='" & UCase(Replace(arrSearch(j), "'", "''")) & "'"
                    sCriteria = sCriteria & " and EXISTS"
                    sCriteria = sCriteria & " (SELECT     '' AS Expr1"
                    sCriteria = sCriteria & " FROM          WordIndex2 A" & j
                    sCriteria = sCriteria & " WHERE      (microtheoryid = b.microtheoryid) "
                    sCriteria = sCriteria & " AND wordValue in (" & objMTFunc.GetSimilarWords(sWordValue, dbsqlserverconn) & ") ) "
                    '    sCriteria = sCriteria & " wordvalue='" & UCase(Replace(arrSearch(j), "'", "''")) & "'"
                    '    sCriteria = sCriteria & " and wordvalue='" & UCase(Replace(arrSearch(j), "'", "''")) & "'"
                    'sCriteria = sCriteria & " and wordvalue='" & UCase(Replace(arrSearch(j), "'", "''")) & "'"
                    iCriteriaCount += 1
                End If
            Next

            sql = " SELECT b.microtheoryid AS microtheoryid,b.microtheoryitem, b.hits"
            sql = sql & " FROM Microtheory b"
            sql = sql & " WHERE"
            'sql = sql & " b.category=@category"
            sql = sql & " b.category>=0"
            sql = sql & sCriteria
            sql = sql & " ORDER BY microtheoryid"


            cmdSelect.Connection = dbsqlserverconn
            cmdSelect.CommandText = sql

            datareader2 = cmdSelect.ExecuteReader()

            iOldID = 0
            iOldHits = 0
            iThreshHold = 10
            iOutputCount = 0
            Dim sPatternBuffer As String

            Do While datareader2.Read And iOutputCount < iThreshHold
                sPatternBuffer = New String("O", iPatternLimit)
                iMaxHit = datareader2("hits")
                'arrPattern(datareader2("positionindex")) = "X"
                'iPosition = datareader2("positionindex")

                iID = datareader2("microtheoryid")
                objMTFunc.SetPattern(iID, sPatternBuffer, iPatternLimit, arrSearch, dbsqlserverconn)
                objMTFunc.ScoreResults(sPatternBuffer, iRowCount, sIP, iID, iSearchCount, arrSearchFound, arrSearchIndexFound, iMaxHit, dbsqlserverconn)
                iOutputCount = iOutputCount + 1
            Loop
            datareader2.Close()




            sDateTime = FormatDateTime(Now, DateFormat.GeneralDate)

            '---------------------------Output Workfile------------------------

            sql = "select sum(a.score) as score"
            sql = sql & " ,b.microtheoryitem "
            sql = sql & " ,b.contentid"
            sql = sql & " ,b.microtheoryid"
            sql = sql & " ,b.hits"
            sql = sql & " ,b.category"
            sql = sql & " from workfile as a, microtheory as b"
            sql = sql & " where ip='" & sIP & "'"
            'sql=sql & " and date_time=#" & sDateTime & "#"
            sql = sql & " and a.microtheoryid=b.microtheoryid"
            sql = sql & " group by b.microtheoryid,b.microtheoryitem,b.contentid,b.hits,b.category"
            sql = sql & " order by sum(a.score) desc"
            'sql=sql & " order by score desc"


            cmdSelect = New OleDbCommand(sql, dbsqlserverconn)
            cmdSelect.Parameters.AddWithValue("@ip", sIP)
            dataReader = cmdSelect.ExecuteReader

            iOutputCount = 0
            iScore = 0
            iContentId = 0

            Do While dataReader.Read
                'sb.Append("<P>")
                iHits = dataReader("hits")
                iID = dataReader("microtheoryid")
                iScore = dataReader("score")
                iContentId = dataReader("contentId")
                sMicrotheoryItem = dataReader("microtheoryitem")

                'If iID <> iOldID And iOldID <> 0 Then
                sb.Append("<table cellpadding=0 cellspacing=0 border=0 width='100%'>")
                sb.Append("<tr>")
                If iOutputCount Mod 2 = 0 Then
                    sb.Append("<td bgcolor=silver height=60 valign=top>")
                Else
                    sb.Append("<td bgcolor=gray height=60 valign=top>")
                End If

                sb.Append(objMTFunc.highlight(sSearchPhrase, sMicrotheoryItem, arrSearch))
                sb.Append("<a href='mtdefault.aspx?process=Redirect&id=" & iID & "&contentid=" & iContentId & "&SiteId=4'>[Learn More...]</a>")
                sb.Append("</td>")
                sb.Append("</tr>")
                sb.Append("</table>")

                'sb.Append("<a href='mtURLForm.aspx?txtId=" & iID & "&txtContentId=" & iContentId & "&txtCategory=" & iCategoryId & "'>[Add URL]</a>")
                'iOutputCount = 0
                iScore = 0
                'End If
                'iOldID = iID
                'iOldScore = iScore
                'iOldContentId = iContentId
                'sOldMicrotheoryItem = sMicrotheoryItem
                iOutputCount = iOutputCount + 1
                If iOutputCount > 50 Then
                    Exit Do
                End If
            Loop
            dataReader.Close()

            Dim bDebug As Boolean
            bDebug = False
            If bDebug = False Then
                'sql = "delete * from workfile"
                sql = "delete from workfile"
                'sql = sql & " where ip=@ip"
                sql = sql & " where ip=?"

                cmdDelete = New OleDbCommand(sql, dbsqlserverconn)
                cmdDelete.Parameters.AddWithValue("@ip", sIP)
                cmdDelete.ExecuteNonQuery()
            End If

        Else
            sb.Append("Search text required!")
        End If
        If iRowCount = 0 Then
            sb.Append("<h3>No Records Found!</h3>")
            If Session("MemberId") = "-1" Then
                sb.Append("Value=" & iValue & "<br>")
                sb.Append("SearchCount=" & iSearchCount)
            End If
        End If
        'dbMTconn.Close()
        lblMT.Text = "<table border=0 width='100%'><tr><td>" & sb.ToString & "</td></tr></table>"
    End Sub

    Sub QueryList()
        'Dim sql As String
        Dim sResponse As String
        Dim arrElement As Array
        Dim iUpperBound As Integer

        'panelView1_1.Visible = False
        'panelView1_2.Visible = True
        'panelView3.Visible = True
        If IsBot(Request) = True Then
            'Response.Redirect("http://www.google.com")
            Response.End()
        End If
        lblView2.Text = ""
        'sPattern=txtSearch.text
        arrElement = Split(UCase(txtSearch.Text) & " ", " ")
        iUpperBound = UBound(arrElement)

        'SaveSearchStat()

        'sql = "update phrase set hits=hits+1 where phrasetext='" & UCase(Trim(Replace(Request("txtSearch"), "'", "''"))) & "'"
        'cmdUpdate = New OleDbCommand(sql, dbconn)
        'cmdUpdate.ExecuteNonQuery()

        'buildTreeFromKeyword()

        sResponse = Introspective(txtSearch.Text)
        If sResponse = "" Then
            outputassociatedurl(txtSearch.Text)
            OutputArticles(txtSearch.Text)
            'connectURLMDB()
            'BuildFastFactView()
            'closeURLMDB()
            SearchList(constBusinessType, txtSearch.Text)
        Else
            Dim oEmail As New cEmail

            With oEmail
                .txtEmail = "dnishimoto@listensoftware.com"
                .txtMessage = txtSearch.Text & " " & sResponse
            End With
            'ProcessEmail(oEmail)
            lblMT.Text = "<table><tr><td>" & sResponse & "</td></tr></table>"
            OutputArticles(txtSearch.Text)
        End If
    End Sub
    'Sub buildTreeFromKeyword()
    ' Dim sql As String
    ' Dim drlocal As OleDbDataReader
    ' Dim oNodes As TreeNodeCollection
    ' Dim oNode As TreeNode
    ' Dim sPattern As String
    ' Dim arrElement As Array
    ' Dim bFound As Boolean
    ' Dim sBusinessName As String
    ' Dim sCategoryName As String
    ' Dim iUpperBound As Integer
    ' Dim i As Integer
    ' Dim iCount As Integer

    '------------Clear the Sub Directory Tree------
    '    oNodes = TreeSubDirectory.Nodes
    '    If oNodes.Count > 0 Then
    '        oNode = oNodes.Item(0)
    '        TreeSubDirectory.Nodes.Remove(oNode)
    '    End If
    '------------Add Parent Node--------------------
    '    oNode = New TreeNode
    '    oNode.Value = "ROOT"
    '    oNode.Text = "Profiles"
    '    TreeSubDirectory.Nodes.Add(oNode)

    '--------------Load Children Profiles
    '    sql = "select a.businessname,a.contentid,a.headline,b.name as categoryname from content as a, wscategories as b where siteid=-2"
    '    sql = sql & " and a.type=b.categoryid"
    'sql = sql & " and trim(businessname)<>''"
    'sql = sql & " and trim(headline)<>''"
    'sql=sql & " and contentid=312"
    'sql = sql & " and a.type=110"
    '    sql = sql & " order by ucase(a.businessname)"
    '    cmdSelect = New OleDbCommand(sql, dbconn)
    '    drlocal = cmdSelect.ExecuteReader
    '    iCount = 0
    '    Do While drlocal.Read
    '        bFound = False
    'sHeadline=" " & ucase(drlocal("headline")) & " "
    '        If IsDBNull(drlocal("businessname")) = True Then
    '            sBusinessName = ""
    '        Else
    '            sBusinessName = " " & UCase(drlocal("businessname")) & " "
    '        End If
    '        sCategoryName = UCase(drlocal("categoryname"))

    '        For i = 0 To iUpperBound - 1
    '            sPattern = arrElement(i)
    '            If Trim(sPattern) <> "" Then
    'System.Diagnostics.Debug.WriteLine(sBusinessName)
    '                If sPattern <> "TO" Then
    '                    If sBusinessName.Contains(sPattern) = True Or sCategoryName.Contains(sPattern) Then
    '                        bFound = True
    '                        Exit For
    '                    End If
    '                End If
    '            End If
    '        Next
    '        If bFound = True Then
    '            AddChildNodeToTree(oNode, drlocal("contentId"), "" & Left(drlocal("businessname"), 20))
    '        End If
    '        iCount += 1
    '        If iCount > 25 Then
    '            Exit Do
    '        End If
    '    Loop
    '    drlocal.Close()
    '    TreeSubDirectory.ExpandAll()

    'End Sub
    Sub OutputArticles(ByVal sSearch As String)
        Dim sql As String
        Dim drlocal As OleDbDataReader
        Dim sHTML As String
        Dim iCount As Integer

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
        sql = sql & " (ucase(b.headline) like '%" & UCase(Trim(Replace(sSearch, "'", "''"))) & "%')"
        sql = sql & " and SiteId in (1,2,3,4,6,7)"
        sql = sql & " and approved=1"
        sql = sql & " order by b.hits desc"

        cmdSelect = New OleDbCommand(sql, dbconn)
        drlocal = cmdSelect.ExecuteReader

        sHTML = "<div class='list-group'>"
        iCount = 1
        Do While drlocal.Read
            If File.Exists(Server.MapPath("microtheory/" & drlocal("contentid") & ".htm")) = False Then
                sHTML = sHTML & "<a class='list-group-item' href='lsscontent.aspx?process=LoadView&SiteId=" & drlocal("SiteId") & "&txtContentId=" & drlocal("contentid") & "#DisplayOutput'>" & iCount & "." & Left(drlocal("headline"), 100) & " <font color=darkred>hits=" & drlocal("hits") & "</font></a>"
            Else
                sHTML = sHTML & "<a class='list-group-item' href='microtheory/" & drlocal("contentid") & ".htm'>" & iCount & "." & Left(drlocal("headline"), 100) & " <font color=darkred>hits=" & drlocal("hits") & "</font></a>"
            End If
            iCount = iCount + 1
        Loop
        sHTML = sHTML & "</div>"
        drlocal.Close()
        lblView4.Text = "<table><tr><td><h3>Articles</h3>" & sHTML & "</td></tr></table>"

        Dim sb As New StringBuilder

        lblView5.Text = ""
        If sSearch.Contains(" ") = False Then

            sql = "select distinct question, questionid,hits from question "
            sql = sql & " where upper(question) like 'HOW %" & Trim(UCase(sSearch)) & "%'"
            sql = sql & " or upper(question) like 'WHY %" & Trim(UCase(sSearch)) & "%'"
            sql = sql & " and len(question) > 20"
            sql = sql & " order by hits desc"

            cmdSelect = New OleDbCommand(sql, dbsqlserverconn)
            dr = cmdSelect.ExecuteReader


            Dim sQuestion As String
            Dim sBuffer As String
            Dim sURL As String

            iCount = 1
            Do While dr.Read
                sURL = "cmwebsite.aspx?process=SearchMicrotheory&txtSearch=" & Replace(Replace(dr("question"), " ", "+"), "'", "")

                sBuffer = Trim(UCase(dr("question")))
                sQuestion = Left(sBuffer, 1)
                sQuestion = sQuestion & LCase(Mid(sBuffer, 2, Len(sBuffer)))
                sQuestion = Strings.StrConv(dr("question"), VbStrConv.ProperCase)

                sb.Append(iCount & "." & "<a href='" & sURL & "'>" & sQuestion & "</a><br>")
                If iCount > 20 Then
                    Exit Do
                End If
                iCount = iCount + 1
            Loop
            dr.Close()
            lblView5.Text = "<table><tr><td><h3>Related Questions</h3>" & sb.ToString & "</td></tr></table>"
        End If

    End Sub
    Const constBusinessType As Integer = 1
    Protected Sub cmdQuery_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        QueryList()
    End Sub
    Sub Webdesign_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("hrxp/webdesign.html")
    End Sub
    Protected Sub AddFastFact_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        '    Dim drlocal As OleDbDataReader
        '    Dim sql As String
        '    connectURLMDB()

        '    If IsAlphaNumeric(txtFastFact.Text) = False Then
        '        lblFastFactErrorMessage.Text = "Not Alpha numeric"
        '        closeURLMDB()
        '        Exit Sub
        '    Else
        '        lblFastFactErrorMessage.Text = ""
        '    End If

        '    If txtFastFact.Text <> "" Then
        '        sql = "select [word]"
        '        sql = sql & ",[fast_fact]"
        '        sql = sql & " from "
        '        sql = sql & " fast_fact"
        '        sql = sql & " where "
        '        sql = sql & " word = '" & UCase(Trim(Replace(txtSearch.Text, "'", "''"))) & "'"
        '        sql = sql & " and ucase(trim([fast_fact]))='" & UCase(Trim(Replace(txtFastFact.Text, "'", "''"))) & "'"

        '        cmdSelect = New OleDbCommand(sql, dbconnurl)
        '        drlocal = cmdSelect.ExecuteReader
        '        If drlocal.HasRows = False Then
        '            sql = "insert into fast_fact ([word],[fast_fact]) values ("
        '            sql += "'" & UCase(Trim(Replace(txtSearch.Text, "'", "''"))) & "'"
        '            sql += ",'" & UCase(Trim(Replace(txtFastFact.Text, "'", "''"))) & "'"
        '            sql += ")"
        '            cmdInsert = New OleDbCommand(sql, dbconnurl)
        '            cmdInsert.ExecuteNonQuery()
        '        End If
        '        drlocal.Close()
        '        txtFastFact.Text = ""
        '        BuildFastFactView()
        '    End If

        '    closeURLMDB()

    End Sub
    Function IsAlphaNumeric(ByVal sPhrase) As Boolean
        Dim mRetVal As Match
        Dim bPass As Boolean
        Dim regx As Regex = New Regex("^[a-z,A-Z,0-9,\.,\?,\-,\%,\$,\!,\#,\&,\(,\),\',\*,\:,\@,\s]*(<BR>)*(<br>)*$", RegexOptions.IgnoreCase)

        '(^[(]{0,1}) the first character maybe a "("
        '\s*([0-9]{3,3})\s strip whitespace and allow three numbers
        '*([)]{0,1}) the previous three numbers may be enclosed with a ")"
        '\s*([-]{0,1})\s*  a "-" may follow the suffix
        '([0-9]{3,3}) three numbers are required
        '\s*([-]*)\s* a "-" may follow
        '([0-9]{4,4}$) four numbers are required
        '$ matches the position at the end of the input string


        mRetVal = regx.Match(sPhrase)


        'if bPass=false then
        'regx.pattern="\s*([0-9]{3,3})\s*([-]*)\s*([0-9]{4,4}$)"
        'bPass=regx.test(sVal)
        'end if
        If mRetVal.Success Then
            bPass = True
        Else
            bPass = False
        End If

        IsAlphaNumeric = bPass
    End Function

    'Sub BuildFastFactView()
    '    Dim sql As String
    '    Dim drlocal As OleDbDataReader
    '    Dim sb As New StringBuilder

    '    sql = "select [word]"
    '    sql = sql & ",[fast_fact]"
    '    sql = sql & " from "
    '    sql = sql & " fast_fact"
    '    sql = sql & " where "
    '    sql = sql & " word = '" & UCase(Trim(Replace(txtSearch.Text, "'", "''"))) & "'"
    '    lblWordFastFact.Text = txtSearch.Text

    '    cmdSelect = New OleDbCommand(sql, dbconnurl)
    '    drlocal = cmdSelect.ExecuteReader

    '    sb.Append("<ul>")
    '    Do While drlocal.Read
    '        sb.Append("<li>" & drlocal("fast_fact"))
    '    Loop
    '    sb.Append("</ul>")
    '    lblViewFastFact.Text = sb.ToString
    'End Sub
    'Sub popularwords_selectedIndexchanged(ByVal sender As Object, ByVal e As System.EventArgs)
    '    If lbxPopularWords.SelectedValue <> "" Then
    '        txtSearch.Text = lbxPopularWords.SelectedValue
    '    End If
    'QueryList()
    'End Sub
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table width="100%" border=0>
        <tr>
            <td valign="top" align=center>
                <asp:Label ID="lblLoginMessage" runat="server"></asp:Label>
                <asp:TextBox Visible=false ID="txtSearch"
                             runat="server"></asp:TextBox>
                <br /><asp:Button ID="cmdQuery" Visible="false" runat="server" Text="Search"
                                  OnClick="cmdQuery_Click" />
            </td>
        </tr>
    </table>

    <table>
        <tr>
            <td valign="top">
                <asp:panel ID="panelUniqueWord" runat="server" ScrollBars="vertical" Height="1200">
                    <asp:Label ID="lblUniqueWordList" runat="server"></asp:Label>
                </asp:panel>
            </td>
            <td valign="top" align="left">
                <asp:Panel ID="panelView2" runat="server" Visible="true">
                    <asp:Label ID="lblView2" runat="server" Font-Size="13px"></asp:Label>
                    <asp:Label ID="lblMT" runat="server" Font-Size="13px"></asp:Label>
                    <asp:Label ID="lblView4" runat="server" Font-Size="13px"></asp:Label>
                    <asp:Label ID="lblView5" runat="server" Font-Size="13px"></asp:Label>
                </asp:Panel>
            </td>
            <td valign="top">
                <asp:Panel ID="panelView3" Visible="true" runat="server">
                    &nbsp;<asp:Label ID="lblView3" runat="server" Font-Size="Small" ></asp:Label>
                </asp:Panel>
            </td>
        </tr>
    </table>
</asp:Content>

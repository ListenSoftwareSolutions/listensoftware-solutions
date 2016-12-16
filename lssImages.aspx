<%@ Page Language="VB" Debug="false" AutoEventWireup="True" MaintainScrollPositionOnPostback="true" MasterPageFile="~/lssMasterPage.master"
    Title="Slide Show" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="system" %>
<%@ Import Namespace="system.data" %>
<%@ Import Namespace="system.data.oledb" %>
<%@ Import Namespace="System.Drawing.Imaging" %>
<%@ Import Namespace="System.Drawing.Drawing2D" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Net.Mail" %>

<script runat="server" language="VB">
    Dim dbconn As OleDbConnection
    Dim cmdSelect As OleDbCommand
    Dim cmdUpdate As OleDbCommand
    Dim cmdInsert As OleDbCommand
    Dim cmdDelete As OleDbCommand
    Sub LoadParameters()
        Dim sql As String
        Dim dr As OleDbDataReader

        Try

            sql = "select distinct category from microtheory"
            sql = sql & " order by category"

            cmdSelect = New OleDbCommand(sql, dbconn)
            dr = cmdSelect.ExecuteReader
            Dim lItem As New ListItem
            lItem.Text = "Select One"
            lItem.Value = "-1"
            With cboInputCategory
                .DataSource = dr
                .AutoPostBack = False
                .DataTextField = "category"
                .DataValueField = "category"
                .DataBind()
                .Items.Insert(0, lItem)
            End With
            dr.Close()


        Catch ex As Exception
        End Try

    End Sub

    Sub connectImagesMDB()
        Dim sConnectionString As String
        sConnectionString = "Provider=Microsoft.Jet.Oledb.4.0;data source=" & Server.MapPath("app_data/images.mdb")
        dbconn = New OleDbConnection(sConnectionString)
        dbconn.Open()
    End Sub
    Sub closeImagesMDB()
        dbconn.Close()
    End Sub
    'Sub Delete_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    'Dim sql As String
    'Sql = "delete * from imageinfo where image_next_number=" & lblImage_Next_Number.Text
    'cmdDelete = New OleDbCommand(sql, dbconn)
    'cmdDelete.ExecuteNonQuery()
    'currentImg.ImageUrl = "thousand_words.jpg"
    'LoadThumbnails()
    ' QueryDS()
    'End Sub
    Protected Sub Upload_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        'Dim dr As OleDbDataReader
        Dim sql As String
        Dim iNextNumber As Integer
        Dim sLocalFileName As String
        Dim sImageFileName As String

        lblErrorMsg.Text = ""
        If txtInputCategory.Text = "" Then
            lblErrorMsg.Text = "Category is required<br>"
        End If
        If txtInputHeadline.Text = "" Then
            lblErrorMsg.Text = lblErrorMsg.Text & "Headline is required<br>"
        End If
        If Session("SecurityKeyOk") = True Then
        Else
            lblErrorMsg.Text = lblErrorMsg.Text & "Not Authorized<br>"
        End If

        'ValidatorCategory.Validate()
        'ValidatorHeadline.Validate()
        If lblErrorMsg.Text <> "" Then
            Exit Sub
        End If
        ' Display properties of the uploaded file
        'FileName.InnerHtml = MyFile.PostedFile.FileName
        lblFileuploadMessage.Text = ""
        FileContent.InnerHtml = MyFile.PostedFile.ContentType
        FileSize.InnerHtml = MyFile.PostedFile.ContentLength
        Dim strFileName As String = MyFile.PostedFile.FileName

        If strFileName <> "" Then
            UploadDetails.Visible = True

            ' only the attched file name not its path
            sLocalFileName = System.IO.Path.GetFileName(strFileName)
            sImageFileName = ""

            'Save uploaded file to server at C:\ServerFolder\
            Try
                'sql = "select * from imageinfo where filename=@Filename"
                'cmdSelect = New OleDbCommand(sql, dbconn)
                'cmdSelect.Parameters.AddWithValue("@Filename", sLocalFileName)
                'dr = cmdSelect.ExecuteReader
                'iNextNumber = 0
                'lblErrorMsg.Text = ""
                'If dr.Read Then
                'lblImage_Next_Number.Text = dr("image_next_number")
                'sImageFileName = dr("image_next_number") & ".jpg"
                'lblErrorMsg.Text = "Filename Already Exists"
                'Else
                iNextNumber = GetNextNumber("ImageNumber")
                sImageFileName = iNextNumber.ToString & ".jpg"
                sql = "insert into imageinfo"
                sql = sql & "("
                sql = sql & " FileName"
                sql = sql & " ,image_next_number"
                sql = sql & " ,hits"
                sql = sql & " )"
                sql = sql & " values ("
                sql = sql & " @FileName"
                sql = sql & " ,@Image_Next_Number"
                sql = sql & " ,1"
                sql = sql & " )"
                cmdInsert = New OleDbCommand(sql, dbconn)
                cmdInsert.Parameters.AddWithValue("@Filename", sLocalFileName)
                cmdInsert.Parameters.AddWithValue("@Image_Next_Number", iNextNumber)
                cmdInsert.ExecuteNonQuery()
                lblImage_Next_Number.Text = iNextNumber
                MyFile.PostedFile.SaveAs(Server.MapPath("Images/") & sImageFileName)
                SaveImageProfile()
                'End If
                'dr.Close()
                'QueryDS()
                lblInputImage_Path.Text = sImageFileName
                'currentImg.ImageUrl = "images/" & sImageFileName
                'BuildReport(lblImage_Next_Number.Text)
                'buildimagetree()
                panelUpload.Visible = False
                If Session("SecurityKeyOk") = True Then
                    linkButtonOpen.Visible = True
                End If

                'Span1.InnerHtml = "Your File Uploaded Sucessfully at server as: " & sImageFileName
                BuildImageTree()
                BuildThumbNail(lblImage_Next_Number.Text)
                LoadParameters()

            Catch Exp As Exception
                lblErrorMsg.Text = "An Error occured uploading file " & Exp.Message
                UploadDetails.Visible = False
                Span2.Visible = False
            End Try
        Else
            Span1.InnerHtml = "Select a file to Upload"
            panelUpload.Visible = True
        End If
        'imgProduct.ImageUrl = "images\" & c

    End Sub
    Public Function IsNvlString(ByVal v) As String
        Dim rv As String
        rv = v
        If Len(rv) = 0 Then
            rv = "NULL"
        Else
            rv = Replace(rv, "'", "''")
            rv = "'" & rv & "'"
        End If
        IsNvlString = rv

    End Function

    Function GetNextNumber(ByVal sNextNumberName As String) As Integer
        Dim iRetVal As Integer
        Dim dr As OleDbDataReader
        Dim sql As String
        Try

            sql = "select * from nextnumber where nextnumbername='" & sNextNumberName & "'"

            'response.write sql

            iRetVal = -1

            cmdSelect = New OleDbCommand(sql, dbconn)
            dr = cmdSelect.ExecuteReader

            If dr.Read Then
                iRetVal = dr("nextnumber")
                dr.Close()
                sql = "update nextnumber set nextnumber=nextnumber+1 where nextnumbername='" & sNextNumberName & "'"
                cmdUpdate = New OleDbCommand(sql, dbconn)
                cmdUpdate.ExecuteNonQuery()
            Else
                dr.Close()
                sql = "Insert into nextnumber"
                sql = sql & "("
                sql = sql & " [nextnumbername]"
                sql = sql & " ,[nextnumber]"
                sql = sql & ")"
                sql = sql & " values"
                sql = sql & " ("
                sql = sql & IsNvlString(sNextNumberName)
                sql = sql & ",1"
                sql = sql & ")"

                'response.write sql
                cmdInsert = New OleDbCommand(sql, dbconn)
                cmdInsert.ExecuteNonQuery()

                sql = "select * from nextnumber where nextnumbername='" & sNextNumberName & "'"
                cmdSelect = New OleDbCommand(sql, dbconn)
                dr = cmdSelect.ExecuteReader
                If dr.Read Then
                    iRetVal = dr("nextnumber")
                End If
                dr.Close()
            End If


        Catch ex As Exception

        End Try

        Return (iRetVal)
    End Function

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        'Dim sql As String
        'Dim imgIndex As Integer
        'Dim dr As OleDbDataReader

        cboInputCategory.Attributes.Add("onchange", "javascript:ddlChange();")
        'Get list of images
        connectImagesMDB()
        If IsPostBack = False Then
            If Session("SecurityKeyOk") = True Then
                'dgImage.Columns(1).Visible = True
                'linkbuttonDelete.Visible = True
            Else
                'dgImage.Columns(1).Visible = False
                'linkbuttonDelete.Visible = False
            End If
            BuildImageTree()
            Dim sCategory As String = "family"
            lblQueryCategory.Text = sCategory
            LoadImageList(sCategory)
            LoadThumbnails(sCategory)

            LoadParameters()
            MultiViewCard.ActiveViewIndex = 0
        End If

        'If imgIndex > 0 Then
        'lnkPrev.NavigateUrl = "lssImages.aspx?N=" & imgIndex - 1
        'End If

        'If imgIndex < images.Length - 1 Then
        'lnkNext.NavigateUrl = "lssImages.aspx?N=" & imgIndex + 1
        'End If

        'dlIndex.DataSource = images
        'dlIndex.DataBind()
        If Session("SecurityKeyOk") = True Then
            hyperLinkLogin.Visible = False
            'LoadThumbnails()
        Else
            hyperLinkLogin.Visible = True
            'panelGridView.Enabled = False
            'lblErrorMsg.Text = "Password required"
        End If
    End Sub
    Sub BuildImageTree()
        Dim sql As String = ""
        Dim dr As OleDbDataReader
        Dim cmdSelect As OleDbCommand


        sql = "select distinct category from microtheory"
        sql = sql & " order by category"

        cboQueryCategory.Items.Clear()

        Try
            cmdSelect = New OleDbCommand(sql, dbconn)
            dr = cmdSelect.ExecuteReader
            Dim lItem As New ListItem
            lItem.Text = "Photo Albums"
            lItem.Value = "-1"
            With cboQueryCategory
                .DataSource = dr
                .AutoPostBack = True
                .DataTextField = "category"
                .DataValueField = "category"
                .DataBind()
                .Items.Insert(0, lItem)
            End With
            dr.Close()

        Catch ex As Exception

        End Try

    End Sub
    Sub DeleteThumbnail(sFileName As String)
        Dim sThumbnailFileName As String = ""
        Try
            sThumbnailFileName = Server.MapPath("images/galleryThumbNail" & sFileName & ".jpg")
            Dim oFile As FileInfo = New FileInfo(sThumbnailFileName)
            If oFile.Exists() = True Then
                oFile.Delete()
            End If
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try

    End Sub
    Sub RotateImage90(sId As String)
        Dim imgPicture As System.Drawing.Image
        Dim sImage_Next_Number As String = GetImageNextNumber(sId)
        Dim sFileName
        Try
            sFileName = Server.MapPath("images/" & sImage_Next_Number & ".jpg")
            imgPicture = System.Drawing.Image.FromFile(sFileName)

            imgPicture.RotateFlip(RotateFlipType.Rotate90FlipNone)

            imgPicture.Save(sFileName)

            imgPicture.Dispose()
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try

    End Sub

    Sub RotateImage180(sId As String)
        Dim imgPicture As System.Drawing.Image
        Dim sImage_Next_Number As String = GetImageNextNumber(sId)
        Dim sFileName As String = ""
        Try
            sFileName = Server.MapPath("images/" & sImage_Next_Number & ".jpg")
            imgPicture = System.Drawing.Image.FromFile(sFileName)

            imgPicture.RotateFlip(RotateFlipType.Rotate180FlipX)

            imgPicture.Save(sFileName)

            imgPicture.Dispose()
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try

    End Sub
    Function GetImageNextNumber(sId)
        Dim sql As String
        Dim dr As OleDbDataReader
        Dim sRetVal As String = ""
        Try


            Sql = "SELECT Imageinfo.imageid, "
            Sql = Sql & " ImageInfo.image_next_number, "
            Sql = Sql & " Microtheory.Headline, "
            Sql = Sql & " Microtheory.Category, "
            Sql = Sql & " imageinfo.hits "
            Sql = Sql & " FROM ImageInfo "
            Sql = Sql & " Left Join Microtheory "
            Sql = Sql & " On ImageInfo.image_next_number = Microtheory.Image_Next_Number "
            sql = sql & " where microtheoryid=" & sId
            sql = Sql & " order by imageid desc"

            cmdSelect = New OleDbCommand(Sql, dbconn)
            dr = cmdSelect.ExecuteReader
            If dr.Read Then
                sRetVal = dr("image_next_number")
            End If
            dr.Close()
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try
        Return (sRetVal)
    End Function
    Public Class cImageInfo
        Public sID As String
        Public sImage_Next_Number As String
        Public sHeadline As String
    End Class
    Sub LoadThumbnails(sCategory As String)
        Dim sql As String
        Dim dr As OleDbDataReader
        Dim sThumbnailFilename As String
        'Dim sFileName As String
        Dim iCount As Integer
        'Dim iCellCount As Integer
        'Dim i As Integer
        Dim oImageBox As Label
        Dim arrList As New ArrayList

        Try


            sql = "SELECT Imageinfo.imageid, "
            sql = sql & " ImageInfo.image_next_number, "
            sql = sql & " Microtheory.Headline, "
            sql = sql & " Microtheory.Category, "
            sql = sql & " imageinfo.hits, "
            sql = sql & " microtheory.microtheoryid as id"
            sql = sql & " FROM ImageInfo "
            sql = sql & " Left Join Microtheory "
            sql = sql & " On ImageInfo.image_next_number = Microtheory.Image_Next_Number "
            sql = sql & " where microtheory.category=" & IsNvlString(sCategory)
            sql = sql & " order by imageid desc"

            cmdSelect = New OleDbCommand(sql, dbconn)
            dr = cmdSelect.ExecuteReader

            iCount = 0
            'iCellCount = 0
            For i = 0 To phImageControls.Controls.Count - 1
                phImageControls.Controls.RemoveAt(0)
            Next

            'phImageControls.Controls.Clear()

            oImageBox = New Label
            oImageBox.Text = "<div class='container'>"
            phImageControls.Controls.Add(oImageBox)

            Dim sBuffer As String = ""
            Dim oImageInfo As cImageInfo
            Do While dr.Read
                'Dim imagebox As System.Web.UI.WebControls.ImageButton = New System.Web.UI.WebControls.ImageButton
                'imagebox.ImageUrl = sThumbnailFilename
                'imagebox.PostBackUrl = "lssImages.aspx?image_next_number=" & dr("image_next_number") & "#viewer"
                oImageBox = New Label
                oImageBox.Text = "<div class='row'>"
                phImageControls.Controls.Add(oImageBox)

                oImageInfo = New cImageInfo
                With oImageInfo
                    .sImage_Next_Number = dr("image_next_number")
                    .sID = dr("id")
                    .sHeadline = dr("headline")
                End With
                arrList.Add(oImageInfo)
                oImageBox = New Label
                sThumbnailFilename = BuildThumbNail(dr("image_next_number"))

                sBuffer = "<div class='col-xs-3 thumbnail'>"
                sBuffer = sBuffer & "<a class='dropdown-toggle' data-toggle='modal' href='#' data-target='#" & dr("image_next_number") & "'>"
                sBuffer = sBuffer & "<img src='" & sThumbnailFilename & "'></a>"
                sBuffer = sBuffer & "</div>"

                oImageBox.Text = sBuffer
                phImageControls.Controls.Add(oImageBox)

                If dr.Read Then
                    oImageInfo = New cImageInfo
                    With oImageInfo
                        .sImage_Next_Number = dr("image_next_number")
                        .sID = dr("id")
                        .sHeadline = dr("headline")
                    End With
                    arrList.Add(oImageInfo)

                    oImageBox = New Label
                    sThumbnailFilename = BuildThumbNail(dr("image_next_number"))

                    sBuffer = "<div class='col-xs-3 thumbnail'>"
                    sBuffer = sBuffer & "<a class='dropdown-toggle' data-toggle='modal' href='#' data-target='#" & dr("image_next_number") & "'>"
                    sBuffer = sBuffer & "<img src='" & sThumbnailFilename & "'></a>"
                    sBuffer = sBuffer & "</div>"
                    oImageBox.Text = sBuffer
                    'oImageBox.Text = "<div class='col-xs-3 thumbnail'><img src='" & sThumbnailFilename & "'></div>"

                    phImageControls.Controls.Add(oImageBox)
                End If

                If dr.Read Then
                    oImageInfo = New cImageInfo
                    With oImageInfo
                        .sImage_Next_Number = dr("image_next_number")
                        .sID = dr("id")
                        .sHeadline = dr("headline")
                    End With
                    arrList.Add(oImageInfo)

                    oImageBox = New Label
                    sThumbnailFilename = BuildThumbNail(dr("image_next_number"))
                    sBuffer = "<div class='col-xs-3 thumbnail'>"
                    sBuffer = sBuffer & "<a class='dropdown-toggle' data-toggle='modal' href='#' data-target='#" & dr("image_next_number") & "'>"
                    sBuffer = sBuffer & "<img src='" & sThumbnailFilename & "'></a>"
                    sBuffer = sBuffer & "</div>"
                    oImageBox.Text = sBuffer

                    'oImageBox.Text = "<div class='col-xs-3 thumbnail'><img src='" & sThumbnailFilename & "'></div>"
                    phImageControls.Controls.Add(oImageBox)
                End If

                If dr.Read Then
                    oImageInfo = New cImageInfo
                    With oImageInfo
                        .sImage_Next_Number = dr("image_next_number")
                        .sID = dr("id")
                        .sHeadline = dr("headline")
                    End With
                    arrList.Add(oImageInfo)


                    oImageBox = New Label
                    sThumbnailFilename = BuildThumbNail(dr("image_next_number"))
                    sBuffer = "<div class='col-xs-3 thumbnail'>"
                    sBuffer = sBuffer & "<a class='dropdown-toggle' data-toggle='modal' href='#' data-target='#" & dr("image_next_number") & "'>"
                    sBuffer = sBuffer & "<img src='" & sThumbnailFilename & "'></a>"
                    sBuffer = sBuffer & "</div>"
                    oImageBox.Text = sBuffer

                    'oImageBox.Text = "<div class='col-xs-3 thumbnail'><img src='" & sThumbnailFilename & "'></div>"
                    phImageControls.Controls.Add(oImageBox)
                End If

                oImageBox = New Label
                oImageBox.Text = "</div>"
                phImageControls.Controls.Add(oImageBox)


                'If IsDBNull(dr("headline")) = False Then
                'imagebox.ToolTip = dr("headline")
                'End If

                'Dim myLabel As Label = New Label
                'myLabel.Text = "<br>"
                'If iCellCount = 6 Then
                'phImageControls.Controls.Add(myLabel)
                'iCellCount = 0
                'End If
                'phImageControls.Controls.Add(oImageBox)
                iCount += 1
                'iCellCount += 1
                If iCount > 1000 Then
                    Exit Do
                End If
            Loop

            oImageBox = New Label
            oImageBox.Text = "</div>"
            phImageControls.Controls.Add(oImageBox)


            Dim sbImages As New StringBuilder
            Dim sImage_Next_Number As String = ""
            'Dim i As Integer = 0

            For Each oImageInfo In arrList
                sImage_Next_Number = oImageInfo.sImage_Next_Number
                sbImages.Append("<section id = '" & sImage_Next_Number & "' Class='modal fade'>")
                sbImages.Append("<div Class='modal-dialog' role='document'>")
                sbImages.Append("<div Class='modal-content'>")
                sbImages.Append("<header Class='modal-header'>")
                sbImages.Append("<Button type = 'button' Class='close' data-dismiss='modal'>×</button>")
                sbImages.Append("<a class='btn btn-primary' href='lssOrderform.aspx'>Order Now</a>")
                sbImages.Append("<Button Class='btn btn-primary' data-dismiss='modal'>Close</button>")
                sbImages.Append("<div class='panel'> ID: " & oImageInfo.sID & " " & oImageInfo.sHeadline & "</div>")
                sbImages.Append("</header>")
                sbImages.Append("<div Class='modal-body'>")
                sbImages.Append(" <img class='carousel' src='images/" & sImage_Next_Number & ".jpg' >")

                'sql = "SELECT Imageinfo.imageid, "
                'sql = sql & " ImageInfo.image_next_number, "
                'sql = sql & " Microtheory.Headline, "
                'sql = sql & " Microtheory.Category, "
                'sql = sql & " imageinfo.hits "
                'sql = sql & " FROM ImageInfo "
                'sql = sql & " Left Join Microtheory "
                'sql = sql & " On ImageInfo.image_next_number = Microtheory.Image_Next_Number "
                'sql = sql & " where ImageInfo.image_next_number=" & sImage_Next_Number
                'sql = sql & " order by imageid desc"

                'cmdSelect = New OleDbCommand(sql, dbconn)
                'dr = cmdSelect.ExecuteReader
                'Dim sHeadline As String = ""
                'Dim sText As String = ""
                'Dim sId As String = ""
                'If dr.Read Then
                '    If IsDBNull(dr("Headline")) = False Then
                '        sHeadline = dr("headline")
                '    End If
                '    If IsDBNull(dr("microtheoryitem")) = False Then
                '        sText = dr("microtheoryitem")
                '    End If
                '    sId = sImage_Next_Number
                'End If
                'dr.Close()
                'sbImages.Append("    <div class='carousel-caption'>")
                'sbImages.Append("        <h3>" & sHeadline & "</h3>")
                'sbImages.Append("         <P>" & sText & "</P>")
                'sbImages.Append("         <P>Id: " & sId & "</P>")
                'sbImages.Append("    </div>")


                sbImages.Append("</div>")
                sbImages.Append("</div>")
                sbImages.Append("</div>")
                sbImages.Append("</section>")
                'sbImages.Append("<div id ='" & sImage_Next_Number & "' Class='panel-body panel-collapse collapse'>")
                'sbImages.Append(" <img class='carousel' src='images/" & sImage_Next_Number & ".jpg' />")
                'sbImages.Append("</div>")
            Next

            oImageBox = New Label
            oImageBox.Text = sbImages.ToString
            phImageControls.Controls.Add(oImageBox)

            dr.Close()
        Catch ex As Exception

        End Try
    End Sub



    Function FilterForImages(ByVal images() As FileInfo) As FileInfo()
        Dim newImages As New ArrayList(images.Length)

        Dim i As Integer
        For i = 0 To images.Length - 1
            If Path.GetExtension(images(i).Name.ToLower()) = ".jpg" OrElse _
               Path.GetExtension(images(i).Name.ToLower()) = ".jpeg" OrElse _
               Path.GetExtension(images(i).Name.ToLower()) = ".png" OrElse _
               Path.GetExtension(images(i).Name.ToLower()) = ".gif" Then
                newImages.Add(images(i))
            End If
        Next

        Return CType(newImages.ToArray(GetType(FileInfo)), FileInfo())
    End Function

    'Sub dlIndex_ItemDataBound(ByVal sender As Object, ByVal e As DataListItemEventArgs)
    '    If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
    '        'Get the Hyperlink
    '        Dim hl As HyperLink = CType(e.Item.FindControl("lnkPic"), HyperLink)

    '        'Set the Text and Navigation properties
    '        hl.Text = Path.GetFileNameWithoutExtension(DataBinder.Eval(e.Item.DataItem, "Name").ToString()) & _
    '               " (" & Int(DataBinder.Eval(e.Item.DataItem, "Length") / 1000) & " KB)"
    '        hl.NavigateUrl = "lssImages.aspx?N=" & e.Item.ItemIndex
    '    End If
    'End Sub

    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs)
        closeImagesMDB()
    End Sub
    Sub SaveImageProfile()
        Dim sql As String

        If lblImage_Next_Number.Text = "" Then
            lblFileuploadMessage.Text = "First Upload Image"
            Exit Sub
        Else
            lblFileuploadMessage.Text = ""
        End If

        'sql = "select * from microtheory where ucase(trim(Headline))=@Headline"
        'cmdSelect = New OleDbCommand(sql, dbconn)
        'cmdSelect.Parameters.AddWithValue("@Headline", UCase(Trim(txtInputHeadline.Text)))
        'dr = cmdSelect.ExecuteReader
        'If dr.HasRows = False Then
        sql = "insert into microtheory"
        sql = sql & "("
        sql = sql & "  microtheoryItem"
        sql = sql & " ,image_next_number"
        sql = sql & " ,headline"
        sql = sql & " ,category"
        sql = sql & " ,hits"
        sql = sql & " )"
        sql = sql & " values ("
        sql = sql & "  @MicrotheoryItem"
        sql = sql & " ,@Image_Next_Number"
        sql = sql & " ,@Headline"
        sql = sql & " ,@Category"
        sql = sql & " ,1"
        sql = sql & " )"
        cmdInsert = New OleDbCommand(sql, dbconn)
        cmdInsert.Parameters.AddWithValue("@MicrotheoryItem", txtInputMicrotheoryItem.Text)
        cmdInsert.Parameters.AddWithValue("@Image_Next_Number", lblImage_Next_Number.Text)
        cmdInsert.Parameters.AddWithValue("@Headline", txtInputHeadline.Text)
        cmdInsert.Parameters.AddWithValue("@Category", txtInputCategory.Text)
        cmdInsert.ExecuteNonQuery()

        'buildimagetree()
        txtInputMicrotheoryItem.Text = ""
        txtInputHeadline.Text = ""
        txtInputCategory.Text = ""
        'If lblImage_Next_Number.Text <> "" Then
        'BuildReport(lblImage_Next_Number.Text)
        'End If
        lblImage_Next_Number.Text = ""
        'End If

        panelUpload.Visible = True
        'panelGridView.Visible = True
    End Sub

    Function BuildThumbNail(sImage_Next_Number As String) As String
        Dim imgPicture As System.Drawing.Image
        Dim sFileName As String = ""
        Dim sThumbnailFileName As String = ""

        Try
            sFileName = "images/" & sImage_Next_Number & ".jpg"
            sThumbnailFileName = "images/galleryThumbNail" & sImage_Next_Number & ".jpg"

            If File.Exists(Server.MapPath(sThumbnailFileName)) = True Then
                Return (sThumbnailFileName)
            End If
            imgPicture = System.Drawing.Image.FromFile(Server.MapPath(sFileName))

            'Dim objBitmap As New Bitmap(imgPicture.Width, imgPicture.Height, PixelFormat.Format24bppRgb)
            Dim iThumbnailsize As Integer = 150
            Dim iWidth, iHeight As Integer

            Dim objBitmap As New Bitmap(Server.MapPath(sFileName))
            'Dim objGraphic As Graphics = Graphics.FromImage(objBitmap)
            If objBitmap.Width > objBitmap.Height Then
                iWidth = iThumbnailsize
                iHeight = objBitmap.Height * iThumbnailsize / objBitmap.Width
            Else
                iWidth = objBitmap.Width * iThumbnailsize / objBitmap.Height
                iHeight = iThumbnailsize
            End If
            objBitmap.Dispose()

            Dim objBitmap2 As New Bitmap(iWidth, iHeight)
            Dim objGraphic As Graphics = Graphics.FromImage(objBitmap2)
            objGraphic.CompositingQuality = CompositingQuality.HighSpeed
            objGraphic.InterpolationMode = InterpolationMode.HighQualityBicubic
            objGraphic.CompositingMode = CompositingMode.SourceCopy

            objGraphic.DrawImage(imgPicture, New Rectangle(0, 0, iWidth, iHeight))

            objBitmap2.Save(Server.MapPath(sThumbnailFileName), ImageFormat.Jpeg)
            objBitmap2.Dispose()
        Catch ex As Exception
            lblErrorMsg.Text = ex.Message
        End Try
        Return (sThumbnailFileName)
    End Function
    Sub ResetSetup()
        lblErrorMsg.Text = ""
        txtInputCategory.Text = ""
        txtInputHeadline.Text = ""
        txtId.Text = ""
        cboInputCategory.SelectedIndex = -1
        txtInputMicrotheoryItem.Text = ""
        If Session("SecurityKeyOk") = True Then
            panelUpload.Visible = True
            linkButtonOpen.Visible = False
        Else
            panelUpload.Visible = False
            linkButtonOpen.Visible = False
        End If
    End Sub
    'Sub UploadPanel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    '    lblErrorMsg.Text = ""
    '    txtInputCategory.Text = ""
    '    txtInputHeadline.Text = ""
    '    txtId.Text = ""
    '    cboInputCategory.SelectedIndex = -1
    '    txtInputMicrotheoryItem.Text = ""
    '    If Session("SecurityKeyOk") = True Then
    '        'panelUpload.Visible = True
    '        lblErrorMsg.Text = ""
    '    Else
    '        lblErrorMsg.Text = "Not Authorized"
    '    End If
    'End Sub
    Sub Cancel_click(ByVal sender As Object, ByVal e As System.EventArgs)
        'panelGridView.Visible = True
        panelUpload.Visible = False
        If Session("SecurityKeyOk") = True Then
            linkButtonOpen.Visible = True
        End If


        txtInputCategory.Text = ""
        txtInputHeadline.Text = ""
        txtInputMicrotheoryItem.Text = ""
        lblFileuploadMessage.Text = ""
        Span1.InnerHtml = ""

    End Sub
    Sub order_print_click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("lssOrderForm.aspx")
    End Sub
    Sub Rotate90Degree_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        RotateImage90(txtId.Text)
        DeleteThumbnail(txtId.Text)

        panelUpload.Visible = False
        If Session("SecurityKeyOk") = True Then
            linkButtonOpen.Visible = True
        End If

        Dim sCategory As String = lblQueryCategory.Text
        LoadImageList(sCategory)
        LoadThumbnails(sCategory)

    End Sub

    Sub FlipX_180Degree_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        RotateImage180(txtId.Text)
        DeleteThumbnail(txtId.Text)

        panelUpload.Visible = False
        If Session("SecurityKeyOk") = True Then
            linkButtonOpen.Visible = True
        End If

        Dim sCategory As String = lblQueryCategory.Text
        LoadImageList(sCategory)
        LoadThumbnails(sCategory)

    End Sub
    Sub Delete_click(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim sql As String = ""
        lblErrorMsg.Text = ""
        If txtId.Text <> "" Then
            sql = "delete from microtheory where microtheoryid=" & txtId.Text
            cmdDelete = New OleDbCommand(sql, dbconn)
            cmdDelete.ExecuteNonQuery()
            lblErrorMsg.Text = "Microtheory id=" & txtId.Text & " has been deleted!"
            panelUpload.Visible = False
            If Session("SecurityKeyOk") = True Then
                linkButtonOpen.Visible = True
            End If

            Dim sCategory As String = lblQueryCategory.Text
            LoadImageList(sCategory)
            LoadThumbnails(sCategory)

        End If

    End Sub

    Sub LoadImageList(sCategory As String)
        Dim sb As New StringBuilder
        Dim sbImages As New StringBuilder
        Dim sql As String
        Dim dr As OleDbDataReader

        Try


            sql = "Select * from microtheory"
            sql = sql & " where ucase(category) = " & IsNvlString(UCase(sCategory))
            sql = sql & " order by microtheoryid desc"

            cmdSelect = New OleDbCommand(sql, dbconn)
            dr = cmdSelect.ExecuteReader

            sbImages.Remove(0, sbImages.Length)

            Dim sHeadline As String = ""
            Dim sText As String = ""
            Dim iCount As Integer = 0
            Dim sId As String = ""
            Do While dr.Read
                sId = dr("microtheoryid")
                If IsDBNull(dr("Headline")) = False Then
                    sHeadline = dr("headline")
                End If
                If IsDBNull(dr("microtheoryitem")) = False Then
                    sText = dr("microtheoryitem")
                End If
                Dim sImage_Next_Number As String = dr("image_next_number")
                If iCount = 0 Then
                    sbImages.Append("<div Class='item active' fixedCarouselImg>")
                Else
                    sbImages.Append("<div class='item carousel'>")
                End If
                sbImages.Append("    <img class='carousel' src='images/" & sImage_Next_Number & ".jpg' />")

                sbImages.Append("    <div class='carousel-caption'>")
                sbImages.Append("        <h3>" & sHeadline & "</h3>")
                sbImages.Append("         <P>" & sText & "</P>")
                sbImages.Append("         <P>Id: " & sId & "</P>")
                sbImages.Append("    </div>")
                sbImages.Append(" </div>")
                iCount += 1
            Loop
            dr.Close()

            sb.Append("  <div id='carousel-example-generic' class='carousel slide ' data-interval='3000' data-ride='carousel'>")

            sb.Append(" <ol class='carousel-indicators'>")
            sb.Append("<li data-target='#carousel-example-generic' data-slide-to='0' ></li>")
            'sb.Append("<li data-target='#carousel-example-generic' data-slide-to='1'></li>")
            'sb.Append("<li data-target='#carousel-example-generic' data-slide-to='2'></li>")
            'sb.Append("<li data-target='#carousel-example-generic' data-slide-to='3' class='active'></li>")
            'sb.Append("<li data-target='#carousel-example-generic' data-slide-to='4'></li>")
            sb.Append("</ol>")

            sb.Append(" <div class='carousel-inner'>")
            sb.Append(sbImages.ToString)
            'sb.Append("<div Class='item'>")
            'sb.Append("<img src = 'images/94.jpg' />")
            'sb.Append("<div class='carousel-caption'><h3>Groomer</h3><P>abc</P></div>")
            'sb.Append("</div>")

            'sb.Append("<div class='item active'>")
            'sb.Append("<img src = 'images/30144_397037718107_660628107_4164039_2021452_n.jpg' />")
            'sb.Append("<div class='carousel-caption'><h3>Caption Text</h3></div>")
            'sb.Append("</div>")

            sb.Append("</div>")

            sb.Append("<a class='left carousel-control' href='#carousel-example-generic' role='button' data-slide='prev'>")
            sb.Append(" <span class='glyphicon glyphicon-chevron-left'></span>")
            sb.Append("</a>")
            sb.Append(" <a class='right carousel-control' href='#carousel-example-generic' role='button' data-slide='next'>")
            sb.Append("    <span class='glyphicon glyphicon-chevron-right'></span>")
            sb.Append(" </a>")
            sb.Append("</div> ")

            image_list.InnerHtml = sb.ToString
            'image_text.InnerText = sb.ToString
        Catch ex As Exception
        End Try
    End Sub
    Sub cboQueryCategory_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sCategory As String = ""
        Try
            lblErrorMsg.Text = ""
            sCategory = cboQueryCategory.Text
            lblQueryCategory.text = sCategory
            LoadImageList(sCategory)
            LoadThumbnails(sCategory)

        Catch ex As Exception
            MsgBox(ex.Message)
        End Try

    End Sub
    Sub UploadFiles_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        ResetSetup()
    End Sub
    Sub cboInputCategory_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        txtInputCategory.Text = cboInputCategory.SelectedItem.Text
    End Sub
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
    Sub MenuCommand_Click(ByVal sender As Object, ByVal e As CommandEventArgs)
        Dim sID As String = e.CommandArgument
        MultiViewCard.ActiveViewIndex = Int32.Parse(sID)

        itemMenu0.Attributes.Remove("class")
        itemMenu1.Attributes.Remove("class")
        itemMenu2.Attributes.Remove("class")

        Select Case sID
            Case "0"
                Dim sCategory As String = lblQueryCategory.Text
                LoadImageList(sCategory)
                LoadThumbnails(sCategory)
                itemMenu0.Attributes.Add("class", "active")
            Case "1"
                itemMenu1.Attributes.Add("class", "active")
            Case "2"
                ResetSetup()
                itemMenu2.Attributes.Add("class", "active")
        End Select

    End Sub
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function ddlChange() {
            var cmb = document.getElementById('<%=cboInputCategory.ClientID %>');
    var textBox = document.getElementById('<%= txtInputCategory.ClientID%>');
    textBox.value = cmb.options[cmb.selectedIndex].value;
}

    </script>

    <div class="container=fluid">

        <div class="jumbotron">
            <h3>Image Gallery</h3>
        </div>

        <div id="myMenu" style="background-color: white">
            <ul class="nav nav-pills">
                <li id="itemMenu0" runat="server" class="active">
                    <asp:LinkButton OnCommand="MenuCommand_Click" CommandArgument="0" runat="server">Gallary</asp:LinkButton></li>
                <li id="itemMenu1" runat="server">
                    <asp:LinkButton OnCommand="MenuCommand_Click" CommandArgument="1" runat="server">Order Form</asp:LinkButton></li>
                <li id="itemMenu2" runat="server">
                    <asp:LinkButton OnCommand="MenuCommand_Click" CommandArgument="2" runat="server">Setup</asp:LinkButton></li>
            </ul>
        </div>
        <asp:MultiView ID="MultiViewCard" runat="server" ActiveViewIndex="0">
            <asp:View ID="View0" runat="server">
                <asp:Panel ID="panelGallery" runat="server" BackColor="white">
                    <h3>Gallary</h3>
                    <div class="list-group">
                        <asp:DropDownList CssClass="list-group-item" ID="cboQueryCategory" runat="server" OnSelectedIndexChanged="cboQueryCategory_SelectedIndexChanged"></asp:DropDownList>
                    </div>

                    <asp:Label ID="lblQueryCategory" runat="server" Visible="false"></asp:Label>
                    <table>
                        <tr>
                            <td valign="top">
                                <asp:Panel ID="panelThumbnails" ScrollBars="Vertical" Height="150" runat="server">
                                    <asp:PlaceHolder ID="phImageControls" runat="server"></asp:PlaceHolder>
                                </asp:Panel>
                                <div id="image_list" runat="server"></div>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

            </asp:View>
            <asp:View ID="View1" runat="server">
                <asp:Panel ID="panelOrderForm" runat="server" BackColor="white">
                <h3>Order Form</h3>
                <div class="jumbotron">
                    <h3>Images will be printed on Cosco Canvas</h3>
                    <div class="list-group">
                        <div class="list-group-item">1. Select image - Provide me the ID (I will determine, if the photo is for sale)</div>
                        <div class="list-group-item">2. You Send $200 to my address. Start by sending me your address information and I will send you my address information.</div>
                        <div class="list-group-item">3. I will order the image on Canvas of the picture, at Cosco.  Cosco will send the canvas by mail to your mailing address</div>
                        <div class="list-group-item">Album pictures for Sales: Flowers, Patterns, Places, Travel, and Food</div>
                    </div>
                </div>
                <asp:Label ID="lblMessage" runat="server" ForeColor="Blue" Font-Size="Large"></asp:Label>
                <asp:Panel ID="panelForm" runat="server">
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
                            <textarea class="form-control" rows="4" name="txtMessage" placeholder="Id=?"></textarea>
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
                            <asp:Button CssClass="btn btn-default" runat="server" ID="txtSubmit" Text="Send" OnClick="Submit_Click" />
                        </div>
                    </div>
                    </asp:Panel>
                </asp:Panel>
            </asp:View>
            <asp:View ID="View2" runat="server">
                <asp:panel ID="panelSetup" runat="server" BackColor="white">
                <h3>Setup</h3>
                <asp:HyperLink CssClass="btn btn-default" ID="hyperLinkLogin" NavigateUrl="lssLogin.aspx" runat="server" Text="Login"></asp:HyperLink>
                <asp:linkbutton CssClass="btn btn-primary" ID="linkButtonOpen" OnClick="UploadFiles_Click" runat="server" Text="Upload Files"></asp:linkbutton>
                <br />
                <asp:Label ID="lblErrorMsg" ForeColor="red" runat="server"></asp:Label>

                <asp:Label ID="lblImage_Next_Number" runat="server"></asp:Label>
                <asp:Panel ID="panelUpload" runat="server" Visible="false">
                    <div class="panel panel-default fixed-panel">
                        <div class="panel-body">
                            <div role="form">
                                <div class="form-group">
                                    <label>Choose Your File To Upload</label><br />
                                    <asp:FileUpload ID="MyFile" runat="server" /><br />
                                    <div id="UploadDetails" visible="true" runat="Server" />
                                    <br />
                                    Index Name:<asp:Label ID="lblInputImage_Path" Text="" runat="server"></asp:Label>
                                    | File Content: <span id="FileContent" runat="Server" />| File Size: <span id="FileSize" runat="Server" />bytes<br />
                                    <br />
                                    <span id="Span1" style="color: Red" runat="Server" />
                                    <span id="Span2" style="color: Red" runat="Server" />
                                    <asp:Label ID="lblFileuploadMessage" runat="server" ForeColor="red"></asp:Label><br />
                                </div>

                                <div class="form-group">
                                    <label>Category:</label><br />
                                    <asp:TextBox ID="txtInputCategory" runat="server" Width="100px" />
                                    <asp:DropDownList ID="cboInputCategory" runat="server" /><br />
                                </div>
                                <div class="form-group">
                                    <label>Headline:</label><br />
                                    <asp:TextBox ID="txtInputHeadline" runat="server" Width="220px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="ValidatorCategory" runat="server" ControlToValidate="txtInputCategory"
                                        ErrorMessage="Please type in a Category"></asp:RequiredFieldValidator>
                                    <asp:RequiredFieldValidator ID="ValidatorHeadline" runat="server" ControlToValidate="txtInputHeadline"
                                        ErrorMessage="Please type in a Headline"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group">
                                    <label>Detail</label><br />
                                    <asp:TextBox ID="txtInputMicrotheoryItem" TextMode="MultiLine" cols="40" Rows="5" runat="server" size="35" />
                                </div>
                                <div class="form-group">
                                    <input class="btn btn-default" id="Submit1" causesvalidation="false" type="submit" value="Save" onserverclick="Upload_Click" runat="Server">
                                    <asp:Button ID="cmdCancel" Text="Cancel" CausesValidation="false" OnClick="Cancel_Click" runat="server" />
                                </div>


                                <div class="form-group">
                                    <label>Picture Id</label>:<asp:TextBox ID="txtId" runat="server"></asp:TextBox><br />
                                    <input class="btn btn-primary" id="btnDelete" causesvalidation="false" type="submit" value="Delete" onserverclick="Delete_Click" runat="Server">
                                    <input class="btn btn-primary" id="btnFlipX" causesvalidation="false" type="submit" value="Flip X" onserverclick="FlipX_180Degree_Click" runat="Server">
                                    <input class="btn btn-primary" id="btnRotate90" causesvalidation="false" type="submit" value="Rotate 90" onserverclick="Rotate90Degree_Click" runat="Server">
                                </div>

                            </div>
                        </div>
                    </div>
                    </asp:Panel>
                    </asp:panel>
            </asp:View>
        </asp:MultiView>
    </div>
</asp:Content>

Attribute VB_Name = "mMain"
Option Explicit

Public oNfoDom As New MSXML2.DOMDocument40
'Public sAudioDirPath As String

' Constants for use with BrowseForFolder
Public Const BIF_RETURNONLYFSDIRS   As Long = &H1
Public Const BIF_DONTGOBELOWDOMAIN  As Long = &H2
Public Const BIF_VALIDATE           As Long = &H20
Public Const BIF_EDITBOX            As Long = &H10
Public Const BIF_NEWDIALOGSTYLE     As Long = &H40
Public Const BIF_USENEWUI As Long = (BIF_NEWDIALOGSTYLE Or BIF_EDITBOX)

Public Sub Main()

    oNfoDom.async = False
    oNfoDom.validateOnParse = False
    oNfoDom.resolveExternals = False
    oNfoDom.preserveWhiteSpace = False
    oNfoDom.setProperty "SelectionLanguage", "XPath"
    oNfoDom.setProperty "SelectionNamespaces", "xmlns:xht='http://www.w3.org/1999/xhtml'"
    oNfoDom.setProperty "NewParser", True

frmMain.Show

End Sub

Public Sub addLog(isLogItem As String)
    frmMain.rtfLog.Text = frmMain.rtfLog.Text & ">> " & isLogItem & Chr(13) & Chr(10)
End Sub

Public Function fncRunRename(sAudioDirPath As String, sRenameNfoPath As String) As Boolean
Dim oNodes As IXMLDOMNodeList
Dim oNode As IXMLDOMNode
Dim sOrigName As String
Dim sNewName As String

  On Error GoTo errH
  fncRunRename = False
  
  If Not fncParseFile(sRenameNfoPath, oNfoDom) Then
    addLog "failed loading rename nfo"
    GoTo errH
  Else
    addLog "rename nfo loaded"
  End If
  
  Set oNodes = oNfoDom.selectNodes("//file")
  addLog "files found in doc: " & oNodes.length
  
  If Not oNodes Is Nothing Then
    If oNodes.length > 0 Then
      For Each oNode In oNodes
        DoEvents
        sOrigName = Trim$(oNode.selectSingleNode("@origName").Text)
        sNewName = Trim$(oNode.selectSingleNode("@newName").Text)
        If LCase$(fncGetExtension(sOrigName)) = ".wav" Or _
           LCase$(fncGetExtension(sOrigName)) = ".mp3" Or _
           LCase$(fncGetExtension(sOrigName)) = ".mp2" Or _
           LCase$(fncGetExtension(sOrigName)) = ".mpeg" Then
          If sOrigName <> "" And sNewName <> "" Then
            If Not fncRenameFile(sAudioDirPath & sNewName, sOrigName) Then
              addLog "rename of " & sNewName & " to " & sOrigName & " failed."
            Else
              addLog sNewName & " :: " & sOrigName
            End If
          End If
        End If 'fncgetextension
      Next
    End If
  End If
  
  fncRunRename = True
errH:
  If Not fncRunRename Then addLog "fncRunRename errh"
End Function



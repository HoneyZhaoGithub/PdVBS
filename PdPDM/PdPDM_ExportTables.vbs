'******************************************************************************
'* File       : PdPDM_ExportTables.vbs
'* Purpose    : ������Excle
'* Title      : ������
'* Category   : ����ģ��
'* Version    : v1.3
'* Company    : www.duanzhihui.com
'* Author     : ���ǻ�
'* Description: ������Excle
'* History    : 2017-06-05  v1.0    ���ǻ�  �����ű���
'*              2017-06-07  v1.1    ���ǻ�  �ű����ţ����ٹ��̵���������л���
'*              2017-06-08  v1.2    ���ǻ�  �ű����ţ����� array ���� powerdesigner �� excle �ķ��ʡ�
'*              2017-06-09  v1.3    ���ǻ�  �ű����ţ���� large array �޷�д��excle���⡣
'******************************************************************************
Option Explicit

Dim mdl                                             ' the current model
Set mdl = ActiveModel
If (mdl Is Nothing) Then
   MsgBox "There is no Active Model"
End If

Dim HaveExcel
Dim RQ
RQ = vbYes 'MsgBox("Is Excel Installed on your machine ?", vbYesNo + vbInformation, "Confirmation")
If RQ = vbYes Then
    HaveExcel = True
    ' Open & Create Excel Document
    Dim exl  '
    Set exl = CreateObject("Excel.Application")

    Dim tplt, path, ws
    set ws=CreateObject("WScript.Shell")
    tplt = ws.CurrentDirectory + "\PdPDM_ExportTables_Template.xlsx"
    path = ws.CurrentDirectory + "\PdPDM_ExportTables_xxx.xlsx"

    path = InputBox ("���������ģ�͵�Excel�ļ�·����", "�ļ�·��", path)
    output "Excel�ļ�·��Ϊ: " + path

    CreateObject("Scripting.FileSystemObject").CopyFile tplt, path, true

    exl.Workbooks.Open path
Else
    HaveExcel = False
End If

'on error Resume Next

Dim fldr, nb1, nb2, ar1(10000, 7), ar2(100000, 8)
Set fldr = ActiveDiagram.Parent
nb1 =0
nb2 =0

ListObjects(fldr)
exl.Workbooks(1).ForceFullCalculation = False
output CStr(now) + " Write list of tables"
exl.Workbooks(1).Worksheets("Tables").Activate
exl.Range("A2").Resize(nb1, 8).Value = ar1
output CStr(now) + " Write list of columns"
exl.Workbooks(1).Worksheets("Columns").Activate
exl.Range("C2").Resize(nb2, 9).Value = ar2
output CStr(now) + " Save excle"
exl.Workbooks(1).ForceFullCalculation = True
exl.Workbooks(1).Close True

Sub ListObjects(fldr)
    output CStr(now) + " Scan "+fldr.ClassName+" "+fldr.Code
    Dim tbl, col
    For Each tbl In fldr.tables
        ar1(nb1, 0) = "R"
        ar1(nb1, 1) = tbl.Parent.Code
        ar1(nb1, 2) = tbl.Name
        ar1(nb1, 3) = tbl.Code
        ar1(nb1, 4) = tbl.Comment
        ar1(nb1, 5) = Rtf2Ascii(tbl.Description)
        ar1(nb1, 6) = Rtf2Ascii(tbl.Annotation)
        if not tbl.Owner is Nothing then
            ar1(nb1, 7) = tbl.Owner.Code
        Else
            ar1(nb1, 7) = ""
        End if
        nb1 = nb1 + 1

        output CStr(now) + " List "+tbl.ClassName+" "+tbl.Code + " Columns"
        for Each col in tbl.Columns
            ar2(nb2, 0) = col.Parent.Code
            ar2(nb2, 1) = col.Name
            ar2(nb2, 2) = col.Code
            ar2(nb2, 3) = col.DataType
            ar2(nb2, 4) = col.Primary
            ar2(nb2, 5) = col.Mandatory
            ar2(nb2, 6) = col.Comment
            ar2(nb2, 7) = Rtf2Ascii(col.Description)
            ar2(nb2, 8) = Rtf2Ascii(col.Annotation)
            nb2 = nb2+1
        Next
    Next

    ' go into the sub-packages
    Dim f ' running folder
    For Each f In fldr.Packages
        ListObjects f
    Next
End Sub

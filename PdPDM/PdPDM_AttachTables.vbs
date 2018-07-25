'******************************************************************************
'* File       : PdPDM_AutoAttach.vbs
'* Purpose    : ��Sheet���ӱ�������ͼ
'* Title      : ��Sheet���ӱ�������ͼ
'* Category   : ���븽��
'* Version    : v1.0
'* Company    : www.duanzhihui.com
'* Author     : ���ǻ�
'* Description:
'*              CRUD
'*                  C ����
'*                  R ֻ��  ֱ�Ӻ��ԡ�
'*                  U ����
'*                  D ɾ��
'* History    :
'*              2016-03-09  v1.0    ���ǻ� ����
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

    Dim path, ws
    set ws=CreateObject("WScript.Shell")
    path = ws.CurrentDirectory + "\PdPDM_AttachTables.xlsx"

    path = InputBox ("���������ģ�͵�Excel�ļ�·����", "�ļ�·��", path)
    output "Excel�ļ�·��Ϊ: " + path

    exl.Workbooks.Open path
    exl.Workbooks(1).Worksheets(1).Activate    'ָ��Ҫ�򿪵�sheet����
Else
    HaveExcel = False
End If

'on error Resume Next
Dim dgrm, tbl, sym, row
row = 2
With exl.Workbooks(1).Worksheets(1)
    do While .Cells(row, 1).Value <> ""                     '�˳�
        select case Ucase(.Cells(row, 1).Value)
        case "C"
            set dgrm = mdl.FindChildByCode(.Cells(row, 2).Value, PdPDM.cls_PhysicalDiagram, "", nothing, False)
            set tbl = mdl.FindChildByCode(.Cells(row, 3).Value, PdPDM.cls_Table, "", nothing, False)
            set sym = dgrm.FindSymbol(tbl)
            if sym is nothing then
                dgrm.AttachObject tbl
                output "��" + CStr(row) + "�У����ӱ�" + tbl + "��"
            end if
        case "R"
        case "U"
        case "D"
        case Else
        end select
       'exl.Range("A"+Cstr(row)).Value = "R"                '�� CRUD ��ΪĬ��ֵ R
        row = row + 1
    Loop
End With
exl.Workbooks(1).Close True

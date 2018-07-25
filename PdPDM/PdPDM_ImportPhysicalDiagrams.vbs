'*******************************************************************************
'* File       : PdPDM_ImportPhysicalDiagrams.vbs
'* Purpose    : ��Sheet�е���PhysicalDiagrams
'* Title      : ��Sheet�е���PhysicalDiagrams
'* Category   : ����ģ��
'* Version    : v1.0
'* Company    : www.duanzhihui.com
'* Author     : ���ǻ�
'* Description:
'*              CRUD
'*                  C ����  ���PhysicalDiagram��������ԣ�����������
'*                  R ֻ��  ֱ�Ӻ��ԡ�
'*                  U ����  ���PhysicalDiagram��������£�����������
'*                  D ɾ��  ɾ��PhysicalDiagram��
'* History    :
'*              2016-03-31  v1.0    ���ǻ�  ����
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
    path = ws.CurrentDirectory + "\PdPDM_ImportPhysicalDiagrams.xlsx"

    path = InputBox ("���������ģ�͵�Excel�ļ�·����", "�ļ�·��", path)
    output "Excel�ļ�·��Ϊ: " + path

    exl.Workbooks.Open path
    exl.Workbooks(1).Worksheets(1).Activate    'ָ��Ҫ�򿪵�sheet����
Else
    HaveExcel = False
End If

dim par, dgrm, row
on error Resume Next

row = 2
With exl.Workbooks(1).Worksheets(1)
    do While .Cells(row, 1).Value <> ""                     '�˳�

        set par = mdl.FindChildByCode(CStr(.Cells(row, 2).Value), PdPDM.cls_Package, "", nothing, False)
        if par is nothing then
            set par = mdl
        end if

        select case Ucase(.Cells(row, 1).Value)
        case "C"
            output "��" + CStr(row) + "�У�����PhysicalDiagram��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
            CreatePhysicalDiagram par, exl, row
        case "R"
            output "��" + CStr(row) + "�У�ֻ��PhysicalDiagram��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
        case "U"
            output "��" + CStr(row) + "�У�����PhysicalDiagram��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
            UpdatePhysicalDiagram par, exl, row
        case "D"
            output "��" + CStr(row) + "�У�ɾ��PhysicalDiagram��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
            DeletePhysicalDiagram par, exl, row
        case Else
            output "��" + CStr(row) + "�У�����PhysicalDiagram��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
        end select
       'exl.Range("A"+Cstr(row)).Value = "R"                '�� CRUD ��ΪĬ��ֵ R
        row = row + 1
    Loop
End With

exl.Workbooks(1).Close True

sub CreatePhysicalDiagram(par, exl, row)
    dim dgrm
    With exl.Workbooks(1).Worksheets(1)
        set dgrm = par.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_PhysicalDiagram, "", nothing, False)
        if not dgrm is nothing then
            output "|__"+CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +") PhysicalDiagram���ڣ�����PhysicalDiagram��"
        Else
            set dgrm = par.PhysicalDiagrams.CreateNew    '���� PhysicalDiagram
            dgrm.Name = .Cells(row, 3).Value            'ָ�� PhysicalDiagram����
            dgrm.Code = .Cells(row, 4).Value            'ָ�� PhysicalDiagram����
            dgrm.Comment = .Cells(row, 5).Value         'ָ�� PhysicalDiagramע��
        end if
    End With
End sub

sub UpdatePhysicalDiagram(par, exl, row)
    dim dgrm
    With exl.Workbooks(1).Worksheets(1)
        set dgrm = par.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_PhysicalDiagram, "", nothing, False)
        if not dgrm is nothing then
            dgrm.Name = .Cells(row, 3).Value            'ָ�� PhysicalDiagram����
           'dgrm.Code = .Cells(row, 4).Value            'ָ�� PhysicalDiagram����
            dgrm.Comment = .Cells(row, 5).Value         'ָ�� PhysicalDiagramע��
        Else
            output "|__"+CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +") PhysicalDiagram�����ڣ�����PhysicalDiagram��"
            CreatePhysicalDiagram par, exl, row
        end if
    End With
End sub

sub DeletePhysicalDiagram(par, exl, row)
    dim dgrm
    With exl.Workbooks(1).Worksheets(1)
        set dgrm = par.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_PhysicalDiagram, "", nothing, False)
        if not dgrm is nothing then
            dgrm.Delete
        end if
    End With
End sub

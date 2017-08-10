'******************************************************************************
'* File:        PdPDM_ImportPackages.vbs
'* Purpose:     ��Sheet�е���Packages
'* Title:
'* Category:
'* Version:     1.1
'* Company:
'* Author:      ���ǻ�
'* Description:
'*              CRUD
'*                  C ����  ���Package��������ԣ�����������
'*                  R ֻ��  ֱ�Ӻ��ԡ�
'*                  U ����  ���Package��������£�����������
'*                  D ɾ��  ɾ��Package��
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
    path = ws.CurrentDirectory + "\PdPDM_ImportPackages.xlsx"

    path = InputBox ("���������ģ�͵�Excel�ļ�·����", "�ļ�·��", path)
    output "Excel�ļ�·��Ϊ: " + path

    exl.Workbooks.Open path
    exl.Workbooks(1).Worksheets(1).Activate    'ָ��Ҫ�򿪵�sheet����
Else
    HaveExcel = False
End If

dim par, pkg, row
on error Resume Next

row = 2
With exl.Workbooks(1).Worksheets(1)
    do While .Cells(row, 1).Value <> ""                     '�˳�

        set par = mdl.FindChildByCode(CStr(.Cells(row, 2).Value), PdPDM.cls_Package)
        if par is nothing then
            set par = mdl
        end if

        select case .Cells(row, 1).Value
        case "C"
            output "��" + CStr(row) + "�У�����Package��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
            CreatePackage par, exl, row
        case "R"
            output "��" + CStr(row) + "�У�ֻ��Package��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
        case "U"
            output "��" + CStr(row) + "�У�����Package��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
            UpdatePackage par, exl, row
        case "D"
            output "��" + CStr(row) + "�У�ɾ��Package��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
            DeletePackage par, exl, row
        case Else
            output "��" + CStr(row) + "�У�����Package��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
        end select
        exl.Range("A"+Cstr(row)).Value = "R"
        row = row + 1
    Loop
End With

exl.Workbooks(1).Close True

sub CreatePackage(par, exl, row)
    dim pkg
    With exl.Workbooks(1).Worksheets(1)
        set pkg = par.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_Package)
        if not pkg is nothing then
            output "|__"+CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +") Package���ڣ�����Package��"
        Else
            set pkg = par.Packages.CreateNew            '���� Package
            pkg.Name = .Cells(row, 3).Value             'ָ�� Package����
            pkg.Code = .Cells(row, 4).Value             'ָ�� Package����
            pkg.Comment = .Cells(row, 5).Value          'ָ�� Packageע��
            pkg.DefaultDiagram.Name =  pkg.Name         'ָ�� DefaultDiagram����
            pkg.DefaultDiagram.Code =  pkg.Code         'ָ�� DefaultDiagram����
        end if
    End With
End sub

sub UpdatePackage(par, exl, row)
    dim pkg
    With exl.Workbooks(1).Worksheets(1)
        set pkg = par.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_Package)
        if not pkg is nothing then
            pkg.Name = .Cells(row, 3).Value             'ָ�� Package����
           'pkg.Code = .Cells(row, 4).Value             'ָ�� Package����
            pkg.Comment = .Cells(row, 5).Value          'ָ�� Packageע��
            pkg.DefaultDiagram.Name =  pkg.Name         'ָ�� DefaultDiagram����
            pkg.DefaultDiagram.Code =  pkg.Code         'ָ�� DefaultDiagram����
        Else
            output "|__"+CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +") Package�����ڣ�����Package��"
            CreatePackage par, exl, row
        end if
    End With
End sub

sub DeletePackage(par, exl, row)
    dim pkg
    With exl.Workbooks(1).Worksheets(1)
        set pkg = par.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_Package)
        if not pkg is nothing then
            pkg.Delete
        end if
    End With
End sub

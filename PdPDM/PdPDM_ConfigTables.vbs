'******************************************************************************
'* File       : PdPDM_ConfigTables.vbs
'* Purpose    : ��excel���������
'* Title      : ���ñ�
'* Category   : ����ģ��
'* Version    : v2.1
'* Company    : www.duanzhihui.com
'* Author     : ���ǻ�
'* Description: ���ñ�����ѡ���Ĭ���ֶ�
'*              CRUD
'*                  C ����  �����������ԣ�����������
'*                  R ֻ��  ֱ�Ӻ��ԡ�
'*                  U ����  �����������£�����������
'*                  D ɾ��  ɾ����
'* History    :
'*              2016-03-31  v1.0    ���ǻ�  ���� Ĭ���ֶ����á�
'*              2016-07-08  v2.0    ���ǻ�  ���� ����ѡ�����ã�֧��ͨ��� * ��
'*              2017-08-18  v2.1    ���ǻ� �޸� CBoolean �����TRUE��FALSE�����ַ�������Ĭ�����FALSE���⡣
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
    Dim exl
    Set exl = CreateObject("Excel.Application")

    Dim path, ws
    set ws=CreateObject("WScript.Shell")
    path = ws.CurrentDirectory + "\PdPDM_ConfigTables.xlsx"

    path = InputBox ("���������ģ�͵�Excel�ļ�·����", "�ļ�·��", path)
    output "Excel�ļ�·��Ϊ: " + path

    exl.Workbooks.Open path
    exl.Workbooks(1).Worksheets(1).Activate    'ָ��Ҫ�򿪵�sheet����
Else
    HaveExcel = False
End If

dim par, tbl, row, spar, stblname, stblcode, typ
'on error Resume Next

row = 2
With exl.Workbooks(1).Worksheets(1)
    do While .Cells(row, 1).Value <> ""                     '�˳�
        spar = CStr(.Cells(row, 2).Value)
        stblname = CStr(.Cells(row, 3).Value)
        stblcode = CStr(.Cells(row, 4).Value)
        typ = CStr(.Cells(row, 5).Value)

        set par = mdl.FindChildByCode(spar, PdPDM.cls_Package)
        if par is nothing then
            set par = mdl
        end if

        if spar = "*" Then
            For Each par in mdl.Packages
                For Each tbl in par.Tables
                    ConfigTable typ, par, exl, row, tbl
                Next
            Next
        ElseIf stblcode = "*" Then
            For Each tbl in par.Tables
                ConfigTable typ, par, exl, row, tbl
            Next
        Else
            set tbl = par.FindChildByCode(stblcode, PdPDM.cls_Table)
            if tbl is Nothing Then
                output "��" + CStr(row) + "�У������ڣ�" + stblname + "(" + stblcode +")��"
            Else
                ConfigTable typ, par, exl, row, tbl
            end if
        end if
        row = row + 1
    Loop
End With

exl.Workbooks(1).Close False

sub ConfigTable(typ, par, exl, row, tbl)
    select case typ
    case "DefaultColumns"
        output "��" + CStr(row) + "�У�Ĭ���ֶΣ�" + tbl + "��"
        DefaultColumns par, exl, row, tbl
    case "PhysicalOption"
        output "��" + CStr(row) + "�У�����ѡ�" + tbl + "��"
        PhysicalOption par, exl, row, tbl
    case Else
        output "��" + CStr(row) + "�У��������ã�" + tbl + "��"
    end select
End sub

sub DefaultColumns(par, exl, row, tbl)
    dim col
    With exl.Workbooks(1).Worksheets(1)
        select case .Cells(row, 1).Value
        case "C"
            output "|__����Ĭ���ֶ�"
            CreateDefaultColumns par, exl, tbl, CLng(.Cells(row, 9).Value)
        case "R"
            output "|__ֻ��Ĭ���ֶ�"
        case "U"
            output "|__�޸�Ĭ���ֶ�"
            UpdateDefaultColumns par, exl, tbl, CLng(.Cells(row, 9).Value)
        case "D"
            output "|__ɾ��Ĭ���ֶ�"
            DeleteDefaultColumns par, exl, tbl, CLng(.Cells(row, 9).Value)
        case Else
            output "|__����Ĭ���ֶ�"
        end select
    End With
End sub

sub CreateDefaultColumns(par, exl, tbl, row)
    dim col, idx
    idx = tbl.Columns.Count
    With exl.Workbooks(1).Worksheets(2)
        do
            set col = tbl.FindChildByCode(.Cells(row, 5).Value, PdPDM.cls_Column)
            if col is Nothing Then
                set col = tbl.FindChildByName(.Cells(row, 4).Value, PdPDM.cls_Column)
            end if
            if col is nothing then
                CreateColumn exl, row, tbl, idx
            end if
            row = row + 1
            idx = idx + 1
        loop while .Cells(row, 3).Value = .Cells(row - 1, 3).Value
    End With
End sub

sub UpdateDefaultColumns(par, exl, tbl, row)
    dim col, idx
    idx = tbl.Columns.Count
    With exl.Workbooks(1).Worksheets(2)
        do
            set col = tbl.FindChildByCode(.Cells(row, 5).Value, PdPDM.cls_Column)
            if col is Nothing Then
                set col = tbl.FindChildByName(.Cells(row, 4).Value, PdPDM.cls_Column)
            end if
            if col is nothing then
                CreateColumn exl, row, tbl, idx
            else
                UpdateColumn exl, row, tbl, col, idx
            end if
            row = row + 1
            idx = idx + 1
        loop while .Cells(row, 3).Value = .Cells(row - 1, 3).Value
    End With
End sub

sub DeleteDefaultColumns(par, exl, tbl, row)
    dim col
    With exl.Workbooks(1).Worksheets(2)
        do
            set col = tbl.FindChildByCode(.Cells(row, 5).Value, PdPDM.cls_Column)
            if col is Nothing Then
                set col = tbl.FindChildByName(.Cells(row, 4).Value, PdPDM.cls_Column)
            end if
            if not col is nothing then
                tbl.Columns.Remove col, True
            end if
            row = row + 1
        loop while .Cells(row, 3).Value = .Cells(row - 1, 3).Value
    End With
End sub


'   CreateColumn    �� PdPDM_ImportTables.vbs ����һ��
sub CreateColumn(exl, row, tbl, idx)
    dim col
    With exl.Workbooks(1).Worksheets(2)
        set col = tbl.Columns.CreateNewAt(idx)                                  '���� �ֶ�
        col.Name = .Cells(row, 4).Value                                         'ָ�� �ֶ�����
        col.Code = .Cells(row, 5).Value                                         'ָ�� �ֶα���
        col.DataType = .Cells(row, 6).Value                                     'ָ�� ��������
        col.Primary = CBoolean(.Cells(row, 7).Value)                            'ָ�� ����
        if not col.Primary Then
          col.Mandatory = CBoolean(.Cells(row, 8).Value)                        'ָ�� ǿ��
        end if
        col.Comment = .Cells(row, 9).Value                                      'ָ�� ע��
        if col.Comment = "" Then
            col.Comment = col.Name
        end if
        col.Description = .Cells(row, 10).Value                                 'ָ�� ����
        col.Annotation = .Cells(row, 11).Value                                  'ָ�� ��ע
    End With
End sub

'   UpdateColumn    �� PdPDM_ImportTables.vbs ����һ��
sub UpdateColumn(exl, row, tbl, col, idx)
    Dim i
    With exl.Workbooks(1).Worksheets(2)
        col.Name = .Cells(row, 4).Value                                         'ָ�� �ֶ�����
        col.Code = .Cells(row, 5).Value                                         'ָ�� �ֶα���
        col.DataType = .Cells(row, 6).Value                                     'ָ�� ��������
        col.Primary = CBoolean(.Cells(row, 7).Value)                            'ָ�� ����
        if not col.Primary Then
          col.Mandatory = CBoolean(.Cells(row, 8).Value)                        'ָ�� ǿ��
        end if
        col.Comment = .Cells(row, 9).Value                                      'ָ�� ע��
        if col.Comment = "" Then
            col.Comment = col.Name
        end if
        col.Description = .Cells(row, 10).Value                                 'ָ�� ����
        col.Annotation = .Cells(row, 11).Value                                  'ָ�� ��ע
    End With

    '�Ƶ�ָ��λ��
    for i = idx to tbl.Columns.Count - 1
        if col.Code = tbl.Columns.Item(i).Code Then
            tbl.Columns.Move idx, i
            exit for
        end if
    Next
End sub

'   CBoolean    �� PdPDM_ImportTables.vbs ����һ��
Function CBoolean(exp)
    select case exp
    case "TRUE"
        CBoolean = TRUE
    case "FALSE"
        CBoolean = FALSE
    case TRUE
        CBoolean = TRUE
    case FALSE
        CBoolean = FALSE        
    case "��"
        CBoolean = TRUE
    case "��"
        CBoolean = FALSE
    case "1"
        CBoolean = TRUE
    case "0"
        CBoolean = FALSE
    case "Y"
        CBoolean = TRUE
    case "N"
        CBoolean = FALSE
    case Else
        CBoolean = FALSE
    end select
End Function

sub PhysicalOption(par, exl, row, tbl)
    dim col, path, value
    With exl.Workbooks(1).Worksheets(1)
        path = CStr(.Cells(row, 7).Value)
        value = CStr(.Cells(row, 8).Value)
        select case .Cells(row, 1).Value
        case "C"
            output "|__��������ѡ��"
            tbl.AddPhysicalOption(path)
            tbl.SetPhysicalOptionValue path, value
        case "R"
            output "|__ֻ������ѡ��"
        case "U"
            output "|__�޸�����ѡ��"
            tbl.SetPhysicalOptionValue path, value
        case "D"
            output "|__ɾ������ѡ��"
            tbl.DeletePhysicalOption path
        case Else
            output "|__��������ѡ��"
        end select
    End With
End sub

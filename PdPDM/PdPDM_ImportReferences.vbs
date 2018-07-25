'******************************************************************************
'* File       : PdPDM_ImportReferences.vbs
'* Purpose    : ��Sheet�е����ϵ
'* Title      : �����ϵ
'* Category   : ����
'* Version    : v1.1
'* Company    : www.duanzhihui.com
'* Author     : ���ǻ�
'* Description: ��Sheet�е����ϵ
'*              CRUD
'*                  C ����  �����ϵ��������ԣ�����������������Ӵ�������ԣ�����������
'*                  R ֻ��  ֱ�Ӻ��ԡ�
'*                  U ����  �����ϵ��������£�����������������Ӵ�����ɾ��������������������
'*                  D ɾ��  ɾ����ϵ��
'* History    : 2016-04-07  v1.0    ���ǻ�  ����
'*              2017-06-20  v1.1    ���ǻ�  opensource�ƻ�
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
    exl.Visible = True

    Dim path, ws
    set ws=CreateObject("WScript.Shell")
    path = ws.CurrentDirectory + "\PdPDM_ImportReferences.xlsx"

    path = InputBox ("���������ģ�͵�Excel�ļ�·����", "�ļ�·��", path)
    output "Excel�ļ�·��Ϊ: " + path

    exl.Workbooks.Open path
    exl.Workbooks(1).Worksheets(1).Activate    'ָ��Ҫ�򿪵�sheet����
Else
    HaveExcel = False
End If

dim par, obj1, obj2, ref, row, num
'on error Resume Next

row = 2
With exl.Workbooks(1).Worksheets(1)
    do While .Cells(row, 1).Value <> ""                                                                         '�˳�
        set obj1 = ActiveModel.FindChildByCode(.Cells(row, 6).Value, PdPDM.cls_Table, "", nothing, False)       'ָ�� ����
        set obj2 = ActiveModel.FindChildByCode(.Cells(row, 7).Value, PdPDM.cls_Table, "", nothing, False)       'ָ�� �ӱ�
        set par = obj2.Parent
        if par is nothing or obj1 is nothing or obj2 is nothing then
            output "��" + CStr(row) + "�У�WARNING���޶��󡿣�" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
        else

            if .Cells(row, 12).Value = 1 then
                num = ""
            else
                num = "-" + CStr(.Cells(row, 13).Value)
            end if
            exl.Range("B"+Cstr(row)).Value = par.Code
            exl.Range("C"+Cstr(row)).Value = "���_" + obj2.Name + "-" + obj1.Name + num

            select case UCase(.Cells(row, 1).Value)
            case "C"
                output "��" + CStr(row) + "�У�������ϵ��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
                CreateReference par, obj1, obj2, exl, row
            case "R"
                output "��" + CStr(row) + "�У�ֻ����ϵ��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
            case "U"
                output "��" + CStr(row) + "�У����¹�ϵ��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
                UpdateReference par, obj1, obj2, exl, row
            case "D"
                output "��" + CStr(row) + "�У�ɾ����ϵ��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
                DeleteReference par, exl, row
            case Else
                output "��" + CStr(row) + "�У����Թ�ϵ��" + CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +")��"
            end select
           'exl.Range("A"+Cstr(row)).Value = "R"            '�� CRUD ��ΪĬ��ֵ R
        end if
        row = row + 1
    Loop
End With

exl.Workbooks(1).Close True

sub CreateReference(par, obj1, obj2, exl, row)
    dim ref
    With exl.Workbooks(1).Worksheets(1)
        set ref = mdl.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_Reference, "", nothing, False)
        if not ref is nothing then
            output "|__"+CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +") ��ϵ���ڣ����Թ�ϵ��"
        Else
            set ref = par.References.CreateNew          '���� ��ϵ
            ref.Name = .Cells(row, 3).Value             'ָ�� ��ϵ����
            ref.Code = .Cells(row, 4).Value             'ָ�� ��ϵ����
            ref.Comment = .Cells(row, 5).Value          'ָ�� ��ϵע��
            set ref.ParentTable = obj1                  'ָ�� ��ϵ����
            set ref.ChildTable = obj2                   'ָ�� ��ϵ�ӱ�
            CreateJoins par, ref, exl, CInt(.Cells(row, 11).Value)              'ָ�� ��ϵ����
        end if
    End With
End sub

sub UpdateReference(par, obj1, obj2, exl, row)
    dim ref
    With exl.Workbooks(1).Worksheets(1)
        set ref = mdl.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_Reference, "", nothing, False)
        if not ref is nothing then
            ref.Name = .Cells(row, 3).Value             'ָ�� ��ϵ����
           'ref.Code = .Cells(row, 4).Value             'ָ�� ��ϵ����
            ref.Comment = .Cells(row, 5).Value          'ָ�� ��ϵע��
            set ref.ParentTable = obj1                  'ָ�� ��ϵ����
            set ref.ChildTable = obj2                   'ָ�� ��ϵ�ӱ�
            UpdateJoins par, ref, exl, CInt(.Cells(row, 11).Value)              'ָ�� ��ϵ����
        Else
            output "|__"+CStr(.Cells(row, 3).Value) + "(" + CStr(.Cells(row, 4).Value) +") ��ϵ�����ڣ�������ϵ��"
            CreateReference par, obj1, obj2, exl, row
        end if
    End With
End sub

sub DeleteReference(par, exl, row)
    dim ref
    With exl.Workbooks(1).Worksheets(1)
        set ref = mdl.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_Reference, "", nothing, False)
        if not ref is nothing then
            ref.Delete
        end if
    End With
End sub

sub CreateJoins(par, ref, exl, row)
    dim jn
    With exl.Workbooks(1).Worksheets(2)
        if ref.Joins.Count = 0 then
            do
                CreateJoin exl, row, ref, -1
                row = row + 1
            loop while .Cells(row, 3).Value = .Cells(row - 1, 3).Value
        Else
            output "|__"+CStr(.Cells(row, 2).Value) + "(" + CStr(.Cells(row, 3).Value) +") ��ϵ���Ӵ��ڣ��޸����ӡ�"
            UpdateJoins par, ref, exl, row
        end if
    End With
End sub

sub UpdateJoins(par, ref, exl, row)
    dim jn, idx
    With exl.Workbooks(1).Worksheets(2)
        if ref.Joins.Count = 0 then
            output "|__"+CStr(.Cells(row, 2).Value) + "(" + CStr(.Cells(row, 3).Value) +") ��ϵ���Ӳ����ڣ��������ӡ�"
            CreateJoins par, ref, exl, row
        Else
            do
                idx = FindJoin(exl, row, ref)               '   ��ȡ�����ֶ�λ��
                if idx = -1 then
                    CreateJoin exl, row, ref, idx
                Else
                    UpdateJoin exl, row, ref, idx
                End if
                row = row + 1
            loop while .Cells(row, 3).Value = .Cells(row - 1, 3).Value
        end if
    End With
End sub


sub CreateJoin(exl, row, ref, idx)
    dim jn
    With exl.Workbooks(1).Worksheets(2)
        set jn = ref.Joins.CreateNewAt(idx)                                                                                         '���� ����
        set jn.ParentTableColumn = ref.ParentTable.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_Column, "", nothing, False)      'ָ�� ���Ӹ��ֶ�
        set jn.ChildTableColumn  = ref.ChildTable.FindChildByCode(.Cells(row, 5).Value, PdPDM.cls_Column, "", nothing, False)       'ָ�� �������ֶ�
    End With
End sub

sub UpdateJoin(exl, row, ref, idx)
    dim jn
    With exl.Workbooks(1).Worksheets(2)
        set jn = ref.Joins.Item(idx)                                                                                                '��ȡ ����
       'set jn.ParentTableColumn = ref.ParentTable.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_Column, "", nothing, False)      'ָ�� ���Ӹ��ֶ�
        set jn.ChildTableColumn  = ref.ChildTable.FindChildByCode(.Cells(row, 5).Value, PdPDM.cls_Column, "", nothing, False)       'ָ�� �������ֶ�
    End With
End sub

Function FindJoin(exl, row, ref)
    dim jn, ptc, idx
    With exl.Workbooks(1).Worksheets(2)
        set ptc = ref.ParentTable.FindChildByCode(.Cells(row, 4).Value, PdPDM.cls_Column, "", nothing, False)                       '��ȡ ���Ӹ��ֶ�
        idx = 0
        FindJoin = -1
        do while idx < ref.Joins.Count
            set jn = ref.Joins.Item(idx)
            if jn.ParentTableColumn.Code = ptc.Code then
                FindJoin = idx
            end if
            idx = idx + 1
        Loop
    End With
End Function

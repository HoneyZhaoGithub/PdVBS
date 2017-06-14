'******************************************************************************
'* File       : PdPDM_AutoAttach.vbs
'* Purpose    : �Զ����ӱ���ϵ��������ͼ
'* Title      : �Զ����ӱ���ϵ��������ͼ
'* Category   : �Զ�����
'* Version    : v1.0
'* Company    : www.duanzhihui.com
'* Author     : ���ǻ�
'* Description: ǰ������ PdPDM_AttachTables.vbs
'* History    :
'*              2016-03-09  v1.0    ���ǻ� ����
'******************************************************************************
Option Explicit

Dim mdl                                             ' the current model
Set mdl = ActiveModel
If (mdl Is Nothing) Then
   MsgBox "There is no Active Model"
End If

'on error Resume Next
AutoAttach mdl

sub AutoAttach(par)
    Dim pkg, dgrm, tbl, ref, sym1, sym2
    For Each dgrm in par.PhysicalDiagrams
        output CStr(dgrm)
        For Each sym2 in dgrm.Symbols
            if sym2.IsKindOf(PdPDM.cls_TableSymbol) then
                set tbl = sym2.Object
                if tbl.IsShortcut then
                    set tbl = tbl.TargetObject
                end if
                output "����"+cstr(tbl)
                For Each ref in tbl.OutReferences
                    if tbl = ref.ChildTable Then
                        set sym1 = dgrm.FindSymbol(ref.ParentTable, true)
                        if not sym1 is nothing Then
                            if dgrm.FindSymbol(ref, true) is nothing Then
                                output "    ����"+Cstr(ref)
                                dgrm.AttachLinkObject ref, sym2, sym1
                            end if
                        end if
                    end if
                Next
         end if
        Next
        dgrm.AutoLayoutWithOptions 0, 1
    Next

    For Each pkg in par.Packages
        AutoAttach pkg
    Next
End Sub

'*******************************************************************************
'* File       : PdPDM_AutoAttachTables.vbs
'* Purpose    : �Զ����ӱ�Ĭ����ͼ
'* Title      : �Զ����ӱ�Ĭ����ͼ
'* Category   : �Զ�����
'* Version    : 1.0
'* Company    : www.duanzhihui.com
'* Author     : ���ǻ�
'* Description: �Զ����ӱ�Ĭ����ͼ�������ָ�������ͼ���� PdPDM_AttachTables.vbs
'* History    :
'*              2016-03-31  v1.0    ���ǻ�  ����
'******************************************************************************
Option Explicit

Dim mdl                                             ' the current model
Set mdl = ActiveModel
If (mdl Is Nothing) Then
   MsgBox "There is no Active Model"
End If

'on error Resume Next
Dim pkg, dgrm, tbl, sym
For Each pkg in mdl.Packages
    set dgrm = pkg.DefaultDiagram
    For Each tbl in pkg.Tables
        set sym = dgrm.FindSymbol(tbl)
        if sym is nothing Then
           dgrm.AttachObject tbl
        end if
    Next
    dgrm.AutoLayoutWithOptions 0, 1
Next

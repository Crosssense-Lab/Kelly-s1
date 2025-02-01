' �����ļ�ϵͳ����
Set fso = CreateObject("Scripting.FileSystemObject")

' ��ȡ��ǰ�ļ���·��
currentFolder = fso.GetAbsolutePathName(".")

' ��ȡ��ǰ�ļ����е������ļ�
Set folder = fso.GetFolder(currentFolder)
Set files = folder.Files

' �洢���е� .pptx �ļ�
Dim pptxFiles()
i = 0

' �����ļ���ɸѡ������ .pptx �ļ�
For Each file In files
    If LCase(fso.GetExtensionName(file.Name)) = "pptx" Then
        ReDim Preserve pptxFiles(i)
        Set pptxFiles(i) = file  ' ʹ�� Set �ؼ��ָ�ֵ����
        i = i + 1
    End If
Next

If i = 0 Then
    WScript.Echo "�� .pptx �ļ�"
    WScript.Quit
End If

' �����޸�ʱ����ļ�����
For i = 0 To UBound(pptxFiles) - 1
    For j = i + 1 To UBound(pptxFiles)
        If pptxFiles(i).DateLastModified > pptxFiles(j).DateLastModified Then
            ' �����ļ�����
            Set temp = pptxFiles(i)
            Set pptxFiles(i) = pptxFiles(j)
            Set pptxFiles(j) = temp
        End If
    Next
Next

' �������ļ�
For i = 0 To UBound(pptxFiles)
    newName = (i + 1) & ".pptx"
    fso.MoveFile pptxFiles(i).Path, currentFolder & "\" & newName
Next

WScript.Echo "�ļ���������ɣ�"
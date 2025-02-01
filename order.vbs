' 创建文件系统对象
Set fso = CreateObject("Scripting.FileSystemObject")

' 获取当前文件夹路径
currentFolder = fso.GetAbsolutePathName(".")

' 获取当前文件夹中的所有文件
Set folder = fso.GetFolder(currentFolder)
Set files = folder.Files

' 存储所有的 .pptx 文件
Dim pptxFiles()
i = 0

' 遍历文件，筛选出所有 .pptx 文件
For Each file In files
    If LCase(fso.GetExtensionName(file.Name)) = "pptx" Then
        ReDim Preserve pptxFiles(i)
        Set pptxFiles(i) = file  ' 使用 Set 关键字赋值对象
        i = i + 1
    End If
Next

If i = 0 Then
    WScript.Echo "无 .pptx 文件"
    WScript.Quit
End If

' 按照修改时间对文件排序
For i = 0 To UBound(pptxFiles) - 1
    For j = i + 1 To UBound(pptxFiles)
        If pptxFiles(i).DateLastModified > pptxFiles(j).DateLastModified Then
            ' 交换文件对象
            Set temp = pptxFiles(i)
            Set pptxFiles(i) = pptxFiles(j)
            Set pptxFiles(j) = temp
        End If
    Next
Next

' 重命名文件
For i = 0 To UBound(pptxFiles)
    newName = (i + 1) & ".pptx"
    fso.MoveFile pptxFiles(i).Path, currentFolder & "\" & newName
Next

WScript.Echo "文件重命名完成！"
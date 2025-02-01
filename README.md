## Kelly s1
基于 RAG 技术实现的英语读后续写模型

---

> 当下人工智能技术浪潮方兴未艾，我们有必要在教学领域进行一些创新的探索，让 AI 对高中生的学习起到促进作用。本项目基于 RAG 技术实现了一个英语读后续写模型，旨在帮助学生提高英语阅读和写作能力。

### 模型构建过程

#### 第一步：数据收集
收集大量的英语读后续写资料，例如教师上课使用的课件以及其他高质量的文本。

教师通常使用 .pptx 文档授课。为了提取课件中的所有英文文本信息，我们可以使用 Python 的 pptx 库，将提取出的文本保存到一个 .txt 文件中，以供预处理。以下是示例代码：

```vbscript
' 这是一段 VBScript 代码。它根据修改时间的先后顺序，重命名当前文件夹下的 .pptx 文档的文件名为 *数字*.pptx ，方便后续 Python 提取文字。使用示例代码时应将编码格式改为 ANSI。
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
```


```python
import os
import re
from pptx import Presentation

pptx_folder = './'
output_txt = 'extract.txt'

# 匹配英文字符和标点符号
english_text_pattern = re.compile(r'[A-Za-z0-9.,!?()";: -]+')

all_english_text = []

# 获取当前目录下所有符合格式的文件
pptx_files = [f for f in os.listdir(pptx_folder) if f.endswith('.pptx') and f[:-5].isdigit()]

# 按照数字顺序排序文件名
pptx_files.sort(key=lambda x: int(x[:-5]))

# 遍历每个 PPT 文件
for pptx_filename in pptx_files:
    pptx_path = os.path.join(pptx_folder, pptx_filename)

    presentation = Presentation(pptx_path)

    # 遍历每一张幻灯片的每个形状
    for slide in presentation.slides:
        for shape in slide.shapes:
            # 确保该形状包含文本框
            if hasattr(shape, 'text'):
                # 获取文本内容
                text = shape.text.strip()

                # 如果文本内容非空，只提取英文文本
                if text:
                    # 用正则表达式提取文本中的英文部分
                    extracted_english_text = ' '.join(english_text_pattern.findall(text))
                    
                    if extracted_english_text:  # 如果有英文文本
                        all_english_text.append(extracted_english_text)

                # 如果文本为空，添加空行
                else:
                    all_english_text.append('')

# 将提取的英文文本写入到 extract.txt 文件
with open(output_txt, 'w', encoding='utf-8') as f:
    for line in all_english_text:
        f.write(line + '\n')

print(f"提取完成，所有英文文本已保存到 {output_txt}")
```

### 第二步：数据预处理
对收集到的数据进行清洗、去重、分词等预处理操作，以便后续的模型训练。
我使用 [kimi.ai](https://kimi.ai) 进行数据清洗。一个示例的 Prompt ：

```markdown
这是一个我制作的英语读后续写语料数据集，Kimi，我需要你完成数据清洗任务，请按照以下要求逐步检查并修正数据中的错误：  

### 需要检查和修正的错误类型包括但不限于：
1. 单词拼写错误：检查是否有拼写错误，并按标准英语拼写修正  
2. 中英文符号混用：（确保全英文内容使用英文符号，全中文内容使用中文符号）  
3. 空格问题：缺少空格（如单词间或标点后未正确添加空格）；多余空格（如连续多个空格和不必要的前后空格）  
4. 大小写错误：句首单词应大写，专有名词应遵循正确大小写规则  
5. 标点符号错误：检查逗号、句号、引号、括号等是否正确使用，是否有标点符号重复、缺失或误用  
6. 文本格式不规范：是否存在行首/行尾多余空格，是否有异常换行（如单个句子被拆成多行）  
7. 特殊字符和乱码：检查是否有不符合语料格式的特殊字符，移除或修正乱码  

### 任务执行前确认
在正式执行任务之前，请回答以下问题：  
1. 你是否完全理解本次任务的要求和操作流程？  
2. 你是否有任何疑问或需要进一步澄清的地方？  
```
在 Kimi 说自己听明白指令后，将 extract.txt 发给它，它会自动进行数据清洗。

在 Kimi 清洗数据结束后，还需要加以辅助性的人工标注，确保数据集的准确性。

### 第三步：模型训练
使用 RAG 技术，将预处理后的数据作为输入，训练一个英语读后续写模型。

我使用了一个开源的 RAG 框架，[FastGPT](https://github.com/labring/FastGPT) . 

**部署过程**和**模型训练**见 FastGPT 文档。这里不赘述。

训练 Kelly s1 的主要流程是：
1. 创建一个知识库，将之前的数据集上传，使用索引模型（如阿里的 text-embedding-v3 模型）训练，实现文本转化成词向量从而实现语义检索。
2. 创建一个工作流，实现：在流程开始后进行知识库检索，检索到的结果作为输入，使用文本生成模型（如 DeepSeek V3）进行后续的续写。需要写好对接文本生成模型的 Prompt。


### 第四步：模型评估
自己写一个测试集，发送给模型，评估模型的效果。如果效果不佳，试着优化 Prompt，或者调整模型参数（均可在 FastGPT 控制台实现）。

模型的温度（一个用于控制模型的输出随机性的参数。当温度参数较高时，模型输出更加随机，有可能生成一些新颖的句子，但有导致输出的文本缺乏连贯性的风险）建议调至最大温度的 50%~70% 。由于模型是基于 RAG 技术实现的，易发生过拟合现象，所以温度尽量调高。

## 其他
数据集不开源。

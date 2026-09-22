# nushell 基础操作

交互 shell 为 nushell；调用一律采用单命令 `nu -c '...'`（内容无法容纳于一行时，
才写为临时脚本并以 `nu file.nu` 执行）。结构化数据一律使用其管道处理。

查询命令：`help <cmd>`（含签名与示例）、
`help commands | where category == "filters"`、`help operators`、`help escapes`。

## 字面量与类型

| 类型 | 写法 |
|---|---|
| `int` / `float` | `42`, `-1.5` |
| `string` | `'单引号'`（原样）、`"双引号"`（转义 `\n` `\t` `\\`）、`r#'原始'#`（适用于正则） |
| `bool` | `true` / `false` |
| `datetime` | `2024-01-02`, `2024-01-02T10:00:00+08:00` |
| `duration` | `2min`, `500ms` |
| `filesize` | `1kb`, `0.5MB`, `1GiB` |
| `range` | `0..4`（含 4）, `0..<5`, `0..` |
| `list` / `record` / `table` | `[1 'a']` / `{a: 1}` / `[[a b]; [1 2]]` |
| `null` | 空值，`describe` 显示为 `nothing` |

以 `<值> | describe` 确认实际类型；
`<值> | into int|float|string|bool|datetime|filesize|duration` 进行显式转换。

## 变量与特殊值

```nu
let x = 1                      # 绑定后不可变；一行内可用 ; 串联多句
$env.FOO                       # 读取环境变量；$env.FOO = "x" 仅写入当前会话
$in                            # 管道上一段的输入
$it                            # 闭包中隐式的当前元素
$nu.os-info                    # 运行时信息（$nu.os-info.name 等）
```

`let` 绑定的值以 `$x` 取用；需要“修改”时，将管道结果重新 `let` 一次
（`let x = ($x | update a 1)`）。

## 运算符

| 类别 | 运算符 |
|---|---|
| 算术 | `+ - * /` |
| 比较 | `== != < > <= >=` |
| 字符串匹配 | `=~`、`!~`、`like`、`not-like`（正则） |
| 包含 | `in` `not-in` `has` `starts-with` `ends-with` |
| 逻辑 | `and` `or` `not` |
| 拼接 | `++`（拼接 list/string） |
| 区间 | `..` `..<` |
| 可选 | `$rec.missing?`（不存在时返回 null） |

`has` 与 `in` 为二元谓词：`[1 2] has 1`、`1 in [1 2]`。

## 字符串

```nu
$"greetings, ($name)!"                    # 插值；可嵌表达式 $"(1 + 2)"、$"($rec.a)"
"one,two" | split row ","                 # → [one two]
"a,b,c" | split column "," x y z          # → table（3 列）
[zero one] | str join ","                 # → zero,one
"Hello" | str contains "ell"              # true
"Hello" | str substring 1..3              # ell
"abc" | str uppercase | str lowercase     # str trim / str length / str reverse
"a1b2" | str replace -a -r "\\d" "#"      # -a 全部，-r 正则（转义须写 \\）
"Nushell rocks" | parse "{shell} {mood}"  # → table
"Hello World" | split words               # → [Hello World]
"a\nb" | lines                            # 按行切分
```

注意：双引号中的反斜杠须写两次（`"\\d"`），或改用原始字符串 `r#'\d'#`。

## 路径与文件

```nu
"x" | path join "y" "z"        # x/y/z，跨平台
"/a/b/c.txt" | path parse      # {parent:/a/b, stem:c, extension:txt}
"a.tar.gz" | path parse | get extension      # gz
"./f" | path expand            # 绝对路径
"/a/b" | path relative-to /a   # b
$env.HOME | path exists
"/tmp/x" | path type           # dir / file / symlink
ls                             # → table：name type size modified
ls **/*.nix | where size > 1kb
open f.json                    # 按扩展名自动解析；open -r 读取原始字节
save -f out.json               # --raw 写文本，--append 追加
mkdir a b; cp x y; mv a b; rm -r d; touch f
glob **/*.md                   # 文件列表；du 目录大小
```

## 管道与闭包

```nu
if 2 > 1 { "yes" } else { "no" }
1..3 | each {|n| $n * 2 }              # 亦可使用隐式 $it：each { $it * 2 }
[1 null 2] | where $it != null
[1 2 3] | par-each {|n| $n * 2 }       # 并行
[3 1 2] | sort-by { $in }              # 按值排序；按列排序写 sort-by size --reverse
```

闭包参数写在 `{|a, b| ... }` 中；`$in` 引用管道输入，`where` 中可直接写表达式
（`where name =~ 'x'`）。

## 外部命令

```nu
^git status                            # ^ 前缀调用外部命令，避免与内置命令同名
^curl -s $url | from json              # 外部输出显式解析
^git status | complete                 # {stdout, stderr, exit_code}
try { ^cmd } catch {|e| $"err: ($e.msg)" }
nu -c 'print 1'                        # 以子进程执行 nushell
```

`$env.LAST_EXIT_CODE` 为上一条外部命令的退出码；`$env.config` 控制提示符与表格。

## 稳定写法

- `nu -c` 中调用外部命令加 `^`（`^git`、`^nix`、`^rg`）。
- `sort-by` 带上列名或闭包：`sort-by size`、`sort-by { $in }`。
- 拼接字符串或 list 使用 `++`。
- record 中字段值为表达式时加括号：`{a: ($r.a * 2)}`。
- `update`/`insert` 返回新值，写回变量时写 `let x = ($x | update ...)`。
- 输出常为惰性 `(stream)`；需要长度、判空这类确定结果时先收集
  （`length` 会驱动流）。
- 正则中的转义写 `"\\d"` 或 `r#'\d'#`。

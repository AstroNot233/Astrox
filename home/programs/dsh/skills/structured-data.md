---
name: structured-data
description: Use when handling structured data — reading, converting, editing, or querying JSON, YAML, TOML, CSV/TSV, XML, config files, logs, or a command's JSON output. This machine does all such work in nushell; full recipes in ~/.dsh/references/nushell/.
---

# 结构化数据处理

本机的结构化数据处理统一使用 nushell：交互 shell 即 nushell，调用一律采用单命令
`nu -c '...'`。

**完整手册（按需 read）**

- `~/.dsh/references/nushell/basics.md` — 字面量与类型、变量与 `$in`/`$it`、运算符、
  字符串、路径与文件、管道与闭包、外部命令
- `~/.dsh/references/nushell/data.md` — 多格式读写、cell-path、list/record/table
  命令速查、常用配方

以下为最高频的部分，足以覆盖日常使用；其余内容查阅上述两个文件。

## 数据结构

list `[1 'two']`、record `{a: 1}`、table `[[a b]; [1 2]]`（**内部为 `list<record>`**）。
以 `<值> | describe` 确认类型；`(stream)` 为惰性值。

```nu
let t = [[a b]; [1 x] [2 y] [3 x]]
$t.a              # 列 → list          $t.0         # 行 → record
$t.a.1            # 单元格             $t | get a   # 值（list）
$t | get 0        # record             $t | select 0 # 结构（单行 table）
{a: 1} | get -o z | default 0           # 可选字段 + 默认值；也可 $t.a?
```

`get` 取值，`select`/`reject` 取结构。

## 高频操作

```nu
open f.json | reject obsolete | save -f f.json      # open 按扩展名自动解析
^nix flake metadata --json | from json | get locks   # 外部 JSON 输出
[1 2 3 4] | where $it > 2 | each {|n| $n * 10 }
{a: 1, b: 2} | transpose key value                   # record → table
[[k v]; [a 1] [b 2]] | transpose -r -d | into record # table → record
[[kind n]; [x 1] [y 2] [x 3]] | group-by kind        # → record<组名, 子表>
| items {|k, v| {kind: $k, n: ($v | length)} }       # → table
[[a b]; [1 2]] | to json -r | save -f f.json         # to json/-r 紧凑
```

## 稳定写法

- `nu -c` 中调用外部命令统一加 `^`（`^git`、`^nix`）。
- record 字段的值为表达式时加括号：`{a: $r.a, b: ($r.a * 2)}`。
- table 字面量各行保持列数一致；`where` 中直接写表达式（`where $it > 1`、
  `name =~ 'x'`）。
- 拼接使用 `++`；`sort-by` 需带列名或闭包；`group-by` 的结果用 `items`/`transpose`
  转回表。
- `to toml` 接受 record；缺失字段以 `get -o` 加 `default` 兜底。

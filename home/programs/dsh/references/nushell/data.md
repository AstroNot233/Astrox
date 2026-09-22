# nushell 数据处理

nushell 的核心在于：管道中流动的是带类型的值（list / record / table），而非文本。
字段与层级语义交由管道处理，仅在纯文本替换、切行与计数时使用文本工具。

查询命令：`help commands | where category in ["formats" "filters" "conversions"]`。

## 三种结构

- **list**：有序值序列，`[1 'two' 3]`，索引从 0 开始。
- **record**：key-value，`{name: "nu", rank: 1}`，key 可加引号 `"key x": 1`。
- **table**：**内部即 `list<record>`**，因此 list 的多数命令同样适用于 table，
  一行 table 就是一个 record。

以 `<值> | describe` 查看实际类型（如 `table<a: int> (stream)`）；
`(stream)` 为惰性值，`length`、`is-empty` 等需要确定结果的命令会驱动它。

## 打开与保存

`open` 按扩展名自动解析；`from xyz` 约定可自定义，使 `open foo.xyz` 生效。

```nu
open flake.lock | from json | get nodes.root.inputs | columns # .lock 不在自动解析的扩展名内
open -r logo.jpg | into binary | first 2       # -r 读取原始字节
open f.json | reject obsolete | save -f f.json # save -f 覆盖；--raw 原样文本
'data.csv' | open                              # 从管道提供文件名
```

| 格式 | 解析 | 输出 |
|---|---|---|
| JSON | `from json`（`-o` 读取 ndjson 流） | `to json`（`-r` 紧凑） |
| YAML | `from yaml` / `from yml` | `to yaml` / `to yml` |
| TOML | `from toml` | `to toml`（**仅接受 record**，table 报类型错误） |
| CSV / TSV | `from csv` / `from tsv`（`-s` 指定分隔符） | `to csv` / `to tsv`（`-n` 不带表头） |
| XLSX / ODS | `from xlsx` / `from ods` | — |
| XML / KDL | `from xml` / `from kdl` | `to xml` / `to kdl` |
| URL 编码 | `from url`（`a=1&b=2` → record） | `url build-query`（record → `a=1&b=2`） |
| nuon | `from nuon` | `to nuon`（将 record 展开为一行，便于查看与粘贴） |
| Markdown / HTML | `from md` | `to md` / `to html` |
| MessagePack | `from msgpack` / `from msgpackz` | `to msgpack` / `to msgpackz` |
| SSV / 无格式文本 | `from ssv` / `detect columns` | — |

`detect columns` 用于没有格式约定的空白对齐文本：`"a  b\n1  2" | detect columns`。

## 取路径（cell-path）

以 `.` 连接：record 使用 key（字符串），list/table 使用索引（整数），可嵌套。

```nu
let t = [[a b]; [1 x] [2 y] [3 x]]
$t.a            # 列 → list<int>        $t.0          # 行 → record
$t.a.1          # 单元格 → 2             $t | get 0     # 同 $t.0
$t | get a      # 值（list）             $t | select 0   # 结构（单行 table）
{a: 1} | get -o b | default 0            # 可选字段 + 默认值
{"key x": 1} | get "key x"               # 含空格或特殊字符的 key 加引号
$t.a?                                    # 不存在 → null
```

`get` 取**值**，`select` / `reject` 取**结构**（`reject` 删除列或行）。

## 命令速查

| 操作 | 命令 |
|---|---|
| 增 / 改 / 删 | `insert` `update` `upsert` / `reject` `drop` `skip` `first` `last` `take` |
| 列与行 | `columns` `values` `headers` `rename` `move` `wrap` `drop column` |
| 过滤排序 | `where` `sort-by <列> --reverse` `uniq` `uniq-by` `compact` |
| 判定 | `any` `all` `length` `in` / `not-in` `has` `is-empty` `describe` |
| 遍历映射 | `each`（返回 record 则变为 table） `par-each` `items`（record） `enumerate` |
| 聚合 | `reduce [--fold 初值]` `math sum/avg/max/min/median/stddev` `group-by` |
| 拼合 | `append` / `prepend` / `++` `merge` `merge deep` `join` `flatten` `transpose` |
| 变换 | `update cells` `split column` `split row` `format pattern` `zip` `rotate` `roll` |

```nu
# list
[1 2 3 4] | where $it > 2 | each {|n| $n * 10 }     # [30 40]
[3 8 4] | reduce {|elt, acc| $acc + $elt }          # 15
[bell book candle] | where ($it =~ 'b')
['a' 'b'] | any {|x| $x == 'b' }                    # true
[1 2 3] | wrap n                                    # → table（列名 n）
[1 2 3] | enumerate                                 # → table<index, item>

# record
{a: 1} | insert b 2 | update a { $in + 1 }
{a: {b: 1}} | merge deep {a: {c: 2}}                # 递归合并
{a: 1, b: 2} | transpose key value                  # → table
{x: 1, y: 2} | items {|k, v| {key: $k, val: $v} }   # → table<key, val>
```

## 常用配方

```nu
# 表 → 单层 record（第一列作为 key）
[[k v]; [a 1] [b 2]] | transpose -r -d | into record     # {a: 1, b: 2}

# 分组聚合，再将 record 转回表
[[kind n]; [x 1] [y 2] [x 3]]
| group-by kind                                          # record<组名, 子表>
| items {|k, v| {kind: $k, n: ($v | length), sum: ($v.n | math sum)} }

# 嵌套 record 拍平为列
[{a: {b: 1, c: 2}}] | flatten                            # → table<b, c>

# 仅取某列并去重排序
$t | get a | uniq | sort-by { $in }

# 两表按键连接（另有 --left / --right）
$t | join $other kind

# 取列中的嵌套值 / 展开子表
[{kind: x, temps: [1 2]}, {kind: y, temps: [3 4]}]
| each {|r| {kind: $r.kind, avg: ($r.temps | math avg)} }   # 逐行计算平均值
$t | flatten temps                                          # 嵌套 list → 多行

# 结构化 → 纯文本
$t | each {|r| $"($r.a): ($r.b)" } | str join (char nl)
$t | to md                                               # Markdown 表格

# 环境/配置类：record 拼装后写为 toml
{edition: 2021, next: 2024} | to toml | save -f rustfmt.toml

# 文本 / 外部命令 → 结构化
^ip -j addr | from json | get addr_info | flatten | where family == "inet" | select local prefixlen
"2024-01-02,3.5" | split row "," | {date: ($in.0 | into datetime), v: ($in.1 | into float)}
```

## 稳定写法

- `nu -c` 中调用外部命令加 `^`（`^git`、`^nix`、`^rg`）。
- record 中字段值为表达式时加括号：`{a: $r.a, b: ($r.a * 2)}`。
- table 字面量 `[[a b]; [1 2]]` 各行保持列数一致。
- `where` 条件写表达式：`where name =~ 'foo'`、`where $it > 1`；`=~` 为正则。
- 拼接与插值使用 `++` 与 `$"..."`。
- `sort-by` 带上列或闭包：`sort-by size`、`sort-by { $in }`。
- `group-by` 的结果用 `items`/`transpose` 转回表。
- `to toml` 接受 record；`to csv`/`to tsv` 收发 table。
- 双引号中的反斜杠写两次（`"\\d"`），或改用原始字符串 `r#'\d'#`。
- 缺失字段用 `get -o`/`default` 兜底；`?` 为可选路径。

参考：<https://www.nushell.sh/book/navigating_structured_data.html>、
<https://www.nushell.sh/book/types_of_data.html>、
<https://www.nushell.sh/book/working_with_tables.html>。

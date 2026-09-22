# references

按需查阅的参考资料。这些文件**不会**自动进入上下文，需要时以 read 打开；
索引中的路径均相对 `~/.dsh/references/`。

| 使用场景 | 对应文件 |
|---|---|
| nushell 单命令用法：字面量与类型、变量与 `$in`/`$it`、运算符、字符串、路径与文件、管道与闭包、外部命令 | `nushell/basics.md` |
| 使用 nushell 读写 JSON/YAML/TOML/CSV、list/record/table 操作与常用配方 | `nushell/data.md` |
| nix 语言（值、函数、builtins/lib、derivation）与 `nix` 子命令速查 | `nix/basics.md` |
| flake 结构、outputs、模块写法，以及 `/flakes` 的用途与访问 | `nix/flakes.md` |

约定：

- 一个主题一个子目录，文件名使用英文小写，必要时以连字符分隔。
- 本目录存放“可查而不必常驻上下文”的长尾知识；反复使用且需主动触发的流程
  仍应写成 `~/.dsh/skills/` 下的技能，技能正文中指向本目录即可。
- 技能目录内部亦可拥有自己的 `references/`；本目录用于存放不区分技能的通用资料。

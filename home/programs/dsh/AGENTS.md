# Global Rules

## 交流

- 默认使用简体中文；代码、命令、标识符与报错信息保留原文。
- 回复先给出结论或改动要点，细节按需展开。

## 工作方式

- 修改前先阅读相关文件与相邻实现，沿用既有风格。
- 改动保持最小：仅补充被要求的注释与文档，仅实施被要求的重构。
- commit、amend、push 在收到明确要求后执行。
- 优先复用既有工具与脚本；存在多种可行做法时，先确认采用哪一种。
- 多步任务先建立 todo 列表；相互独立的调研并行交给 subagent。

## 环境

- 本机为 NixOS，由 `/flakes/Astrox` 的 flake 管理；交互 shell 为 nushell。
- `/flakes` 存放持久化 flake。需要访问时先执行 `ls /flakes` 查看其下的条目；
  当前工作可能相关时，请求访问对应的 flake；系统相关问题优先请求访问 `/flakes/Astrox`。
- 配置修改完成后，实际执行一次构建或检查，并以命令输出作为判断依据。

## 工具

- 结构化数据（JSON/YAML/TOML/CSV）优先使用 nushell，其接口更为现代；
  确有必要时再引入其他依赖。
- 需要本机未安装的外部工具时，优先使用仓库 devshell：
  `nix develop . --command <cmd>`。
- devshell 中同样没有该工具时，先征得用户同意再使用 `nix shell`，
  并在 todo 中记录原本需要的工具。
- 同一段对话中累计请求 `nix shell` 达到 10 次时，向用户提议将该工具加入
  `/flakes/Astrox` 的 `devShells`。

## DSH 自身配置

- 提示词、技能与参考资料由本目录经 home-manager 生成到 `~/.dsh/`。
- 内容改动一律落在本目录的源文件；**严禁**编辑 `~/.dsh` 下的只读软链。

## 参考资料

- 参考资料存放在 `~/.dsh/references` 中。
  工作内容与参考资料的条目相关时，必须先阅读材料。
- 开始对话后，**立即执行** `ls -R ~/.dsh/references`，使参考资料条目进入上下文；
  接着查看`~/.dsh/references/README.md`，确认其余信息。
- 该目录按主题一目录一文件存放 nushell 等基础操作的速查资料，入口为其中的
  `README.md` 索引；具体内容按需 read，无法确定语法时查阅对应文件。

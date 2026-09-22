''
  # Global Rules

  ## 交流
  - 默认使用简体中文回复；代码、命令、标识符和报错信息保持原文。
  - 先给结论或改动要点，再按需补充细节，保持简洁。

  ## 工作方式
  - 修改前先阅读相关文件与相邻实现，遵循仓库现有的风格和约定。
  - 不要主动添加注释、文档，或进行未要求的重构。
  - 除非明确要求，不要执行 git commit、amend、push 等操作。
  - 优先复用仓库已有工具和脚本；不确定时先提问而不是猜测。

  ## 环境
  - 重要！系统为 NixOS，由 flake 管理，交互式 shell 为 nushell。
  - 修改配置后，运行对应的构建或检查命令进行验证。

  ## 工具
  - 处理 JSON/YAML/TOML/CSV 等结构化数据时，优先用 nushell（`nu -c 'open f.json | get a.b'`、`from json`/`to yaml`/`query` 等），无需 jq/yq。
  - 缺少 nushell 无法替代的工具时，用本仓库 flake 的 devshell 执行：`nix develop . --command <cmd> ...`。
  - 不要用 `nix shell nixpkgs#<pkg> -c ...` 这类一次性命令，它难以复现；需要长期使用的工具请加进 flake 的 `devShells`。
''

---
name: nixos-flake-workflow
description: Use when changing or verifying this machine's NixOS or home-manager configuration in /flakes/Astrox — os/ and home/ modules, packages, program settings, flake.nix inputs, the devshell, or running nix flake check / nix build / nixos-rebuild.
---

# NixOS flake 工作流

`/flakes/Astrox` 是本机配置的唯一真源，`flake.nix` 暴露两侧：

- `nixosConfigurations.astrox` — 系统侧，入口为 `./os`（+ `./hardware-configuration.nix`）
- `homeConfigurations.kay` — 用户侧，入口为 `./home`

`home/default.nix` 的 `stateVersion = "26.05"` 与 `os/system/default.nix` 的
`system.stateVersion` 属于安装期版本，随安装时刻固定，nixpkgs 升级时保持原值。

## 验证（修改后必须执行）

```sh
# 1. 求值 + 结构检查
XDG_CACHE_HOME=/tmp/dsh-nix-cache nix flake check --no-build

# 2. 系统侧：构建并与运行中系统比对
XDG_CACHE_HOME=/tmp/dsh-nix-cache nix build --no-link --print-out-paths \
  .#nixosConfigurations.astrox.config.system.build.toplevel
readlink -f /run/current-system

# 3. 用户侧：构建并与当前 profile 比对
XDG_CACHE_HOME=/tmp/dsh-nix-cache nix build --no-link --print-out-paths \
  .#homeConfigurations.kay.activationPackage
readlink -f /home/kay/.local/state/nix/profiles/home-manager
```

判定：**store path 与运行中的一致**表示该侧无回归；不一致表示该侧已变更，
须执行 switch 方可生效。该判据比主观判断可靠，是确认是否引入回归的主要手段。

`nix flake check` 会输出一条 `unknown flake output 'globalArgs'` 警告，
其来源是 `flake.nix` 有意暴露的调试 output，属于已知且可接受的现象。

## 沙箱限制

受限会话中 `~/.cache/nix` 不可写，直接执行 nix 会报错：

```text
error: executing SQLite statement 'pragma synchronous = off':
attempt to write a readonly database
```

因此上文各条命令均带 `XDG_CACHE_HOME=/tmp/dsh-nix-cache`（该目录须先 `mkdir -p`）。

## 工具来源

`python3` 不在系统 PATH 上，`jq`/`yq`/`rg`/`fd` 等按约定亦通过 devshell 使用：
`nix develop . --command python3 -c 'print("ok")'`。

## nushell 包装器

`home/programs/nushell/config.nu` 定义了以下命令（`sudo`/`eval` 被包装为
`nu --stdin --commands`，其引号行为与 bash 不同，须注意转义）：

| 命令 | 作用 |
|---|---|
| `rs` | 重建 system 与 home；`-s` 仅系统、`-h` 仅 home；执行前先 `git add .` |
| `fu` | `nix flake update`（默认针对本 flake） |
| `fp` | `git add .` → commit（时间戳消息）→ `push origin main` |
| `ngc` | `nix-collect-garbage -d` 后执行 `nixos-rebuild boot` |

## 结构约定

- 每个目录均含 `default.nix`，仅负责 `imports`，具体配置置于同目录下的分类文件；
  新增模块挂入对应 `default.nix`，`imports` 按字母序排列。
- `hardware-configuration.nix` 由 `nixos-generate-config` 生成；覆盖默认值应在
  `os/hardware/` 下编写模块（可参照 `os/fileSystems/default.nix` 中以 `lib.mkForce`
  覆盖挂载参数的写法）。
- `flake.nix` 的 `globalArgs = inputs // { assets; hostPlatform; }` 经
  `specialArgs`/`extraSpecialArgs` 注入所有模块，模块可直接取用 `assets`、
  `hostPlatform` 及任意 flake input（如 `llm-agents`、`home-manager`）。

## 新增依赖前的判断

向 `flake.nix` 增加 input 时须明确回答两点：

1. **是否设置 `inputs.nixpkgs.follows = "nixpkgs"`**。follow 可去除重复的 nixpkgs、
   缩小闭包；若上游拥有独立 cachix 缓存，follow 后极易出现 cache miss 并转为本地
   构建，因此须先确认上游的缓存策略：`axl` 即**有意**保持独立，配合
   `os/nix/settings.nix` 中的 `axolotl-launcher-git.cachix.org`。
2. **其包与模块如何进入系统**。优先通过上游提供的 `homeModules`/`nixosModules`
   接入。

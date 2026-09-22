# flake 与 /flakes 目录

## /flakes 的位置与权限

- `/flakes` 是 btrfs 子卷 `@flakes` 的挂载点（与 `/home`、`/sync` 同设备），
  挂载选项见 `os/fileSystems/default.nix`；内容持久保存，不受 `nixos-rebuild`
  与 `nix store gc` 影响，子卷形态便于快照与备份。
- 权限为 `root:root` 775，`kay` 属于 `root` 组（`id` 可见），正常会话可读写。
  受限会话中该目录位于工作区之外，写入需要更宽的沙箱权限。
- 用途：存放持久化的 flake，每个子目录为一个独立 git 仓库并含一个 `flake.nix`：

| 目录 | 内容 |
|---|---|
| `Astrox` | **本机系统配置的唯一真源**（NixOS + home-manager）；系统相关问题优先查阅此处 |
| `axolotl` `xmcl` | 第三方/自建应用，打包为 flake 后由 Astrox 以 input 引入 |
| `nixgear` `minieap` `phreeqc` | 独立打包仓库，`flake.nix` + `package.nix` |

- 根目录下会出现 `result` 软链，为某个 flake 中 `nix build` 留下的产物链接。
  需要打包新内容时，在 `/flakes` 下新建目录，流程见技能 `nix-packaging`。

## flake 结构

```nix
{
  description = "…";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # 上游自带模块时按需引入；input 之间可以用 follows 去重 nixpkgs
    # home-manager.url = "github:nix-community/home-manager/master";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, ... }: {
    packages.x86_64-linux.default = ...;  # nix build / nix run
    devShells.x86_64-linux.default = ...; # nix develop
    formatter.x86_64-linux = ...;         # nix fmt
    nixosModules.default = ...;           # 供别的 flake import
    homeModules.default = ...;
  };
}
```

- `flake.lock` 记录所有 input 的精确 rev，**须提交**；`nix flake update [input]`
  用于刷新（不带参数即全量更新），`nix flake lock` 仅补全锁文件。
- flake 源仅收集 **git 已跟踪**的文件：新建文件若未先 `git add`，`nix build`
  的结果中不会包含它（构建仍会成功，只是内容缺失）。`rs` 包装器每次都先执行
  `git add .`，因此该问题通常不易察觉。
- 需要多系统时使用 `nixpkgs.lib.genAttrs` 展开（`/flakes/minieap/flake.nix`
  通过 `builtins.listToAttrs` 达到相同效果）：

```nix
let
  systems = [ "x86_64-linux" "aarch64-linux" ];
  forAllSystems = f:
    nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
in
{
  packages = forAllSystems (pkgs: {
    default = pkgs.callPackage ./package.nix { };
  });
}
```

- 本机专用 flake 仅需 `x86_64-linux`，直接写
  `nixpkgs.legacyPackages.x86_64-linux`，无需展开 `forAllSystems`。

## Astrox flake 的 outputs

| output | 说明 |
|---|---|
| `nixosConfigurations.astrox` | 系统侧，模块入口 `./os`（+ `./hardware-configuration.nix`） |
| `homeConfigurations.kay` | 用户侧，模块入口 `./home` |
| `devShells.x86_64-linux.default` | 仓库 devshell（jq/yq/rg/fd/python3…），`nix develop .` |
| `globalArgs` | 调试 output：inputs 加 `assets`、`hostPlatform`；经 `specialArgs`/`extraSpecialArgs` 注入所有模块，会带一条 `unknown flake output 'globalArgs'` 警告，已知且接受 |

模块中可直接按名取用：`{ pkgs, assets, hostPlatform, llm-agents, ... }: { ... }`。

## 模块写法

home-manager 与 NixOS 模块均为 attrset 合并，骨架固定：

```nix
{ config, lib, pkgs, ... }:
let cfg = config.programs.foo; in
{
  options.programs.foo = {
    enable = lib.mkEnableOption "foo";
    package = lib.mkOption { type = lib.types.package; default = pkgs.foo; };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
```

- 多个模块写入同一选项时会合并；冲突时后定义者胜出，可用 `lib.mkDefault`
  （降低优先级）或 `lib.mkForce` 显式表态。
- 列表型选项（`home.packages`、`environment.systemPackages`）为**拼接**而非覆盖。
- `imports = [ ./a.nix ./b.nix ];` 引入子模块，路径按字母序排列。
- 本仓库约定：每个目录的 `default.nix` 仅负责 `imports`，配置置于同目录的分类文件，
  细节见技能 `nixos-flake-workflow`。

## 常用命令

```sh
export XDG_CACHE_HOME=/tmp/dsh-nix-cache                            # 受限会话必需
nix flake check --no-build                                          # 求值 + 结构自检
nix flake show .                                                    # 列出 outputs
nix flake update nixpkgs                                            # 仅更新一个 input
sudo nixos-rebuild switch --flake /flakes/Astrox#astrox
home-manager switch --flake /flakes/Astrox#kay
```

nushell 中另有包装器：`rs`（重建，`-s` 仅系统 / `-h` 仅 home）、
`fu`（flake update）、`fp`（commit + push）、`ngc`（GC 后执行
`nixos-rebuild boot`），签名见技能 `nixos-flake-workflow`。

---
name: nix-packaging
description: Use when packaging software with nix in /flakes — creating a new flake working directory under /flakes, writing flake.nix and package.nix derivations, fetching sources and computing hashes, building or testing the result, or wiring a packaged flake into Astrox as an input.
---

# 在 /flakes 下打包

## 目录位置

每个包对应一个独立 git 仓库，置于 `/flakes/<name>/`。Astrox 不直接引用其中文件，
仅将该仓库作为 flake input。受限会话中 `/flakes` 位于工作区之外，新建目录会得到
`Permission denied`，需要更宽的沙箱权限。

目录结构沿用既有仓库：

| 文件 | 作用 | 参考 |
|---|---|---|
| `flake.nix` | outputs：`packages`，按需增加 `homeModules`/`nixosModules` | `/flakes/minieap`（最小实现） |
| `package.nix` | 推导本体，由 `callPackage` 调用 | `/flakes/xmcl`、`/flakes/axolotl`（含 `home-module.nix`、`enwrap.nix`） |
| `README.md` | 用法示例 | `/flakes/nixgear` |
| `flake.lock` | 锁定 input，**须提交** | 各仓库均有 |

执行 `git init` 后先编写 `.gitignore`，至少忽略 `result` 与 `result-*`。
最小实现可参照 `/flakes/minieap`：`flake.nix` 与 `package.nix` 合计不足 40 行。

## flake.nix

职责仅有一条：将 `package.nix` 暴露为 `packages.<system>.default`。

```nix
{
  description = "…";
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.callPackage ./package.nix { };
      });
      # homeModules.default = import ./home-module.nix { inherit self; };
    };
}
```

仅在本机使用时，可直接写死 `nixpkgs.legacyPackages.x86_64-linux`，
无需铺设 `forAllSystems`。

## package.nix

```nix
{ stdenv, fetchFromGitHub, lib, ... }:
stdenv.mkDerivation (finalAttrs: {
  pname = "foo";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "someone";
    repo = "foo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-...";
  };
  installPhase = ''
    mkdir -p $out/bin
    cp foo $out/bin/
  '';
  meta = { description = "..."; license = lib.licenses.mit; mainProgram = "foo"; };
})
```

- 采用 `finalAttrs: { }` 形式，属性之间通过 `finalAttrs.<name>` 互相引用
  （旧写法为 `rec`）。
- 上游提供 release 时使用 `fetchFromGitHub`；源码位于本机时使用 `src = ./.;`
  或 `lib.cleanSource ../upstream`（整个目录会进入 store，大文件须预先清理）。
- 获取 hash 有两条途径：
  - `nix store prefetch-file --json <url>`：输出中的 `hash` 即 SRI，可直接填入；
    需要解包后的树（`fetchzip`/`fetchFromGitHub` 一类）时增加 `--unpack`。
  - 先填入 `lib.fakeHash` 并构建，再从失败信息中取得 `got: sha256-...` 并填入。
- 纯脚本工具优先使用 `pkgs.writeShellApplication { name; runtimeInputs; text; }`，
  它包含 `shellcheck` 检查并自动加上 `set -euo pipefail`。
- `installPhase` 中的产物一律写入 `$out` 之下，构建期不写入 `$out` 以外的系统路径。
- `meta.mainProgram` 决定 `nix run .` 所执行的可执行文件。

## 构建与验证

```sh
export XDG_CACHE_HOME=/tmp/dsh-nix-cache     # 受限会话必需
nix build .#default -L                       # 查看完整日志；成功后 ./result 为产物
./result/bin/foo --help                      # 实际执行一次
nix run .#default -- --version
nix build --no-link --print-out-paths .#default
nix flake check .
```

判定：`nix build` 成功仅说明推导可求值并构建完成，**并不代表程序可用**，
至少须执行一次 `--help` 或 `--version`。无参数启动即失败的包较为常见
（缺少 `runtimeInputs`、硬编码绝对路径、遗漏 wrap 等）。构建失败时先查看
`-L` 日志；已构建过的产物可用 `nix log ./result` 回溯。

网络：受限会话本身无直接网络连接（`/dev/tcp/github.com/443` 不通），
取源由 nix daemon 完成；实测 daemon 获取 `raw.githubusercontent.com` 会超时
（该域名在本机仅解析出 IPv6）。存在可用镜像 URL 时应使用镜像，
否则先确认主机侧网络或代理配置，再着手操作。

## 接入 Astrox

1. 打包仓库先行 `git init` 并提交；后续改动单独 `commit` 与 `push`
   （可由 `fp /flakes/<name>` 完成）。
2. 在 `/flakes/Astrox/flake.nix` 中增加 input：

   ```nix
   foo = {
     url = "github:AstroNot233/foo";
     inputs.nixpkgs.follows = "nixpkgs";
   };
   ```

   是否设置 `follows` 依技能 `nixos-flake-workflow` 中的两条判据决定。
3. 在 `os/` 或 `home/` 的对应模块中取用 `foo.packages.${hostPlatform}.default`
   （`foo` 与 `hostPlatform` 均由 `globalArgs` 注入），例如
   `home.packages = [ ... ];`。
4. 按 `nixos-flake-workflow` 的验证流程构建比对，再以 `rs`（或 `rs -h` / `rs -s`）
   使其生效。

仅作临时验证、暂不接入系统时，直接执行 `nix build /flakes/<name>#default` 即可。

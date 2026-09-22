# nix 语言与 CLI 速查

`experimental-features` 已启用 `nix-command`、`flakes`、`fetch-tree`，
因此统一使用 `nix <子命令> <选项> <参数>`。

`os/nix/settings.nix` 决定以下行为：`sandbox = true`、`max-jobs = auto`（本机为 16）、
`cores = 0`（自动选取）、`trusted-users = root @wheel`；substituter 除默认的
cache.nixos.org 外，还配置了 CERNET/中科大/清华镜像以及 `nix-community`、
`axolotl-launcher-git` 两个 cachix。查看生效值时每次查询一个键：
`nix config show substituters`。

受限会话中 `~/.cache/nix` 不可写，nix 命令统一添加前缀（细节见技能
`nixos-flake-workflow`）：

```sh
XDG_CACHE_HOME=/tmp/dsh-nix-cache nix <子命令>
```

## 语言

### 值

| 类型 | 写法 |
|---|---|
| 整数 / 浮点 | `1` `-2` `1.5` |
| 字符串 | `"可插值 ${x}"`；`''原样多行，可含 " 与 $''`（字面 `${` 写为 `''${`） |
| 布尔 / null | `true` `false` `null` |
| 路径 | `./foo` `/abs/path`，拼接使用 `+`：`./x + "/y"` |
| list | `[ 1 "a" ./f ]`，以**空格**分隔，不使用逗号 |
| attrset | `{ a = 1; b.c = 2; }`，每项以 `;` 结尾 |
| 函数 | `x: x + 1`、`{ a, b ? 2, ... }@args: a + b` |

在 `nix repl` 中以 `:t <expr>` 查看类型，以 `builtins.attrNames builtins`
列出全部 builtin。

### 组合方式

```nix
let
  x = 1;
in
{
  inherit x;                                        # 等价 x = x;
  y = x + 1;
  z = if x > 0 then "pos" else "neg";
}
```

- `let ... in ...` 是唯一的作用域构造；仅 `rec { }` 支持 attrset 内部互相引用。
- `with pkgs; [ hello jq ]` 将 attrset 引入作用域；模块中应少用，
  属性名拼错不会报错。
- `a // b` 为浅合并（同键取右值），深合并使用 `lib.recursiveUpdate`。
- nix 无循环结构：使用 `map`、`builtins.foldl'`、`lib.genList`、`lib.range`。

### 常用 builtins / lib

| 目标 | 使用 |
|---|---|
| 引入文件 | `import ./x.nix`（`.nix` 文件即一个值或函数） |
| 读取文件 / 转换 JSON | `builtins.readFile`、`builtins.toJSON` / `fromJSON` |
| 列表 | `map` `filter` `foldl'` `length` `elem` `concatLists` |
| attrset | `attrNames` `attrValues` `listToAttrs`，更易用的封装在 `lib.mapAttrs` |
| 条件开关 | `lib.mkIf` `lib.optional` `lib.optionals` `lib.optionalString` |
| 覆盖优先级 | `lib.mkDefault` `lib.mkForce` `lib.mkOverride` `lib.mkMerge` |
| 选项与类型 | `lib.mkOption` `lib.mkEnableOption` `lib.types.*` |
| 字符串 | `lib.concatStringsSep` `lib.escapeShellArg` `lib.removeSuffix` |

判断属性是否存在：`s ? x` 或 `builtins.hasAttr "x" s`。

### derivation

构建与打包的最终产物是 derivation。日常只需掌握以下两段：

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
  nativeBuildInputs = [ /* 构建期工具：cmake、pkg-config… */ ];
  buildInputs = [ /* 链接期依赖 */ ];
  installPhase = ''
    mkdir -p $out/bin
    cp foo $out/bin/
  '';
  meta = { description = "..."; license = lib.licenses.mit; };
})
```

- 调用方式：`pkgs.callPackage ./package.nix { }`；`pkg.override { }` 修改参数，
  `pkg.overrideAttrs (old: { })` 修改推导本身。
- 获取 hash：`nix store prefetch-file --json <url>` 直接给出 SRI；或先填入
  `lib.fakeHash`，再从构建失败信息中取得 `got: sha256-...` 并填入。
- 打包的完整流程见技能 `nix-packaging`。

## CLI

| 目标 | 命令 |
|---|---|
| 求值 | `nix eval --expr '1 + 1'`；`nix eval --raw .#globalArgs.hostPlatform` |
| 机读输出 | 任何子命令加 `--json`，nu 中直接接 `\| from json` |
| 构建 | `nix build .#<attr>`（生成 `./result`）；`--no-link --print-out-paths` 仅输出 store 路径 |
| 查看日志 | `nix build -L .#<attr>`；事后 `nix log ./result` |
| 运行程序 | `nix run nixpkgs#hello`；`nix run .#foo -- --help` |
| 临时环境 | `nix shell nixpkgs#jq`（仅修改 PATH）、`nix develop .`（本仓库 devshell） |
| 查询包 | `nix search nixpkgs <关键字>`（走网络，偏慢） |
| flake | `nix flake show .`、`nix flake metadata .`、`nix flake check`、`nix flake update [input]` |
| store | `nix path-info -S <path>`（闭包体积）、`nix why-depends a b`、`nix store gc` |
| 交互 | `nix repl` → `:lf .` 载入本 flake，再 `:b packages.x86_64-linux.foo` |
| 杂项 | `nix hash convert --to sri --hash-algo sha256 <hash>`、`nix store prefetch-file <url>`、`nix fmt` |

注意事项：

- flake 引用写法：`.`、`.#attr`、`nixpkgs#hello`、`github:NixOS/nixpkgs`。
  本地目录的 git 树为脏状态时会输出 `Git tree is dirty` 警告，不影响构建。
- 在 nu 中书写 nix 表达式：普通双引号**不**插值（`"$a"` 为字面量），因此
  `nix eval --expr "1 + 1"` 是安全的；仅需将 nu 变量带入表达式时才使用
  `$"...($v)..."`。
- `nix fmt` 要求 flake 暴露 `formatter`，本仓库未提供；`nixfmt`/`statix`/`deadnix`
  均不在 PATH 上，需要时按全局规则通过 `nix shell nixpkgs#nixfmt-rfc-style` 使用，
  并先征得用户同意。
- `nixos-rebuild`、`home-manager` 是独立命令，并非 `nix` 的子命令。

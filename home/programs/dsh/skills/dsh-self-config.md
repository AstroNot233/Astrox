---
name: dsh-self-config
description: Use when writing or editing this DSH setup's own prompts — AGENTS.md, skills/*.md and references/* under home/programs/dsh, covering prompt wording, skill frontmatter and naming, and the ~/.dsh symlinks; also when an instruction file or skill unexpectedly does not load.
---

# 维护本 DSH 配置

## 提示词措辞

模型会注意到句中**出现过**的每个词，包括被否定的词，因此被否定的选项留在
提示词中会分散注意力。据此：

- 遇到“一种可行、另一种更优”的取舍时，只介绍更优者，较劣者整段不提；
  取舍理由留在对话中说明。
- 常规规则写成“**该做什么**”：正面、具体、可判定。
- 仅“写出即会出错”的行为采用禁止式，且**每条**禁止前**各自**显式重复一次
  **严禁**，使禁令本身成为被强调的对象。例如写
  `**严禁**编辑 ~/.dsh 下的软链`，而非 `不要做以下事情：...、改软链、...`。
- 只收录会被实际触发的规则；小众、几乎不会被用到的细枝末节一律省略。

## 三类入口

| 用途 | 路径 | 格式 | 进入上下文的方式 |
|---|---|---|---|
| 全局规则 | `$DSH_HOME/AGENTS.md` | 纯 markdown，**无** frontmatter | 每次会话自动注入 |
| 技能 | `$DSH_HOME/skills/<name>/SKILL.md` 或 `$DSH_HOME/skills/<name>.md` | 需要 YAML frontmatter | 目录中仅含 name/description，正文按需加载 |
| 参考资料 | `$DSH_HOME/references/**` | 普通 markdown | **不自动**，依据 AGENTS.md 或技能的指引 read |

分工：常驻规则写入 AGENTS.md；需要主动触发的流程写成技能；
可查而不必常驻的长尾资料放入 references。三者可相互引用。

`$DSH_HOME` 解析优先级：显式配置 > 环境变量 > `~/.dsh`。本机解析为 `~/.dsh`。

DSH 采用**单一根**设计：`AGENTS.md`、`skills`、`settings.yaml`、`profiles`、
`sessions`、`storages`、`.credentials.yaml` 位于同一目录，因此 `~/.dsh` 置于
家目录顶层，未使用 `xdg.configFile`。

## 本仓库的落地方式

`home/programs/dsh/default.nix` 将 `.dsh/AGENTS.md`、`.dsh/skills`、
`.dsh/references` 链接至 `home/programs/dsh/` 下的源文件与目录，因此
`~/.dsh/` 中这三项是**只读软链**：内容改动一律修改源文件，再执行
`home-manager switch`。**严禁**直接编辑 `~/.dsh` 下这三条软链。
新增 reference 文件无需修改 nix，整目录已映射；新增**目录**
（如 `.dsh/something`）才需增加一行 `home.file`。

`~/.dsh` 下的 `settings.yaml`、`profiles/`、`sessions/`、`storages/`、
`.credentials.yaml` 属于运行时可变的用户状态，保留在 flake 之外；`~/.dsh`
保持普通目录，这些状态方可随时读写。

## frontmatter 规则

必填 `name`（kebab-case，约定与文件/目录同名）与 `description`；
可选 `whenToUse`、`metadata`、`disable-model-invocation`、`user-invocable`。

- **模型仅可见 `name` 与 `description`**：技能目录行格式为
  `` - `name`: description ``，超过 500 字符截断为 `...`。触发场景须全部写入
  `description`；`whenToUse` 仅出现在人类侧技能列表（Session API），
  不进入模型上下文。
- `description` 描述**何时使用**（触发场景），而非“这是什么”，
  例如 "Use when creating, changing, or validating ..."，并将最具辨识度的
  关键词置于开头。
- 布尔值接受 `true`/`false`/`yes`/`no`/`on`/`off`/`1`/`0`。
- `disable-model-invocation: true` 使技能不进入模型目录；
  `user-invocable: false` 使其不出现在人类命令中。

**关键陷阱**：frontmatter 非法（名字非 kebab-case、缺少 `description`、布尔值
写法错误）时，DSH 仅在其日志中输出一行 `skill file ... ignored: ...`，
模型侧表现为“技能不存在”。因此，修改 frontmatter 后须自行校验。

## 技能根与优先级

| rank | 来源 | 路径 |
|---|---|---|
| 100 | project-dsh | `<projectRoot>/.dsh/skills` |
| 200 | project-agents | `<projectRoot>/.agents/skills` |
| 300 | custom | `Config.customSkillDirs` |
| 400 | user-dsh | `<dshHome>/skills` |
| 500 | user-agents | `$DSH_AGENTS_HOME` 或 `~/.agents/skills` |
| 600 | bundled | DSH 自带技能目录 |

项目根为自 cwd 向上最近的含 `.git` 的目录。仅扫描**根目录第一层**：
`<name>/SKILL.md`（目录束）或 `<name>.md`（平铺文件）；嵌套的 `**/SKILL.md`
不在扫描范围内，因此技能条目平铺放置于 `~/.dsh/skills/` 第一层。
目录束内的子目录（`references/`、`scripts/`、`assets/`）属于技能自身的资源，
修改它们不触发目录刷新，正文中以相对路径引用并按需 read。

rank 越小优先级越高，项目级技能覆盖 `~/.dsh/skills/` 下的同名技能。

## 预算

全局 `AGENTS.md` 与项目指令链共享 `dsh-agent-instructions` 的 65536 字节
基线预算（standard preset 中配置的 `maxBytes`）。超出预算时，**先整体丢弃较宽泛
的文件**，再截断最具体的文件——`~/.dsh/AGENTS.md` 过长会整体失效，因此全局
规则保持精简，长内容移入技能或 references 按需加载。

指令文件候选名：项目每层为 `AGENTS.md`、`CLAUDE.md`，另叠加
`AGENTS.local.md`、`CLAUDE.local.md`；用户全局仅有固定的 `$DSH_HOME/AGENTS.md`。

## 修改后的验证

```sh
# 1. frontmatter 自查：name 为 kebab-case 且 description 非空（在仓库根执行）
nu -c '
[home/programs/dsh/skills/*.md home/programs/dsh/skills/*/SKILL.md]
| each {|p| glob $p } | flatten
| each {|f|
    let fm = (open --raw $f | lines | skip 1
      | take while {|l| $l != "---" } | str join (char nl) | from yaml)
    let name = ($fm.name? | default "")
    {file: (($f | path basename) | into string)
     name: $name
     kebab: ($name =~ "^[a-z0-9]+(-[a-z0-9]+)*$")
     desc_len: (($fm.description? | default "") | str length)
     ok: (($name =~ "^[a-z0-9]+(-[a-z0-9]+)*$") and (($fm.description? | default "") | is-not-empty))}
  } | to md'

# 2. 求值检查 + 构建 home 配置
XDG_CACHE_HOME=/tmp/dsh-nix-cache nix flake check --no-build
XDG_CACHE_HOME=/tmp/dsh-nix-cache nix build --no-link --print-out-paths \
  .#homeConfigurations.kay.activationPackage

# 3. 在 store 结果中确认软链（无需 switch）
ls -l <上一步的 store path>/home-files/.dsh/
ls -l <上一步的 store path>/home-files/.dsh/skills/
ls -lR <上一步的 store path>/home-files/.dsh/references/
```

第 1 步检查源文件；如需检查已安装的版本，将路径替换为
`$store/home-files/.dsh/skills`（在 `home-manager switch` 之前，
`~/.dsh/skills` 仍指向旧的 store path）。

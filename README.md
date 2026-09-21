# Moontech Codex Toolkit

个人工作流与自定义 Codex Skill 集合。首批收录产品网站建设与审查整合包 v1.3.0，后续按主题扩展。

## 开始使用

- [下载 v1.3.0 Windows 整合包](downloads/Codex-product-site-suite-v1.3.0.zip)
- [安装与使用说明](README-先读这里.md)
- [完整工作流手册](skills/product-site-suite/references/manual-v1.3.0.md)
- [本地验证结果与限制](验证结果.md)

解压后在 Codex 打开文件夹，让 Codex 阅读安装说明并执行 `Install.ps1`。需要 PowerShell 7；同名 Skill 默认保留，显式替换会先备份。

- [Volt 参谋双版本：区别、安装与调用](workflows/advisor-versions.md)
- [下载 Volt 参谋双版本 v1.0](downloads/Volt-advisors-v1.0.zip)

## Skill 目录

| Skill | 用途 |
|---|---|
| [product-site-suite](skills/product-site-suite/SKILL.md) | 产品网站总入口，路由开工、建设和审查 |
| [product-project-bootstrap](skills/product-project-bootstrap/SKILL.md) | 用户指定目录、项目模板和三个工作台 |
| [shopify-product-site-factory](skills/shopify-product-site-factory/SKILL.md) | 单品／少量产品 Shopify 建设与审查便携版 |
| [volt-deep-advisor](skills/volt-deep-advisor/SKILL.md) | 深度参谋：用于评估项目是否值得做、审视商业或功能方案、比较多个选择。检查依据、成本和风险，给出推荐及下一步。适合已经有具体问题或方案，需要深入分析和决策建议时。 |
| [volt-discussion-advisor](skills/volt-discussion-advisor/SKILL.md) | 讨论参谋：用于梳理尚未成型的想法、厘清项目目标与需求、讨论工作或业务方向。通过分轮交流理解你的考虑、探索选择，再形成建议。适合还没想清楚，或希望先充分讨论再作决定时。 |

使用示例：

> 使用 $product-site-suite。产品名称：……；项目文件夹：……；产品／参考网址：……。先整理资料与外观参考，再提供完整 Home 手机／PC 方案，逐步补全网站。

三个网站 Skill 需一起安装，包内使用相对依赖。浏览器、Shopify、Git、图片生成与任务管理工具由使用环境提供，不包含账号或付费服务。缺少持久任务工具时生成工作台启动提示，不声称已经创建任务。

## 内容组织

- `skills/`：可安装源码、模板和手册。
- `workflows/`：工作流索引，引用同一手册。
- `downloads/`：已验证的便携版本快照。
- `Install.ps1`、`checksums.json`：安装与包内容校验。

当前只收录经过整理的公开版，不包含完整机器配置、认证文件、私人对话或真实店铺资料。仓库公开不等于已选择开源许可；具体再分发授权以未来明确的许可证为准。

## 后续维护

新增自定义 Skill 时使用独立目录，保留入口说明与实际依赖；源码改动后更新对应校验值与分发包，并记录已测试及未测试范围。不要直接复制整个本机 skills 或配置目录。

两个参谋 Skill 可独立安装。根目录安装脚本仍服务于三个网站 Skill；参谋双版本的安装方式见上方专用说明。

[v1.2.1 Logo 流程修复与旧项目采用说明](workflows/logo-workflow-fix-v1.2.1.md)。品牌名称确定不再视为 Logo 设计已确认。

[v1.2.2 严格复刻素材迁移说明](workflows/media-migration-v1.2.2.md)。视频等素材迁入目标存储，不能以参考站热链作为交付。

[v1.2.3 评论复刻与内部核实说明](workflows/review-handling-v1.2.3.md)。内部核实状态不出现在网站上。

[当前 v1.3.0：执行、验收与安装修复](workflows/release-v1.3.0.md)。此前补丁链接为历史记录。

已合并 [v1.2.4 初始化修复](workflows/bootstrap-initialization-hardening-v1.2.4.md)，保留初始化与后续建站分离的边界。

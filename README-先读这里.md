# Codex 产品网站整合包 v1.2.4

这是可安装的Skill包，不是只含文档的压缩包；不包含账号、店铺凭据、付费服务或插件连接。

## 安装

1. 解压整个文件夹，用Codex打开它。
2. 对Codex说：“阅读README-先读这里.md，运行Install.ps1安装本整合包。保留现有同名Skill，先报告冲突；如果我明确要求替换，则先备份再替换。”
3. 也可在PowerShell 7执行：`pwsh -File ./Install.ps1`。脚本默认安装到当前用户 `.agents/skills`；如果同名技能已在 `.codex/skills`，整套使用该旧目录，避免拆散相对引用；若两处都有本包Skill则报告冲突。
4. 同名内容一致时跳过；内容不同时默认保留并报冲突。明确要用本包替换时执行 `pwsh -File ./Install.ps1 -ReplaceExisting`，先备份到用户 `.agents/skill-backups`。不覆盖其他Skill。
5. Codex会检测Skill变化；若没有出现，重启Codex后新开任务。可搜索 `product-site-suite`。

## 使用

“使用 $product-site-suite 初始化并搭建产品网站。产品名称：……；项目文件夹：……；产品/参考网址：……。先整理资料和外观参考，给我完整Home手机/PC方案，再逐步补全。”

仅初始化可用 `$product-project-bootstrap`；已有网站建设/审查可用 `$shopify-product-site-factory`。严格复刻明确写明该模式和参考范围。

## 包内内容

- `skills/product-site-suite`：总入口＋完整v1.2手册。
- `skills/product-project-bootstrap`：三工作台规则、项目模板、PowerShell 7初始化脚本。
- `skills/shopify-product-site-factory`：单店建设/审查便携版。它不包含旧版Moontech团队DEV或付费建站器的批量模板适配器；原版存在时安装器会报告冲突。
- `Install.ps1`：安全安装/显式替换及备份；不下载软件、不登录账号。
- `checksums.json`：包文件校验清单。
- `验证结果.md`：实际完成的本地测试及未测范围。

依赖：Windows PowerShell **7**（不是5.1）；Codex任务管理工具用于自动创建持久任务。缺少任务工具时只生成项目骨架，不用普通文件夹或临时子代理冒充持久任务，也不声称三个工作台已完成。浏览器、Shopify、Git、图片工具由运行环境提供；缺少时继续可做的本地工作并说明限制。

三个Skill需一起安装。当前包不会自动迁移既有产品项目，也不会发布网站。安装状态、项目初始化和真实站点验收分别报告。

官方目录及发现规则（核对2026-09-17）：https://developers.openai.com/codex/skills/

当前补丁包含Logo设计确认、严格复刻素材迁移、评论内部核实，以及三工作台仅初始化状态加固；手册路径沿用v1.2。历史ZIP是旧版快照，安装最新版请使用v1.2.4。

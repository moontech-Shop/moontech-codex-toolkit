---
name: product-site-suite
description: Coordinate a product website from user-supplied references through workspace setup, guided design, Shopify implementation and evidence-based review. Use for the integrated product-site workflow or a request to start or audit a product site; route workspace creation to product-project-bootstrap and implementation to shopify-product-site-factory.
---

# Product Site Suite v1.2

Read [the integrated manual](references/manual-v1.2.md) first. Treat its default market and design values as replaceable defaults; the user's current requirements and existing decisions take precedence.

## 严格复刻素材约束

严格复刻按手册第四章迁移可使用的原素材：下载并核验实际文件，上传目标商店/自有CDN，替换所有运行时引用，完成双端播放与断开参考站依赖的验证。原站或其CDN链接只作为来源证据，不作为已完成交付的媒体地址。视频封面、字幕、分片及懒加载依赖同时处理。素材缺失记HOLD并保留模块，不默认隐藏或用不同内容替代；用户批准的例外记Deviation Log。仅文件上传成功不代表复刻完成。

## Logo 状态边界

品牌名或 Logo 文字不是已确认的 Logo 设计。仅有名称时，按手册 G1 的 Logo 流程制作可查看候选、取得选择依据并完成适用位置校样，再应用正式资产。明确已有正式文件时复用，不重复设计。网站风格选定与“开始做”不能替代 Logo 选定。状态与资产版本记入 VISUAL-BASELINE；待选期间仅使用注明的内部占位或候选校样，继续无关工作，不擅自批量替换产品/包装图。

## Route by the actual request

- Workspace setup or explicit three-workbench initialization: read [product-project-bootstrap](../product-project-bootstrap/SKILL.md). Obtain the product name and exact user-supplied root; preserve existing files and tasks. Setup-only requests do not authorize a full build.
- Build/design/continue a site: read [shopify-product-site-factory](../shopify-product-site-factory/SKILL.md). If the user requested workspace setup, complete it first; otherwise use their existing project without creating extra tasks.
- Audit an existing site: use the audit route in the factory skill. Read-only review does not authorize site changes.
- Strict replication: additionally follow manual chapter four, including reference-map readiness and independent fidelity checks.

Ask only for missing dependencies that affect the current step; reuse existing answers and continue independent work. Do not treat the manual as permission to publish, purchase, send messages or create extra persistent tasks.

## Capabilities

This bundle provides instructions, templates and a PowerShell 7 initializer. It does not supply browser control, Shopify access, GitHub authentication, image generation, MiroMiro, payments or task-management tools. Discover available tools at runtime. Missing external capabilities block their dependent steps only; never fabricate a created task, screenshot, upload or test result.

All three skills must be installed together because sibling references are relative. If a sibling is absent or a conflicting older skill was retained, report the exact dependency mismatch and repair the installation before claiming the integrated workflow is ready.

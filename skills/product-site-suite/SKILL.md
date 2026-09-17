---
name: product-site-suite
description: Coordinate a product website from user-supplied references through workspace setup, guided design, Shopify implementation and evidence-based review. Use for the integrated product-site workflow or a request to start or audit a product site; route workspace creation to product-project-bootstrap and implementation to shopify-product-site-factory.
---

# Product Site Suite v1.2

Read [the integrated manual](references/manual-v1.2.md) first. Treat its default market and design values as replaceable defaults; the user's current requirements and existing decisions take precedence.

## Route by the actual request

- Workspace setup or explicit three-workbench initialization: read [product-project-bootstrap](../product-project-bootstrap/SKILL.md). Obtain the product name and exact user-supplied root; preserve existing files and tasks. Setup-only requests do not authorize a full build.
- Build/design/continue a site: read [shopify-product-site-factory](../shopify-product-site-factory/SKILL.md). If the user requested workspace setup, complete it first; otherwise use their existing project without creating extra tasks.
- Audit an existing site: use the audit route in the factory skill. Read-only review does not authorize site changes.
- Strict replication: additionally follow manual chapter four, including reference-map readiness and independent fidelity checks.

Ask only for missing dependencies that affect the current step; reuse existing answers and continue independent work. Do not treat the manual as permission to publish, purchase, send messages or create extra persistent tasks.

## Capabilities

This bundle provides instructions, templates and a PowerShell 7 initializer. It does not supply browser control, Shopify access, GitHub authentication, image generation, MiroMiro, payments or task-management tools. Discover available tools at runtime. Missing external capabilities block their dependent steps only; never fabricate a created task, screenshot, upload or test result.

All three skills must be installed together because sibling references are relative. If a sibling is absent or a conflicting older skill was retained, report the exact dependency mismatch and repair the installation before claiming the integrated workflow is ready.

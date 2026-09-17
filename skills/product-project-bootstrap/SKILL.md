---
name: product-project-bootstrap
description: "Initialize a new product website project at a user-supplied folder and create three coordinated Codex workbench tasks: the website master workbench, Home page workbench, and Product page workbench. Use when the user wants to start, set up, scaffold, or reopen this three-workbench product-project structure. Do not use for ordinary edits inside an already-initialized project unless the user asks to repair or resume its workbench setup."
---

# Product Project Bootstrap

Create one shared product-project folder and three durable Codex tasks with strict ownership boundaries.

This is the workspace entrypoint for planning, implementation, and acceptance. After initialization read the generated `00-总工作台/EXECUTION-FLOW.md`. The scaffold includes AGENTS rules, a visual baseline, a replication map, role-local change records, and acceptance evidence. Initialization alone does not build or verify a website.

For existing projects preserve all files and source locations. Report old rules/indexes that do not reference new records; merge those only when setup repair is requested, preserving existing decisions. New projects receive the self-contained `06-QA与发布/QUALITY-STANDARD.md` v1.2. Read it and `STANDARD-SOURCES.md` when applying this integration; user-specified standards and accepted exceptions are recorded in PROJECT-BRIEF. QA-CHECKLIST is the single general result log; REFERENCE-MAP holds replication-only evidence. Do not depend on another project's absolute paths or create competing copies. Updating this skill does not migrate existing projects automatically.

## Portable bundle integration

Read [the integrated manual](../product-site-suite/references/manual-v1.2.md). This bundle requires PowerShell 7 for its initializer (`pwsh`); do not run it with Windows PowerShell 5.1. Task creation requires the Codex desktop project/task tools. If unavailable, produce the scaffold and `00-总工作台/TASK-STARTERS.md` role prompts, leave registry IDs blank and report tasks not created. Do not invent IDs or start unrelated sessions as a workaround. Before creating persistent tasks, use the actual available tool schemas.

## Required inputs

Collect only missing information:

- Product name.
- Exact project folder path supplied by the user.

Treat the supplied path as the project root. Do not append the product name unless the user explicitly says the path is a parent folder. Accept an existing or not-yet-created path. Reject a drive root, the user profile root, or another obviously broad directory and ask for a dedicated product-project folder instead.

Before changing an existing non-empty folder, inspect its top level. Preserve all existing content. The initializer creates missing folders and files only; it never overwrites files.

## Initialize the folder

Run:

```powershell
& "<skill-dir>\scripts\initialize_product_project.ps1" -ProjectPath "<absolute-path>" -ProductName "<product-name>"
```

Use the actual skill directory in place of `<skill-dir>`. Read the script's JSON result and report any skipped existing files. Do not treat a scaffold as product research or as completed page work.

The scaffold establishes these ownership zones:

- `00-总工作台`: source of truth, product brief, verified facts and claims, decisions, status, task registry, cross-workbench requests, and handoffs.
- `01-产品资料`: raw inputs, verified facts, reference sites, and original assets.
- `02-品牌与共享设计`: shared brand system and assets. The master workbench owns changes here.
- `03-Home页工作台`: Home-only research, copy, design, assets, implementation notes, and QA.
- `04-Product page工作台`: Product-page-only research, copy, design, assets, implementation notes, and QA.
- `05-网站开发`: integrated site/theme files and integration notes. The master workbench coordinates shared or cross-page edits here.
- `06-QA与发布`: cross-page evidence and release records.
- `99-归档`: retired material.

## Resolve the Codex project

Call `list_projects` after the folder exists. Normalize paths case-insensitively on Windows and choose the most specific saved local project whose configured path equals or contains the supplied project folder.

- If a matching project exists, create all three tasks in that project using the `local` environment so they share the exact same files. Do not use separate worktrees unless the user explicitly requests isolation.
- If no saved project contains the supplied folder, stop before creating tasks. Tell the user the folder scaffold is ready and ask them to add or open that folder (or its intended parent repository) as a Codex project, then invoke this skill again. Do not create three unrelated projectless directories as a workaround.

## Avoid duplicate tasks

Read `00-总工作台/TASK-REGISTRY.md`, then call `list_threads`.

Use these exact titles:

1. `<产品名称> 网站总工作台`
2. `<产品名称> Home页工作台`
3. `<产品名称> Product page工作台`

Reuse an existing task only when its exact title and project context both match, or when its task ID is already recorded in the registry. Never create a duplicate merely because an earlier run partially failed.

## Create the three tasks

Creating these tasks is authorized only when the user explicitly asks to initialize/start the product project or create the workbenches. Use `create_thread` for each missing task. Do not use subagents: these are persistent user-owned tasks that must appear in the sidebar.

Every initial prompt must include the exact product name, absolute project path, role, owned directories, read-only dependencies, and these shared rules:

- Read `AGENTS.md`, `PROJECT-INDEX.md`, `WORKBENCH-RULES.md`, `00-总工作台/STATUS.md`, `00-总工作台/PROJECT-BRIEF.md`, `00-总工作台/FACTS-CLAIMS.md`, `00-总工作台/EXECUTION-FLOW.md`, and the role brief before working. Visual tasks also read `02-品牌与共享设计/VISUAL-BASELINE.md`.
- Read `06-QA与发布/QUALITY-STANDARD.md` and use `06-QA与发布/QA-CHECKLIST.md` for current results. The latest guided intake overrides long upfront forms: research and collect product references, then provide 2–3 visual style cards and at least one complete desktop/mobile Home proposal for new design exploration. Reuse selected styles; replication follows its reference instead. Missing commercial launch facts do not block independent design work.
- Track scope and affected pages/themes/devices in the role-local CHANGE-RECORD. Derive replication, visual-only, or redesign mode from the user request; do not silently change modes. Replication uses REFERENCE-MAP. Verify original requirements and affected desktop/mobile behavior before claiming completion. Include these rules in all three initial prompts.
- Never invent product facts, certifications, reviews, medical/performance claims, prices, policies, or assets. Mark unknowns as `待确认`.
- Preserve applicable existing user authorization and its exact scope in handoffs; do not demand repeat approval. Initialization alone does not authorize publication, Git push, or external messages. Preview, GitHub sync, Shopify publication, and launch readiness are separate states.
- Write only inside the role's owned zone. For a change to a shared/global file, create a request in `00-总工作台/REQUESTS` for the master workbench.
- Record meaningful decisions and handoffs in the provided project files, not only in chat.

### Website master workbench

Owns `00-总工作台`, `01-产品资料`, `02-品牌与共享设计`, `05-网站开发`, `06-QA与发布`, root coordination files, and final integration. It coordinates scope, facts/claims, shared components, navigation/footer, design-system decisions, Shopify/Git state, cross-page QA, and release gates. It does not silently take over Home or Product-page creative work.

Initial assignment: inspect the scaffold and existing files, populate only verified/user-provided project facts, list missing inputs, establish the first status snapshot, and coordinate—not fabricate—the two page workbenches.

### Home page workbench

Owns `03-Home页工作台`. It handles Home information architecture, copy, Home-specific visuals/assets, responsive design, implementation within its owned area, and Home QA. It reads shared facts and brand decisions but proposes shared/global changes through `00-总工作台/REQUESTS`.

Initial assignment: inspect available inputs, create a Home gap list and a page plan in the Home brief, and continue independent research, reference collection and design while listing only the dependent work blocked by missing facts or direction. For a full build follow QUALITY-STANDARD G0–G1; setup alone is not authorization to build the site.

### Product page workbench

Owns `04-Product page工作台`. It handles product-page hierarchy, product media requirements, offer/variant/CTA presentation, specifications, supporting proof, FAQ, responsive behavior, implementation within its owned area, and Product-page QA. It reads shared facts and brand decisions but proposes shared/global changes through `00-总工作台/REQUESTS`.

Initial assignment: inspect available inputs, create a Product-page gap list and page plan in the role brief, and flag claim, pricing, variant, inventory, shipping, or policy unknowns rather than guessing.

## Record and verify

After each successful creation, record the task title, task ID, host ID when returned, role, project path, and creation time in `00-总工作台/TASK-REGISTRY.md`. Preserve existing registry entries.

Wait once for a compact progress snapshot from the three new tasks. Verify that each task either started successfully or clearly needs user attention. Do not require completion of their page work as part of initialization.

Finish with:

- The exact project path.
- What was created versus preserved.
- Links or IDs for the three tasks, identifying any reused task.
- Any blocker, especially a folder not yet registered as a Codex project.
- The next best action: provide product source materials to the master workbench.

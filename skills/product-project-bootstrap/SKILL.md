---
name: product-project-bootstrap
description: "Initialize only a new product website project in a user-supplied folder and create or reuse three persistent Codex workbench tasks: website master, Home page, and Product page. Use when the user explicitly asks to initialize this three-workbench project structure. Initialization creates the workspace and tasks but does not start research, design, copywriting, development, uploads, Git operations, publishing, or QA. Do not use for ongoing project work, repairs, migrations, or ordinary website edits."
---

# Product Project Bootstrap

Create one shared project scaffold and three persistent Codex workbench tasks. This skill performs initialization only.

## Hard scope boundary

Initialization may:

- Create missing project directories and template files without overwriting existing content.
- Create or reuse the three workbench tasks and record their IDs.
- Confirm that each task can access the project and understands its future responsibility.

Initialization must not begin product research, reference collection, style exploration, copywriting, image creation, page planning, implementation, remote upload, Git work, publication, or QA. Each new workbench only acknowledges its role and waits for the user's next instruction.

## Required inputs

Collect only missing information:

- Product name.
- Exact absolute project folder path supplied by the user.

Treat the supplied path as the project root. Do not append the product name unless the user explicitly says the path is a parent directory. Reject a drive root, user-profile root, common personal-library root, or another obviously broad location and ask for a dedicated product-project folder.

Before writing, inspect the target's top level. Preserve every existing file and source location. Do not merge or rewrite existing project rules during initialization.

## Create the scaffold

Run:

```powershell
& "<skill-dir>\scripts\initialize_product_project.ps1" -ProjectPath "<absolute-path>" -ProductName "<product-name>"
```

Use the actual skill directory. Read the JSON result and distinguish created from preserved files. If a required directory path is occupied by a file, or a required file path is occupied by a directory, stop and report the exact collision.

The scaffold creates coordination, product-source, brand, Home, Product-page, development, QA/release, and archive zones. The generated `PROJECT-INDEX.md` and `WORKBENCH-RULES.md` are the routing sources; detailed future build standards are read only after the user assigns actual website work.

## Check task-management capability

The full workflow requires the Codex desktop task tools `list_projects`, `list_threads`, `list_archived_threads`, `read_thread`, `create_thread`, and `wait_threads`.

If those tools are unavailable, finish the filesystem scaffold only. Explain that the three persistent tasks still need to be created from Codex desktop. Do not create projectless substitute directories or use subagents.

## Resolve the saved Codex project

After the folder exists, call `list_projects`.

On Windows, normalize path case and trailing separators. A saved project is a match only when its configured path:

- equals the supplied project root; or
- is an ancestor of the supplied project root.

A saved project located inside the supplied root is not a match. When several ancestor projects match, choose the longest, most specific path. If the result is missing or ambiguous, stop before task creation and ask the user to add/open the intended folder or parent repository as a Codex project.

Use the matching project's `local` environment so all three tasks share the same exact folder. Do not use separate worktrees for this workflow.

## Reuse tasks without creating duplicates

Use these exact titles:

1. `<产品名称> 网站总工作台`
2. `<产品名称> Home页工作台`
3. `<产品名称> Product page工作台`

Resolve each role in this order:

1. Read `00-总工作台/TASK-REGISTRY.md`. For every recorded task ID, call `read_thread` and verify the title and project context. A recorded but temporarily inaccessible task is a blocker; do not silently replace it.
2. Call `list_threads` with `limit: 50` and reuse only an exact title plus exact project match.
3. Search archived tasks with `list_archived_threads`, following its cursor as needed for exact-title candidates. Do not create a duplicate of an archived match. Report it and ask the user whether to restore it.

Ignore same-title tasks belonging to other projects. Never infer a match from title alone.

For every verified reused task, upsert its current title, task ID, host ID, role, project path, verification time, and `已复用，等待用户指令` status in `00-总工作台/TASK-REGISTRY.md`. Update the matching task-ID row when it exists; do not append a duplicate row.

`list_threads` exposes at most 50 non-pinned active tasks and cannot prove that an older unregistered task does not exist. If the registry has no usable ID, no exact match is visible, and the supplied project may already have had workbench tasks before this initialization, report the limited duplicate check and ask before creating replacements. A newly created project root has no such legacy ambiguity.

## Create missing tasks

Read [references/thread-prompts.md](references/thread-prompts.md) only when at least one task must be created.

Use `create_thread` for each missing persistent task with:

- the matched project ID;
- `environment: { type: "local" }`;
- the exact title above;
- no model or reasoning override;
- the exact bootstrap-only role prompt adapted with the product name and absolute project path.

Create sequentially. Immediately after each successful creation, upsert its title, task ID, host ID, role, project path, time, and `已创建，启动状态待确认` status in `00-总工作台/TASK-REGISTRY.md`. Update the matching task-ID row when it exists; do not append a duplicate row. If recording fails, stop before creating another task and report the created task ID so a retry cannot duplicate it.

The initial prompt must explicitly forbid research, design, planning, file edits, uploads, Git operations, publication, and QA. The task should only read its minimal routing files, confirm the path and role, then wait.

## Verify initialization

Call `wait_threads` with `timeoutMs: 0` and all newly created tasks to obtain one compact startup snapshot for every target. Record each task separately as `已初始化，等待用户指令` only when its snapshot confirms readiness; otherwise retain `已创建，启动状态待确认`. A timeout or missing acknowledgement does not prove failure or readiness.

Do not wait for website work because no website work is authorized by this skill.

## Synchronize initialization state

Update `00-总工作台/STATUS.md` after task resolution, not before it:

- Mark each role as created, reused, archived-blocked, unavailable, or awaiting confirmation based on evidence.
- Set the overall state to complete only when the scaffold exists and all three persistent tasks are created or verified for the exact project.
- If project registration, task tools, duplicate ambiguity, an archived match, registry recording, or startup confirmation blocks part of the workflow, state that the scaffold is complete and task initialization is incomplete. Never leave a blocked or unavailable role marked `已初始化` or `无` blocker.

Finish with:

- Exact project path and product name.
- Created versus preserved scaffold items.
- Created, reused, archived-blocked, or unavailable status for each workbench task.
- Any project-registration or capability blocker.
- A precise statement of whether the scaffold only or the full three-task initialization is complete.
- A clear statement that no research, design, development, upload, Git, publication, or QA was started.

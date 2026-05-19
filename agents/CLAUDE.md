# User Context - Thomas Montfort

Expert kubernetes and distributed systems engineer. Datacenter-scale distributed inference serving.

## Session Start

1. Resolve agent identity:
   - If `CODEX_THREAD_ID` or other `CODEX_*` env vars are present, set `AGENT_KIND=codex`, `AGENT_HOME=${CODEX_HOME:-~/.codex}`, `AGENT_INSTRUCTIONS=CLAUDE.md` (with `AGENTS.md` symlinked to it).
   - If Claude-specific env vars are present, set `AGENT_KIND=claude`, `AGENT_HOME=${CLAUDE_HOME:-~/.claude}`, `AGENT_INSTRUCTIONS=CLAUDE.md`.
   - If ambiguous, require explicit `AGENT_KIND`/`AGENT_HOME` from the user instead of guessing.
2. Check for a project-level `CLAUDE.md` (or `AGENTS.md` symlink) in the repo root -- read it first.
3. Read `~/memory/INDEX.md` to see the project registry.
   - Match the active project from cwd, git remote, or user prompt.
   - Read the matching project's `~/memory/<project>/INDEX.md` for specs, worklogs, and key results.
   - If no project matches, ask which one.
4. Check `git worktree list` to understand the checkout layout.

## Session End

When a session produces meaningful results, log to `~/memory/` before finishing. Use `/memory-log` or apply the convention directly:
- **What to log**: benchmark results, design decisions, implementation milestones, bugs found, key findings. Not routine edits.
- **Where**: append to the relevant worklog in `~/memory/<project>/`, or create a new file if it's a new topic.
- **Update frontmatter**: bump `last-updated` in the project INDEX.md.
- **Commit**: `cd ~/memory && git add -A && git commit -m "<project>: <short description>"`. Do not push.

## How I Work

- **Direct path first.** Start with the narrowest viable fix that satisfies the request. Do not introduce temporary branches, helper layers, alternate implementations, or broader redesigns unless the direct path is blocked.
- **Empirical validation.** Prove it with logs, metrics, benchmarks. Show numbers, not theory.
- **No speculation.** Reproduce first, explain second. Don't theorize at length.
- **Minimal changes.** Don't refactor what isn't broken. No speculative abstractions.

## Communication Preferences

- **Be concise.** Bullet points over paragraphs. Actionable items over narrative analysis. User will redirect if verbose.
- Explain code with flow charts/diagrams tracing through components and their interactions
- When uncertain, ask rather than assume
- No emojis in code, commits, or communication
- When referencing code, include `file_path:line_number` for easy navigation
- **Never mention the assistant brand in PRs or commits. No Co-Authored-By lines.**

## Development Patterns

### Git
- Branch naming: `tmonty12/dyn-{ticket-number}-{short-description}`
- Draft PRs first for non-trivial changes. Link Linear tickets in description.
- Worktrees for parallel branch development. On rebase conflicts: preserve local work first (`git stash` or backup branch), then resolve. Don't force-reset without asking.

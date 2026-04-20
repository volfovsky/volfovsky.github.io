# Website Audit Workflow Template

This public template is safe to keep in GitHub. It should not contain private notes, draft answers, or old audit findings. The active working file should be `SITE_AUDIT.md`, which is ignored by git.

## How To Use This File

When Alex asks for a site audit or refresh:

1. Create or refresh a local `SITE_AUDIT.md` from this template.
2. Audit the site before editing content. Review visible pages, layouts/includes, navigation, sitemap/feed behavior, assets, build setup, and external links.
3. In `SITE_AUDIT.md`, separate findings into:
   - `Needs Direct Answers From Alex`
   - `Agent Can Handle Independently`
   - `Proposed Work Order`
   - `Page-by-Page Findings`
   - `Verification Notes`
4. Ask Alex to answer the direct-answer items directly in `SITE_AUDIT.md`.
5. After Alex answers, execute the approved changes. Do not commit until Alex has reviewed the result and said it is ready.
6. Once Alex is satisfied, run verification, commit, push, and archive the completed local audit in `site_audit_archive/YYYY-MM-DD-description.md`.
7. Leave `SITE_AUDIT.md` reset to a fresh worksheet for the next audit cycle.

## Agent Instructions

Treat `SITE_AUDIT.md` as local working notes. It may contain draft copy, personal preferences, unpublished roster details, and temporary research notes. Do not remove it from `.gitignore` and do not commit it.

Use the existing site style and keep changes scoped. Prefer small source edits, then verify with `bundle exec jekyll build`. If analytics, publication details, conference information, faculty titles, current lab rosters, policies, or other current facts are involved, verify with authoritative sources or ask Alex.

### Needs Direct Answers From Alex

Ask Alex before editing public copy or making decisions about:

- About page wording and biography emphasis.
- Homepage positioning, recruiting language, travel notes, and current announcements.
- Current title, affiliations, leadership roles, and contact routing.
- Lab group roster, new members, alumni moves, links to keep/remove, and preferred ordering.
- Teaching page course titles, semesters, and which courses should remain listed.
- CV visibility and whether `/cv/` should stay hidden-but-public.
- Blog, miscellany, or other hidden-page visibility decisions.
- Analytics IDs and social/footer links.
- Any claim that is not technically verifiable from the repo or authoritative public sources.

Suggested lab-group input format:

```text
Name:
Role/program:
Status: current member / alumnus
Website or profile URL:
Research area or one-line description:
Start year or cohort, if desired:
For alumni: first placement after graduation:
Preferred ordering or grouping:
```

### Agent Can Handle Independently

Handle these without waiting unless they change substantive public meaning:

- Build setup and local development tooling.
- Obvious typos, grammar fixes, broken Markdown, and stale template comments.
- Link hygiene, including replacing broken links with DOI, arXiv, publisher, or other canonical links.
- `http` to `https` upgrades where supported.
- Research page verification and refresh using authoritative sources.
- Sitemap/feed/indexing cleanup for placeholder or intentionally hidden pages.
- Analytics template modernization once Alex provides the current measurement ID.
- README cleanup for public, repo-level development instructions.
- Template/include fixes such as alt text handling, mixed-content links, and malformed HTML.

### Research Refresh Instructions

For `research.md`, the agent should:

- Verify titles, authors, years, venues, DOIs, arXiv links, and proceedings links.
- Search authoritative sources such as Scholars@Duke, Google Scholar, arXiv, DOI/publisher pages, PMLR, journal pages, and relevant lab/profile pages.
- Prefer durable DOI, arXiv, proceedings, or publisher URLs over temporary links.
- Add missing recent publications or working papers when confidently matched to Alexander Volfovsky.
- Keep entries readable and consistently formatted.
- Record sources used in `SITE_AUDIT.md` so Alex can review provenance.

### Execution And Review Instructions

Before edits:

- Read the repo structure and existing page style.
- Build or identify build blockers.
- Populate `SITE_AUDIT.md` with direct questions and technical tasks.

After Alex answers:

- Make the approved content changes and technical fixes.
- Run `bundle exec jekyll build`.
- Check key pages locally when possible.
- Run `git diff --check`.
- Summarize what changed and what still needs Alex's review.

Commit and push only after Alex explicitly approves. After pushing, archive the completed audit locally and leave a fresh `SITE_AUDIT.md` for next time.

## Fresh Audit Worksheet

Audit date:

Scope:

### Needs Direct Answers From Alex

- 

### Agent Can Handle Independently

- 

### Proposed Work Order

1. 

### Page-by-Page Findings

#### Homepage

- 

#### About

- 

#### Lab Group

- 

#### Research

- 

#### Teaching

- 

#### CV

- 

#### Blog, Miscellany, Sitemap, Feed

- 

#### Templates, Includes, Assets

- 

### Verification Notes

- 

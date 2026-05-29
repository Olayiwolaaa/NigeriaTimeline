# Contributing to Nigeria State Tracker

Thank you for taking the time to contribute. This project only works if the data is trustworthy and the codebase is maintainable — so this document exists to protect both. Please read it fully before opening a pull request.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Ways to Contribute](#ways-to-contribute)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Commit Conventions](#commit-conventions)
- [Data Contributions](#data-contributions)
- [Code Contributions](#code-contributions)
- [Opening Issues](#opening-issues)
- [Pull Request Process](#pull-request-process)
- [What Gets Rejected](#what-gets-rejected)

---

## Code of Conduct

This is a data integrity project. The one non-negotiable rule: **do not fabricate, manipulate, or misrepresent data**. Everything else is discussion. Be direct, be respectful, and keep arguments focused on evidence — not politics or identity.

---

## Ways to Contribute

You don't have to write code to contribute meaningfully.

| Contribution Type | Examples |
|---|---|
| **Data** | Adding exchange rate history, GDP figures, inflation data, policy events |
| **Verification** | Cross-checking existing data points against primary sources |
| **Bug fixes** | Correcting ingestion logic, fixing UI rendering issues |
| **Features** | Building out roadmap items (see `README.md`) |
| **Documentation** | Improving clarity, fixing errors, adding examples |
| **Source research** | Identifying new credible data repositories worth ingesting |

---

## Getting Started

If you haven't set up the project locally yet, follow the [installation guide in README.md](https://github.com/Olayiwolaaa/NigeriaTimeline/blob/main/README.md#getting-started). All development happens inside Docker — you should not need to install Node or PostgreSQL directly on your machine.

Once running:

```bash
# Verify everything is healthy
docker compose ps

# Open a shell in the app container
docker compose exec app sh

# Run the test suite
docker compose exec app npm run test
```

---

## Development Workflow

### Branch Structure

```
main        ← stable, production-ready. only the maintainer merges here.
└── dev     ← integration branch. all PRs target this.
    └── your-feature-branch
```

`main` reflects what is publicly live. `dev` is where all contributions land first, get reviewed, and are tested together before the maintainer promotes them to `main`. **Never open a PR directly against `main`.**

---

1. **Check existing issues** before starting work. If your idea isn't tracked yet, open an issue first so it can be discussed before you invest time in it.

2. **Fork the repository** and clone your fork locally:

   ```bash
   git clone https://github.com/Olayiwolaaa/NigeriaTimeline.git
   cd NigeriaTimeline
   ```

3. **Create a branch** off `dev` using the naming convention below:

   ```
   feature/your-feature-name
   fix/short-description
   data/source-name-indicator-name
   docs/what-you-changed
   ```

   Examples:
   ```
   feature/cytoscape-policy-graph
   fix/cbn-ingestion-pagination
   data/cbn-exchange-rate-2015-2024
   docs/update-data-source-list
   ```

4. **Make your changes.** Keep commits small and focused — one logical change per commit.

5. **Test your changes** before pushing:

   ```bash
   docker compose exec app npm run test
   docker compose exec app npm run lint
   docker compose exec app npm run typecheck
   ```

6. **Push and open a pull request** against `dev`:

   ```bash
   git push origin feature/your-feature-name
   ```

   Then open a PR at [github.com/Olayiwolaaa/NigeriaTimeline/pulls](https://github.com/Olayiwolaaa/NigeriaTimeline/pulls). Make sure the base branch is set to `dev`, not `main`.

---

## Commit Conventions

This project follows [Conventional Commits](https://www.conventionalcommits.org/).

```
<type>(<scope>): <short description>
```

| Type | When to use |
|---|---|
| `feat` | New feature or UI component |
| `fix` | Bug fix |
| `data` | Adding or correcting dataset entries |
| `refactor` | Code change that doesn't add a feature or fix a bug |
| `docs` | Documentation only |
| `test` | Adding or updating tests |
| `chore` | Build config, dependencies, tooling |

**Examples:**

```
feat(timeline): add zoomable D3 timeline component
fix(ingestion): handle missing CBN rate entries for public holidays
data(cbn): add USD/NGN exchange rates 2010–2024
docs(readme): clarify Docker migration step
```

Keep the subject line under 72 characters. No period at the end.

---

## Data Contributions

Data is the core of this project. The bar for data contributions is deliberately high.

### Rules

**1. Primary sources only.**
Data must be traceable to an official or institutionally verified source. Acceptable sources include:

- Central Bank of Nigeria (CBN) — `cbn.gov.ng`
- National Bureau of Statistics (NBS) — `nigerianstat.gov.ng`
- World Bank Open Data — `data.worldbank.org`
- IMF Data — `imf.org/en/Data`
- Nigerian Senate / NASS official publications
- Audited government budget documents

Unacceptable sources: news articles, Wikipedia, social media, unverified PDFs of unknown origin, personal blogs.

**2. Every data point needs a citation.**
When submitting data, include the source URL, publication date, and the specific table or figure number where the data appears. If the source document is behind a link that may rot, archive it at [web.archive.org](https://web.archive.org/) and include the archive URL too.

**3. Do not interpolate or estimate.**
If data is missing for a given period, leave it null. Do not fill gaps with estimates, averages, or projections — unless you are explicitly adding a `type: "estimated"` field and the estimation methodology is fully documented in the PR.

**4. Disputed data must be flagged.**
If two credible sources disagree on a figure, do not pick one silently. Flag the discrepancy using the `disputed: true` field in the schema and document both sources in your PR description.

### Data PR Template

When opening a data-related pull request, your description must include:

```
## Data Summary
- Indicator: (e.g. USD/NGN Official Exchange Rate)
- Time range covered: (e.g. January 2015 – December 2024)
- Number of records added/modified:

## Source(s)
- Source name:
- URL:
- Archive URL:
- Publication date:
- Table/figure reference:

## Notes
(Any gaps, anomalies, or decisions made during data entry)
```

---

## Code Contributions

### Style

- TypeScript strict mode is enabled. No `any` types without an explicit comment explaining why.
- Formatting is handled by Prettier. Run `npm run format` before committing.
- Linting is handled by ESLint. Fix all warnings — don't suppress them without a reason.
- Fix build issue. Run `npx tsx -b` before pushing

### Database / Schema Changes

- All schema changes go through Drizzle migrations. Never modify the database directly.
- Generate a migration after schema changes:
  ```bash
  docker compose exec app npx drizzle-kit generate
  ```
- Migration files are committed alongside the schema change in the same PR.
- Destructive migrations (dropping columns, renaming tables) require a note in the PR explaining the impact on existing data.

### Ingestion Pipelines

- Pipelines live in `pipelines/`. Each pipeline targets a single data source.
- Pipelines must be idempotent — running them twice should not create duplicate records.
- Pipelines must log what they fetched, what they skipped, and why.
- Do not hardcode credentials. Use environment variables defined in `.env.example`.

### Testing

- New ingestion pipelines require at least one integration test with a mocked HTTP response.
- New UI components require at least one render test.
- Bug fixes should include a test that would have caught the bug.

---

## Opening Issues

Use the appropriate issue template (available when you click "New Issue" on [github.com/Olayiwolaaa/NigeriaTimeline/issues](https://github.com/Olayiwolaaa/NigeriaTimeline/issues)).

For **data issues** (wrong value, missing period, bad source), include:
- The specific data point(s) affected
- What you believe the correct value is
- Your source

For **bugs**, include:
- Steps to reproduce
- Expected behaviour
- Actual behaviour
- Your environment (OS, Docker version, browser if relevant)

For **feature requests**, describe the problem you're solving, not just the solution you have in mind.

---

## Pull Request Process

1. All PRs must target `dev`, not `main`. PRs opened against `main` will be closed and redirected.
2. PRs must pass all CI checks before review: tests, lint, typecheck.
3. At least one maintainer review is required before merging into `dev`.
4. Squash and merge is the default — keep your PR focused so the squash commit is meaningful.
5. Link your PR to the relevant issue using `Closes #issue-number` in the description.
6. Draft PRs are welcome for early feedback. Mark them ready for review when they're actually ready.

---

## What Gets Rejected

To save everyone's time, here is what will not be merged:

- Data without a verifiable primary source citation
- Estimated or interpolated data submitted as factual
- PRs that mix unrelated changes (data + feature + refactor in one PR)
- `any` types without justification
- Migrations that modify the database without a Drizzle migration file
- Pipelines that are not idempotent
- Anything that introduces partisan framing into data labels, descriptions, or UI copy — this project is descriptive, not prescriptive

If you're unsure whether something qualifies, open an issue and ask before writing code.

---

*This project runs on the assumption that Nigerians deserve access to objective, verifiable information about their own country. Every contribution — however small — moves that forward.*
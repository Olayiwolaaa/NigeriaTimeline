# Nigeria Timeline

A transparent, data-driven timeline mapping Nigeria's economic and political evolution — built to replace apathy with verifiable truth.

## The Vision

Most Nigerians complain about the current state of the economy, yet few understand the historical trajectory that led us here. In an era where many are distracted by short-term noise and cheap dopamine, this project exists to provide a grounded, undeniable record of how our systems have performed.

This is not just a database. It is a tool for systemic literacy — designed to map the relationship between political decisions and economic outcomes, and make that knowledge freely accessible to anyone who wants it.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Next.js (TypeScript) |
| Database | PostgreSQL |
| ORM | Drizzle ORM |
| Data Visualization | D3.js / Cytoscape.js |
| Data Ingestion | Node.js pipelines (NBS, CBN, verified public repositories) |
| Infrastructure | Docker / Docker Compose |

---

## Getting Started

### Prerequisites

Make sure you have the following installed on your machine:

- [Docker](https://docs.docker.com/get-docker/) (v24+)
- [Docker Compose](https://docs.docker.com/compose/install/) (v2.20+)
- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/) (v20+ — only needed if running outside Docker)

---

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Olayiwolaaa/NigeriaTimeline.git
cd NigeriaTimeline
```

**2. Set up environment variables**

```bash
cp .env.example .env
```

Open `.env` and fill in the required values:

```env
# App
NODE_ENV=development
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Database
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password_here
POSTGRES_DB=nigeria_tracker
DATABASE_URL=postgresql://postgres:your_password_here@db:5432/nigeria_tracker
```

**3. Build and start the containers**

```bash
docker compose up --build
```

This starts three services:
- `app` — Next.js dev server on `http://localhost:3000`
- `db` — PostgreSQL on port `5432`

**4. Run database migrations**

In a separate terminal (while containers are running):

```bash
docker compose exec app npx drizzle-kit migrate
```

**5. Seed initial data** *(optional)*

```bash
docker compose exec app npm run seed
```

The app should now be running at `http://localhost:3000`.

---

### Useful Commands

```bash
# Start containers (detached/background mode)
docker compose up -d

# Stop containers
docker compose down

# Rebuild after dependency changes
docker compose up --build

# View logs
docker compose logs -f app

# Open a shell inside the app container
docker compose exec app sh

# Run Drizzle Studio (visual DB explorer)
docker compose exec app npx drizzle-kit studio

# Run tests
docker compose exec app npm run test
```

---

### Project Structure

```
NigeriaTimeline/
├── app/                    # Next.js app directory
│   ├── (routes)/           # Page routes
│   ├── api/                # API route handlers
│   └── components/         # Shared UI components
├── db/
│   ├── schema/             # Drizzle schema definitions
│   ├── migrations/         # Auto-generated migration files
│   └── seed.ts             # Seed scripts
├── pipelines/              # Data ingestion scripts (CBN, NBS, etc.)
├── public/                 # Static assets
├── docker-compose.yml
├── Dockerfile
├── drizzle.config.ts
└── .env.example
```

---

## Roadmap

### Phase 1 — Economic Foundation
- [ ] PostgreSQL/Drizzle schema for time-series economic data
- [ ] Automated ingestion pipeline for CBN Exchange Rate history
- [ ] Read-only timeline UI for initial data points
- [ ] Docker Compose setup for local development

### Phase 2 — Contextual Mapping
- [ ] Political and policy event tagging system
- [ ] Relationship graph between policies and economic indicators
- [ ] D3.js timeline visualizations

### Phase 3 — Community & Governance
- [ ] Tiered contributor verification system
- [ ] Public-facing network visualization (Event / Policy / Actor mapping)
- [ ] Cytoscape.js graph rendering for policy-actor relationships
- [ ] Public data submission and review workflow

---

## Contributing

Contributions are welcome — whether that's data, code, or corrections.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes and commit: `git commit -m 'feat: describe your change'`
4. Push to your fork: `git push origin feature/your-feature-name`
5. Open a pull request against `main`

Please read [`CONTRIBUTING.md`](https://github.com/Olayiwolaaa/NigeriaTimeline/blob/main/CONTRIBUTING.md) before submitting data-related changes. All data sources must be cited and verifiable.

---

## Data Sources

All economic data is sourced from official, publicly accessible repositories:

- [Central Bank of Nigeria (CBN)](https://www.cbn.gov.ng/)
- [National Bureau of Statistics (NBS)](https://nigerianstat.gov.ng/)
- [World Bank Open Data](https://data.worldbank.org/)

If you identify a discrepancy or know of an additional credible source, open an issue.

---

## License

MIT — see `LICENSE` for details.

---

*Built to combat apathy through data.*
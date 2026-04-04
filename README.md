# Plutos

A wealth tracker and visualisation tool for savings accounts and ISAs (Individual Savings Accounts). Track deposits, withdrawals, interest, and investment variance across multiple accounts, with interactive charts to visualise performance over time.

## Features

- **Multi-account support** — savings, cash ISA, investment ISA, and lifetime ISA
- **Transaction tracking** — deposits, withdrawals, interest (cash accounts), and variance (investment accounts)
- **Interactive visualisations** — performance charts, deposit/withdrawal comparisons, balance trends over time
- **Dark mode** — toggle between light and dark themes, persisted across sessions
- **Secure by default** — per-user data isolation enforced at every layer

## Tech stack

| Layer | Technology |
|-------|-----------|
| Language | Ruby 3.4.2 |
| Framework | Rails 8.1 |
| Database | PostgreSQL 16 |
| Frontend | React 19 + TypeScript (via React on Rails + Shakapacker) |
| UI components | Chakra UI v3 |
| Charts | Recharts |
| API | GraphQL (`graphql-ruby` + Apollo Client) |
| Auth | Devise 5 |
| Authorisation | Pundit |
| Materialized views | Scenic |
| Testing | Minitest, shoulda-matchers, FactoryBot, Faker, Capybara |
| CI/CD | GitHub Actions |
| Containerisation | Docker |
| Deployment | Heroku |

## Prerequisites

- Ruby 3.4.2 (managed with `rbenv` or `asdf`)
- Node 20+ and Yarn 1.22+
- PostgreSQL 16+
- Docker (optional, for containerised development)

## Local setup

```bash
# Clone the repo
git clone git@github.com:olvado/plutos.git
cd plutos

# Install Ruby dependencies
bundle install

# Install JavaScript dependencies
yarn install

# Set up the database
bin/rails db:create db:migrate

# Seed with example data
bin/rails db:seed

# Start the development server (Rails + webpack dev server)
bin/dev
```

Visit `http://localhost:3000`.

## Running with Docker

```bash
docker compose up
```

The app will be available at `http://localhost:3000`. The database is provisioned automatically on first start.

## Running tests

```bash
# All unit and integration tests
bin/rails test

# System tests (requires Chrome)
bin/rails test:system

# Full CI suite (tests + lint + security)
bin/ci
```

## Code quality

```bash
bin/rubocop          # Ruby linting
bin/brakeman -q      # Security static analysis
bin/bundler-audit    # Dependency vulnerability audit
```

## Environment variables

| Variable | Description | Required |
|----------|-------------|----------|
| `DATABASE_URL` | PostgreSQL connection string | Production |
| `RAILS_MASTER_KEY` | Decrypts `config/credentials.yml.enc` | Production |
| `SECRET_KEY_BASE` | Rails secret key (auto-derived from master key) | Production |

Copy `.env.example` to `.env` for local overrides (never commit `.env`).

## Deployment

Plutos is configured for Heroku deployment.

```bash
# Set required config vars
heroku config:set RAILS_MASTER_KEY=$(cat config/master.key)

# Deploy
git push heroku main

# Migrate
heroku run bin/rails db:migrate
```

## Development workflow

Each feature phase is developed on a dedicated branch (`phase-N/description`) and merged via pull request. PRs are reviewed from three perspectives before merging:

- **Engineering Lead** — architecture, performance, N+1 queries, indexes
- **Security Manager** — auth, authorisation, data exposure, CSP
- **UX Designer** — accessibility, responsiveness, interaction design

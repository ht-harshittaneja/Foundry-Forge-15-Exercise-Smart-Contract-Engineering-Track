# 11 — CI/CD with GitHub Actions

## Problem

Set up continuous testing and linting for a basic contract on every PR using GitHub Actions.

## Concepts

- `CI setup`
- `forge test`
- `forge fmt`
- `GitHub workflows`




Added a GitHub Actions CI workflow to the root repository to automatically build contracts, run tests, and check formatting on every push and pull request.

For revision purposes, I have also maintained a reference copy of the workflow inside the Q11 exercise folder (`.github/workflows/test.yml`).
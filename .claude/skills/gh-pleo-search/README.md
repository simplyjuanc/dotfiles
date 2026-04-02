# Searching GitHub Organization Skill

A Claude Code skill for searching code across Pleo's GitHub organization repositories using the GitHub CLI.

## What it does

This skill enables Claude to search through all repositories in the Pleo GitHub organization using the `gh search code` command. It's particularly useful for:

- Finding implementation examples across multiple repositories
- Researching patterns and best practices used in your organization
- Understanding how specific features or libraries are used
- Discovering code that matches specific criteria (language, path, content)

## Prerequisites

- [GitHub CLI (`gh`)](https://cli.github.com/) installed and authenticated
- Access to the Pleo GitHub organization (pleo-io)

## Installation

### Project-specific (recommended for team sharing)

1. Copy the `searching-github-org` folder to your project's `.claude/skills/` directory:
   ```bash
   cp -r skills/searching-github-org /path/to/your/project/.claude/skills/
   ```

### Personal (available across all projects)

1. Copy the `searching-github-org` folder to your global `.claude/skills/` directory:
   ```bash
   cp -r skills/searching-github-org ~/.claude/skills/
   ```

## How to use

Once installed, Claude will automatically use this skill when appropriate. You can also explicitly invoke it by asking questions like:

- "Search our organization for examples of error handling with Either"
- "Find all Kotlin files that use sealed interfaces in the domain layer"
- "Show me how other repos implement metrics collection"
- "Search for usage of the XYZ library across our repositories"

## Example usage scenarios

### Finding implementation patterns
```
User: "How do our services implement authentication middleware?"
Claude: [Uses the skill to search across repos for auth middleware patterns]
```

### Researching library usage
```
User: "Find examples of how we use Arrow Either for error handling"
Claude: [Searches for Either usage patterns across the organization]
```

### Understanding architecture
```
User: "Show me how domain models are structured in our Kotlin services"
Claude: [Searches for domain model patterns in Kotlin repositories]
```

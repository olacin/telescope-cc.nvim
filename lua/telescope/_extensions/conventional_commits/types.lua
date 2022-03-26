local types = {
    {
        value = "test",
        description = "Adding missing tests or correcting existing tests",
    },
    {
        value = "style",
        description = "Changes that do not affect the meaning of the code",
    },
    {
        value = "revert",
        description = "Reverts a previous commit",
    },
    {
        value = "refactor",
        description = "A code change that neither fixes a bug nor adds a feature",
    },
    {
        value = "perf",
        description = "A code change that improves performance",
    },
    {
        value = "fix",
        description = "A bug fix",
    },
    {
        value = "feat",
        description = "A new feature",
    },
    {
        value = "docs",
        description = "Documentation only changes",
    },
    {
        value = "ci",
        description = "Changes to our CI configuration files and scripts",
    },
    {
        value = "chore",
        description = "Other changes that don't modify src or test files",
    },
    {
        value = "build",
        description = "Changes that affect the build system or external dependencies",
    },
}

return types

```markdown
# agent-skills Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill teaches you the core development patterns and conventions used in the `agent-skills` TypeScript repository. You'll learn how to structure files, write imports/exports, and follow the project's coding style. The guide also covers how to write and run tests, and suggests commands for common development workflows.

## Coding Conventions

### File Naming
- Use **camelCase** for file names.
  - Example: `agentSkill.ts`, `userProfileManager.ts`

### Import Style
- Use **relative imports** for referencing other files.
  - Example:
    ```typescript
    import { getAgent } from './agentUtils';
    ```

### Export Style
- Use **named exports** for functions, classes, or constants.
  - Example:
    ```typescript
    export function getAgent(id: string) { ... }
    export const AGENT_TYPE = 'basic';
    ```

### Commit Patterns
- Commit messages are **freeform**, sometimes with prefixes, and average around 54 characters.
  - Example: `Add agentSkillManager and refactor imports`

## Workflows

### Add a New Agent Skill
**Trigger:** When you need to introduce a new agent skill module  
**Command:** `/add-skill`

1. Create a new TypeScript file in camelCase, e.g., `myNewSkill.ts`.
2. Implement the skill logic using named exports.
    ```typescript
    export function myNewSkill(params: SkillParams) { ... }
    ```
3. Use relative imports for dependencies within the project.
4. Write a corresponding test file named `myNewSkill.test.ts`.
5. Commit your changes with a descriptive message.

### Refactor Existing Skill
**Trigger:** When improving or restructuring an existing skill  
**Command:** `/refactor-skill`

1. Update the relevant TypeScript file, maintaining camelCase naming.
2. Refactor code to use named exports and relative imports as needed.
3. Update or add tests in the corresponding `*.test.ts` file.
4. Commit changes with a clear, descriptive message.

### Run Tests
**Trigger:** To verify code correctness after changes  
**Command:** `/run-tests`

1. Identify test files matching the `*.test.*` pattern.
2. Use your preferred test runner (framework is not specified; check project docs or package.json).
3. Run all tests and review results.
4. Fix any failing tests before committing.

## Testing Patterns

- Test files follow the pattern: `*.test.*` (e.g., `agentSkill.test.ts`).
- The specific testing framework is **unknown**; check for clues in the project or ask a maintainer.
- Write tests alongside the code they cover, using the same naming conventions.

  Example test file:
  ```typescript
  import { myNewSkill } from './myNewSkill';

  test('myNewSkill returns expected result', () => {
    expect(myNewSkill({ input: 'test' })).toBe('expectedOutput');
  });
  ```

## Commands
| Command         | Purpose                                            |
|-----------------|----------------------------------------------------|
| /add-skill      | Scaffold and implement a new agent skill module    |
| /refactor-skill | Refactor or improve an existing skill              |
| /run-tests      | Run all project tests                              |
```

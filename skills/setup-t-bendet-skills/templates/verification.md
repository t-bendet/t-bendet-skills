# Verification

Use this guide to select checks before handing off work. <The file that defines local commands>
defines the commands; <the CI workflow file> defines the CI gates.

## Local checks

Run the checks the change affects. The ordinary sequence is:

```bash
<build command>
<lint command>
<type-check command>
<test command>
<format check command>
```

| Change             | Additional guidance                               |
| ------------------ | ------------------------------------------------- |
| <kind of change>   | <the guide to read, and any extra command to run> |
| Documentation only | <the documentation checks>                        |

<What each test command needs to run: a database, Docker, a seeded server.>

## CI coverage

<The required CI jobs by name, which of them the local sequence covers, and which have no local
equivalent.> Report local checks separately from observed CI results; an unrun gate is reported as
unrun.

## After a merge

<One check that a merged change is live, such as a health URL at the deployed hostname. Delete this
section when merging does not deploy.>

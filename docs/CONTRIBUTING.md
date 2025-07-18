### Kanban board

[Link to the Kanban board](https://github.com/orgs/TheTopSecretTeam/projects/1/views/8)

### Git workflow

We have adopted the GitHub flow for our context.

Main steps:

1. In the beginning of the sprint, Scrum master create issues according to [templates](https://github.com/TheTopSecretTeam/TheCOOrP/tree/dev/.github/ISSUE_TEMPLATE). It can be one of three types: feature, bug, and task.

2. Scrum master assign issue to the correct team member, choose the type, priority, story points (after the Planning Poker), and milestone, and write acceptance criteria for each feature and task or bug report.

3. For each feature we create branch from the dev, name it as the feature itself, 

4. When the work was done, we create commit to the dev branch (our Trunk-based). All commits must have name and description with changes.

5. After that we create a pull request according to [template](https://github.com/TheTopSecretTeam/TheCOOrP/tree/dev/.github/PULL_REQUEST_TEMPLATE), add connected issues in Development section, and send requests for review.

6. Only privileged team members (LocalT0aster and nonamecorn) can review. All team members can write comments for them or the author of this request.

7. When CI was passed and reviewer approves,the pull request is merged and the branch is deleted.

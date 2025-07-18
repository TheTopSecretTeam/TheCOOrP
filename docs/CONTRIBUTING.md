### Kanban board

[Link to the Kanban board](https://github.com/orgs/TheTopSecretTeam/projects/1/views/8)

### Git workflow

We have adopted the GitHub flow for our context.

Main steps:

1. In the beginning of the sprint, Scrum master create issues according to [templates](https://github.com/TheTopSecretTeam/TheCOOrP/tree/dev/.github/ISSUE_TEMPLATE). It can be one of three types: feature, bug, and task.

2. Scrum master assign issue to the correct team member, choose the type, priority, story points (after the Planning Poker), and milestone, and write acceptance criteria for each feature and task or bug report.

3. For each feature we fetch amd pull the origin/dev (our Trunk-based). After, we work in local dev or create new branch from the origin/dev. If there are push commits, they have to be discard.

4. When the work was done, we create commit to the branch that was used for work (develop or feature branch). All commits must have name and description with changes.

5. After that we create a pull request according to [template](https://github.com/TheTopSecretTeam/TheCOOrP/tree/dev/.github/PULL_REQUEST_TEMPLATE), add connected issues in Development section, and send requests for review.

6. Only privileged team members (LocalT0aster and nonamecorn) can review. All team members can write comments for them or the author of this request.

7. When CI was passed and reviewer approves,the pull request is merged and the branch is deleted.

8. Also, we do rebase to add changes firstly in dev and then in main branches.

9. DevOps integrate it in itch.io at the final stage of our workflow.

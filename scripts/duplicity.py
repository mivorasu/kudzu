#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.pygithub

import os
from concurrent.futures import ThreadPoolExecutor

from github import Github

TOKEN = os.getenv("GITHUB_TOKEN")
if not TOKEN:
    raise RuntimeError()
GH = Github(TOKEN)
USER = GH.get_user()
LOGIN = USER.login
EXECUTOR = ThreadPoolExecutor(max_workers=18)


def process_comments(getter):
    for c in getter():
        if c.user.id != LOGIN.id:
            continue
        c.delete()


def delete_pr_comments(num):
    pr = GH.get_repo("NixOS/nixpkgs").get_pull(number=num)
    process_comments(pr.get_review_comments)
    process_comments(pr.get_comments)
    process_comments(pr.get_issue_comments)
    users, teams = pr.get_review_requests()
    reviewers = [user.login for user in users]
    team_reviewers = [team.slug for team in teams]
    _, _ = GH.requester.requestJsonAndCheck(
        "DELETE",
        f"{pr.url}/requested_reviewers",
        input={"reviewers": reviewers, "team_reviewers": team_reviewers},
    )
    pr.delete_labels()


def main():
    for i in range(7, 9):
        for issue in GH.search_issues(f"commenter:{LOGIN.name}", type="pr").get_page(i):
            print(issue.number)
            EXECUTOR.submit(delete_pr_comments, issue.number)


if __name__ == "__main__":
    main()

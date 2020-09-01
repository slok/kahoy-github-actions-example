# Kahoy github actions example

This repository is an example of how you would use Kahoy to maintain in sync a Kubernetes raw manifest repository with the cluster using Gitops and Github actions.

**The Kahoy executions that require a cluster have been _NOOP-ed_ because we don't have a running cluster (for now).**

## Files

- `./manifests`: Directory where our resources are stored and the ones that will be in sync.
- `./.github`: What triggers [Kahoy] and has the magic for our gitops based system.
- `./kahoy.yml`: Kahoy configuration for group deployment priorities.
- `./scripts`: Helper CI deployment scripts.

## Syncs

### Partial

Partial sync process handles deploys and deletions only with the changes from one state to the other (e.g. git rev A and git rev B). This is used on regular Git flow (PR, commit push, merge..).

When the PR is created, commits are pushed or branches merged, it will sync only the resources that have been changed, this involves deploying manifest that changed/created and deleting the ones deleted (Garbage collect).

### Full

A Full sync means applying all the changes that are on the repository.

This mode doesn't delete resources, it ensures that the ones that should exist are on the correct state if something outside our CI have delete or modified them.

A full sync will happen on scheduled intervals just to ensure everything that exists is in the last state.

Full syncs are optional, partial sync should be enough, however this is a way of adding reliability.

## Kahoy execution

When a person creates a pull request, the CI will trigger a `dry-run` execution with the manifests that will be applied and deleted.

Then it will execute a `diff` against the server to see what will be the real changes against the cluster.

Finally when the PR is merged, it will execute the real deployment against the server.

This gives visibility to the user of what will be the changes, `dry-run` to know what resources will be involved, and `diff` for a real view of what fields will be changed on the cluster, with the current server state.

Every hour we have a sheduled pipeline that will sync all the resources that exist on the repository to the latest known state.

## K8s auth

We have commented the K8s credentials retrieval script execution because we don't have a Kubernets cluster running, but is there as an example.

## Examples and use cases

### Deploy a bunch of resources

In this PR we are deploying some resources of different types:

- [PR](https://github.com/slok/kahoy-github-actions-example/pull/3)
- [Dry-run execution](https://github.com/slok/kahoy-github-actions-example/runs/1047206120)

When we where doing this, Kahoy detected a collision on 2 resources having the same ID, Check the [Dry-run execution](https://github.com/slok/kahoy-github-actions-example/runs/1047199817) of the collision.

As we see, the changes on those manifests have been detected and Kahoy planned the `apply` of those resources only (based on PRs resource diff changes).

### Remove resources and add others

In this PR we have rmeoved `app2` resource and add a new `grafana2` service. Kahoy detected both changes:

- [PR](https://github.com/slok/kahoy-github-actions-example/pull/4)
- [Dry-run execution](https://github.com/slok/kahoy-github-actions-example/runs/1047212334)

### Move, rename and split files

Kahoy acts at resource level, changes on manifest should not affect on deletions and creations. As we see in this PR, we didn't lost any of the resources, and if we had a diff we would see no changes against the server.

- [PR](https://github.com/slok/kahoy-github-actions-example/pull/5)
- [Dry-run execution](https://github.com/slok/kahoy-github-actions-example/pull/5/checks?check_run_id=1047219624)

### Deploy in priority batches

In `kahoy.yml` we have set that the `ns` group, should be deployed before any other, in this PR we see that Kahoy splitted in 2 different `apply`:

- [PR](https://github.com/slok/kahoy-github-actions-example/pull/2)
- [Dry-run execution](https://github.com/slok/kahoy-github-actions-example/pull/2/checks?check_run_id=1047194657)

### Scheduled full sync

Our scheduled pipeline, runs full syncs every hour. It tries to reconcile all the known resources to the latest state

- [Dry-run execution](https://github.com/slok/kahoy-github-actions-example/runs/1047318029?check_suite_focus=true)

[kahoy]: https://github.com/slok/kahoy

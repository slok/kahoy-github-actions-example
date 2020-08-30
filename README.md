# Kahoy github actions example

This repository is an example of how you would use Kahoy to maintain in sync a Kubernetes raw manifest repository with the cluster using Gitops with Github actions.

## Files

- `./manifests`: Directory where our resources are stored and the ones that will be in sync.
- `./.github/workflows/ci.yaml`: What triggers [Kahoy] and has the magic for our gitops based system.
- `kahoy.yml`: Kahoy configuration for group deployment priorities.

[kahoy]: https://github.com/slok/kahoy

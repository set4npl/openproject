# SET4NPL OpenProject fork

This repository is SET4NPL's GPLv3 fork of OpenProject. The production branch
`set4npl-17.9` starts at the upstream `v17.9.6` tag. The earlier production
release, `17.7.2-set4npl.2`, is retained on `set4npl-17.7` for recovery with a
matching pre-upgrade database and attachment backup.

This fork is independently maintained by SET4NPL. It is not OpenProject
Enterprise Edition and does not include an OpenProject support subscription.

## Enabled features

The fork enables the following code already present in the upstream GPLv3
repository:

- Model Context Protocol (MCP) server
- Custom theme, logo, favicon and PDF styling
- Gantt PDF export
- Baseline comparison
- Sharing individual work packages with users outside the project
- Automatic work-package subject generation
- Exact time-entry restrictions
- External-link warnings
- Placeholder users

The implementation is centralized in
`lib/open_project/set4npl/features.rb`. Existing signed Enterprise tokens still
work normally and can grant additional features; the SET4NPL set is merged with
their entitlements. Features outside the list above remain unchanged.

## Runtime configuration

No setting is required for normal SET4NPL deployments. When
`OPENPROJECT_SET4NPL_FEATURES` is absent or set to `all`, all features listed
above are enabled.

The variable can restrict a deployment to a comma-separated subset:

```text
OPENPROJECT_SET4NPL_FEATURES=mcp_server,define_custom_style
```

Use `none`, `false`, or `0` to disable the entire SET4NPL set. Unknown feature
names stop application startup or request processing with an explicit error
instead of silently changing entitlements.

## MCP security model

Entitlement does not automatically expose data. An administrator must enable
the MCP server and its individual tools/resources under Administration. MCP
clients must authenticate with a personal API token or OAuth token carrying the
`mcp` scope, and normal OpenProject visibility rules still apply. The MCP tools
shipped in OpenProject 17.9.6 include work-package, comment, relation and
time-entry writes. Review the enabled tools during deployment; new tool
configurations are enabled by the upstream seeder by default.

Relation columns and date alerts are now Community features. They do not need
SET4NPL entitlements. Multiple target versions remain a separate, irreversible
administrator opt-in and are not enabled by this fork.

The MCP endpoint returns HTTP 202 with an empty body when the MCP library
accepts a notification without producing a response. This permits strict
Streamable HTTP clients, including Codex, to complete initialization.

## Build an image

Build a production image from the repository root:

```bash
docker build -f docker/prod/Dockerfile --target slim \
  -t ghcr.io/set4npl/openproject:17.9.6-set4npl.1 .
```

For an all-in-one image matching OpenProject's bundled deployment shape, use
`--target all-in-one` instead. The manual **SET4NPL / Build container** GitHub
Actions workflow can build and publish either target to GitHub Container
Registry without additional registry credentials.

Before replacing an existing container, back up PostgreSQL and the persistent
attachments volume. Do not mix this branch with a newer OpenProject database
schema without completing the corresponding upstream upgrade first.

## Validation and upgrades

The upstream test suite runs with `OPENPROJECT_SET4NPL_FEATURES=none` by default
so Community-mode expectations remain valid. Fork-specific examples explicitly
enable the feature set and test backend authorization, frontend feature
discovery and non-trial classification.

For each upstream upgrade:

1. Create a new SET4NPL branch from the exact upstream release tag.
2. Port the small feature module and `EnterpriseToken` integration.
3. Review every selected feature's current upstream call sites.
4. Run the targeted specs and the complete upstream test suite.
5. Build a versioned image; never overwrite an existing production image tag.

OpenProject's existing copyright notices and GPLv3 license remain applicable.
SET4NPL modifications are distributed under the same license.

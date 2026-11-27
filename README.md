# Module: authentication through Keycloak

A ReasonR module (RFC §23.3): it is embedded into a project.

| Part | What it gives |
|---|---|
| `src/contexts/Auth` | Bounded context `Auth`: actor `User` — a Keycloak user (the id is the token's `sub`), their name, query `Me`, screen `MyAccount` |
| `src/apps/Account` | The account app `app(User) Account` |

Adding it to a project — the model's `reasonr.yaml`:

```yaml
requires:
  github.com/tycheg/reasonr-auth: v0.1.0
```

`reasonr mod download` downloads the module into the module cache and writes `reasonr.lock`; in a local checkout the module can be substituted with a directory (`replace`).

A Keycloak user becomes an actor of the project through an ACL of a project bounded context (RFC §23.2): `actor Auth.User as Customer` — the caller `Auth.User` acts as a customer with the same identifier (example: `examples/taxi/src/contexts/Ordering/auth.acl.rr` of the compiler repository). The project keeps its own user data in its own actor, not in the module's model.

The module has no Go code: the engine's built-in `jwt` authentication checks Keycloak tokens. The settings in `engine.yaml`:

```yaml
auth:
  - type: jwt
    issuer: https://sso.example.com/realms/taxi                              # the realm is the token issuer
    jwks: https://sso.example.com/realms/taxi/protocol/openid-connect/certs  # the realm's keys
    audience: taxi-web                                                       # the client (aud); not checked when omitted
    actor: { claim: sub, type: Auth.User }
    roles: { claim: realm_access.roles }
```

The caller is actor `Auth.User` with the id from `sub`; the roles are `realm_access.roles` (a model role if the model has exactly one role with that name).

## Layout

| Directory | What is in it |
|---|---|
| `src/contexts/Auth` | Bounded context `Auth`: actor `User`, query `Me`, screen `MyAccount` |
| `src/apps/Account` | The account app |
| `reasonr.yaml` | The module: `github.com/tycheg/reasonr-auth` |

## Development

```sh
make tools   # reasonr and reasonrd of the released framework into $(go env GOPATH)/bin
make check   # formatting, reasonr check, the module's acceptance tests on reasonrd
```

A release is a tag `vX.Y.Z`: `reasonr mod download` clones the module at it.

# standard-portlet

A Liferay DXP 7.3.10 Update 35 WAR portlet investigating Portlet 3.0 (JSR-362) behaviour — specifically whether the `renderHeaders` lifecycle phase is invoked and how `HeaderResponse` output is handled.

## Requirements

- Java 8+
- Liferay DXP 7.3.10u35 bundle

## Build

```bash
./mvnw clean package
```

The WAR is produced at `target/standard-portlet-7.3.10.u35-SNAPSHOT.war`.

## Deploy

Copy the WAR to your Liferay deploy folder:

```bash
cp target/standard-portlet-7.3.10.u35-SNAPSHOT.war ../../bundles/deploy/
```

The default `liferay.home` in `pom.xml` points to `../../bundles`. Adjust it if your bundle is elsewhere.

## What it does

The portlet appears under **Testing** in the Liferay widget menu.

When added to a page it:

1. Calls `renderHeaders()` (Portlet 3.0 header phase) — writes a `<meta>` tag to the response and logs to stdout
2. Calls `render()` — writes `<h1>Hello World!</h1>`

### Verifying `renderHeaders` support

After deployment check:

- **Tomcat log** (`logs/catalina.out`) for:
  ```
  StandardPortlet.renderHeaders() called — Portlet 3.0 header phase is supported
  ```
- **Page source** `<head>` section for:
  ```html
  <meta content="portlet=standard-portlet" />
  ```

If the log line appears but the meta tag is absent from `<head>`, Liferay is calling the method but discarding raw writer output from `HeaderResponse` — use `addDependency` for `<script>`/`<link>` resources instead.

## Dependencies

A single provided-scope dependency covers all DXP APIs:

```xml
<dependency>
    <groupId>com.liferay.portal</groupId>
    <artifactId>release.dxp.api</artifactId>
    <version>7.3.10.u35</version>
    <scope>provided</scope>
</dependency>
```

Resolved from the [Liferay public repository](https://repository.liferay.com/nexus/content/repositories/liferay-public-releases/).

## Contributing

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>
```

Common types: `feat`, `fix`, `chore`, `docs`, `refactor`

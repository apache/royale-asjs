<!--

Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to You under the Apache License, Version 2.0
(the "License"); you may not use this file except in compliance with
the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

-->

# Consuming Royale Code Graphs

## What Code Graphs Provide

A code graph describes the public declarations and type relationships that the
Royale compiler resolves for a specific framework version and target. It
contains stable IDs, callable signatures, inheritance, metadata, ASDoc, source
provenance, and explicit references to symbols in other libraries. The aggregate
also maps Maven dependencies and MXML namespace tags.

Editors can use this data for completion and navigation, documentation tools can
render APIs without recompiling source, compatibility tools can compare stable
symbols between releases, and AI-assisted tools can answer API questions from
compiler facts instead of source-text guesses. Separate JavaScript and SWF
graphs prevent tools from recommending APIs unavailable on the active target.

Code graphs describe public declarations, not runtime control flow. They do not
contain method bodies or application call graphs.

Code graphs are build-time metadata. Do not embed them in framework SWCs, copy
the full aggregate into each application repository, or deploy them with an
application.

## Locating the Graphs

Use the graph bundle that matches the application's Royale framework version.
Consumers should search in this order:

1. An explicitly configured codegraph directory.
2. The active package-manager dependency or cache.
3. The active Royale SDK at `$ROYALE_HOME/frameworks/codegraphs`.
4. A shared local cache keyed by framework version and graph schema version.

Release artifacts expose the same aggregate through these locations:

| Installation | Location |
| --- | --- |
| Binary SDK | `$ROYALE_HOME/frameworks/codegraphs` |
| npm SDK | `<package>/royale-asjs/frameworks/codegraphs` |
| Maven | `org.apache.royale.framework:distribution:zip:codegraphs:<version>` |

Maven-based tools should resolve and unpack the classifier into their own cache.
They should not add its contents to application resources or distribution
assemblies.

## Reading an Aggregate

1. Read `index.json` and reject unsupported schema major versions.
2. Select `js` or `swf` to match the compiler target.
3. Select modules from the application's direct and transitive framework
   dependencies.
4. Load only the selected module shards.
5. Verify each shard against the SHA-256 value in `index.json`.
6. Read `mxml.json` when namespace and tag completion is required.

A module may not contain every target. Consumers must inspect `module.targets`
instead of assuming both `js` and `swf` exist. Symbol and member IDs are stable
semantic identities and should be used as keys. File paths are provenance, not
identity.

External references may point to symbols in another loaded module or library.
Resolve them by stable ID first. Preserve explicit unresolved references and
surface them to users instead of guessing a type from its simple name.

## Application and Third-Party Graphs

Applications do not need a graph merely to compile or run. Generate an
application or third-party library graph only when a tool needs to understand
that project's public API.

### Maven

Maven projects can invoke the compiler plugin explicitly:

```xml
<plugin>
  <groupId>org.apache.royale.compiler</groupId>
  <artifactId>royale-maven-plugin</artifactId>
  <executions>
    <execution>
      <id>codegraph</id>
      <phase>prepare-package</phase>
      <goals>
        <goal>compile-codegraph</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

The output is written under `target/codegraph`. Keep this project-owned graph
separate from dependency bundles. A consumer can compose them in memory through
stable references; no physical merged copy is required.

### Ant

Ant applications and libraries can invoke the same compiler client with a
`<java>` task. Reuse the compiler configuration that builds the project so the
source paths, libraries, namespaces, and includes match the compiled artifact.

```xml
<property environment="env"/>
<property name="ROYALE_HOME" value="${env.ROYALE_HOME}"/>
<property name="ROYALE_COMPILER_HOME" value="${env.ROYALE_COMPILER_HOME}"/>

<target name="codegraph-js">
    <mkdir dir="${basedir}/target/codegraph/js"/>
    <java jar="${ROYALE_COMPILER_HOME}/lib/codegraph.jar"
          fork="true" failonerror="true">
        <jvmarg value="-Xmx512m"/>
        <jvmarg value="-Droyalecompiler=${ROYALE_COMPILER_HOME}"/>
        <jvmarg value="-Droyalelib=${ROYALE_HOME}/frameworks"/>
        <arg value="-load-config=${basedir}/src/main/config/compile-js-config.xml"/>
        <arg value="-compiler.define+=COMPILE::JS,true"/>
        <arg value="-compiler.define+=COMPILE::SWF,false"/>
        <arg value="-keep-asdoc=true"/>
        <arg value="-output=${basedir}/target/codegraph/js/MyApplication.json"/>
        <arg value="${basedir}/src/main/royale/MyApplication.mxml"/>
    </java>
</target>
```

For a SWF target, load the SWF config, set `COMPILE::JS` to `false` and
`COMPILE::SWF` to `true`, and write to `target/codegraph/swf`. A project that
uses a positional main source file may add it as the final `<arg>`; library
projects commonly rely on `include-sources` and `include-classes` from their
existing config.

Generating an application graph does not copy framework graphs into the
application. Tools should resolve the matching framework aggregate separately
and compose the graphs by stable symbol ID.

### Command Line

The installed compiler provides `bin/codegraph` (`bin/codegraph.bat` on
Windows). In an SDK, it is normally available at
`$ROYALE_HOME/js/bin/codegraph`.

```bash
$ROYALE_COMPILER_HOME/bin/codegraph \
  -load-config=/path/to/compile-js-config.xml \
  -compiler.define+=COMPILE::JS,true \
  -compiler.define+=COMPILE::SWF,false \
  -keep-asdoc=true \
  -output=target/codegraph/js/MyApplication.json \
  src/main/royale/MyApplication.mxml
```

The final positional file is optional. When present, its base name becomes the
module name and it is included as a graph root. Without it, configure roots with
`-include-sources` or `-include-classes`; the output file's base name becomes the
module name.

Common arguments:

| Argument | Meaning |
| --- | --- |
| `-load-config=<file>` | Load a compiler config; use `-load-config+=<file>` to append one. |
| `-output=<file>` | JSON output path. |
| `-compiler.define+=NAME,VALUE` | Supply conditional compilation values, including `COMPILE::JS` and `COMPILE::SWF`. |
| `-include-sources+=<path>` | Include a source file or directory as a graph root. |
| `-include-classes+=<name>` | Include a qualified class as a graph root. |
| `-keep-asdoc=true` | Include parsed ASDoc. |
| `-create-target-with-errors=true` | Permit output despite compiler errors; avoid this for trusted release metadata. |

All normal compiler path, namespace, define, and external-library options are
accepted. Use the same values as the corresponding application or library
compile so the graph represents the artifact users actually run.

Third-party library publishers should eventually attach a version-matched
codegraph sidecar to each SWC. Until that convention is standardized, tools may
accept an explicit graph location and cache it by library coordinates.

## Caching

Treat released graph artifacts as immutable. A cache key should include the
artifact coordinates, target, schema version, and indexed SHA-256 value. Never
reuse a graph from a different framework version simply because the module name
matches.

The complete aggregate is approximately 120 MB unpacked but about 6 MB
compressed. Resolve it once per framework version and share the cache between
projects rather than copying it into every workspace.
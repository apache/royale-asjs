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

# Code Graphs for Framework Developers

## What a Code Graph Is

A code graph is a deterministic, compiler-resolved JSON description of a
module's public API for one target. It contains public classes, interfaces,
package definitions, members, callable signatures, ASDoc, metadata, inheritance
and implementation edges, resolved type references, and source provenance.
Aggregate indexes add Maven dependencies, content hashes, and MXML namespace and
tag mappings.

This is more reliable than parsing ActionScript or MXML source because the
compiler has already resolved imports, external SWCs, visibility, inheritance,
metadata, and conditional compilation. JavaScript and SWF graphs are separate,
so tools see the API that actually exists for each target.

Code graphs support editors, documentation generators, API browsers,
compatibility checks, static analysis, and AI-assisted development. They are
public declaration and type graphs, not runtime call graphs or method-body
dependency graphs. They are build metadata and are not linked into SWCs or
deployed applications.

## Maven Lifecycle

Code graph generation is bound to `prepare-package` for every module under
`frameworks/projects`. A normal Maven build generates the JavaScript graph. The
`option-with-swf` profile generates both JavaScript and SWF graphs.

```bash
./mvnw prepare-package
./mvnw -Poption-with-swf prepare-package
```

Module shards are written to:

```text
frameworks/projects/<module>/target/codegraph/<js|swf>/<module>.json
```

When `with-distribution` is active, Maven also creates and verifies the
aggregate classifier:

```bash
./mvnw -Pwith-distribution verify
./mvnw -Pwith-distribution,option-with-swf verify
```

The attached artifact is:

```text
org.apache.royale.framework:distribution:zip:codegraphs:<version>
```

Use `-Droyale.skipCodeGraph=true` for a local build that intentionally skips
generation. Release and CI builds should not use this override.

## Ant Lifecycle

The Ant build requires `ROYALE_COMPILER_HOME` to point to a compiler containing
`lib/codegraph.jar`. Set `AIR_HOME` to generate SWF graphs; without it, the
framework driver generates JavaScript graphs only.

From the repository root, generate all available module graphs and the aggregate
index with one command:

```bash
ant codegraphs
```

The Ant binary release targets invoke `codegraphs` automatically before
packaging:

```bash
ant binary-release
ant binary-release-noclean
```

The equivalent framework-level commands are:

```bash
ant -f frameworks/build.xml codegraphs
ant -f frameworks/build.xml validate-codegraphs
ant -f frameworks/build.xml codegraph-index
```

Generate or validate one module while developing it:

```bash
ant -Dcodegraph.module=Basic -f frameworks/build.xml codegraph
ant -Dcodegraph.module=Basic -f frameworks/build.xml validate-codegraph
ant -Dcodegraph.module=Basic -f frameworks/build.xml validate-codegraph-determinism
```

`codegraphs` writes module shards beneath
`frameworks/projects/<module>/target/codegraph`. `codegraph-index` validates the
available target set, copies the shards to `frameworks/target/codegraphs`, and
writes `index.json` and `mxml.json`.

## Standalone Command Line

The binary compiler distribution provides `bin/codegraph` and
`bin/codegraph.bat`; the SDK compiler is normally under `js/bin`. The scripts
invoke `lib/codegraph.jar` and pass through normal compiler arguments.

```bash
$ROYALE_COMPILER_HOME/bin/codegraph \
   -load-config=/path/to/compile-config.xml \
   -compiler.define+=COMPILE::JS,true \
   -compiler.define+=COMPILE::SWF,false \
   -keep-asdoc=true \
   -output=target/codegraph/js/MyLibrary.json
```

For SWF, reverse the two defines and use the SWF compiler configuration and
output directory. The most relevant arguments are:

| Argument | Purpose |
| --- | --- |
| `-load-config=<file>` | Loads the project's normal compiler configuration. Use `+=` to append another config. |
| `-output=<file>` | Sets the JSON output file. The default is `codegraph.json`, or `<target>.codegraph.json` when a target file is supplied. |
| `-compiler.define+=COMPILE::JS,<boolean>` | Selects JavaScript conditional declarations. |
| `-compiler.define+=COMPILE::SWF,<boolean>` | Selects SWF conditional declarations and the graph target label. |
| `-include-sources+=<path>` | Adds source files or directories when no positional target file supplies the roots. |
| `-include-classes+=<qualified-name>` | Includes configured top-level classes using normal SWC target semantics. |
| `-keep-asdoc=true` | Preserves parsed ASDoc descriptions and tags. |
| `-create-target-with-errors=true` | Allows output after compiler errors; omit this for normal validation and release builds. |

A positional source file may be supplied after the options. Its base name is
used as the graph's module name. Without a positional target, the output file's
base name becomes the module name.

## Aggregate Layout

The aggregate is staged at `frameworks/target/codegraphs` and contains:

```text
index.json
mxml.json
<version>/<module>/<target>/<module>.json
```

`index.json` records module coordinates, dependencies, available targets,
counts, paths, and SHA-256 hashes. `mxml.json` maps namespace tags to graph
symbols for each available target. A JS-only aggregate contains 39 files; a
JS/SWF aggregate contains 76 files.

Validate an extracted or staged aggregate independently:

```bash
node frameworks/scripts/verify-codegraph-package.js --root <codegraph-directory>
```

## Adding or Changing Framework APIs

1. Build the affected module and inspect both target graphs when the API is
   target-specific.
2. Check stable IDs, resolved type references, ASDoc, metadata, and MXML tags.
3. Run the one-module determinism check.
4. Run the full aggregate validation before merging changes that affect shared
   base classes, manifests, or dependencies.

Graph schema changes must follow the schema compatibility policy in the
compiler repository. Update the model version, packaged schema, writer, and
golden tests together.

## Release Checks

Release builds must use `option-with-swf`, verify the 76-file classifier, and
confirm that the same aggregate is present under `frameworks/codegraphs` in the
binary SDK and npm archives. Normal Apache checksum, signature, and RAT checks
also apply.
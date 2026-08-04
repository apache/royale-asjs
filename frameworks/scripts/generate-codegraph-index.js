#!/usr/bin/env node

/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

function parseArguments(args) {
    const options = {
        metadata: path.resolve(__dirname, "../target/codegraph-index-metadata.tsv"),
        root: path.resolve(__dirname, "../projects"),
        output: path.resolve(__dirname, "../target/codegraphs"),
        targets: ["js", "swf"]
    };
    for (let index = 0; index < args.length; index++) {
        const argument = args[index];
        if (argument === "--metadata" || argument === "--root" || argument === "--output") {
            options[argument.substring(2)] = path.resolve(args[++index]);
        } else if (argument === "--targets") {
            options.targets = args[++index].split(",");
        } else {
            throw new Error(`Unknown argument: ${argument}`);
        }
    }
    if (options.targets.length === 0 || options.targets.some(target => target !== "js" && target !== "swf")) {
        throw new Error(`Unsupported codegraph targets: ${options.targets.join(",")}`);
    }
    return options;
}

function readMetadata(file) {
    const modules = new Map();
    const lines = fs.readFileSync(file, "utf8").trim().split(/\r?\n/);
    lines.forEach((line, lineIndex) => {
        const fields = line.split("\t");
        const kind = fields.shift();
        const moduleName = fields.shift();
        if (kind === "MODULE") {
            modules.set(moduleName, {
                name: moduleName,
                coordinates: {
                    groupId: fields[0], artifactId: fields[1], version: fields[2], type: "swc"
                },
                dependencies: { js: [], swf: [] },
                namespaces: []
            });
            return;
        }
        const module = modules.get(moduleName);
        if (!module) {
            throw new Error(`${file}:${lineIndex + 1}: ${kind} appears before MODULE ${moduleName}`);
        }
        if (kind === "DEPENDENCY") {
            const classifier = fields[0];
            if (classifier === "js" || classifier === "swf") {
                module.dependencies[classifier].push({
                    groupId: fields[1], artifactId: fields[2], version: fields[3],
                    type: "swc", classifier
                });
            }
        } else if (kind === "NAMESPACE") {
            module.namespaces.push({ type: fields[0], uri: fields[1], manifest: fields[2], tags: [] });
        } else if (kind === "TAG") {
            const namespace = module.namespaces.find(candidate =>
                candidate.type === fields[0] && candidate.uri === fields[1]);
            if (!namespace) {
                throw new Error(`${file}:${lineIndex + 1}: TAG has no matching namespace`);
            }
            namespace.tags.push({
                name: fields[2], class: fields[3], lookupOnly: fields[4] === "true"
            });
        } else {
            throw new Error(`${file}:${lineIndex + 1}: unknown record ${kind}`);
        }
    });
    return Array.from(modules.values());
}

function graphPath(root, module, target) {
    return path.join(root, module, "target", "codegraph", target, `${module}.json`);
}

function namespaceSupportsTarget(namespace, target) {
    return !namespace.type || namespace.type === (target === "js" ? "js" : "as");
}

function writeJson(file, value) {
    fs.writeFileSync(file, `${JSON.stringify(value, null, 2)}\n`);
}

function main() {
    const options = parseArguments(process.argv.slice(2));
    const modules = readMetadata(options.metadata);
    const versions = new Set(modules.map(module => module.coordinates.version));
    if (versions.size !== 1 || versions.has("")) {
        throw new Error(`Expected one non-empty framework version, found: ${Array.from(versions).join(", ")}`);
    }
    const version = Array.from(versions)[0];
    const versionRoot = path.join(options.output, version);
    fs.rmSync(options.output, { recursive: true, force: true });
    fs.mkdirSync(versionRoot, { recursive: true });

    const symbolsByTarget = Object.fromEntries(options.targets.map(target => [target, new Map()]));
    const indexModules = modules.map(module => {
        const targets = {};
        options.targets.forEach(target => {
            const source = graphPath(options.root, module.name, target);
            const contents = fs.readFileSync(source);
            const graph = JSON.parse(contents.toString("utf8"));
            const relativePath = path.join(version, module.name, target, `${module.name}.json`);
            const destination = path.join(options.output, relativePath);
            fs.mkdirSync(path.dirname(destination), { recursive: true });
            fs.copyFileSync(source, destination);
            graph.symbols.forEach(symbol => symbolsByTarget[target].set(symbol.qualifiedName, symbol.id));
            targets[target] = {
                path: relativePath.split(path.sep).join("/"),
                sha256: crypto.createHash("sha256").update(contents).digest("hex"),
                symbolCount: graph.symbols.length,
                classCount: graph.symbols.filter(symbol => symbol.kind === "class").length
            };
        });
        return {
            name: module.name,
            coordinates: module.coordinates,
            dependencies: module.dependencies,
            targets
        };
    });

    const mxmlTargets = {};
    let unavailableTags = 0;
    options.targets.forEach(target => {
        mxmlTargets[target] = [];
        modules.forEach(module => module.namespaces
            .filter(namespace => namespaceSupportsTarget(namespace, target))
            .forEach(namespace => {
                const tags = namespace.tags.map(tag => {
                    const id = symbolsByTarget[target].get(tag.class);
                    if (!id) {
                        unavailableTags++;
                    }
                    const mapping = {
                        name: tag.name,
                        class: tag.class,
                        lookupOnly: tag.lookupOnly,
                        available: Boolean(id)
                    };
                    if (id) {
                        mapping.id = id;
                    }
                    return mapping;
                });
                mxmlTargets[target].push({
                    module: module.name,
                    uri: namespace.uri,
                    manifest: namespace.manifest,
                    tags
                });
            }));
    });

    writeJson(path.join(options.output, "index.json"), {
        schemaVersion: "1.0", version, modules: indexModules
    });
    writeJson(path.join(options.output, "mxml.json"), {
        schemaVersion: "1.0", version, targets: mxmlTargets
    });
    console.log(`Generated codegraph index for ${modules.length} module(s) at ${options.output}.`);
    if (unavailableTags > 0) {
        console.log(`Preserved ${unavailableTags} MXML tag mapping(s) unavailable in their target graph.`);
    }
}

try {
    main();
} catch (error) {
    console.error(error.message);
    process.exitCode = 1;
}
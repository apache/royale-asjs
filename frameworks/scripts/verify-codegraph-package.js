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
    let root = process.cwd();
    for (let index = 0; index < args.length; index++) {
        if (args[index] !== "--root" || index + 1 >= args.length) {
            throw new Error(`Unknown or incomplete argument: ${args[index]}`);
        }
        root = args[++index];
    }
    return path.resolve(root);
}

function readJson(file) {
    return JSON.parse(fs.readFileSync(file, "utf8"));
}

function listFiles(root, directory = root) {
    return fs.readdirSync(directory, { withFileTypes: true }).flatMap(entry => {
        const absolutePath = path.join(directory, entry.name);
        return entry.isDirectory() ? listFiles(root, absolutePath) :
            [path.relative(root, absolutePath).split(path.sep).join("/")];
    });
}

function resolvePackagedPath(root, relativePath) {
    const normalizedPath = path.posix.normalize(relativePath);
    if (normalizedPath !== relativePath || normalizedPath.startsWith("../") || path.isAbsolute(relativePath)) {
        throw new Error(`Invalid packaged path: ${relativePath}`);
    }
    return path.join(root, ...relativePath.split("/"));
}

function main() {
    const root = parseArguments(process.argv.slice(2));
    const index = readJson(path.join(root, "index.json"));
    const mxml = readJson(path.join(root, "mxml.json"));
    if (index.schemaVersion !== "1.0" || mxml.schemaVersion !== index.schemaVersion) {
        throw new Error("Codegraph index schema versions are missing or inconsistent");
    }
    if (!index.version || mxml.version !== index.version || !Array.isArray(index.modules)) {
        throw new Error("Codegraph index versions are missing or inconsistent");
    }
    if (!mxml.targets || !Array.isArray(mxml.targets.js) || !Array.isArray(mxml.targets.swf)) {
        throw new Error("MXML index must contain JS and SWF target mappings");
    }

    const expectedFiles = new Set(["index.json", "mxml.json"]);
    const moduleNames = new Set();
    index.modules.forEach(module => {
        if (!module.name || moduleNames.has(module.name)) {
            throw new Error(`Missing or duplicate module name: ${module.name}`);
        }
        moduleNames.add(module.name);
        ["js", "swf"].forEach(target => {
            const targetIndex = module.targets && module.targets[target];
            if (!targetIndex || !targetIndex.path || !targetIndex.sha256) {
                throw new Error(`${module.name} is missing its ${target} graph index`);
            }
            const graphFile = resolvePackagedPath(root, targetIndex.path);
            const contents = fs.readFileSync(graphFile);
            const digest = crypto.createHash("sha256").update(contents).digest("hex");
            if (digest !== targetIndex.sha256) {
                throw new Error(`${targetIndex.path} does not match its SHA-256 index`);
            }
            const graph = JSON.parse(contents.toString("utf8"));
            if (graph.schemaVersion !== index.schemaVersion || graph.module !== module.name || graph.target !== target) {
                throw new Error(`${targetIndex.path} has inconsistent graph identity`);
            }
            if (!Array.isArray(graph.symbols) || graph.symbols.length !== targetIndex.symbolCount) {
                throw new Error(`${targetIndex.path} has an inconsistent symbol count`);
            }
            const classCount = graph.symbols.filter(symbol => symbol.kind === "class").length;
            if (classCount !== targetIndex.classCount) {
                throw new Error(`${targetIndex.path} has an inconsistent class count`);
            }
            expectedFiles.add(targetIndex.path);
        });
    });

    const actualFiles = listFiles(root);
    const unexpectedFiles = actualFiles.filter(file => !expectedFiles.has(file));
    const missingFiles = Array.from(expectedFiles).filter(file => !actualFiles.includes(file));
    if (unexpectedFiles.length || missingFiles.length) {
        throw new Error(`Package membership mismatch; missing: ${missingFiles.join(", ") || "none"}; ` +
            `unexpected: ${unexpectedFiles.join(", ") || "none"}`);
    }
    console.log(`Verified packaged codegraphs for ${index.modules.length} module(s) and ${actualFiles.length} file(s).`);
}

try {
    main();
} catch (error) {
    console.error(error.message);
    process.exitCode = 1;
}
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

const fs = require("fs");
const path = require("path");

function parseArguments(args) {
    const options = {
        root: path.resolve(__dirname, "../projects"),
        targets: ["js", "swf"]
    };

    for (let index = 0; index < args.length; index++) {
        const argument = args[index];
        if (argument === "--root") {
            options.root = path.resolve(args[++index]);
        } else if (argument === "--module") {
            options.module = args[++index];
        } else if (argument === "--targets") {
            options.targets = args[++index].split(",");
        } else if (argument === "--compare-root") {
            options.compareRoot = path.resolve(args[++index]);
        } else {
            throw new Error(`Unknown argument: ${argument}`);
        }
    }

    return options;
}

function collectModules(options) {
    if (options.module) {
        return [options.module];
    }

    return fs.readdirSync(options.root, { withFileTypes: true })
        .filter(entry => entry.isDirectory())
        .map(entry => entry.name)
        .filter(module => options.targets.some(target =>
            fs.existsSync(graphPath(options.root, module, target))))
        .sort();
}

function graphPath(root, module, target) {
    return path.join(root, module, "target", "codegraph", target, `${module}.json`);
}

function findUnresolved(value, location, unresolved) {
    if (!value || typeof value !== "object") {
        return;
    }
    if (value.unresolved === true) {
        unresolved.push(location);
    }
    if (Array.isArray(value)) {
        value.forEach((item, index) => findUnresolved(item, `${location}[${index}]`, unresolved));
        return;
    }
    Object.keys(value).forEach(key => findUnresolved(value[key], `${location}.${key}`, unresolved));
}

function validateDeclarations(graph, file) {
    if (!Array.isArray(graph.symbols)) {
        throw new Error(`${file}: symbols must be an array`);
    }

    const ids = new Set();
    graph.symbols.forEach((symbol, symbolIndex) => {
        const declarations = [symbol].concat(Array.isArray(symbol.members) ? symbol.members : []);
        declarations.forEach((declaration, declarationIndex) => {
            if (typeof declaration.id !== "string" || declaration.id.length === 0) {
                throw new Error(`${file}: declaration ${symbolIndex}:${declarationIndex} has no id`);
            }
            if (ids.has(declaration.id)) {
                throw new Error(`${file}: duplicate declaration id ${declaration.id}`);
            }
            ids.add(declaration.id);
        });
    });
}

function validateGraph(options, module, target) {
    const file = graphPath(options.root, module, target);
    if (!fs.existsSync(file)) {
        throw new Error(`${file}: expected graph does not exist`);
    }

    const contents = fs.readFileSync(file);
    const graph = JSON.parse(contents.toString("utf8"));
    if (graph.schemaVersion !== "1.0") {
        throw new Error(`${file}: expected schemaVersion 1.0, found ${graph.schemaVersion}`);
    }
    if (graph.module !== module) {
        throw new Error(`${file}: expected module ${module}, found ${graph.module}`);
    }
    if (graph.target !== target) {
        throw new Error(`${file}: expected target ${target}, found ${graph.target}`);
    }

    validateDeclarations(graph, file);
    const unresolved = [];
    findUnresolved(graph, "$", unresolved);
    const unresolvedApi = unresolved.filter(location => location.indexOf(".metadata[") === -1);
    if (unresolvedApi.length > 0) {
        throw new Error(`${file}: ${unresolvedApi.length} unresolved API reference(s), first at ${unresolvedApi[0]}`);
    }

    if (options.compareRoot) {
        const comparisonFile = graphPath(options.compareRoot, module, target);
        if (!fs.existsSync(comparisonFile) || !contents.equals(fs.readFileSync(comparisonFile))) {
            throw new Error(`${file}: differs from ${comparisonFile}`);
        }
    }
    return unresolved.length - unresolvedApi.length;
}

function main() {
    const options = parseArguments(process.argv.slice(2));
    const modules = collectModules(options);
    if (modules.length === 0) {
        throw new Error(`No codegraph modules found under ${options.root}`);
    }

    let unresolvedMetadata = 0;
    modules.forEach(module => options.targets.forEach(target => {
        unresolvedMetadata += validateGraph(options, module, target);
    }));
    console.log(`Validated ${modules.length * options.targets.length} codegraph shard(s) for ${modules.length} module(s).`);
    if (unresolvedMetadata > 0) {
        console.log(`Preserved ${unresolvedMetadata} unresolved metadata reference name(s).`);
    }
}

try {
    main();
} catch (error) {
    console.error(error.message);
    process.exitCode = 1;
}
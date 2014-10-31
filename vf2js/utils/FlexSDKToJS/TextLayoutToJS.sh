#!/bin/sh

ARGS=""
ARGS="$ARGS +env.PLAYERGLOBAL_HOME="/Users/erik/Documents/apacheFlex/dependencies/PlayerGlobal/player" "
ARGS="$ARGS +playerglobal.version=15.0 "
ARGS="$ARGS +source.dir="/Users/erik/Documents/ApacheFlex/git/flex-tlf/TextLayout" "

ARGS="$ARGS -define=CONFIG::debug,false "
ARGS="$ARGS -define=CONFIG::release,true "

ARGS="$ARGS -load-config+="/Users/erik/Documents/ApacheFlex/git/flex-tlf/compile-config.xml" "

ARGS="$ARGS -ignore-problems=org.apache.flex.compiler.problems.DuplicateSkinStateProblem "
ARGS="$ARGS -ignore-problems=org.apache.flex.compiler.problems.DuplicateQNameInSourcePathProblem "
ARGS="$ARGS -ignore-problems=org.apache.flex.compiler.problems.NoDefinitionForSWCDependencyProblem "

ARGS="$ARGS -js-output-type=VF2JS "

ARGS="$ARGS -closure-lib="/Users/erik/Documents/ApacheFlex/dependencies/GoogleClosure/library" "

ARGS="$ARGS -output="/Users/erik/Documents/ApacheFlex/git/flex-asjs/vf2js/frameworks/js/vf2js" "

java -jar "/Users/erik/Documents/ApacheFlex/git/flex-falcon/compiler.jx/lib/compc.jar" ${ARGS}

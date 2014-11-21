#!/bin/sh

ROOT="/Users/erik/Documents/ApacheFlex/git/flex-asjs/vf2js/utils/FlexSDKToJS"
OUTPUT="/Users/erik/Documents/ApacheFlex/git/flex-asjs/vf2js/frameworks/js/vf2js"

ARGS=""
ARGS="$ARGS +env.PLAYERGLOBAL_HOME="/Users/erik/Documents/apacheFlex/dependencies/PlayerGlobal/player" "
ARGS="$ARGS +playerglobal.version=15.0 "

ARGS="$ARGS -load-config+="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/flex-config.xml" "
ARGS="$ARGS -load-config+="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/framework/framework-config.xml" "
ARGS="$ARGS -load-config+="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/spark/compile-config.xml" "

ARGS="$ARGS -external-library-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/libs/air/airspark.swc" "
ARGS="$ARGS -external-library-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/libs/player/15.0/playerglobal.swc" "
ARGS="$ARGS -external-library-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/libs/osmf.swc" "
ARGS="$ARGS -external-library-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/libs/textlayout.swc" "

ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/advancedgrids/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/apache/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/charts/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/core/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/experimental/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/flash-integration/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/framework/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/mx/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/rpc/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/spark/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/spark_dmv/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/sparkskins/src" "
ARGS="$ARGS -source-path="/Users/erik/Documents/ApacheFlex/git/flex-sdk/frameworks/projects/wireframe/src" "

ARGS="$ARGS -ignore-problems=org.apache.flex.compiler.problems.DuplicateSkinStateProblem "
ARGS="$ARGS -ignore-problems=org.apache.flex.compiler.problems.DuplicateQNameInSourcePathProblem "
ARGS="$ARGS -ignore-problems=org.apache.flex.compiler.problems.NoDefinitionForSWCDependencyProblem "

ARGS="$ARGS -js-output-type=VF2JS "
ARGS="$ARGS -keep-asdoc=false "

ARGS="$ARGS -closure-lib="/Users/erik/Documents/ApacheFlex/dependencies/GoogleClosure/library" "

ARGS="$ARGS -output=${OUTPUT} "

java -jar "/Users/erik/Documents/ApacheFlex/git/flex-falcon/compiler.jx/lib/compc.jar" ${ARGS}



./TextLayoutToJS.sh



cd ${OUTPUT}
#pwd

# Delete xClasses.js
rm ./AdvancedDataGridClasses.js
rm ./ApacheClasses.js
rm ./ChartsClasses.js
rm ./CoreClasses.js
rm ./ExperimentalClasses.js
rm ./FrameworkClasses.js
rm ./MxClasses.js
rm ./RPCClasses.js
rm ./SparkClasses.js
rm ./SparkDmvClasses.js
rm ./SparkSkinsClasses.js
rm ./WireframeClasses.js

# Create class 'QName'
cat <<EOF > ./QName.js
/**
 * @fileoverview 'QName'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('QName');



/**
 * @constructor
 * @struct
 */
QName = function() {};
EOF

# Create class 'mx.core.mx_internal'
cat <<EOF > ./mx/core/mx_internal.js
/**
 * @fileoverview 'mx.core.mx_internal'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('mx.core.mx_internal');



/**
 * @constructor
 * @struct
 */
mx.core.mx_internal = function() {};
EOF

# copy org.apache.flex.utils.Language from FlexJS SDK
mkdir ./org/apache/flex/utils
cp /Users/erik/Documents/ApacheFlex/git/flex-asjs/frameworks/js/FlexJS/src/org/apache/flex/utils/Language.js ./org/apache/flex/utils/Language.js

# copy flash.utils.IDataInput and refactor to flash.utils.IDataInput2
cp ./flash/utils/IDataInput.js ./flash/utils/IDataInput2.js
sed -i '' -e "s/IDataInput/IDataInput2/g" ./flash/utils/IDataInput2.js

# copy flash.utils.IDataOutput and refactor to flash.utils.IDataOutput2
cp ./flash/utils/IDataOutput.js ./flash/utils/IDataOutput2.js
sed -i '' -e "s/IDataOutput/IDataOutput2/g" ./flash/utils/IDataOutput2.js

# Remove 'wrong' chars from mx/utils/StringUtil.js
sed -i '' -e 's/ //g' ./mx/utils/StringUtil.js
sed -i '' -e 's/ //g' ./mx/utils/StringUtil.js

# Remove 'wrong' char from spark/components/Label.js
sed -i '' -e 's/ //g' ./spark/components/Label.js

# Remove 'wrong' public namespace reference from mx/styles/CSSStyleDeclaration.js
sed -i '' -e 's/public\.this\.setStyle/this\.setStyle/g' ./mx/styles/CSSStyleDeclaration.js

# Add missing namespace to flash/geom/Vector3D.js
sed -i '' -e 's/= Vector3D/= flash.geom.Vector3D/g' ./flash/geom/Vector3D.js

# Remove namespace from Vector type in spark/components/DataGroup.js
sed -i '' -e 's/Vector\.<mx\.core\.IVisualElement>/Vector/g' ./spark/components/DataGroup.js

# Remove "difficult" interface reference from mx/core/UIComponent.js
sed -i '' -e 's/, mx.validators.IValidatorListener, /, /g' ./mx/core/UIComponent.js

# Remove goog.require from spark.layouts.supportClasses.LinearLayoutVector
tr '\n' '#' < ./spark/layouts/supportClasses/LinearLayoutVector.js > ./spark/layouts/supportClasses/LinearLayoutVector.js_temp
sed -i '' -e "s/#goog.require('spark.layouts.supportClasses.Block');//g" ./spark/layouts/supportClasses/LinearLayoutVector.js_temp
tr '#' '\n' < ./spark/layouts/supportClasses/LinearLayoutVector.js_temp > ./spark/layouts/supportClasses/LinearLayoutVector.js
rm ./spark/layouts/supportClasses/LinearLayoutVector.js_temp

# Add 'global' goog.require to mx.managers.SystemManager
tr '\n' '#' < ./mx/managers/SystemManager.js > ./mx/managers/SystemManager.js_temp

sed -i '' -e "s/####\/\*\*/##goog.require('org.apache.flex.utils.Language');&/g" ./mx/managers/SystemManager.js_temp

sed -i '' -e "s/####\/\*\*/##goog.require('mx.core.EmbeddedFontRegistry');&/g" ./mx/managers/SystemManager.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.styles.StyleManagerImpl');&/g" ./mx/managers/SystemManager.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.managers.BrowserManagerImpl');&/g" ./mx/managers/SystemManager.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.managers.CursorManagerImpl');&/g" ./mx/managers/SystemManager.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.managers.HistoryManagerImpl');&/g" ./mx/managers/SystemManager.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.managers.LayoutManager');&/g" ./mx/managers/SystemManager.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.managers.PopUpManagerImpl');&/g" ./mx/managers/SystemManager.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.managers.ToolTipManagerImpl');&/g" ./mx/managers/SystemManager.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.managers.DragManagerImpl');&/g" ./mx/managers/SystemManager.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.core.TextFieldFactory');&/g" ./mx/managers/SystemManager.js_temp

sed -i '' -e "s/####\/\*\*/##goog.require('Class');&/g" ./mx/managers/SystemManager.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('INT');&/g" ./mx/managers/SystemManager.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('QName');&/g" ./mx/managers/SystemManager.js_temp

sed -i '' -e "s/####\/\*\*/##goog.require('mx.preloaders.DownloadProgressBar');&/g" ./mx/managers/SystemManager.js_temp

sed -i '' -e "s/####\/\*\*/##goog.require('mx.managers.systemClasses.ChildManager');&/g" ./mx/managers/SystemManager.js_temp

sed -i '' -e "s/mx\.managers\.SystemManager = function() {#  /mx\.managers\.SystemManager = function() {#  window['apache-flex_system-manager'] = this;#/g" ./mx/managers/SystemManager.js_temp

tr '#' '\n' < ./mx/managers/SystemManager.js_temp > ./mx/managers/SystemManager.js
rm ./mx/managers/SystemManager.js_temp

# Add 'missing' (?) goog.require to mx.skins.halo.HaloFocusRect
tr '\n' '#' < ./mx/skins/halo/HaloFocusRect.js > ./mx/skins/halo/HaloFocusRect.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.skins.ProgrammaticSkin');&/g" ./mx/skins/halo/HaloFocusRect.js_temp
tr '#' '\n' < ./mx/skins/halo/HaloFocusRect.js_temp > ./mx/skins/halo/HaloFocusRect.js
rm ./mx/skins/halo/HaloFocusRect.js_temp

# Add 'missing' (?) goog.require to mx.preloaders.DownloadProgressBar
tr '\n' '#' < ./mx/preloaders/DownloadProgressBar.js > ./mx/preloaders/DownloadProgressBar.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.geom.RoundedRectangle');&/g" ./mx/preloaders/DownloadProgressBar.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.preloaders.IPreloaderDisplay');&/g" ./mx/preloaders/DownloadProgressBar.js_temp
tr '#' '\n' < ./mx/preloaders/DownloadProgressBar.js_temp > ./mx/preloaders/DownloadProgressBar.js
rm ./mx/preloaders/DownloadProgressBar.js_temp

# Add 'missing' (?) goog.require to mx.skins.halo.ToolTipBorder
tr '\n' '#' < ./mx/skins/halo/ToolTipBorder.js > ./mx/skins/halo/ToolTipBorder.js_temp
sed -i '' -e "s/####\/\*\*/##goog.require('mx.skins.RectangularBorder');&/g" ./mx/skins/halo/ToolTipBorder.js_temp
tr '#' '\n' < ./mx/skins/halo/ToolTipBorder.js_temp > ./mx/skins/halo/ToolTipBorder.js
rm ./mx/skins/halo/ToolTipBorder.js_temp

# Move property to below static method in mx.binding.Binding
tr '\n' '#' < ./mx/binding/Binding.js > ./mx/binding/Binding.js_temp
sed -i '' -e "s/###\/\*\*# \* @type {Object}# \*\/#mx.binding.Binding.allowedErrors = mx.binding.Binding.generateAllowedErrors();//g" ./mx/binding/Binding.js_temp
sed -i '' -e "s/  o\[2005\] = 1;#  return o;#};/  o\[2005\] = 1;#  return o;#};###\/\*\*# \* @type {Object}# \*\/#mx.binding.Binding.allowedErrors = mx.binding.Binding.generateAllowedErrors();/g" ./mx/binding/Binding.js_temp
tr '#' '\n' < ./mx/binding/Binding.js_temp > ./mx/binding/Binding.js
rm ./mx/binding/Binding.js_temp



cd ${ROOT}
#pwd

# create 'deps.js' for SDK + FP JS classes
./JSFlexSDKDeps.sh

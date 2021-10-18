////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package mx.rpc.remoting.mxml
{
    COMPILE::SWF
    {
        import flash.utils.ByteArray;
    }

    import mx.collections.IList;
    import mx.rpc.AbstractOperation;

    import org.apache.royale.net.remoting.amf.AMFBinaryData;
    import org.apache.royale.reflection.getQualifiedClassName;

    /**
     * A RemoteObject that performs automatic serialization/deserialization of results.
     *
     * It deserializes the compressed ByteArray in order to optimize the transfer time.
     * TODO improve to serialize the sending.
     */
    public dynamic class CompressedRemoteObject extends RemoteObject
    {
        /**
         * disable the compression if true
         *
         * defaults to false
         *
         * @royalesuppresspublicvarwarning
         */
        public static var disableCompression:Boolean;

        [ArrayElementType("String")]
        /**
         * @royalesuppresspublicvarwarning
         */
        public static var includePackages:Array = ["org.apache.royale."];

        [ArrayElementType("String")]
        /**
         * @royalesuppresspublicvarwarning
         */
        public static var includeClasses:Array;

        [ArrayElementType("String")]
        /**
         * @royalesuppresspublicvarwarning
         */
        public static var excludeClasses:Array;

        [ArrayElementType("String")]
        /**
         * @royalesuppresspublicvarwarning
         */
        public var includePackages:Array;

        [ArrayElementType("String")]
        /**
         * @royalesuppresspublicvarwarning
         */
        public var includeClasses:Array;

        [ArrayElementType("String")]
        /**
         * @royalesuppresspublicvarwarning
         */
        public var excludeClasses:Array;

        /**
         * Uses the pako library for the zlib compression algorithm
         *
         * <inject_script>
         * var script = document.createElement("script");
         * script.setAttribute("src", "https://cdnjs.cloudflare.com/ajax/libs/pako/1.0.6/pako.min.js");
         * document.head.appendChild(script);
         * </inject_script>
         */
        public function CompressedRemoteObject(destination:String = null)
        {
            super(destination);
        }

        override public function initialize():void
        {
            super.initialize();
            convertParametersHandler = serializeParameters;
            convertResultHandler = deserializeResult;
        }

        private function serializeParameters(parameters:Array):Array
        {
            var includePackages:Array = this.includePackages ? this.includePackages : CompressedRemoteObject.includePackages;
            var includeClasses:Array = this.includeClasses ? this.includeClasses : CompressedRemoteObject.includeClasses;
            var excludeClasses:Array = this.excludeClasses ? this.excludeClasses : CompressedRemoteObject.excludeClasses;
            for (var i:int = 0; i < parameters.length; i++) {
                var parameter:Object = parameters[i];
                if (parameter is Array && (parameter as Array).length > 0) {
                    parameter = parameter[0];
                } else if (parameter is IList && IList(parameter).length > 0) {
                    parameter = parameter[0];
                }
                var parameterClassName:String = getQualifiedClassName(parameter);
                if (parameterClassName) {
                    parameterClassName = parameterClassName.replace("::", ".");
                    var included:Boolean;
                    if (includePackages && includePackages.length > 0) {
                        //var lastDotIndex:int = parameterClassName.lastIndexOf(".");
                        //var packageName:String = lastDotIndex != -1 ? parameterClassName.slice(0, lastDotIndex) : "";
                        for each (var includePackage:String in includePackages) {
                            if (parameterClassName.indexOf(includePackage) >= 0) {
                                included = true;
                                break;
                            }
                        }
                    }
                    if (!included && includeClasses && includeClasses.length > 0) {
                        included = includeClasses.indexOf(parameterClassName) != -1;
                    }
                    if (included && excludeClasses && excludeClasses.length > 0) {
                        included = excludeClasses.indexOf(parameterClassName) == -1;
                    }
                }

                // if (included) {
                //     COMPILE::SWF{
                //     var byteArray:ByteArray = new ByteArray();
                //     byteArray.writeObject(parameters[i]);
                //     byteArray.compress();
                //     parameters[i] = byteArray;
                //     }
                //     COMPILE::JS
                //     {
                    // var bytearray:AMFBinaryData = new AMFBinaryData();
                    // bytearray.writeObject(parameter[i]);
                    // window["pako"].deflate(bytearray)
                    // parameter[i] = bytearray;
                //     }
                // }
            }
            return parameters;
        }
	
		/**
		 * @royaleignorecoercion org.apache.royale.net.remoting.amf.AMFBinaryData
		 */
		private function deserializeResult(result:*, operation:AbstractOperation):* // NO PMD
        {
            COMPILE::SWF{
                if (!disableCompression && result is ByteArray) {
                    var byteArray:ByteArray = result as ByteArray;
                    byteArray.uncompress();
                    return byteArray.readObject();
                } else {
                    return result;
                }
            }

            COMPILE::JS
            {
                if (!disableCompression && result is AMFBinaryData)
                {
					var original:AMFBinaryData = result as AMFBinaryData;
					// --- uncompress the original bytes to get the real object (tree) and create a new AMFBinaryData with it
					var uncompressed:AMFBinaryData = new AMFBinaryData(window["pako"]["inflate"](original.array).buffer);
                    // --- return the inflated data object as result
					return uncompressed.readObject();
                }
                else
                {
                    return result;
                }
            }
        }
    }
}

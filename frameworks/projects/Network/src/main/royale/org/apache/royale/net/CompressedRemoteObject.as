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
package org.apache.royale.net
{
    import org.apache.royale.net.remoting.amf.AMFBinaryData;
    import org.apache.royale.net.events.ResultEvent;

    COMPILE::SWF
    {
        import flash.utils.ByteArray;
    }
    
    /**
     * A RemoteObject that performs automatic serialization/deserialization of results.
     *
     * It deserializes the compressed ByteArray in order to optimize the transfer time.
     * TOOD improve to serialize the sending.
     * 
     */
    public class CompressedRemoteObject extends RemoteObject
    {
        /**
         * Uses the pako library for the zlib compression algorithm
         *
         * <inject_html>
         * <script src="https://cdnjs.cloudflare.com/ajax/libs/pako/1.0.6/pako.min.js"></script>
         * </inject_html>
         */
        public function CompressedRemoteObject()
        {
            super();
        }

        override public function resultHandler(param:Object):void
		{
            COMPILE::JS
            {
                // --- Transform the number array into a bytearray
                var bytearray:Uint8Array = new Uint8Array(param.body);

                // --- uncompress the bytearray to get the real object (tree) and create the AMFBinaryData with it
                var data:AMFBinaryData = new AMFBinaryData(window["pako"].inflate(bytearray));

                // --- dispatch the ResultEvent like in the standard RemoteObject with the inflated result object
    		    dispatchEvent(new ResultEvent(ResultEvent.RESULT, data.readObject()));
            }

            COMPILE::SWF
            {
                // --- SWF not tested
                var byteArray:ByteArray = param.body as ByteArray;
                byteArray.uncompress();
                dispatchEvent(new ResultEvent(ResultEvent.RESULT, byteArray.readObject()));
            }
		}
    }
}
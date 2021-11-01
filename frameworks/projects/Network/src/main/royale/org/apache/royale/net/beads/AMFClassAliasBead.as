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
package org.apache.royale.net.beads
{

    COMPILE::JS
    {
        import org.apache.royale.net.remoting.amf.AMFBinaryData;
    }

    import org.apache.royale.reflection.beads.ClassAliasBead;
    
    /**
     *  The AMFClassAliasBead class is an extension of the reflection
     *  ClassAliasBead and is useful where aliasing is for AMF serialization/deserialization support.
     *  It offers a simple option to reduce logging noise in JSRoyale debug builds by setting
     *  verboseLogging to false (it is true by default for debug builds).
     *  AMF Verbose logging is never present in JSRoyale release builds.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.9
     */
	public class AMFClassAliasBead extends ClassAliasBead
	{


        /**
         *  Whether or not AMF Verbose logging should be enabled in JSRoyale debug builds.
         *  AMF Verbose logging is never present in JSRoyale release builds.
         *
         *  @default true
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.9
         */
        public function set verboseLogging(value:Boolean):void{
            COMPILE::JS{
                AMFBinaryData.verboseLogging = value;
            }
        }
        public function get verboseLogging():Boolean{
            COMPILE::JS{
                return AMFBinaryData.verboseLogging;
            }
            COMPILE::SWF{
                return false;
            }
        }
    }
}

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
package org.apache.royale.textLayout.conversion
{
    /** Contains information about a format.
     * 
     * @playerversion Flash 10.0
     * @playerversion AIR 2.0
     * @langversion 3.0
     */
    public class FormatDescriptor
    {
        private var _format:String;
        private var _clipboardFormat:String;
        private var _importerClass:Class;
        private var _exporterClass:Class;
        
        /** Constructor.
         * 
         * @playerversion Flash 10.0
         * @playerversion AIR 2.0
         * @langversion 3.0
        */
        public function FormatDescriptor(format:String, importerClass:Class, exporterClass:Class, clipboardFormat:String)
        {
            _format = format;
            _clipboardFormat = clipboardFormat;
            _importerClass = importerClass;
            _exporterClass = exporterClass;
        }
        
        /** Returns the data format used by the converter.
         * 
         * @playerversion Flash 10.0
         * @playerversion AIR 2.0
         * @langversion 3.0     
        */
        public function get format():String
        { return _format; }

        /** Descriptor used when matching this format to the formats posted on the external clipboard. If the format supports importing, 
         * (it's importerClass is not null), it will be called when pasting from the clipboard, if the clipboard contents include data 
         * in this format. If the format supports exporting, it will be called when copying to the clipboard, and the output it creates 
         * will be posted to the clipboard with this clipboardFormat.
         * 
         * @playerversion Flash 10.0
         * @playerversion AIR 2.0
         * @langversion 3.0
         * 
         * @see flash.desktop.Clipboard
         * @see flash.desktop.ClipboardFormats
         */
        public function get clipboardFormat():String
        { return _clipboardFormat; }

        /** Returns the class used for converting data from the format. 
         * 
         * @playerversion Flash 10.0
         * @playerversion AIR 2.0
         * @langversion 3.0
        */
        public function get importerClass():Class
        { return _importerClass; }

        /** Returns the class used for converting to the format. 
         * 
         * @playerversion Flash 10.0
         * @playerversion AIR 2.0
         * @langversion 3.0
        */
        public function get exporterClass():Class
        { return _exporterClass; }
    }
}

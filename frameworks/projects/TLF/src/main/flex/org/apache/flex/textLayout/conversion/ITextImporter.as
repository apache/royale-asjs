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
	import org.apache.royale.textLayout.elements.ITextFlow;
    import org.apache.royale.textLayout.elements.IConfiguration;
    
    /** 
     * Interface for importing text content into a TextFlow from an external source. 
     * The TextConverter class creates importers with no constructor arguments.
     * 
     * @see org.apache.royale.textLayout.elements.TextFlow
     * 
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @langversion 3.0
     */
    public interface ITextImporter
    {   
        /** 
         * Import text content from an external source and convert it into a TextFlow.
         * @param source        The data to convert.
         * @return TextFlow Created from the source.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
		 */
		function importToFlow(source:Object):ITextFlow;
        
        /** 
         * This property contains a vector of error messages as strings after a call
         * to an importer method is the <code>throwOnError</code> property is set to
         * <code>false</code>, which is the default. If there were no errors, the
         * property returns <code>null</code>. The property is reset on each method
         * call.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function get errors():Vector.<String>;
        
        /** 
         * The <code>throwOnError</code> property controls how the importer handles errors.
         * If set to <code>true</code>, methods throw an Error instance on errors. 
         * If set to <code>false</code>, which is the default, errors are collected
         * into a vector of strings and stored in the <code>errors</code> property, 
         * and the importer does not throw. 
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        function get throwOnError():Boolean;
        function set throwOnError(value:Boolean):void;
        
        /** 
         * Controls whether or not the 
         * importer should handle the extra information necessary for the clipboard. 
         * When data comes in from the clipboard, it might contain partial paragraphs; 
         * paragraphs that are missing the terminator or newline character. If <code>useClipboardAnnotations</code> 
         * is <code>true</code>, the importer marks these partial paragraphs with a 
         * <code>ConverterBase.MERGE_TO_NEXT_ON_PASTE</code> attribute. This causes the paste
         * operation to correctly handle merging of the pasted paragraph (and any list or div elements
         * that may include the paragraph) into the text.
         *  
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         *  
         * @see org.apache.royale.textLayout.conversion.ConverterBase.MERGE_TO_NEXT_ON_PASTE
         */
        function get useClipboardAnnotations():Boolean;
        function set useClipboardAnnotations(value:Boolean):void;

        /**
         * The <code>configuration</code> property contains the IConfiguration instance that
         * the importer needs when creating new TextFlow instances. This property
         * is initially set to <code>null</code>.
         * 
         * @see org.apache.royale.textLayout.elements.TextFlow
         * 
         * @playerversion Flash 10.2
         * @playerversion AIR 2.0
         * @langversion 3.0
         */
        function get configuration():IConfiguration;
        function set configuration(value:IConfiguration):void;
        
    }
}

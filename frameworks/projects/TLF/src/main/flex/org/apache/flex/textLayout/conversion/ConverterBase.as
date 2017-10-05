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
package org.apache.royale.textLayout.conversion {


	
	/**
	 * This is a base class for importers as well as exporters. It implements the error handling
	 * plus property getters and setters that generate an error when invoked.
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.0
	 * @langversion 3.0 
	 */
	public class ConverterBase
	{
		private var _errors:Vector.<String> = null;
		private var _throwOnError:Boolean = false;
		private var _useClipboardAnnotations:Boolean = false;
		private var _config:ImportExportConfiguration;

		
		/** Errors encountered while parsing. 
		 * Value is a vector of Strings.
		 */
		public function get errors():Vector.<String>
		{
			return _errors;
		}
		
		/** @copy ITextImporter#throwOnError()
		 */
		public function get throwOnError():Boolean
		{
			return _throwOnError;
		}
		
		public function set throwOnError(value:Boolean):void
		{
			_throwOnError = value;
		}
		
		/** @private
		 * Clear errors.
		 */
		public function clear():void
		{
			_errors = null;
		}
		
		/** @private
		 * Register an error that was encountered while parsing. If throwOnError
		 * is true, the error causes an exception. Otherwise it is logged and parsing
		 * continues.
		 * @param error	the String that describes the error
		 */
		public function reportError(error:String):void
		{
			if (_throwOnError)
				throw new Error(error);
			
			if (!_errors)
				_errors = new Vector.<String>();
			_errors.push(error);
		}

		/** @copy ITextImporter#useClipboardAnnotations()
		 */
		public function get useClipboardAnnotations():Boolean
		{
			return _useClipboardAnnotations;
		}
		public function set useClipboardAnnotations(value:Boolean):void
		{
			_useClipboardAnnotations = value;
		}
		
		/**
		 * Returns the import and export configuration. 
		 **/
		public function get config():ImportExportConfiguration {
			return _config;
		}
		
		/**
		 * @private
		 **/
		public function set config(value:ImportExportConfiguration):void {
			_config = value;
		}
		
	}
}

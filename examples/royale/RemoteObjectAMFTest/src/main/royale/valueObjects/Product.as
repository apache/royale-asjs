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
package valueObjects
{
    [RemoteClass(alias="org.apache.royale.amfsamples.valueobjects.Product")]
	public class Product
	{
		public function Product()
		{
		}

		private var _name:String;

        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            _name = value;
        }

        private var _description:String;

        public function get description():String
        {
            return _description;
        }
        
        public function set description(value:String):void
        {
            _description = value;
        }

        private var _taxonomy:Taxonomy;

        public function get taxonomy():Taxonomy
        {
            return _taxonomy;
        }
        
        public function set taxonomy(value:Taxonomy):void
        {
            _taxonomy = value;
        }

        // collection of zones (Zone), we can use Array and ArrayList
        private var _zones:Array;

        public function get zones():Array
        {
            return _zones;
        }
        
        public function set zones(value:Array):void
        {
            _zones = value;
        }

        private var _flavors:Array = null;

        public function get flavors():Array
        {
            return _flavors;
        }
        
        public function set flavors(value:Array):void
        {
            _flavors = value;
        }

	}
}

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
package components.mdbutton {
	public class MDButtonFactory {
		private static var _instance : MDButtonFactory;
		protected var elementName : String = "md-button";
		protected var baseComponent : Object = MDButton;
		protected var componentClass : Object;
		protected var alreadyRegistered: Boolean = false;

		public function MDButtonFactory() {
			if (_instance) {
				throw new Error("MDButtonFactory is a singleton. Use getInstance instead.");
			}
			_instance = this;
		}

		public static function	getInstance() : MDButtonFactory {
			if (!_instance) {
				new MDButtonFactory();
			}
			return _instance;
		}
		
		protected function registerComponent() : void {
			if(!alreadyRegistered)
			{
				var classProto:Object = Object["create"](components.mdbutton.MDButton['prototype']);
				componentClass = document["registerElement"](elementName, {'prototype':classProto});
				alreadyRegistered = true;
			}
		}
		
		public function getButtonClass():Object
		{
			registerComponent();
			return componentClass;	
		}
	}
}

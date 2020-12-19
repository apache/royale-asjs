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
package org.apache.royale.language
{



	[ExcludeClass]
	COMPILE::JS
	/**
	 * @royalesuppresspublicvarwarning
	 * @royalesuppressexport
	 */
	public class NotificationXML extends XML
	{

		private static const ATTRIBUTE_ADDED:String = 'attributeAdded';
		private static const ATTRIBUTE_CHANGED:String = 'attributeChanged';
		private static const ATTRIBUTE_REMOVED:String = 'attributeRemoved';
		private static const NODE_ADDED:String = 'nodeAdded';
		private static const NODE_CHANGED:String = 'nodeChanged';
		private static const NODE_REMOVED:String = 'nodeRemoved';
		private static const TEXT_SET:String = 'textSet';
		private static const NAME_SET:String = 'nameSet';
		private static const NAMESPACE_SET:String = 'namespaceSet';
		private static const NAMESPACE_ADDED:String = 'namespaceAdded';
		private static const NAMESPACE_REMOVED:String = 'namespaceRemoved';


		private static var _inst:NotificationXML;
		private static var _instX:XML;
		private static var _unlocked:Boolean;

		private static function init():void{
			_unlocked = true;
			//hack so that instance.constructor points to XML class:
			NotificationXML.prototype.constructor = XML;
			_inst = new NotificationXML();
			_instX = new XML();
			_unlocked = false;
		}

		public static function getUpgradeTemplate():XML{
			var inst:XML =_inst
			if (!inst){
				init();
				inst = _inst;
			}
			return inst;
		}

		public static function getDowngradeTemplate():XML{
			var inst:XML =_instX;
			if (!inst){
				init();
				inst = _instX;
			}
			return inst;
		}

		public function NotificationXML(){
			if (!_unlocked) throw new Error('Forbidden - internal utility class only');
		}


		override public function setNamespace(ns:Object):void{
			super.setNamespace(ns);
			/*if (_notificationFunction != null)*/ _notificationFunction(this, NAMESPACE_SET, this, ns, null);
		}

		override public function setValue(value:String):void{
			super.setValue(value);
		//	if (_notificationFunction != null) {
				_notificationFunction(this, TEXT_SET, this, value, null);
				_notificationFunction(this, NODE_ADDED, this, this, null);
		//	}
		}

		override protected function appendChildInternal(child:*):void
		{
			var before:int = _children ? _children.length : 0
			super.addChildInternal(child);
			var after:Array = _children;
			if (after && after.length) {
				var l:uint = after.length;
				//if (_notificationFunction != null) {
					for (var i:uint = before; i < l;i++ ) {
						var xml:XML = after[i];
						if (xml.nodeKind() == 'text') {
							_notificationFunction(this, TEXT_SET, xml, xml.getValue(), null);
							_notificationFunction(xml, NODE_ADDED, xml, xml, null);
						} else {
							_notificationFunction(this, NODE_ADDED, this, xml, null);
						}
					}
				//}
			}
		}

		override public function removeChild(child:XML):Boolean
		{
			if (!child) return false;
			var isAtt:Boolean = false;
			if (child is XML && child.nodeKind() == 'attribute') {
				isAtt = true;
			} else if (child is String && (child+'').charAt(0) == '@'){
				isAtt = true;
			}
			var originalAtts:Array;
			if (isAtt) {
				originalAtts = attributes ? _attributes.slice(): [];
			}
			const removed:Boolean = super.removeChild(child);
			if (removed && originalAtts) {
				var currentAtts:Array = _attributes;
				var l:uint = originalAtts.length;
				while (l) {
					l--;
					if (currentAtts.indexOf(originalAtts[l]) == -1) {
						_notificationFunction(this, ATTRIBUTE_REMOVED, this, originalAtts[l].localName(), originalAtts[l].getValue());
					}
				}
			}
			return removed;
		}

		override public function replace(propertyName:Object, value:*):*
		{
			_replacing = true;
			super.replace(propertyName, value);
			_replacing = false;
			_notificationFunction(this, NODE_CHANGED, this, value, value); //not sure what 'detail' should be here
		}
		private var _replacing:Boolean;

		override protected function childRemoved(child:XML, index:int):void{
			super.childRemoved(child, index);
			if (!_replacing)
				_notificationFunction(this, NODE_REMOVED, this, child, null);//not sure what 'detail' should be here
		}

		override protected function attributeUpdated(attribute:XML, value:String):void{
			var oldVal:String = attribute.getValue();
			super.attributeUpdated(attribute, value);
			_notificationFunction(this, ATTRIBUTE_CHANGED, this,  attribute.name()+'', oldVal);
		}

		override protected function addChildInternal(child:XML):void
		{
			super.addChildInternal(child);
			//if (_notificationFunction != null) {
				if(child.nodeKind() == 'attribute') {
					//add or update

					_notificationFunction(this, ATTRIBUTE_ADDED, this,  child.name()+'', child.toString());
				} else {
					_notificationFunction(this, NODE_ADDED, this, child, null);//not sure what 'detail' should be here
				}
			//}
		}

		override public function insertChildAfter(child1:XML, child2:XML):XML
		{
			var result:XML = super.insertChildAfter(child1, child2);
			if (result) {


			}
			return result;
		}

		override public function setAttribute(attr:*,value:String):String
		{
			value = super.setAttribute(attr,value);
			//if (_notificationFunction !=null) {
				if (attr is XML && (attr as XML).nodeKind() == 'attribute') {
					_notificationFunction(this, ATTRIBUTE_ADDED, this, attr.name()+'', value);
				}
			//}
			return value;
		}


		override public function setName(name:*):void
		{
			var detail:String = this.name()+'';
			super.setName(name);
			_notificationFunction(this, NAME_SET, this, name, detail);
		}

	}
}

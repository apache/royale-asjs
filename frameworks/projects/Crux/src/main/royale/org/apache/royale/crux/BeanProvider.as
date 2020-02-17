/*
 * Copyright 2010 Swiz Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.apache.royale.crux
{
	import org.apache.royale.core.IDocument;
	import org.apache.royale.core.IMXMLDocument;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.reflection.AccessorDefinition;
	import org.apache.royale.reflection.TypeDefinition;
	import org.apache.royale.reflection.VariableDefinition;
	import org.apache.royale.reflection.describeType;
	import org.apache.royale.utils.MXMLDataInterpreter;

    [DefaultProperty("beans")]

	/**
	 * BeanProvider
	 */
    public class BeanProvider extends EventDispatcher implements IBeanProvider, IMXMLDocument, IDocument
	{
        /**
		 * Constructor
		 */
		public function BeanProvider(beans:Array = null)
		{
			super();
			this.beans = beans;
		}

        protected var _rawBeans:Array = [];
        protected var _beans:Array = [];
		
		[ArrayElementType("Object")]
		public function get beans():Array
		{
			return _beans;
		}
		public function set beans(value:Array):void
		{
			if(value != null && value != _beans && value != _rawBeans)
			{
				_rawBeans = value;
			}
		}

		public function initialize():void
		{
			// first initialize, then attempt to set all bean ids
			initializeBeans();
			setBeanIds();
		}

		protected function initializeBeans():void
		{
			for each(var beanSource:Object in _rawBeans)
			{
				_beans.push(BeanFactory.constructBean(beanSource, null));
			}
		}

		/**
		 * Since the setter for beans should have already created Bean objects for all children,
		 * we are primarily trying to identify the id to set in the bean's name property.
		 *
		 * However, in some cases, we don't always have an array of beans at this time,
		 * so if we don't find a Bean for an element we find in describeType, we create it.
		 */
		protected function setBeanIds():void
		{
			var typeDefinition:TypeDefinition;
			//check whether this BeanProvider is a subclass or inline
			var inspect:Object;
			var inspectOutside:Boolean;
			if (this['constructor'] !== BeanProvider) {
				//normal, mxml subclass
				inspect = this;
			} else {
				//inline BeanProvider
				inspect = this._mxmlDocument;
				inspectOutside = true;
			}
			
			typeDefinition = describeType(inspect);
			
			var beanList:Array = typeDefinition.variables;

			var accessors:Array  = typeDefinition.accessors;
			while (accessors.length) {
				var accessorDef:AccessorDefinition = accessors.shift();
				if (accessorDef.access == 'readwrite') beanList.push(accessorDef);
			}

			var child:*;
			var name:String;
			var beanId:String = null;

			var found:Boolean;
			for each(var varDef:VariableDefinition in beanList) {
				name = varDef.name;
				beanId = varDef is AccessorDefinition ? name : null; 
				if(name != "beans")
				{
					// BeanProvider will take care of setting the type descriptor,
					// but we want to wrap the instances in Bean classes to set the Bean.name to id
					if (name == 'model') { // accessing Royale model accessor can throw an error if it is not set and there is not css value supplied
						try{
							child = varDef.getValue(inspect);
						} catch(e:Error) {
							child = null;
						}
					} else {
						child = varDef.getValue(inspect);
					}
					
					if(child != null)
					{
						found = false;

						// look for any bean we may already have, and set the name propery of the bean object only
						for each(var bean:Bean in beans)
						{
							if((bean == child) || (bean.type == child))
							{
								bean.name = beanId;
								found = true;
								break;
							}
						}

						// if we didn't find the bean, we need to construct it
						if(!found && !inspectOutside)
						{
							beans.push(BeanFactory.constructBean(child, beanId));
						}
					}
				}
			}

		}
		
		public function addBean(bean:Bean):void
		{
			if(beans)
			{
				beans[beans.length] = bean;
			}
			else
			{
				beans = [bean];
			}
		}
		
		public function removeBean(bean:Bean):void
		{
			if(beans)
			{
				beans.splice(beans.indexOf(bean), 1);
			}
		}

		private var _mxmlDescriptor:Array;
		private var _mxmlDocument:Object = this;
		//private var _initialized:Boolean;

		/**
		 *  @copy org.apache.royale.core.Application#MXMLDescriptor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get MXMLDescriptor():Array
		{
			return _mxmlDescriptor;
		}
		
		/**
		 *  @private
		 */
		public function setMXMLDescriptor(document:Object, value:Array):void
		{
			_mxmlDocument = document;
			_mxmlDescriptor = value;
		}
		
		/**
		 *  @private
		 */
		public function setDocument(document:Object, id:String = null):void
		{
			_mxmlDocument = document;
		}
		

		/**
		 *  @copy org.apache.royale.core.Application#generateMXMLAttributes()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function generateMXMLAttributes(data:Array):void
		{
			MXMLDataInterpreter.generateMXMLProperties(this, data);
			if ('_bindings' in this) processStartupBindings();
		}


		/**
		 *  Supports lightweight basic cross-assignment values at startup only. No actual real bindings are created
		 */
		protected function processStartupBindings():void
		{

			var bindingData:Array = this["_bindings"];
			var n:int = bindingData[0];
			//var bindings:Array = [];
			var binding:Object = null;
			var i:int;
			var index:int = 1;
			for (i = 0; i < n; i++)
			{
				binding = {};
				binding.source = bindingData[index++];
				binding.destFunc = bindingData[index++];
				binding.destination = bindingData[index++];

				//bindings.push(binding);

				processStartupAssignment(binding.source, binding.destination);
			}
		}


		protected function processStartupAssignment( source:Object, destination:Object):void{
			var sourceValue:Object;
			var sourceArray:Array;
			var destArray:Array;
			if (source is String) sourceArray = [source];
			else sourceArray = (source as Array).slice();

			sourceValue = this;
			while (sourceArray.length && sourceValue != null) {
				sourceValue = sourceValue[sourceArray.shift()]
			}

			if (sourceValue != null) {
				if (destination is String) destArray = [destination];
				else destArray = (destination as Array).slice();
				destination = this;
				while (destArray.length > 1 && destination) {
					destination = destination[destArray.shift()];
				}
				if (destination) {
					destination[destArray[0]] = sourceValue;
					//trace('startup value assigned ', destArray[0]);
				} else {
					//trace('startup value not assigned in BeanProvider', this);
				}
			}
		}

	}
}

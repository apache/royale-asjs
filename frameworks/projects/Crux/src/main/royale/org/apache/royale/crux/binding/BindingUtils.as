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
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux.binding {
	
	import org.apache.royale.binding.PropertyWatcher;

	public class BindingUtils {
		/**
		 *  Binds a public property or setter function, <code>prop</code> on the <code>site</code>
		 *  Object, to a bindable property or property chain.
		 *  If a CruxBinding instance is successfully created, <code>prop</code>
		 *  is initialized to the current value of <code>chain</code>.
		 *
		 *  @param site The Object defining the root host for the property to be bound
		 *  to <code>chain</code>.
		 *
		 *  @param prop The destination prop chain or a setter function for the destination value
		 *
		 *  @param host The object that hosts the property or property chain
		 *  to be watched.
		 *
		 *  @param chain An Array specifying the chain to be watched.
		 *
		 *
		 *  @return A CruxBinding instance, if at least one property name has
		 *  been specified to the <code>chain</code> argument; null otherwise.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function bindProperty(
				site:Object, prop:Object,
				host:Object, chain:Array):CruxBinding
		{
			
			var cb:CruxBinding = new CruxBinding();
			cb.setDocument(site);
			if (prop is String ) {
				prop = [prop]
			}
			if (prop is Array) {
				cb.destinationData = prop;
			} else {
				cb.destinationFunction = prop as Function;
			}
			
			cb.sourceRoot = host;
			
			if (chain.length==1){
				cb.source = BindableChainInfo(chain[0]).name;
			} else {
				var names:Array = [];
				for each(var info:BindableChainInfo in chain) names.push(info.name);
				cb.source = names;
			}
			
			setupWatchers(cb, chain);

			
			return cb;
		}
		
		
		
		
		/**
		 * @royaleignorecoercion Function
		 * @royaleignorecoercion String
		 */
		private static function setupWatchers(binding:CruxBinding, watcherChain:Array):void
		{
			var watcherInfo:BindableChainInfo = watcherChain[0];
			var parentObject:Object = binding.sourceRoot;
			var watcher:PropertyWatcher;
			var parentWatcher:PropertyWatcher;
			while (watcherInfo)
			{
				var events:Array = [];
				for (var key:String in watcherInfo.changeEvents) {
					if (watcherInfo.changeEvents[key]) {
						events.push(key);
					}
				}
				
				watcher = new PropertyWatcher(parentObject,
						watcherInfo.name,
						events.length ==1 ? events[0] : events, null);

				if (parentWatcher)
				{
					watcher.parentChanged(parentWatcher.value);
				}
				else
				{
					watcher.parentChanged(parentObject);
				}
				
				if (parentWatcher)
				{
					parentWatcher.addChild(watcher);
				}
				
				watcherInfo = watcherInfo.next;
				parentWatcher = watcher;
				
				if (!binding.rootWatcher) binding.rootWatcher= watcher;
			}
			
			watcher.addBinding(binding);
		}
		
	}
}

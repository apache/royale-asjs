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
package org.apache.royale.crux.processors
{
    import org.apache.royale.crux.ICrux;
	
    /**
	 * Base interface that ensures all implementers have a reference to the containing
	 * instance of <code>Crux</code> and a <code>priority</code> to determine
	 * their place in line.
	 */
	public interface IProcessor
	{
		/**
		 * Method used to set reference to parent <code>Crux</code> instance.
		 */
		function init(crux:ICrux):void;
		
		/**
		 * Read-only property used to specify this processor's priority in the list of processors.
		 */
		function get priority():int;
	}
}

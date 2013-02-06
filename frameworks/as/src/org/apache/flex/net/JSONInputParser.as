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
package org.apache.flex.net
{
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.ISelectionModel;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.core.UIBase;
    import org.apache.flex.html.staticControls.beads.SingleLineBorderBead;
    import org.apache.flex.html.staticControls.beads.models.SingleLineBorderModel;
    import org.apache.flex.html.staticControls.supportClasses.Border;
    import org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup;

	public class JSONInputParser implements IInputParser
	{        
		public function parseItems(s:String):Array
        {
            return s.split("},");
        }
	}
}
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
package org.apache.royale.utils
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ValuesManager;

	/**
	*  @return Loaded Bead.
	*  
	*  @langversion 3.0
	*  @playerversion Flash 9
	*  @playerversion AIR 1.1
	*  @productversion Flex 3
	*  @royalesuppressexport
	*  @royaleignorecoercion Class
	*  @royaleignorecoercion Function
	*  @royaleignorecoercion org.apache.royale.core.IBead
	*/
	public function loadBeadFromValuesManager(classOrInterface:Class, classOrInterfaceName:String, strand:IStrand):IBead
	{
		var result:IBead = strand.getBeadByType(classOrInterface);
		if (!result)
		{
			var c:Class = ValuesManager.valuesImpl.getValue(strand, classOrInterfaceName) as Class;
			if (c)
			{
                COMPILE::JS
                {
                    var f:Function = c as Function;
                    result = new f() as IBead;
                }
                COMPILE::SWF
                {
                    result = new c() as IBead;
                }
				if (result)
					strand.addBead(result);
			}
		}
		return result;
	}
}

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
package org.apache.royale.reflection.utils
{
	import org.apache.royale.reflection.TypeDefinition;
	
	
    /**
     *  A utility method to check whether one definition is derived from another
	 *
	 *  This could be to check whether an interface extends another interface, or a class is a subclass of another class
	 *  or whether a class implements an interface.
	 *  
     *  @param targetType TypeDefinition the definition to verify
	 *  @param derivedFrom TypeDefinition the definition to verify against
	 *  @return true if targetType parameter represents some form of 'descendant' of derivedFrom parameter
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
	 *
	 *  @royaleignorecoercion org.apache.royale.reflection.TypeDefinition
	 *  @royalesuppressexport
     */
    public function isDerivedType(targetType:TypeDefinition, derivedFrom:TypeDefinition):Boolean
	{
		if (!targetType || !derivedFrom) throw new Error('both arguments must be non-null');

		//if this is the same definition, then it cannot be a derived type
		if (targetType == derivedFrom || targetType.qualifiedName == derivedFrom.qualifiedName) return false;

		var i:int, l:int;
		var checks:Array;

		if (derivedFrom.kind == 'class') {
			if (targetType.kind == 'interface') return false; //an interface cannot be derived from (be a descendent of) a class
			if (derivedFrom.qualifiedName == 'Object') return true; //always true
			checks = targetType.baseClasses;
		} else {
			//derivedFrom is an interface
			checks = targetType.interfaces;
		}
		l = checks.length;
		var dervivedName:String = derivedFrom.qualifiedName;
		for (i=0; i<l; i++) {
			if (derivedFrom == checks[i] || dervivedName == TypeDefinition(checks[i]).qualifiedName) return true;
		}

		return false;
    }
	
	
}

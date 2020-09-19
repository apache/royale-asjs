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
package
{

/**
 *  @private
 *  This class is used to link additional classes into Reflection.swc
 *  beyond those that are found by dependecy analysis starting
 *  from the classes specified in manifest.xml.
 */
internal class ReflectionClasses
{
	COMPILE::JS
	{
		import org.apache.royale.reflection.nativejs.AS3Array; AS3Array;
		import org.apache.royale.reflection.nativejs.AS3Boolean; AS3Boolean;
		import org.apache.royale.reflection.nativejs.AS3Number; AS3Number;
		import org.apache.royale.reflection.nativejs.AS3int; AS3int;
		import org.apache.royale.reflection.nativejs.AS3uint; AS3uint;
	}
	
	import org.apache.royale.reflection.describeType; describeType;
	import org.apache.royale.reflection.getAliasByClass; getAliasByClass;
	import org.apache.royale.reflection.getClassByAlias; getClassByAlias;
	import org.apache.royale.reflection.getDefinitionByName; getDefinitionByName;
	import org.apache.royale.reflection.getDynamicFields; getDynamicFields;
	import org.apache.royale.reflection.isDynamicObject; isDynamicObject;
	import org.apache.royale.reflection.getQualifiedClassName; getQualifiedClassName;
	import org.apache.royale.reflection.getQualifiedSuperclassName; getQualifiedSuperclassName;
	import org.apache.royale.reflection.registerClassAlias; registerClassAlias;
	//utils
	import org.apache.royale.reflection.utils.getMembersWithMetadata; getMembersWithMetadata;
	import org.apache.royale.reflection.utils.getMembers; getMembers;
	import org.apache.royale.reflection.utils.MemberTypes; MemberTypes;
	import org.apache.royale.reflection.utils.getStaticConstantsByConvention; getStaticConstantsByConvention;
	import org.apache.royale.reflection.utils.getMembersWithNameMatch; getMembersWithNameMatch;
	import org.apache.royale.reflection.utils.getMembersWithQNameMatch; getMembersWithQNameMatch;
	import org.apache.royale.reflection.utils.filterForMetaTags; filterForMetaTags;
	import org.apache.royale.reflection.utils.isDerivedType; isDerivedType;
	import org.apache.royale.reflection.utils.isSameType; isSameType;
	
	import org.apache.royale.reflection.ExtraData; ExtraData;
	import org.apache.royale.reflection.AccessorDefinition; AccessorDefinition;
	import org.apache.royale.reflection.CompilationData; CompilationData;
	import org.apache.royale.reflection.DefinitionBase; DefinitionBase;
	import org.apache.royale.reflection.DefinitionWithMetaData; DefinitionWithMetaData;
	import org.apache.royale.reflection.FunctionDefinition; FunctionDefinition;
	import org.apache.royale.reflection.MemberDefinitionBase; MemberDefinitionBase;
	import org.apache.royale.reflection.MetaDataDefinition; MetaDataDefinition;
	import org.apache.royale.reflection.MetaDataArgDefinition; MetaDataArgDefinition;
	import org.apache.royale.reflection.MethodDefinition; MethodDefinition;
	import org.apache.royale.reflection.ParameterDefinition; ParameterDefinition;
	import org.apache.royale.reflection.TypeDefinition; TypeDefinition;
	import org.apache.royale.reflection.VariableDefinition; VariableDefinition;
	

}

}


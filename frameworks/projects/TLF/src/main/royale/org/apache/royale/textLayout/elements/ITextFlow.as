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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.compose.IFlowComposer;
	import org.apache.royale.textLayout.edit.ISelectionManager;
	import org.apache.royale.textLayout.factory.ITLFFactory;
	import org.apache.royale.events.Event;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	public interface ITextFlow extends IContainerFormattedElement
	{
		function damage(damageStart:int, damageLen:int, damageType:String, needNormalize:Boolean = true):void;
		function processModelChanged(changeType:String, elem:Object, changeStart:int, changeLen:int, needNormalize:Boolean, bumpGeneration:Boolean):void;
		function get formatResolver(): IFormatResolver;
		function getTextLayoutFormatStyle(elem:Object):TextLayoutFormat;
		function getExplicitStyle(elem:Object):TextLayoutFormat;
		function get parentElement():IFlowGroupElement;
		function set parentElement(value:IFlowGroupElement):void;
		function get interactiveObjectCount():int;
		function incInteractiveObjectCount():void;
		function decInteractiveObjectCount():void;
		function get graphicObjectCount():int;
		function incGraphicObjectCount():void;
		function decGraphicObjectCount():void;
		function hasEventListener(type:String):Boolean;
		function dispatchEvent(event:Event):Boolean;
		function getBackgroundManager():IBackgroundManager;
		function get tlfFactory() : ITLFFactory;
		function get backgroundManager():IBackgroundManager;
		function get interactionManager():ISelectionManager;
		function set interactionManager(newInteractionManager:ISelectionManager):void;
		function get configuration():IConfiguration;
		function getElementsByTypeName(typeNameValue:String):Array;
		function appendOneElementForUpdate(elem:IFlowElement):void;
		function processAutoSizeImageLoaded(elem:InlineGraphicElement):void;
		function findAbsoluteParagraph(pos:int):IParagraphElement;
		function nestedInTable():Boolean;
		function get generation():uint;
		function setGeneration(num:uint):void;
		function normalize():void;
		function findAbsoluteFlowGroupElement(pos:int):IFlowGroupElement;
		function set flowComposer(composer:IFlowComposer):void;
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
		// function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
		function invalidateAllFormats():void;
		function clearBackgroundManager():void;
		function mustUseComposer():Boolean;
		function changeFlowComposer(newComposer:IFlowComposer,okToUnloadGraphics:Boolean):void;
		function set hostFormat(value:ITextLayoutFormat):void;
		function get hostFormat():ITextLayoutFormat;
		function applyUpdateElements(okToUnloadGraphics:Boolean):Boolean;
		function unloadGraphics():void;

		CONFIG::debug function debugCheckTextFlow(validateControllers:Boolean = true):int;

	}
}

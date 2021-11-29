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
package org.apache.royale.externsjs.inspiretree.beads
{

	/**
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStyledUIBase;
	import org.apache.royale.core.Strand;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.externsjs.inspiretree.beads.models.InspireTreeModel;
    import org.apache.royale.externsjs.inspiretree.supportClasses.IInspireTree;

    COMPILE::JS
	public class InspireTreeIconBead  extends Strand implements IBead
	{
		/**
		 *  constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */

		public function InspireTreeIconBead()
		{
			super();
		}
        private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get strand():IStrand
        {
            return _strand;
        }
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set strand(value:IStrand):void
		{
            _strand = value;

			if(_typeIconsSet == "")
				_typeIconsSet = "default";

			(_strand as IEventDispatcher).addEventListener("initComplete", init);
		}

		private function init(event:Event):void
		{
			(_strand as IEventDispatcher).removeEventListener("initComplete", init);

			var treeModel:InspireTreeModel = (_strand.getBeadByType(IBeadModel) as InspireTreeModel);
			treeModel.addEventListener("checkboxModeChanged", updateHost);
			treeModel.useCustomStyle = true;

			setIcons(null);
		}

		private var _typeIconsSet:String = "";
		public function get typeIconsSet():String
		{
			return _typeIconsSet;
		}
        [Inspectable(category="General", enumeration="default,custom,customClass,customClasses,none")]
		/**
		 * typeIconsSet property: tree should have parent and child icons or not
		 * default,custom,customClass,customClasses,none
		 */
		public function set typeIconsSet(value:String):void
		{
			if(_typeIconsSet != value)
			{
				_typeIconsSet = value;
				//updateHost(false);
			}
		}
        /**
         * ClassName assigned to the component when typeIconSet is set to 'customClass'.
         */
		private var _className:String = "";
		[Bindable]
		public function get className():String{ return _className; }
		public function set className(value:String):void
		{
			if(_className != value)
			{
				if(_strand && _typeIconsSet == 'customClass' && _className)
					(_strand as IStyledUIBase).removeClass(_className);

				_className = value;
				if(_updateInProgress) return;

				updateHost(false,"className");
			}

		}

		private var _parentIcon:String = "";
		[Bindable]
		public function get parentIcon():String{ return _parentIcon; }
		public function set parentIcon(value:String):void
		{
			if(_parentIcon != value)
			{
				//After initialization
				if(_strand && _typeIconsSet == 'customClasses')
					(_strand as IStyledUIBase).removeClass(_parentIcon);

				_parentIcon = value;
				if(_updateInProgress) return;

				updateHost(false,"parentIcon");
			}

		}
		private var _parentOpenIcon:String = "";
		[Bindable]
		public function get parentOpenIcon():String{ return _parentOpenIcon; }
		public function set parentOpenIcon(value:String):void
		{
			if(_parentOpenIcon != value)
			{
				//After initialization
				if(_strand && _typeIconsSet == 'customClasses')
					(_strand as IStyledUIBase).removeClass(_parentOpenIcon);

				_parentOpenIcon = value;
				if(_updateInProgress) return;

				updateHost(false,"parentOpenIcon");
			}

		}

		private var _parentSelectedIcon:String = "";
		[Bindable]
		public function get parentSelectedIcon():String{ return _parentSelectedIcon; }
		public function set parentSelectedIcon(value:String):void
		{
			if(_parentSelectedIcon != value)
			{
				//After initialization
				if(_strand && _typeIconsSet == 'customClasses')
					(_strand as IStyledUIBase).removeClass(_parentSelectedIcon);

				_parentSelectedIcon = value;
				if(_updateInProgress) return;

				updateHost(false,"parentSelectedIcon");
			}

		}
		private var _parentOpenSelectedIcon:String = "";
		[Bindable]
		public function get parentOpenSelectedIcon():String{ return _parentOpenSelectedIcon; }
		public function set parentOpenSelectedIcon(value:String):void
		{
			if(_parentOpenSelectedIcon != value)
			{
				//After initialization
				if(_strand && _typeIconsSet == 'customClasses')
					(_strand as IStyledUIBase).removeClass(_parentOpenSelectedIcon);

				_parentOpenSelectedIcon = value;
				if(_updateInProgress) return;

				updateHost(false,"parentOpenSelectedIcon");
			}

		}

		private var _childIcon:String = "";
		[Bindable]
		public function get childIcon():String{ return _childIcon; }
		public function set childIcon(value:String):void
		{
			if(_childIcon != value)
			{
				//After initialization
				if(_strand && _typeIconsSet == 'customClasses')
					(_strand as IStyledUIBase).removeClass(_childIcon);

				_childIcon = value;
				if(_updateInProgress) return;

				updateHost(false,"childIcon");
			}
		}
		private var _childSelectedIcon:String = "";
		[Bindable]
		public function get childSelectedIcon():String{ return _childSelectedIcon; }
		public function set childSelectedIcon(value:String):void
		{
			if(_childSelectedIcon != value)
			{
				//After initialization
				if(_strand && _typeIconsSet == 'customClasses')
					(_strand as IStyledUIBase).removeClass(_childSelectedIcon);

				_childSelectedIcon = value;
				if(_updateInProgress) return;

				updateHost(false,"childSelectedIcon");
			}
		}

		private var _minusIcon:String;
		[Bindable]
		public function get minusIcon():String{ return _minusIcon; }
		public function set minusIcon(value:String):void
		{
			if(_minusIcon != value)
			{
				//After initialization
				if(_strand && _typeIconsSet == 'customClasses' && _minusIcon)
					(_strand as IStyledUIBase).removeClass(_minusIcon);

				_minusIcon = value;
				if(_updateInProgress) return;

				updateHost(false,"minusIcon");
			}

		}

		private var _plusIcon:String;
		[Bindable]
		public function get plusIcon():String{ return _plusIcon; }
		public function set plusIcon(value:String):void
		{
			if(_plusIcon != value)
			{
				//After initialization
				if(_strand && _typeIconsSet == 'customClasses' && _plusIcon)
					(_strand as IStyledUIBase).removeClass(_plusIcon);

				_plusIcon = value;
				if(_updateInProgress) return;

				updateHost(false,"plusIcon");
			}

		}

		private var lastUID:String = "";

		private function updateHost( init:Boolean = false, propertyChange:String=""):void
		{
			if(!strand)
				return;

			//var hostelement:Element = (_strand as StyledUIBase).element;
			var checkboxMode:Boolean =(_strand.getBeadByType(IBeadModel) as InspireTreeModel).checkboxMode;
            var existClasswithoutCB:Boolean = (_strand as IStyledUIBase).containsClass('withoutcheckbox') ? true : false;

            if(checkboxMode && existClasswithoutCB)
            {
				(_strand as IStyledUIBase).removeClass('withoutcheckbox');
                existClasswithoutCB = false;
            }

			if(_typeIconsSet == "custom")
			{
				var currentUID:String = (_strand as IInspireTree).uid;

				if(lastUID == "") lastUID = currentUID;

				if(lastUID != currentUID )
				{
					//If the uid has changed:
					// 1- We remove the reference to the previous class from the component.
					(_strand as IStyledUIBase).removeClass("itreecustom"+lastUID);

					// 2- And we delete the styles associated with the previous uid and create the new ones.
            		var lastStyle:HTMLStyleElement = document.getElementById("itreecustom"+lastUID) as HTMLStyleElement;
					if(lastStyle)
					{
						//https://www.w3.org/wiki/Dynamic_style_-_manipulating_CSS_with_JavaScript
						lastStyle.parentNode.removeChild(lastStyle);
					}
				}

				var ruleHTML:String ="";
				var selector:String = "itreecustom"+currentUID;
				var arSelectors:Object = {};

				if(!_parentIcon) ruleHTML=""; else	ruleHTML="url(" + _parentIcon +")";
				arSelectors["parentIcon"] = {prop:"parentIcon", selectorId:".inspire-tree." + selector + " .icon-folder::before", value:ruleHTML};
				if(!_parentOpenIcon) ruleHTML=""; else	ruleHTML="url(" + _parentOpenIcon +")";
				arSelectors["parentOpenIcon"] = {prop:"parentOpenIcon", selectorId:".inspire-tree." + selector + " .icon-folder-open::before", value:ruleHTML};
				if(!_parentSelectedIcon) ruleHTML=""; else	ruleHTML="url(" + _parentSelectedIcon +")";
				arSelectors["parentSelectedIcon"] = {prop:"parentSelectedIcon", selectorId:".inspire-tree." + selector + " .selected > .title-wrap .icon-folder::before", value:ruleHTML};
				if(!_parentOpenSelectedIcon) ruleHTML=""; else	ruleHTML="url(" + _parentOpenSelectedIcon +")";
				arSelectors["parentOpenSelectedIcon"] = {prop:"parentOpenSelectedIcon", selectorId:".inspire-tree." + selector + " .selected > .title-wrap .icon-folder-open::before", value:ruleHTML};
				if(!_childIcon) ruleHTML=""; else	ruleHTML="url(" + _childIcon +")";
				arSelectors["childIcon"] = {prop:"childIcon", selectorId:".inspire-tree." + selector + " .icon-file-empty::before", value:ruleHTML};
				if(!_childSelectedIcon) ruleHTML=""; else	ruleHTML="url(" + _childSelectedIcon +")";
				arSelectors["childSelectedIcon"] = {prop:"childSelectedIcon", selectorId:".inspire-tree." + selector + " .selected > .title-wrap .icon-file-empty::before", value:ruleHTML};
				if(!_minusIcon) ruleHTML=""; else	ruleHTML="url(" + _minusIcon +")";
				arSelectors["minusIcon"] = {prop:"minusIcon", selectorId:".inspire-tree." + selector + " .icon-collapse::before", value:ruleHTML};
				if(!_plusIcon) ruleHTML=""; else	ruleHTML="url(" + _plusIcon +")";
				arSelectors["plusIcon"] = {prop:"plusIcon", selectorId:".inspire-tree." + selector + " .icon-expand::before", value:ruleHTML};

				var style:HTMLStyleElement = document.getElementById(selector) as HTMLStyleElement;
				if(!style)
				{
					ruleHTML ="";
					if(!style)
					{
						style = document.createElement('style') as HTMLStyleElement;
						style.type = 'text/css';
						style.id = selector;
						propertyChange = "new";
					}

					for each(var prop:Object in arSelectors)
					{
						//Our CSS example icon "expand = plusIcon" '>' has a flip transformation applied, we need to override it.
						var selectorString:String = prop.selectorId + " { background-image: " + prop.value + ";";
						if( prop.prop == "plusIcon" && _plusIcon)
							selectorString += " -webkit-transform: rotate(0deg); -ms-transform: rotate(0deg); transform: rotate(0deg); " + " }";
						selectorString +=  " }";
						ruleHTML += selectorString + ' ';
					}
					style.innerHTML = ruleHTML;
					//What is the difference between adding to the body and adding to the head?
					//org.apache.royale.utils.css.addDynamicSelector adds the style tag in the header, I guess that's the right thing to do :) //document.getElementsByTagName('head')[0].appendChild(style);
					//document.body.appendChild(style);
					if(propertyChange == "new")
						document.head.appendChild(style);
				}
				//if propertyChange != "" --> Update by change property, modify rule
				else if(propertyChange != "")
				{
					//https://www.w3.org/TR/DOM-Level-2-Style/css.html#CSS-CSSStyleDeclaration
					var sheet:CSSStyleSheet = style.sheet as CSSStyleSheet;
					var rulecss:Object;
					var selectorItem:Object = arSelectors[propertyChange];

					for(var idxrule:int = 0; idxrule< sheet.cssRules.length; idxrule++)
					{
						rulecss = sheet.cssRules[idxrule];
						if(rulecss.selectorText == selectorItem.selectorId)
						{
							rulecss.style["background-image"] = selectorItem.value;
							if( selectorItem.prop == "plusIcon" && _plusIcon){
								rulecss.style["-webkit-transform"] = 'rotate(0deg)';
								rulecss.style["-ms-transform"] = 'rotate(0deg)';
								rulecss.style["transform"] = 'rotate(0deg)';
							}
							break;
						}
					}
				}
				if( !(_strand as IStyledUIBase).containsClass(selector) )
					(_strand as IStyledUIBase).addClass(selector);

				lastUID = currentUID;
			}
			else if(_typeIconsSet == "customClass")
			{
				if(_className != "")
					(_strand as IStyledUIBase).addClass(_className);
			}
			else if(_typeIconsSet == "none")
			{
				(_strand as IStyledUIBase).addClass("noneicon");
			}
			else if(_typeIconsSet == 'customClasses')
			{
				if(_parentIcon != "" && (propertyChange == "" || propertyChange == "parentIcon") )
					(_strand as IStyledUIBase).addClass(_parentIcon);
				if(_parentOpenIcon != "" && (propertyChange == "" || propertyChange == "parentOpenIcon") )
					(_strand as IStyledUIBase).addClass(_parentOpenIcon);
				if(_parentSelectedIcon != "" && (propertyChange == "" || propertyChange == "parentSelectedIcon") )
					(_strand as IStyledUIBase).addClass(_parentSelectedIcon);
				if(_parentOpenSelectedIcon != "" && (propertyChange == "" || propertyChange == "parentOpenSelectedIcon") )
					(_strand as IStyledUIBase).addClass(_parentOpenSelectedIcon);
				if(_childIcon != "" && (propertyChange == "" || propertyChange == "childIcon") )
					(_strand as IStyledUIBase).addClass(_childIcon);
				if(_childSelectedIcon != "" && (propertyChange == "" || propertyChange == "childSelectedIcon") )
					(_strand as IStyledUIBase).addClass(_childSelectedIcon);
				if(_minusIcon != "" && (propertyChange == "" || propertyChange == "minusIcon") )
					(_strand as IStyledUIBase).addClass(_minusIcon);
				if(_plusIcon != "" && (propertyChange == "" || propertyChange == "plusIcon") )
					(_strand as IStyledUIBase).addClass(_plusIcon);
			}

			if(!checkboxMode && !existClasswithoutCB)
				(_strand as IStyledUIBase).addClass('withoutcheckbox');

		}

		private var _updateInProgress:Boolean = false;
		/**
		 * Allows all properties to be defined in a single object.
		 * It is recommended to use this function to set any icons after initialisation.
		 *
		 * @param collectionIcons 	A "property-Icon": "value-Icon" pair object is expected.
		 * 							A null value will be interpreted as if typeIconsSet='default'.
		 * Examples:
		 * 		setIcons( {typeIconsSet:'default'} );
		 *
		 * 		setIcons( {typeIconsSet:'none'} );
		 *
		 * 		setIcons( {typeIconsSet:'customClass', className:'className'} );
		 *
		 * 		setIcons( {typeIconsSet:'customClasses', parentIcon:'folderClosedIconCSSClass', parentOpenIcon:'folderOpenIconCSSClass',
		 *  	 parentSelectedIcon:'folderSelectedClosedIconCSSClass', parentOpenSelectedIcon:'folderSelectedOpenIcon',
		 * 		 childIcon:'defaultLeafIconCSSClass', childSelectedIcon:'defaultSelectedLeafIconCSSClass',
		 * 		 minusIcon:'disclosureClosedIconCSSClass', plusIcon:'disclosureOpenIconCSSClass'} );
		 *
		 * 		setIcons( {typeIconsSet:'custom', parentIcon:'folderClosedIcon.svg', parentOpenIcon:'folderOpenIcon.svg',
		 *  	 parentSelectedIcon:'folderSelectedClosedIcon.svg', parentOpenSelectedIcon:'folderSelectedOpenIcon',
		 * 		 childIcon:'defaultLeafIcon.svg', childSelectedIcon:'defaultSelectedLeafIcon.svg',
		 * 		 minusIcon:'disclosureClosedIcon.svg', plusIcon:'disclosureOpenIcon.svg'} );
		 */
		public function setIcons(collectionIcons:Object = null):void
		{

			_updateInProgress = true;

			var prop:Object = {typeIconsSet:_typeIconsSet, className:_className, parentIcon:_parentIcon, parentOpenIcon:_parentOpenIcon,
		   	 				parentSelectedIcon:_parentSelectedIcon, parentOpenSelectedIcon:_parentOpenSelectedIcon,
		  		 			childIcon:_childIcon, childSelectedIcon:_childSelectedIcon,
		  		 			minusIcon:_minusIcon, plusIcon:_plusIcon};

			if(collectionIcons == null)
                collectionIcons = prop;
            else{
                if(collectionIcons.hasOwnProperty('typeIconsSet')) prop.typeIconsSet = collectionIcons.typeIconsSet;
                if(collectionIcons.hasOwnProperty('className')) prop.className = collectionIcons.className;
                if(collectionIcons.hasOwnProperty('parentIcon')) prop.parentIcon = collectionIcons.parentIcon;
                if(collectionIcons.hasOwnProperty('parentOpenIcon')) prop.parentOpenIcon = collectionIcons.parentOpenIcon;
                if(collectionIcons.hasOwnProperty('parentSelectedIcon')) prop.parentSelectedIcon = collectionIcons.parentSelectedIcon;
                if(collectionIcons.hasOwnProperty('parentOpenSelectedIcon')) prop.parentOpenSelectedIcon = collectionIcons.parentOpenSelectedIcon;
                if(collectionIcons.hasOwnProperty('childIcon'))	prop.childIcon = collectionIcons.childIcon;
                if(collectionIcons.hasOwnProperty('childSelectedIcon'))	prop.childSelectedIcon = collectionIcons.childSelectedIcon;
                if(collectionIcons.hasOwnProperty('minusIcon'))	prop.minusIcon = collectionIcons.minusIcon;
                if(collectionIcons.hasOwnProperty('plusIcon')) prop.plusIcon = collectionIcons.plusIcon;
            }

			//Change of configuration type
			if(collectionIcons.typeIconsSet != _typeIconsSet)
			{
				//Revert the configuration associated with the previous typeIconsSet

				if(!_strand){
					//If the component has not yet been initialised for the first time...
                    className = prop.className;
					parentIcon = prop.parentIcon;
					parentOpenIcon = prop.parentOpenIcon;
					parentSelectedIcon = prop.parentSelectedIcon;
					parentOpenSelectedIcon = prop.parentOpenSelectedIcon;
					childIcon = prop.childIcon;
					childSelectedIcon = prop.childSelectedIcon;
					minusIcon = prop.minusIcon;
					plusIcon = prop.plusIcon;
					typeIconsSet = prop.typeIconsSet;
					return;

				}else if(_typeIconsSet == 'custom' && lastUID != "")
				{
					(_strand as IEventDispatcher).removeEventListener("onCreationComplete", updateHost);
					(_strand as IStyledUIBase).removeClass("itreecustom"+lastUID);
					var lastStyle:HTMLStyleElement = document.getElementById("itreecustom"+lastUID) as HTMLStyleElement;
					if(lastStyle)
						lastStyle.parentNode.removeChild(lastStyle);
				}
				else if(_typeIconsSet == 'customClasses')
				{
					if(_parentIcon != "")
						(_strand as IStyledUIBase).removeClass(_parentIcon);
					if(_parentOpenIcon != "")
						(_strand as IStyledUIBase).removeClass(_parentOpenIcon);
					if(_parentSelectedIcon != "")
						(_strand as IStyledUIBase).removeClass(_parentSelectedIcon);
					if(_parentOpenSelectedIcon != "")
						(_strand as IStyledUIBase).removeClass(_parentOpenSelectedIcon);
					if(_childIcon != "")
						(_strand as IStyledUIBase).removeClass(_childIcon);
					if(_childSelectedIcon != "")
						(_strand as IStyledUIBase).removeClass(_childSelectedIcon);
					if(_minusIcon != "")
						(_strand as IStyledUIBase).removeClass(_minusIcon);
					if(_plusIcon != "")
						(_strand as IStyledUIBase).removeClass(_plusIcon);
				}
				else if(_typeIconsSet == 'customClass')
				{
					if(_className != "")
						(_strand as IStyledUIBase).removeClass(_className);
				}
				else if(_typeIconsSet == 'none')
				{
					(_strand as IStyledUIBase).removeClass("noneicon");
				}
			}

			//Apply the new configuration
			if(prop.typeIconsSet == 'default' || prop.typeIconsSet == 'none' || prop.typeIconsSet == 'customClass')
			{
				parentIcon = "";
				parentOpenIcon = "";
				parentSelectedIcon = "";
				parentOpenSelectedIcon = "";
				childIcon = "";
				childSelectedIcon = "";
				minusIcon = "";
				plusIcon = "";
			}
			else //'custom' - 'customClasses'
			{

				if(prop.typeIconsSet == 'custom' && _typeIconsSet != 'custom')
					(_strand as IEventDispatcher).addEventListener("onCreationComplete", updateHost);

				//If we have not changed theSet type, one of the properties has been changed.
				parentIcon = prop.parentIcon;
				parentOpenIcon = prop.parentOpenIcon;
				parentSelectedIcon = prop.parentSelectedIcon;
				parentOpenSelectedIcon = prop.parentOpenSelectedIcon;
				childIcon = prop.childIcon;
				childSelectedIcon = prop.childSelectedIcon;
				minusIcon = prop.minusIcon;
				plusIcon = prop.plusIcon;
			}
			_typeIconsSet = prop.typeIconsSet;

			updateHost(false,"");

			_updateInProgress = false;

		}

	}

    COMPILE::SWF
	public class InspireTreeIconBead
	{
    }
}

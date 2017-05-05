/**

Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to You under the Apache License, Version 2.0
(the "License"); you may not use this file except in compliance with
the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/
package
{

import org.apache.flex.core.Application;
import org.apache.flex.core.ItemRendererClassFactory;
import org.apache.flex.core.SimpleCSSValuesImpl;
import org.apache.flex.events.Event;
import org.apache.flex.html.beads.CSSButtonView;
import org.apache.flex.html.beads.CSSTextButtonView;
import org.apache.flex.html.beads.CSSTextToggleButtonView;
import org.apache.flex.html.beads.CheckBoxView;
import org.apache.flex.html.beads.ContainerView;
import org.apache.flex.html.beads.DataItemRendererFactoryForArrayData;
import org.apache.flex.html.beads.DropDownListView;
import org.apache.flex.html.beads.ListView;
import org.apache.flex.html.beads.RadioButtonView;
import org.apache.flex.html.beads.SingleLineBorderBead;
import org.apache.flex.html.beads.SolidBackgroundBead;
import org.apache.flex.html.beads.TextAreaView;
import org.apache.flex.html.beads.TextButtonMeasurementBead;
import org.apache.flex.html.beads.TextFieldLabelMeasurementBead;
import org.apache.flex.html.beads.TextFieldView;
import org.apache.flex.html.beads.TextInputWithBorderView;
import org.apache.flex.html.beads.TextItemRendererFactoryForArrayData;
import org.apache.flex.html.beads.controllers.DropDownListController;
import org.apache.flex.html.beads.controllers.ItemRendererMouseController;
import org.apache.flex.html.beads.controllers.EditableTextKeyboardController;
import org.apache.flex.html.beads.controllers.ListSingleSelectionMouseController;
import org.apache.flex.html.beads.layouts.BasicLayout;
import org.apache.flex.html.beads.layouts.VerticalLayout;
import org.apache.flex.html.beads.models.ArraySelectionModel;
import org.apache.flex.html.beads.models.SingleLineBorderModel;
import org.apache.flex.html.beads.models.TextModel;
import org.apache.flex.html.beads.models.ToggleButtonModel;
import org.apache.flex.html.beads.models.ValueToggleButtonModel;
import org.apache.flex.html.beads.models.ViewportModel;
import org.apache.flex.html.supportClasses.ContainerContentArea;
import org.apache.flex.html.supportClasses.DropDownListList;
import org.apache.flex.html.supportClasses.DataGroup;
import org.apache.flex.html.supportClasses.ScrollingViewport;
import org.apache.flex.html.supportClasses.Viewport;
import org.apache.flex.html.supportClasses.StringItemRenderer;
import org.apache.flex.net.HTTPService;
import org.apache.flex.collections.parsers.JSONInputParser;
import org.apache.flex.collections.LazyCollection;
import org.apache.flex.utils.ViewSourceContextMenuOption;

import models.MyModel;
import controllers.MyController;

public class DataBindingExample extends Application
{
    
    public function DataBindingExample()
    {
        addEventListener("initialize", initializeHandler);
        var vi:SimpleCSSValuesImpl = new SimpleCSSValuesImpl();
        setupStyles(vi);
        valuesImpl = vi;
        initialView = new MyInitialView();
        model = new MyModel();
        controller = new MyController(this);
        service = new HTTPService();
        collection = new LazyCollection();
        collection.inputParser = new JSONInputParser();
        collection.itemConverter = new StockDataJSONItemConverter();
        service.addBead(collection);
        addBead(service);
        addBead(new ViewSourceContextMenuOption());
    }
        
    public var service:HTTPService;
    public var collection:LazyCollection;
    
    private function initializeHandler(event:Event):void
    {
        MyModel(model).stockSymbol="ADBE";
    }

    private function setupStyles(vi:SimpleCSSValuesImpl):void
    {
        var viv:Object = vi.values = {};
        viv["global"] = 
        {
            fontFamily: "Arial",
            fontSize: 12        
        };
        
        var o:Object;
        
        o = viv[makeDefinitionName("org.apache.flex.html::Container")] =
        {
            
            iBeadView: ContainerView,
    		iBeadLayout: BasicLayout,
    		iContentView: ContainerContentArea,
			iViewport: Viewport,
			iViewportModel: ViewportModel
        };
        
        o = viv[makeDefinitionName("org.apache.flex.core::View")] =
        {
            
            iBeadView: ContainerView,
    		iBeadLayout: BasicLayout,
    		iContentView: ContainerContentArea,
			iViewport: Viewport,
			iViewportModel: ViewportModel
        };
		
        COMPILE::SWF {
            o.iBackgroundBead = SolidBackgroundBead;
            o.iBorderBead = SingleLineBorderBead;
        }
            
        viv[makeDefinitionName("org.apache.flex.html::List")] = 
        {
            iBeadModel: ArraySelectionModel,
            iBeadView:  ListView,		
            iBeadController: ListSingleSelectionMouseController,
            iBeadLayout: VerticalLayout,
            iContentView: DataGroup,
            iDataProviderItemRendererMapper: DataItemRendererFactoryForArrayData,
			iViewport: ScrollingViewport,
			iViewportModel: ViewportModel,
            iItemRendererClassFactory: ItemRendererClassFactory,
            iItemRenderer: StringItemRenderer
        };
        
        o = viv[makeDefinitionName("org.apache.flex.html::Button")] =
        {
            backgroundColor: 0xd8d8d8,
            border: [1, "solid", 0x000000],
            padding: 4
        };
        COMPILE::SWF {
            o.iBeadView = CSSButtonView;
        }
            
        viv[makeDefinitionName("org.apache.flex.html::Button:hover")] =
        {
            backgroundColor: 0x9fa0a1,
            border: [1, "solid", 0x000000],
            padding: 4
        };
        
        viv[makeDefinitionName("org.apache.flex.html::Button:active")] =
        {
            backgroundColor: 0x929496,
            border: [1, "solid", 0x000000],
            padding: 4
        };
        
        COMPILE::SWF {
            viv["org.apache.flex.html::CheckBox"] =
            {
                iBeadModel: ToggleButtonModel,
                iBeadView:  CheckBoxView
            };
            
            viv["org.apache.flex.html::DropDownList"] =
            {
                iBeadModel: ArraySelectionModel,
                iBeadView: DropDownListView,
                iBeadController: DropDownListController,
                iPopUp: DropDownListList
            };
            
            viv["org.apache.flex.html.supportClasses::DropDownListList"] =
            {
                iBeadModel: ArraySelectionModel,
                iDataProviderItemRendererMapper: TextItemRendererFactoryForArrayData,
                iItemRendererClassFactory: ItemRendererClassFactory,
                iItemRenderer: StringItemRenderer,
			    iBackgroundBead: SolidBackgroundBead,
				borderStyle: "solid",
    			borderRadius: 4,
			    borderColor: 0,
			    borderWidth: 1,
			    backgroundColor: 0xFFFFFF
            };
            
            viv["org.apache.flex.html::Label"] =
            {
                iBeadModel: TextModel,
                iBeadView: TextFieldView,
                iMeasurementBead: TextFieldLabelMeasurementBead
            };
    
            viv["org.apache.flex.html::List"] =
            {
                iBorderBead: SingleLineBorderBead,
                iBorderModel: SingleLineBorderModel
            };
    
            viv["org.apache.flex.html::RadioButton"] =
            {
                iBeadModel: ValueToggleButtonModel,
                iBeadView:  RadioButtonView
            };
            
            viv["org.apache.flex.html::TextArea"] =
            {
                iBeadModel: TextModel,
                iBeadView: TextAreaView,
                iBeadController: EditableTextKeyboardController,
                iBorderBead: SingleLineBorderBead,
                iBorderModel: SingleLineBorderModel,
			    borderStyle: "solid",
    			borderColor: 0,
    			borderWidth: 1,
    			backgroundColor: 0xFFFFFF
            };
            
            viv["org.apache.flex.html::TextButton"] =
            {
                iBeadModel: TextModel,
                iBeadView: CSSTextButtonView,
                iMeasurementBead: TextButtonMeasurementBead
            };
    
            viv["org.apache.flex.html::TextInput"] =
            {
                iBeadModel: TextModel,
                iBeadView: TextInputWithBorderView,
                iBeadController: EditableTextKeyboardController,
                iBorderBead: SingleLineBorderBead,
			    iBackgroundBead: SolidBackgroundBead,
			    borderStyle: "solid",
    			borderColor: 0,
    			borderWidth: 1,
    			backgroundColor: 0xFFFFFF
            };
            
            viv["org.apache.flex.html::ToggleTextButton"] =
            {
                iBeadModel: ToggleButtonModel,
                iBeadView:  CSSTextToggleButtonView
            };
    
            viv["org.apache.flex.html::SimpleList"] =
            {
                iBeadModel: ArraySelectionModel,
                iBeadView:  ListView,
                iBeadController: ListSingleSelectionMouseController,
                iBeadLayout: VerticalLayout,
                iContentView: DataGroup,
                iDataProviderItemRendererMapper: TextItemRendererFactoryForArrayData,
	    		iViewport: ScrollingViewport,
	    		iViewportModel: ViewportModel,
                iItemRendererClassFactory: ItemRendererClassFactory,
                iItemRenderer: StringItemRenderer
            }
            
            viv["org.apache.flex.html.supportClasses::StringItemRenderer"] =
            {
                iBeadController: ItemRendererMouseController,
                height: 16
            }
        }
    }
    
    private function makeDefinitionName(s:String):String
    {
        COMPILE::JS {
            s = s.replace("::", ".");
        }
        return s;
    }
}

}

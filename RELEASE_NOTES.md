Apache Royale 0.9.10
====================

- RoyaleUnit
  - Added BDD-style expect() method for natural language assertions
  - Added a number of new asserts, including checks for NaN, less than, greater than, less or equal, greater or equal, within range, is of type, throws exception, and matches regular expression.

Apache Royale 0.9.9
===================

-MXRoyale
 - MXRoyale has been split 2 libs : MXRoyaleBase (mostly non-UI code) and MXRoyale (mostly UI code). Users of MXRoyale should see no immediate changes as the build of this swc remains the same.
 - Listen to children's resize events to fix some layout issues
 - Various fixes to measured sizes (ComboBox, and other UI components)
 - Fixes to labels in item renderers not displaying correctly
 - ComboBox prompt fixes
 - ArrayCollection.refresh() updating lists
 - Various fixes to labels in item renderers not showing correctly
 - Add option to add custom header renderers to data grids
 - Fix issues with Menu.show() when receiving non-null parent arguments
 - Improve emulation of ADG's expand/collapse behavior

 -SparkRoyale
 - ComboBox sizing improvements
 
 -Basic
 - Improvements to DragBead's out of bounds behavior

 -RoyaleUnit
 - Fix coercion error in MetadataRunner when expecting an exception in a test, like [Test(expected="RangeError")]

 -Reflection
 - getQualifiedSuperclassName() can find the superclass of a Class object in JS, matching the behavior of SWF

 -Examples
 - Ace example running in Maven
 - Added Jewel TriStateCheckBox example in [Tour De Jewel](https://royale.apache.org/tourdejewel/)

 -Jewel
  - Improved:
    - Added emphasized and secondary sass settings for Jewel CheckBox / Switch
  - New:
    - Added Jewel TriStateCheckBox and some associated beads: TriStateCheckBoxTooltipState, TriStateCheckBoxState
    - Added ComboBoxReadOnly bead

 -Icons
  - Icon constants have been added to MaterialIconType and FontAwesome5IconType
 
 
Apache Royale 0.9.8
===================
- Core
 - Added getClassStyle function that gets an Object with all styles in a CSS className.
- Basic
  - Move getParentEventTarget() from EventDispatcher to UIBase to reduce required dependencies. This allows EventDispatcher to be used in non-GUI contexts, such as Node.js.
  - UIBase: added loadBeads hook method
  - Added BrowserResizeListener bead that listen for browser resizing and resizes a component accordingly. The old bead was renamed to "BrowserResizeApplicationListener"
  - StyledUIBase & ClassSelectorListSupport: added replaceClass method
  - Added ILabelFunction and LabelFunction bead
  - Added LayoutChildren: A bead to trigger the layout in children. Added support in StyledLayoutBase.
  - Added interfaces for better extension in Basic and Jewel: IColumns, ITableModel, ITableView, ITextButton, IPaddings, IPositioning
  - Paddings: New bead to add padding in mxml to a component
  - Positioning: New bead to add positioning in mxml to a component
  - Add SelectionDataItemRendererFactoryForCollectionView to handle ISelectionModel for components that uses selection and add/remove/update items at runtime.

- RoyaleUnit
  - Fixed issue where CIListener incorrectly escaped quotes in messages.
  - Better error messages when [BeforeClass] or [AfterClass] is detected, but the method is not found by reflection.
- Jewel
  - ASDocs: multiple refactors in many components to document and describe components better.
  - Item Renderers
    - Refactor to make Basic Layout the default (horizontal was the default).
    - Initializers now use new Paddings bead. Create a default if one is not found.
    - Remove the minimum height of 34px, so we can have renderers with less height.
  - New BinaryImage component.
  - Card:
    - New CardExpandedContent: Used for content like navigation bars that need to avoid padding.
  - Button, CheckBox, RadioButton: 
    - add "spanLabel" to separate the text from other decorations like icons and get more control over styling.
  - Image: added "loadComplete" event.
    - New ClipImage bead for images to allow clipping.
    - New ErrorImage beads.
  - Added SimpleLoader component that shows an indeterminate spin circle.
  - DataContainer
    - dataProvider is now the DefaultProperty.
  - List 
    - Added label function through beads.
    - New ListAlternateRowColor bead (should be temporary until we get nth-child css styles working in compiler)
    - dataProvider is now the DefaultProperty.
    - Fixes on SearchFilterForList.
  - ComboBox:
    - Fixed sizing issues
    - Improved speed of opening a popup.
    - New ComboBoxItemByField bead that lets you select an item by field.
    - dataProvider is now the DefaultProperty.
    - Add item renderer support at mxml (TLC) level.
    - Fixes to SearchFilter.
  - DateField:
    - Fixed sizing issues.
  - TabBar: 
    - Multiple refactors to decouple functionality in beads and make renderers more flexible. Now we allow vertical layoutss and indicators in renderers can be positioned in different places.
    - Add "sameWidths" to make all buttons share the same width.
    - dataProvider is now the DefaultProperty.
  - Table
    - Refactored to get better scrolling and fixed header.
    - Added label function through beads.
    - New TableAlternateRowColor bead.
    - Solved RTE when setting columns at runtime.
    - Added Initializer.
    - New TableAlternateRowColor bead (should be temporary until we get nth-child css styles working in the compiler)
    - Removed CRUD beads and added new CRUDTableItemRendererFactoryForCollectionView.
  - DataGrid
    - Multiple fixes in column dimensions to allow more configurations.
    - Added sorting through DataGridSortBead.
    - Added swapping of columns.
    - Added label function through beads.
    - dataProvider is now the DefaultProperty.
    - Added item renderer support at mxml (TLC) level.
  - PresentationModels refactor for List and DataGrid based controls to allow more flexibility.
  - NumericStepper:
    - Fixed sizing issues.
  - New responsive beads: ResponsiveSize, ResponsiveResizeListener and ResponsiveLabelVisibility.
  - New TileHorizontalLayout and TileVerticalLayout beads.
  - New ViewLayout for View.
  - Removed Jewel ControlBar since it was just an HGroup.
  - Jewel Themes:
    - Lots of changes to accommodate the rest of component development and fixes in Jewel.
    - Added fluid text sizing responsiveness, so size of text shrinks or grows depending on device to fit on different screens.
  - Start of VirtualDataGrid component (still has some issues).
- Collections
  - ArrayList.length now is bindable.

- Maven Distribution:
  The distributions built by Maven should now be equivalent to those of the Ant build.
  
- Maven Archetypes:
  - Updated royale-simple-application-archetype
  - Nw royale-jewel-application-archetype.
  - New royale-jewel-module-application-archetype.
  - New royale-jewel-crux-application-archetype

Apache Royale 0.9.7
===================

- Reflection support improved (supports access to custom namespaces) including improved utility methods
- Added a 'getTimer' emulation to Core library, similar to 'flash.utils.getTimer'
- added [RoyaleArrayLike] implementation support to Royale Collections, and BinaryData
- improvements to XML/E4X conformance, and memory footprint
- General improvements in Bindings, including function bindings
- Added new Router classes
- Added AMFLocalStorage, a javascript version of the Flash runtime LSO (Local Shared Object)
- Added new ItemRendererInitializer bead infrastructure to decouple better item renderers functionality
- Added ToolTipRemovalWhenItemRemoved for renderers that use tooltips.
- Fix bin/mxmlc and bin/compc scripts that did not understand certain default compiler options in royale-config.xml
- Crux:
  - Improved:
    - Crux can now be used in MXRoyale and SparkRoyale applications
  - New:
    - Added support for using Command pattern to Crux
    - Added Documentation in royale-docs site
- Graphics:
  - New:
    - Added new high-parity swf graphics emulation (UIGraphicBase)
- Jewel:
  - Improved:
    - Massive refactors and improvements
    - Hierarchy improved in many Jewel framework branches to make StyleUIBase the base of all components and unify APIs.
    - StyleUIBase now improve width and height, so we can use NaN values to unset values. For JS this means return to default values.
    - Card: Added new subcomponents (CardHeader, CardTitle, CardPrimaryContent and CardActions)
    - Button: Added new unboxed and outlined styles (also to IconButton and ToggleButton)
    - CheckBox and RadioButton now can size the icon part
    - ComboBox can now configure custom renders and supports rowCount, and fixed percent width. Also, popup adapts to data provider length.
    - List supports now variableRowHeight, scrollToIndex and can be navigated with arrow cursors (up/down)
    - Item Renderer: Use the new Initializer infrastructure
    - Remove mappers to rely on basic ones, also remove CRUD beads (Add, Remove and Update item beads)
    - Layouts, Group and Container supports variableRowHeight
    - Layouts many fixes and improvements in alignment, and now children dispatch a "sizeChanged"
    - Viewport and ScrollingViewport refactor. Viewport has now clipContent so Container can activate/deactivate
    - added tabindex in many components and to Disabled bead (=-1)
    - Prompt beads now support changes at runtime
    - TabBar: fix AssignTabContent bead when change dataProvider 
    - Jewel Themes was updated to show many visual improvements in colors and styles. Flat and Light themes are almost finished. Still Dark themes are work in progress.
    - [Tour De Jewel](https://royale.apache.org/tourdejewel/) was updated to show all the latest updates
  - New:
    - Runtime Theme Switch. Can be seen working in Tour De Jewel
    - StyledUIBase now adds min and max width and height properties.
    - Added VSlider. The original Slider is now HSlider.
    - Added Paddings bead
    - Added VContainer and HContainer for clipped content
    - Added DataGrid
    - Added ButtonBar
    - Added ComboBoxTruncateText
    - Added DrawerFooter
    - Added VirtualList and VirtualComboBox to load huge amounts of data in a performant way
    - New colors for text and icons (lightest, light, normal, dark and darkest)
    - Added Jewel TodoMVC and TodoMVC with Crux examples following the [TodoMVC](http://todomvc.com/) website guidelines. Also added more blog examples. 
- Icons
    - Refactored classes IIcon classes to support more icons sets
    - Added FontAwesome v5 support (also v4)
    - Icons now support Material and FontAwesome (more sets can be added)
- SVG:
    - Fixed SVGImage when using Maven
- Network:
  - Improved:
    - URLLoader now respects contentType passed in via URLRequest.
  - New:
    - Added URLVariables emulation
- MXRoyale: 
  - Improved: 
    - mx.utils.ObjectUtil - improved parity
    - mx.net.SharedObject - improved parity
    - [add support for legacy HttpService decoding format](https://github.com/apache/royale-asjs/issues/466)
    - Fixes in mx.messaging for polling support, mx.external.ExternalInterface
  - New:
    - mx.net.SharedObjectJSON - new alternative
- Maven:
  - Massive improvements
  - Now Maven can generate a valid distribution (SDK) to use in any IDE (tested on VSCode and Moonshine)
  - distribution can be JS only
  - SASS generation is now separated from main build to a profile to save lots of time when no need to build themes
- RoyaleUnit:
  - [Test(async)] may be used to define asynchronous tests
  - [BeforeClass] and [AfterClass] metadata must be added to static methods
  - [Test] metadata supports an 'expected' attribute to expect a thrown exception
  - Fixed incorrect order of expected and actual values in assert messages
- RoyaleUnitUI: An optional UI to display the results of RoyaleUnit tests
- Dozens of bugs reported, investigated, and squashed. For details of
  closed bug reports see [GitHub Issues list](https://github.com/apache/royale-asjs/issues?q=is%3Aissue+is%3Aclosed).

Updates to the RELEASE_NOTES made after this file was packaged into the release artifacts can be found here:

https://github.com/apache/royale-asjs/wiki/Release-Notes-0.9.7

Apache Royale 0.9.6
===================

- Compiles faster.
- For applications targeting JavaScript, you can now incorporate the vast resources available in existing, free JavaScript libraries.
- Many additional components are available:
  - for the Jewel component set, Wizard, PopUp, TabBar, Module, ModuleLoader, FooterBar, Badge, ScrollableSectionContent, and HorizontalListScroll are now available.
- Emulations of many other components are available.
- Many improvements and fixes in the Jewel component set:
  - Full implementation of DateField/DateChooser.
  - Components now work correctly on IE11 and on Android/iOS mobile devices.
  - Many improvements to all themes, such as styles for new components and a disabled style that was missing in some components.
  - Many beads have been added for Jewel components:
    - Search filter bead on Jewel ComboBox
    - SearchFilterForList bead to use with Jewel List and TextInput
    - RequiredSelection for DropDownList
  - Improvements to focus handling.
  - Button now extends from new BasicButton.
- Many improvements on Tour De Jewel demo app to show components and beads introduced in this version.
- Added BrowserOrientation bead.
- Added loadCSS, to load external CSS dynamically.
- Added generation of source-maps to all Royale libs for better debugging of framework code.
- Added new [RoyaleUnit](https://apache.github.io/royale-docs/testing/royaleunit.html) library for unit testing.
- Improvements to AMF / RemoteObject Support.
- AMFBinaryData api now matches flash.utils.ByteArray, (the missing feature is non-UTF String encoding support). It therefore now works for deep cloning via readObject/writeObject and registerClassAlias.
- Updates to Royale collections library with support for sorting and filtering via ArrayListView. Simple example added to Tour de Jewel.
- A conforming runtime implementation of AS3 Vector (typed Arrays) was added for javaScript output, with options for avoiding certain runtime checks.
- int, uint, Class are now represented as simple, distinct types (Class is now not an 'Object', int is now not a 'Number', for example), and these support indirect 'as' or 'is' type checking and instantiation, matching swf behavior.
- General improvements and additions to the Reflection library.
- New Apache Royale Crux MVC/DI/IOC application architecture library (based on Swiz Framework) was added, with some simple examples.
- Added and updated documentation in many areas of [ASDocs reference](https://royale.apache.org/asdoc/).
- Dozens of bugs reported, investigated, and squashed. For details of
  closed bug reports see [GitHub Issues list](https://github.com/apache/royale-asjs/issues?q=is%3Aissue+is%3Aclosed).

Updates to the RELEASE_NOTES made after this file was packaged into the release artifacts can be found here:

https://github.com/apache/royale-asjs/wiki/Release-Notes-0.9.6

Apache Royale 0.9.4
===================

- [Better way to style components: ClassSelectorList](https://github.com/apache/royale-asjs/issues/205)
- [Fixed AMF / RemoteObject Support](https://github.com/apache/royale-asjs/issues/204)
- [Added New Jewel UI Set And First 72 Jewel Themes 12 Colors, Light and Dark (Initial work)](https://github.com/apache/royale-asjs/issues/154)
- [Renamed TextOverflow bead to EllipsisOverflow. It now supports Label elements as well.](https://github.com/apache/royale-asjs/issues/130)
- [Added IEEventAdapterBead](https://github.com/apache/royale-asjs/issues/131)
- [Added Object getter/setter utility functions](https://github.com/apache/royale-asjs/issues/132)
- [Added InfiniteVScroller Bead](https://github.com/apache/royale-asjs/issues/134)
- Initial release of the migration component sets (MXRoyale and SparkRoyale) that have a goal of reducing migration effort for those moving existing Flex applications to Royale.
- Initial release of the Tour de Flex example migrated to Royale via the migration component sets.  This is a work in progress.  You can see latest progress on our [CI server](http://apacheroyaleci.westus2.cloudapp.azure.com:8080/job/TourDeFlexMigration/lastSuccessfulBuild/artifact/examples/mxroyale/tourdeflexmodules/bin/js-debug/index.html)

Known Issues:
 - Users only using Basic components and not MXRoyale or SparkRoyale emulation components should delete 
    frameworks/libs/MXRoyale.swc, frameworks/libs/SparkRoyale.swc, frameworks/js/libs/MXRoyaleJS.swc,
    and frameworks/js/libs/SparkRoyaleJS.swc from their library-paths (or from the file system).

Updates to the RELEASE_NOTES made after this file was packaged into the release artifacts can be found here:

https://github.com/apache/royale-asjs/wiki/Release-Notes-0.9.4

Apache Royale 0.9.2
===================

- [Added ApplicationParametersBead and ApplicationParametersCaseInsensitiveBead](https://github.com/apache/royale-asjs/issues/129)
- Added virtual item renderer management for fixed row height vertical lists.
- Added Menu and MenuBar
- Added DividedBox
- Many CSS default values are now in the basic.css theme.
- Theme support. Now compiler will copy all resources in "assets" folder to target
- Added JSON2ASVO, a utility that creates AS classes from a JSON result
- Added JSONReviver, a class that converts JSON to AS classes sort of like AMF
- Added HScrollViewport
- Added VScrollViewport
- Fixed bugs in XML parsing and converting back to strings
  - https://github.com/apache/royale-asjs/issues/120
  - https://github.com/apache/royale-asjs/issues/121
  - https://github.com/apache/royale-asjs/issues/122
  - https://github.com/apache/royale-asjs/issues/123
- Fixed Maven distribution so you can use in IDEs like VSCode, Moonshine and more.
  - https://github.com/apache/royale-asjs/issues/125

Updates to the RELEASE_NOTES made after this file was packaged into the release artifacts can be found here:

https://github.com/apache/royale-asjs/wiki/Release-Notes-0.9.2

Apache Royale 0.9.1
===================

- The ASDoc example was upgraded to look better, show events, and provide permalinks.

Updates to the RELEASE_NOTES made after this file was packaged into the release artifacts can be found here:

https://github.com/apache/royale-asjs/wiki/Release-Notes-0.9.1

Apache Royale 0.9.0
===================

Apache Royale is an SDK that provides the capability to cross-compile MXML 
and ActionScript applications to HTML/JS/CSS so they can run in a browser
without Flash.

Apache Royale was previously released by the Apache Flex project.  You can
see RELEASE_NOTES for earlier releases in the Apache Flex releases.

Updates to the RELEASE_NOTES made after this file was packaged into the release artifacts can be found here:

https://github.com/apache/royale-asjs/wiki/Release-Notes-0.9.0

Please report new issues to our bugbase at:

    https://github.com/apache/royale-asjs/issues

                                          The Apache Royale Project
                                          <http://royale.apache.org/>

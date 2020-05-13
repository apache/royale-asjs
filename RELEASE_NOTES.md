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
    - Massive refactors and improvments
    - Hierachy improved in many Jewel framework branches to make StyleUIBase the base of all components and unify APIs.
    - StyleUIBase now improve width and height so we can use NaN values to unset values. For JS this means return to default values.
    - Card: Added new subcomponents (CardHeader, CardTitle, CardPrimaryContent and CardActions)
    - Button: Added new unboxed and outlined styles (also to IconButton and ToggleButton)
    - CheckBox and RadioButton now can size the icon part
    - ComboBox can now confifure custom renders and supports rowCount, and fixed percent width. also popup adapts to data provider length.
    - List supports now variableRowHeight, scrollToIndex and can be navigated with arrow cursors (up/down)
    - Item Renderer: Use the new Initializer infrastructure
    - Remove mappers to rely on basic ones, also remove CRUD beads (Add, Remove and Update item beads)
    - Layouts, Group and Container supports variableRowHeight
    - Layouts many fixes and improvements in alignment, and now dispatch childs dispatch a "sizeChanged"
    - Viewport and ScrollingViewport refactor. Viewport has now clipContent so Container can activate/deactivate
    - added tabindex in many components and to Disabled bead (=-1)
    - Prompt beads now support changes at runtime
    - TabBar: fix AssignTabContent bead when change dataprovider 
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
    - Added ComboBoxTrucatedText
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

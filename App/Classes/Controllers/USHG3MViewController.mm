//
//  USHG3MViewController.m
//  App
//
//  Created by Cristiano Carducci on 22/11/13.
//  Copyright (c) 2013 Ushahidi. All rights reserved.
//

#import "USHG3MViewController.h"
#import <G3MiOSSDK/G3MBuilder_iOS.hpp>

#import <G3MiOSSDK/VisibleSectorListener.hpp>
#import <G3MiOSSDK/MarksRenderer.hpp>
#import <G3MiOSSDK/ShapesRenderer.hpp>
#import <G3MiOSSDK/GEORenderer.hpp>
#import <G3MiOSSDK/BusyMeshRenderer.hpp>
#import <G3MiOSSDK/MeshRenderer.hpp>
#import <G3MiOSSDK/FloatBufferBuilderFromGeodetic.hpp>
#import <G3MiOSSDK/FloatBufferBuilderFromColor.hpp>
#import <G3MiOSSDK/DirectMesh.hpp>
#import <G3MiOSSDK/WMSLayer.hpp>
#import <G3MiOSSDK/CameraSingleDragHandler.hpp>
#import <G3MiOSSDK/CameraDoubleDragHandler.hpp>
#import <G3MiOSSDK/CameraZoomAndRotateHandler.hpp>
#import <G3MiOSSDK/CameraRotationHandler.hpp>
#import <G3MiOSSDK/CameraDoubleTapHandler.hpp>
#import <G3MiOSSDK/LevelTileCondition.hpp>
#import <G3MiOSSDK/LayerBuilder.hpp>
#import <G3MiOSSDK/PlanetRendererBuilder.hpp>
#import <G3MiOSSDK/MarkTouchListener.hpp>
#import <G3MiOSSDK/TrailsRenderer.hpp>
#import <G3MiOSSDK/Mark.hpp>
#import <G3MiOSSDK/CircleShape.hpp>
#import <G3MiOSSDK/QuadShape.hpp>
#import <G3MiOSSDK/BoxShape.hpp>
#import <G3MiOSSDK/EllipsoidShape.hpp>
#import <G3MiOSSDK/SceneJSShapesParser.hpp>
#import <G3MiOSSDK/LayoutUtils.hpp>

#import <G3MiOSSDK/IJSONParser.hpp>
#import <G3MiOSSDK/JSONGenerator.hpp>
#import <G3MiOSSDK/BSONParser.hpp>
#import <G3MiOSSDK/BSONGenerator.hpp>

#import <G3MiOSSDK/MeshShape.hpp>
#import <G3MiOSSDK/IShortBuffer.hpp>
#import <G3MiOSSDK/SimpleCameraConstrainer.hpp>
#import <G3MiOSSDK/WMSBillElevationDataProvider.hpp>
#import <G3MiOSSDK/ElevationData.hpp>
#import <G3MiOSSDK/IBufferDownloadListener.hpp>
#import <G3MiOSSDK/BilParser.hpp>
#import <G3MiOSSDK/ShortBufferBuilder.hpp>
#import <G3MiOSSDK/BilinearInterpolator.hpp>
#import <G3MiOSSDK/SubviewElevationData.hpp>
#import <G3MiOSSDK/GInitializationTask.hpp>
#import <G3MiOSSDK/PeriodicalTask.hpp>
#import <G3MiOSSDK/IDownloader.hpp>
#import <G3MiOSSDK/OSMLayer.hpp>
#import <G3MiOSSDK/CartoDBLayer.hpp>
#import <G3MiOSSDK/HereLayer.hpp>
#import <G3MiOSSDK/MapQuestLayer.hpp>
#import <G3MiOSSDK/MapBoxLayer.hpp>
#import <G3MiOSSDK/GoogleMapsLayer.hpp>
#import <G3MiOSSDK/BingMapsLayer.hpp>

#import <G3MiOSSDK/BusyQuadRenderer.hpp>
#import <G3MiOSSDK/Factory_iOS.hpp>

#import <G3MiOSSDK/G3MWidget.hpp>
#import <G3MiOSSDK/GEOJSONParser.hpp>

//import <G3MiOSSDK/WMSBillElevationDataProvider.hpp>
#import <G3MiOSSDK/SingleBillElevationDataProvider.hpp>
#import <G3MiOSSDK/FloatBufferElevationData.hpp>

#import <G3MiOSSDK/GEOSymbolizer.hpp>
#import <G3MiOSSDK/GEO2DMultiLineStringGeometry.hpp>
#import <G3MiOSSDK/GEO2DLineStringGeometry.hpp>
#import <G3MiOSSDK/GEOFeature.hpp>
#import <G3MiOSSDK/JSONObject.hpp>
#import <G3MiOSSDK/GEOLine2DMeshSymbol.hpp>
#import <G3MiOSSDK/GEOMultiLine2DMeshSymbol.hpp>
#import <G3MiOSSDK/GEOLine2DStyle.hpp>
#import <G3MiOSSDK/GEO2DPointGeometry.hpp>
#import <G3MiOSSDK/GEOShapeSymbol.hpp>
#import <G3MiOSSDK/GEOMarkSymbol.hpp>
#import <G3MiOSSDK/GFont.hpp>

#import <G3MiOSSDK/CompositeElevationDataProvider.hpp>
#import <G3MiOSSDK/LayerTilesRenderParameters.hpp>
#import <G3MiOSSDK/RectangleI.hpp>
#import <G3MiOSSDK/LayerTilesRenderParameters.hpp>
#import <G3MiOSSDK/QuadShape.hpp>
#import <G3MiOSSDK/IImageUtils.hpp>
#import <G3MiOSSDK/RectangleF.hpp>
#import <G3MiOSSDK/ShortBufferElevationData.hpp>
#import <G3MiOSSDK/SGShape.hpp>
#import <G3MiOSSDK/SGNode.hpp>
#import <G3MiOSSDK/SGMaterialNode.hpp>

#import <G3MiOSSDK/MapBooBuilder_iOS.hpp>
#import <G3MiOSSDK/IWebSocketListener.hpp>

#include <G3MiOSSDK/GPUProgramFactory.hpp>
#import <G3MiOSSDK/FloatBufferBuilderFromCartesian3D.hpp>
#import <G3MiOSSDK/Color.hpp>

#import <G3MiOSSDK/TileRasterizer.hpp>
#import <G3MiOSSDK/DebugTileRasterizer.hpp>
#import <G3MiOSSDK/GEOTileRasterizer.hpp>

#import <G3MiOSSDK/GEORasterLineSymbol.hpp>
#import <G3MiOSSDK/GEOMultiLineRasterSymbol.hpp>
#import <G3MiOSSDK/GEO2DLineRasterStyle.hpp>

#import <G3MiOSSDK/GEO2DPolygonGeometry.hpp>
#import <G3MiOSSDK/GEORasterPolygonSymbol.hpp>
#import <G3MiOSSDK/GEO2DSurfaceRasterStyle.hpp>

#import <G3MiOSSDK/GEO2DMultiPolygonGeometry.hpp>
#import <G3MiOSSDK/GPUProgramFactory.hpp>

#import <G3MiOSSDK/GenericQuadTree.hpp>
#import <G3MiOSSDK/GEOFeatureCollection.hpp>
#import <G3MiOSSDK/Angle.hpp>

#import <G3MiOSSDK/SectorAndHeightCameraConstrainer.hpp>

#import <G3MiOSSDK/HUDRenderer.hpp>
#import <G3MiOSSDK/HUDImageRenderer.hpp>

#import <G3MiOSSDK/CartoCSSParser.hpp>

#import <G3MiOSSDK/ColumnCanvasElement.hpp>
#import <G3MiOSSDK/TextCanvasElement.hpp>
#import <G3MiOSSDK/URLTemplateLayer.hpp>
#import <G3MiOSSDK/JSONArray.hpp>



class TestVisibleSectorListener : public VisibleSectorListener {
public:
    void onVisibleSectorChange(const Sector& visibleSector,
                               const Geodetic3D& cameraPosition) {
        ILogger::instance()->logInfo("VisibleSector=%s, CameraPosition=%s",
                                     visibleSector.description().c_str(),
                                     cameraPosition.description().c_str());
    }
};


Mesh* createSectorMesh(const Planet* planet,
                       const int resolution,
                       const Sector& sector,
                       const Color& color,
                       const int lineWidth) {
    // create vectors
    //  FloatBufferBuilderFromGeodetic vertices(CenterStrategy::givenCenter(),
    //                                          planet,
    //                                          sector._center);
    FloatBufferBuilderFromGeodetic vertices = FloatBufferBuilderFromGeodetic::builderWithGivenCenter(planet, sector._center);
    
    
    // create indices
    ShortBufferBuilder indices;
    
    const int resolutionMinus1 = resolution - 1;
    int indicesCounter = 0;
    
    const double offset = 0;
    
    // west side
    for (int j = 0; j < resolutionMinus1; j++) {
        const Geodetic3D g(sector.getInnerPoint(0, (double)j/resolutionMinus1),
                           offset);
        vertices.add(g);
        
        indices.add(indicesCounter++);
    }
    
    // south side
    for (int i = 0; i < resolutionMinus1; i++) {
        const Geodetic3D g(sector.getInnerPoint((double)i/resolutionMinus1, 1),
                           offset);
        vertices.add(g);
        
        indices.add(indicesCounter++);
    }
    
    // east side
    for (int j = resolutionMinus1; j > 0; j--) {
        const Geodetic3D g(sector.getInnerPoint(1, (double)j/resolutionMinus1),
                           offset);
        vertices.add(g);
        
        indices.add(indicesCounter++);
    }
    
    // north side
    for (int i = resolutionMinus1; i > 0; i--) {
        const Geodetic3D g(sector.getInnerPoint((double)i/resolutionMinus1, 0),
                           offset);
        vertices.add(g);
        
        indices.add(indicesCounter++);
    }
    
    return new IndexedMesh(GLPrimitive::lineLoop(),
                           true,
                           vertices.getCenter(),
                           vertices.create(),
                           indices.create(),
                           lineWidth,
                           1,
                           new Color(color),
                           NULL, //colors
                           0,    // colorsIntensity
                           false //depthTest
                           );
}



@interface USHG3MViewController ()

@end

@implementation USHG3MViewController

@synthesize G3MWidget;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // initialize a customized widget without using a builder
    //[[self G3MWidget] initSingletons];
    // [self initWithoutBuilder];
    
    [self initCustomizedWithBuilder];
    
    //  [self initWithMapBooBuilder];
    
    //  [self initWithBuilderAndSegmentedWorld];
    
    [[self G3MWidget] startAnimation];
}


class MoveCameraInitializationTask : public GInitializationTask {
private:
    G3MWidget_iOS* _iosWidget;
    const Sector   _sector;
    
public:
    
    MoveCameraInitializationTask(G3MWidget_iOS* iosWidget,
                                 const Sector   sector) :
    _iosWidget(iosWidget),
    _sector(sector)
    {
    }
    
    void run(const G3MContext* context) {
        //    const std::string cartoCSS = "/* coment */ // comment\n @water: #C0E0F8; [zoom > 1] { line-color:@waterline; line-width:1.6; ::newSymbolizer { line-width:2; } } #world .class [level == 5] { background-color: black; } ";
        
        //    const std::string cartoCSS = "@water: #ddeeff;\n#lakes[ScaleRank<3][zoom=3],\n#lakes[ScaleRank<4][zoom=4],\n#lakes[ScaleRank<5][zoom=5],\n#lakes[ScaleRank<6][zoom>=6] {\n    polygon-fill:@water;\n    line-color:darken(@water, 20%);\n    line-width:0.3;\n  }\n";
        
        //    const std::string cartoCSS = "/* coment */ // comment\n @water: #C0E0F8; [zoom > 1] { line-color:@waterline; line-width:1.6; ::newSymbolizer { line-width:2; } } #world .class [level == 5] { background-color: black; } \n@water: #ddeeff;\n#lakes[ScaleRank<3][zoom=3],\n#lakes[ScaleRank<4][zoom=4],\n#lakes[ScaleRank<5][zoom=5],\n#lakes[ScaleRank<6][zoom>=6] {\n    polygon-fill:@water;\n    line-color:darken(@water, 20%);\n    line-width:0.3;\n  }\n.class1.class2{} ::anotherSymbolizer {background-color: black;} * {line-color:white;} ";
        const std::string cartoCSS = "@water: #C0E0F8; #id { a:1; b:2; .class {a:2;} [level > 2] {b:3; [COUNTRY=US][COUNTRY=AR] { d:33;} } }";
        
        CartoCSSResult* result = CartoCSSParser::parse(cartoCSS);
        
        if (result->hasError()) {
            std::vector<CartoCSSError> errors = result->getErrors();
            const int errorsSize = errors.size();
            for (int i = 0; i < errorsSize; i++) {
                const CartoCSSError error = errors[i];
                ILogger::instance()->logError("\"%s\" at %d",
                                              error.getDescription().c_str(),
                                              error.getPosition());
            }
        }
        
        const CartoCSSSymbolizer* symbolizer = result->getSymbolizer();
        if (symbolizer != NULL) {
            ILogger::instance()->logInfo("%s", symbolizer->description(true).c_str());
            delete symbolizer;
        }
        
        delete result;
        
        //    Geodetic3D position(Geodetic3D(_sector.getCenter(), 5000));
        //    [_iosWidget widget]->setAnimatedCameraPosition(TimeInterval::fromSeconds(5), position);
        //[_iosWidget widget]->setCameraPosition(position);
    }
    
    bool isDone(const G3MContext* context) {
        return true;
    }
};


//class ToggleGEORendererTask: public GTask {
//private:
//  GEORenderer* _geoRenderer;
//
//public:
//  ToggleGEORendererTask(GEORenderer* geoRenderer) :
//  _geoRenderer(geoRenderer)
//  {
//
//  }
//
//  void run(const G3MContext* context) {
//    _geoRenderer->setEnable( !_geoRenderer->isEnable() );
//  }
//
//};


- (void) initWithBuilderAndSegmentedWorld
{
    G3MBuilder_iOS builder([self G3MWidget]);
    
    LayerSet* layerSet = new LayerSet();
    //  layerSet->addLayer(MapQuestLayer::newOSM(TimeInterval::fromDays(30), true, 10));
    layerSet->addLayer(MapQuestLayer::newOSM(TimeInterval::fromDays(30)));
    builder.getPlanetRendererBuilder()->setLayerSet(layerSet);
    
    
    //  GEORenderer* geoRenderer = builder.createGEORenderer( new SampleSymbolizer(builder.getPlanet()) );
    //
    //  geoRenderer->loadJSON(URL("file:///geojson/countries-50m.geojson", false),
    //                        new SampleSymbolizer(builder.getPlanet()));
    
    //  builder.addPeriodicalTask(new PeriodicalTask(TimeInterval::fromSeconds(5),
    //                                               new ToggleGEORendererTask(geoRenderer)));
    
    //  builder.getPlanetRendererBuilder()->addTileRasterizer(new DebugTileRasterizer());
    
    //  builder.getPlanetRendererBuilder()->addTileRasterizer(new DebugTileRasterizer(GFont::monospaced(),
    //                                                                                Color::red(),
    //                                                                                false,
    //                                                                                true));
    //  builder.getPlanetRendererBuilder()->addTileRasterizer(new DebugTileRasterizer(GFont::monospaced(),
    //                                                                                Color::yellow(),
    //                                                                                true,
    //                                                                                false));
    
    
    //  const Sector sector = Sector::fromDegrees(-17.2605373678851670, 145.4760907919427950,
    //                                            -17.2423142646939311, 145.4950606689779420);
    const Sector sector = Sector::fromDegrees(40.1540143280790858, -5.8664874640814313,
                                              40.3423148480663158, -5.5116079822178570);
    
    //  final Geodetic2D lower = new Geodetic2D( //
    //                                          Angle.fromDegrees(40.1540143280790858), //
    //                                          Angle.fromDegrees(-5.8664874640814313));
    //  final Geodetic2D upper = new Geodetic2D( //
    //                                          Angle.fromDegrees(40.3423148480663158), //
    //                                          Angle.fromDegrees(-5.5116079822178570));
    //
    //  final Sector demSector = new Sector(lower, upper);
    
    builder.setShownSector(sector);
    
    //  builder.setPlanet(Planet::createSphericalEarth());
    //  builder.setPlanet(Planet::createFlatEarth());
    
    //  int _DIEGO_AT_WORK;
    //  builder.getPlanetRendererBuilder()->setShowStatistics(true);
    
    //  MeshRenderer* meshRenderer = new MeshRenderer();
    //  builder.addRenderer(meshRenderer);
    //  meshRenderer->addMesh( createSectorMesh(builder.getPlanet(), 32, sector, Color::red(), 2) );
    
    builder.setInitializationTask(new MoveCameraInitializationTask([self G3MWidget], sector),
                                  true);
    
    ElevationDataProvider* elevationDataProvider = new SingleBillElevationDataProvider(URL("file:///aus4326.bil", false),
                                                                                       sector,
                                                                                       Vector2I(2083, 2001),
                                                                                       -758.905);
    
    builder.getPlanetRendererBuilder()->setElevationDataProvider(elevationDataProvider);
    builder.getPlanetRendererBuilder()->setVerticalExaggeration(3);
    
    builder.initializeWidget();
}


class SampleMapBooApplicationChangeListener : public MapBooApplicationChangeListener {
public:
    void onNameChanged(const G3MContext* context,
                       const std::string& name) {
        ILogger::instance()->logInfo("MapBoo application name=\"%s\"",
                                     name.c_str());
    }
    
    void onIconChanged(const G3MContext* context,
                       const std::string& icon) {
        ILogger::instance()->logInfo("MapBoo application icon=\"%s\"",
                                     icon.c_str());
    }
    
    void onScenesChanged(const G3MContext* context,
                         const std::vector<MapBoo_Scene*>& scenes) {
        const int scenesSize = scenes.size();
        for (int i = 0; i < scenesSize; i++) {
            ILogger::instance()->logInfo("MapBoo application scene #%d %s",
                                         i,
                                         scenes[i]->description().c_str());
        }
    }
    
    void onSceneChanged(const G3MContext* context,
                        int sceneIndex,
                        const MapBoo_Scene* scene) {
        ILogger::instance()->logInfo("MapBoo application current scene=%l",
                                     sceneIndex);
    }
    
    void onWebsiteChanged(const G3MContext* context,
                          const std::string& website) {}
    
    void onEMailChanged(const G3MContext* context,
                        const std::string& eMail) {}
    
    void onAboutChanged(const G3MContext* context,
                        const std::string& about) {}
    
    void onWebSocketOpen(const G3MContext* context) {}
    
    void onWebSocketClose(const G3MContext* context) {}
    
    void onTerrainTouch(MapBooBuilder*         builder,
                        const G3MEventContext* ec,
                        const Vector2I&        pixel,
                        const Camera*          camera,
                        const Geodetic3D&      position,
                        const Tile*            tile) { }
};


- (void) initWithMapBooBuilder
{
    MapBooApplicationChangeListener* applicationListener = new SampleMapBooApplicationChangeListener();
    
    const std::string applicationId = "2glgs5j2mq5i9nxx68q";
    
    bool enableNotifications = false;
    
    _g3mcBuilder = new MapBooBuilder_iOS([self G3MWidget],
                                         URL("http://192.168.1.2:8080/web", false),
                                         URL("ws://192.168.1.2:8888/tube", false),
                                         "",
                                         VIEW_RUNTIME,
                                         applicationListener,
                                         enableNotifications);
    
    _g3mcBuilder->initializeWidget();
}

- (void) initWithDefaultBuilder
{
    G3MBuilder_iOS builder([self G3MWidget]);
    builder.initializeWidget();
}


- (void)  initializeElevationDataProvider: (G3MBuilder_iOS&) builder
{
    float verticalExaggeration = 1.0f;
    builder.getPlanetRendererBuilder()->setVerticalExaggeration(verticalExaggeration);
    
    //ElevationDataProvider* elevationDataProvider = NULL;
    //builder.getPlanetRendererBuilder()->setElevationDataProvider(elevationDataProvider);
    
    
    ElevationDataProvider* elevationDataProvider = new SingleBillElevationDataProvider(URL("file:///full-earth-2048x1024.bil", false),
                                                                                       Sector::fullSphere(),
                                                                                       Vector2I(2048, 1024));
    builder.getPlanetRendererBuilder()->setElevationDataProvider(elevationDataProvider);
}

- (GPUProgramSources) loadDefaultGPUProgramSourcesFromDisk{
    //GPU Program Sources
    NSString* vertShaderPathname = [[NSBundle mainBundle] pathForResource: @"Shader"
                                                                   ofType: @"vsh"];
    if (!vertShaderPathname) {
        NSLog(@"Can't load Shader.vsh");
    }
    const std::string vertexSource ([[NSString stringWithContentsOfFile: vertShaderPathname
                                                               encoding: NSUTF8StringEncoding
                                                                  error: nil] UTF8String]);
    
    NSString* fragShaderPathname = [[NSBundle mainBundle] pathForResource: @"Shader"
                                                                   ofType: @"fsh"];
    if (!fragShaderPathname) {
        NSLog(@"Can't load Shader.fsh");
    }
    
    const std::string fragmentSource ([[NSString stringWithContentsOfFile: fragShaderPathname
                                                                 encoding: NSUTF8StringEncoding
                                                                    error: nil] UTF8String]);
    
    return GPUProgramSources("DefaultProgram", vertexSource, fragmentSource);
}

- (GPUProgramSources) loadDefaultGPUProgramSourcesWithName: (NSString*) name{
    //GPU Program Sources
    NSString* vertShaderPathname = [[NSBundle mainBundle] pathForResource: name
                                                                   ofType: @"vsh"];
    if (!vertShaderPathname) {
        NSLog(@"Can't load %@.vsh", name);
    }
    const std::string vertexSource ([[NSString stringWithContentsOfFile: vertShaderPathname
                                                               encoding: NSUTF8StringEncoding
                                                                  error: nil] UTF8String]);
    
    NSString* fragShaderPathname = [[NSBundle mainBundle] pathForResource: name
                                                                   ofType: @"fsh"];
    if (!fragShaderPathname) {
        NSLog(@"Can't load %@.fsh", name);
    }
    
    const std::string fragmentSource ([[NSString stringWithContentsOfFile: fragShaderPathname
                                                                 encoding: NSUTF8StringEncoding
                                                                    error: nil] UTF8String]);
    
    return GPUProgramSources([name UTF8String], vertexSource, fragmentSource);
}

class TestMeshLoadListener : public MeshLoadListener {
public:
    void onBeforeAddMesh(Mesh* mesh) {
    }
    
    void onAfterAddMesh(Mesh* mesh) {
    }
    
};

- (void) initCustomizedWithBuilder2
{
    
    
    G3MBuilder_iOS builder([self G3MWidget]);
    
    GEOTileRasterizer* geoTileRasterizer = new GEOTileRasterizer();
    
    //builder.getPlanetRendererBuilder()->addTileRasterizer(new DebugTileRasterizer());
    builder.getPlanetRendererBuilder()->addTileRasterizer(geoTileRasterizer);
    
    //  SimpleCameraConstrainer* scc = new SimpleCameraConstrainer();
    //  builder.addCameraConstraint(scc);
    
    builder.setCameraRenderer([self createCameraRenderer]);
    
    const Planet* planet = Planet::createEarth();
    //const Planet* planet = Planet::createSphericalEarth();
    //const Planet* planet = Planet::createFlatEarth();
    builder.setPlanet(planet);
    
    Color* bgColor = Color::newFromRGBA(0.0f, 0.1f, 0.2f, 1.0f);
    
    builder.setBackgroundColor(bgColor);
    
    LayerSet* layerSet = [self createLayerSet2];
    
    //  layerSet->addLayer(new WMSLayer("precipitation", //
    //                                  URL("http://wms.openweathermap.org/service", false), //
    //                                  WMS_1_1_0, //
    //                                  Sector::fromDegrees(-85.05, -180.0, 85.05, 180.0), //
    //                                  "image/png", //
    //                                  "EPSG:4326", //
    //                                  "", //
    //                                  true, //
    //                                  NULL)
    //                     );
    
    bool useElevations = true;
    if (useElevations) {
        [self initializeElevationDataProvider: builder];
    }
    
    builder.getPlanetRendererBuilder()->setLayerSet(layerSet);
    builder.getPlanetRendererBuilder()->setPlanetRendererParameters([self createPlanetRendererParameters]);
    builder.getPlanetRendererBuilder()->addVisibleSectorListener(new TestVisibleSectorListener(),
                                                                 TimeInterval::fromSeconds(3));
    
    Renderer* busyRenderer = new BusyMeshRenderer(Color::newFromRGBA((float)0, (float)0.1, (float)0.2, (float)1));
    builder.setBusyRenderer(busyRenderer);
    
    ShapesRenderer* shapesRenderer = [self createShapesRenderer: builder.getPlanet()];
    
    builder.addRenderer(shapesRenderer);
    
    MeshRenderer* meshRenderer = new MeshRenderer();
    builder.addRenderer( meshRenderer );
    
    
    //  meshRenderer->loadJSONPointCloud(URL("file:///pointcloud/points.json"),
    //                                   10,
    //                                   new TestMeshLoadListener(),
    //                                   true);
    meshRenderer->loadJSONPointCloud(URL("file:///pointcloud/matterhorn.json"),
                                     2,
                                     0,
                                     new TestMeshLoadListener(),
                                     true);
    
    //  void testMeshLoad(const G3MContext* context) {
    //    context->getDownloader()->requestBuffer(URL("file:///isosurface-mesh.json"),
    //                                            100000, //  priority,
    //                                            TimeInterval::fromDays(30),
    //                                            true,
    //                                            new ParseMeshBufferDownloadListener(_meshRenderer, _planet),
    //                                            true);
    //  }
    meshRenderer->loadJSONMesh(URL("file:///isosurface-mesh.json"),
                               Color::newFromRGBA(1, 1, 0, 1));
    
    MarksRenderer* marksRenderer = [self createMarksRenderer];
    builder.addRenderer(marksRenderer);
    
    GEORenderer* geoRenderer = [self createGEORendererMeshRenderer: meshRenderer
                                                    shapesRenderer: shapesRenderer
                                                     marksRenderer: marksRenderer
                                                 geoTileRasterizer: geoTileRasterizer
                                                            planet: builder.getPlanet()];
    builder.addRenderer(geoRenderer);
    
    
    if (true) { //HUD
        //    HUDRenderer* hudRenderer = new HUDRenderer();
        //
        //    NSBundle* mainBundle = [NSBundle mainBundle];
        //    Image_iOS *image = new Image_iOS([[UIImage alloc] initWithContentsOfFile: [mainBundle pathForResource: @"Icon-72"
        //                                                                                                   ofType: @"png"]],
        //                                     NULL);
        //    hudRenderer->addImage("IMAGE", image, Vector2D(100, 100), Vector2D(40,40));
        //
        //    Image_iOS *image2 = new Image_iOS([[UIImage alloc] initWithContentsOfFile: [mainBundle pathForResource: @"horizontal-gears"
        //                                                                                                    ofType: @"png"]],
        //                                      NULL);
        //    hudRenderer->addImage("IMAGE2", image2, Vector2D(100, 100), Vector2D(240,40));
        //
        //    builder.addRenderer(hudRenderer);
        
        
        class TestImageFactory : public HUDImageRenderer::CanvasImageFactory {
        protected:
            void drawOn(ICanvas* canvas,
                        int width,
                        int height) {
                //        canvas->setFillColor(Color::fromRGBA(0.9f, 0.4f, 0.4f, 1.0f));
                //        canvas->fillRectangle(0, 0,
                //                              width, height);
                
                //        canvas->setLineColor(Color::yellow());
                //        canvas->setLineWidth(5);
                //        canvas->strokeRectangle(0, 0,
                //                                width, height);
                
                //        canvas->setFont(GFont::sansSerif(30));
                
                //        const std::string text = "Hello World from HUD!";
                //        canvas->setFont(GFont::sansSerif(30));
                //        const Vector2F extent = canvas->textExtent(text);
                //
                //        canvas->setFillColor(Color::white());
                //        canvas->setShadow(Color::black(), 10, 2, -2);
                //
                //        canvas->fillText(text,
                //                         (width  - extent._x) / 2,
                //                         (height - extent._y) / 2);
                
                const std::string text = "glob3mobile.com";
                canvas->setFont(GFont::sansSerif(25));
                const Vector2F extent = canvas->textExtent(text);
                
                canvas->setFillColor(Color::white());
                canvas->setShadow(Color::black(), 1, 0, 0);
                
                canvas->fillText(text,
                                 (width  - extent._x) / 2,
                                 (height - extent._y) - extent._y/2);
                
                
                //        canvas->setFillColor(Color::black());
                //        canvas->fillRectangle(0, 0,
                //                              width, height);
                //
                //        ColumnCanvasElement column(Color::fromRGBA(0.9f, 0.4f, 0.4f, 1.0f),
                //                                   0,  /* margin */
                //                                   16,  /* padding */
                //                                   8   /* cornerRadius */);
                //        const GFont labelFont  = GFont::sansSerif(22);
                //        const Color labelColor = Color::white();
                //        column.add( new TextCanvasElement("Error message #1", labelFont, labelColor) );
                //        column.add( new TextCanvasElement("Another error message", labelFont, labelColor) );
                //        column.add( new TextCanvasElement("And another error message", labelFont, labelColor) );
                //        column.add( new TextCanvasElement("And just another error message", labelFont, labelColor) );
                //
                //        column.drawCentered(canvas);
            }
        };
        
        /*
         HUDImageRenderer* hudRenderer = new HUDImageRenderer(new TestImageFactory());
         builder.addRenderer(hudRenderer);
         */
    }
    
    
    //  [self createInterpolationTest: meshRenderer];
    
    //  meshRenderer->addMesh([self createPointsMesh: builder.getPlanet() ]);
    
    //Draw light direction
    if (false) {
        
        Vector3D lightDir = Vector3D(100000, 0,0);
        //    FloatBufferBuilderFromCartesian3D vertex(CenterStrategy::noCenter(), Vector3D::zero);
        FloatBufferBuilderFromCartesian3D vertex = FloatBufferBuilderFromCartesian3D::builderWithoutCenter();
        
        Vector3D v = planet->toCartesian(Geodetic3D(Angle::fromDegrees(28.127222),
                                                    Angle::fromDegrees(-15.431389),
                                                    10000));
        
        vertex.add(v);
        vertex.add(v.add(lightDir));
        //lightDir.normalized().times(planet->getRadii().maxAxis() *1.5));
        
        meshRenderer->addMesh( new DirectMesh(GLPrimitive::lines(),
                                              true,
                                              vertex.getCenter(),
                                              vertex.create(),
                                              3.0,
                                              1.0,
                                              Color::newFromRGBA(1.0, 0.0, 0.0, 1.0)));
        
        
    }
    
    GInitializationTask* initializationTask = [self createSampleInitializationTask: shapesRenderer
                                                                       geoRenderer: geoRenderer
                                                                      meshRenderer: meshRenderer
                                                                     marksRenderer: marksRenderer
                                                                            planet: planet];
    builder.setInitializationTask(initializationTask, true);
    
    PeriodicalTask* periodicalTask = [self createSamplePeriodicalTask: &builder];
    builder.addPeriodicalTask(periodicalTask);
    
    const bool logFPS = false;
    builder.setLogFPS(logFPS);
    
    const bool logDownloaderStatistics = false;
    builder.setLogDownloaderStatistics(logDownloaderStatistics);
    
    //  WidgetUserData* userData = NULL;
    //  builder.setUserData(userData);
    
    // initialization
    builder.initializeWidget();
    //  [self testGenericQuadTree:geoTileRasterizer];
    
}

- (void) initCustomizedWithBuilder
{
    
    
    G3MBuilder_iOS builder([self G3MWidget]);
    
    GEOTileRasterizer* geoTileRasterizer = new GEOTileRasterizer();
    
    //builder.getPlanetRendererBuilder()->addTileRasterizer(new DebugTileRasterizer());
    builder.getPlanetRendererBuilder()->addTileRasterizer(geoTileRasterizer);
    
    //  SimpleCameraConstrainer* scc = new SimpleCameraConstrainer();
    //  builder.addCameraConstraint(scc);
    
    builder.setCameraRenderer([self createCameraRenderer]);
    
    const Planet* planet = Planet::createEarth();
    //const Planet* planet = Planet::createSphericalEarth();
    //const Planet* planet = Planet::createFlatEarth();
    builder.setPlanet(planet);
    
    Color* bgColor = Color::newFromRGBA(0.0f, 0.1f, 0.2f, 1.0f);
    
    builder.setBackgroundColor(bgColor);
    
    LayerSet* layerSet = [self createLayerSet];
    
    //  layerSet->addLayer(new WMSLayer("precipitation", //
    //                                  URL("http://wms.openweathermap.org/service", false), //
    //                                  WMS_1_1_0, //
    //                                  Sector::fromDegrees(-85.05, -180.0, 85.05, 180.0), //
    //                                  "image/png", //
    //                                  "EPSG:4326", //
    //                                  "", //
    //                                  true, //
    //                                  NULL)
    //                     );
    
    bool useElevations = true;
    if (useElevations) {
        [self initializeElevationDataProvider: builder];
    }
    
    builder.getPlanetRendererBuilder()->setLayerSet(layerSet);
    builder.getPlanetRendererBuilder()->setPlanetRendererParameters([self createPlanetRendererParameters]);
    builder.getPlanetRendererBuilder()->addVisibleSectorListener(new TestVisibleSectorListener(),
                                                                 TimeInterval::fromSeconds(3));
    
    Renderer* busyRenderer = new BusyMeshRenderer(Color::newFromRGBA((float)0, (float)0.1, (float)0.2, (float)1));
    builder.setBusyRenderer(busyRenderer);
    
    ShapesRenderer* shapesRenderer = [self createShapesRenderer: builder.getPlanet()];
    
    builder.addRenderer(shapesRenderer);
    
    MeshRenderer* meshRenderer = new MeshRenderer();
    builder.addRenderer( meshRenderer );
    
    
    //  meshRenderer->loadJSONPointCloud(URL("file:///pointcloud/points.json"),
    //                                   10,
    //                                   new TestMeshLoadListener(),
    //                                   true);
    meshRenderer->loadJSONPointCloud(URL("file:///pointcloud/matterhorn.json"),
                                     2,
                                     0,
                                     new TestMeshLoadListener(),
                                     true);
    
    //  void testMeshLoad(const G3MContext* context) {
    //    context->getDownloader()->requestBuffer(URL("file:///isosurface-mesh.json"),
    //                                            100000, //  priority,
    //                                            TimeInterval::fromDays(30),
    //                                            true,
    //                                            new ParseMeshBufferDownloadListener(_meshRenderer, _planet),
    //                                            true);
    //  }
    meshRenderer->loadJSONMesh(URL("file:///isosurface-mesh.json"),
                               Color::newFromRGBA(1, 1, 0, 1));
    
    MarksRenderer* marksRenderer = [self createMarksRenderer];
    builder.addRenderer(marksRenderer);
    
    GEORenderer* geoRenderer = [self createGEORendererMeshRenderer: meshRenderer
                                                    shapesRenderer: shapesRenderer
                                                     marksRenderer: marksRenderer
                                                 geoTileRasterizer: geoTileRasterizer
                                                            planet: builder.getPlanet()];
    builder.addRenderer(geoRenderer);
    
    
    if (true) { //HUD
        //    HUDRenderer* hudRenderer = new HUDRenderer();
        //
        //    NSBundle* mainBundle = [NSBundle mainBundle];
        //    Image_iOS *image = new Image_iOS([[UIImage alloc] initWithContentsOfFile: [mainBundle pathForResource: @"Icon-72"
        //                                                                                                   ofType: @"png"]],
        //                                     NULL);
        //    hudRenderer->addImage("IMAGE", image, Vector2D(100, 100), Vector2D(40,40));
        //
        //    Image_iOS *image2 = new Image_iOS([[UIImage alloc] initWithContentsOfFile: [mainBundle pathForResource: @"horizontal-gears"
        //                                                                                                    ofType: @"png"]],
        //                                      NULL);
        //    hudRenderer->addImage("IMAGE2", image2, Vector2D(100, 100), Vector2D(240,40));
        //
        //    builder.addRenderer(hudRenderer);
        
        
        class TestImageFactory : public HUDImageRenderer::CanvasImageFactory {
        protected:
            void drawOn(ICanvas* canvas,
                        int width,
                        int height) {
                //        canvas->setFillColor(Color::fromRGBA(0.9f, 0.4f, 0.4f, 1.0f));
                //        canvas->fillRectangle(0, 0,
                //                              width, height);
                
                //        canvas->setLineColor(Color::yellow());
                //        canvas->setLineWidth(5);
                //        canvas->strokeRectangle(0, 0,
                //                                width, height);
                
                //        canvas->setFont(GFont::sansSerif(30));
                
                //        const std::string text = "Hello World from HUD!";
                //        canvas->setFont(GFont::sansSerif(30));
                //        const Vector2F extent = canvas->textExtent(text);
                //
                //        canvas->setFillColor(Color::white());
                //        canvas->setShadow(Color::black(), 10, 2, -2);
                //
                //        canvas->fillText(text,
                //                         (width  - extent._x) / 2,
                //                         (height - extent._y) / 2);
                
                const std::string text = "glob3mobile.com";
                canvas->setFont(GFont::sansSerif(25));
                const Vector2F extent = canvas->textExtent(text);
                
                canvas->setFillColor(Color::white());
                canvas->setShadow(Color::black(), 1, 0, 0);
                
                canvas->fillText(text,
                                 (width  - extent._x) / 2,
                                 (height - extent._y) - extent._y/2);
                
                
                //        canvas->setFillColor(Color::black());
                //        canvas->fillRectangle(0, 0,
                //                              width, height);
                //
                //        ColumnCanvasElement column(Color::fromRGBA(0.9f, 0.4f, 0.4f, 1.0f),
                //                                   0,  /* margin */
                //                                   16,  /* padding */
                //                                   8   /* cornerRadius */);
                //        const GFont labelFont  = GFont::sansSerif(22);
                //        const Color labelColor = Color::white();
                //        column.add( new TextCanvasElement("Error message #1", labelFont, labelColor) );
                //        column.add( new TextCanvasElement("Another error message", labelFont, labelColor) );
                //        column.add( new TextCanvasElement("And another error message", labelFont, labelColor) );
                //        column.add( new TextCanvasElement("And just another error message", labelFont, labelColor) );
                //
                //        column.drawCentered(canvas);
            }
        };
        
        /*
         HUDImageRenderer* hudRenderer = new HUDImageRenderer(new TestImageFactory());
         builder.addRenderer(hudRenderer);
         */
    }
    
    
    //  [self createInterpolationTest: meshRenderer];
    
    //  meshRenderer->addMesh([self createPointsMesh: builder.getPlanet() ]);
    
    //Draw light direction
    if (false) {
        
        Vector3D lightDir = Vector3D(100000, 0,0);
        //    FloatBufferBuilderFromCartesian3D vertex(CenterStrategy::noCenter(), Vector3D::zero);
        FloatBufferBuilderFromCartesian3D vertex = FloatBufferBuilderFromCartesian3D::builderWithoutCenter();
        
        Vector3D v = planet->toCartesian(Geodetic3D(Angle::fromDegrees(28.127222),
                                                    Angle::fromDegrees(-15.431389),
                                                    10000));
        
        vertex.add(v);
        vertex.add(v.add(lightDir));
        //lightDir.normalized().times(planet->getRadii().maxAxis() *1.5));
        
        meshRenderer->addMesh( new DirectMesh(GLPrimitive::lines(),
                                              true,
                                              vertex.getCenter(),
                                              vertex.create(),
                                              3.0,
                                              1.0,
                                              Color::newFromRGBA(1.0, 0.0, 0.0, 1.0)));
        
        
    }
    
    GInitializationTask* initializationTask = [self createSampleInitializationTask: shapesRenderer
                                                                       geoRenderer: geoRenderer
                                                                      meshRenderer: meshRenderer
                                                                     marksRenderer: marksRenderer
                                                                            planet: planet];
    builder.setInitializationTask(initializationTask, true);
    
    PeriodicalTask* periodicalTask = [self createSamplePeriodicalTask: &builder];
    builder.addPeriodicalTask(periodicalTask);
    
    const bool logFPS = false;
    builder.setLogFPS(logFPS);
    
    const bool logDownloaderStatistics = false;
    builder.setLogDownloaderStatistics(logDownloaderStatistics);
    
    //  WidgetUserData* userData = NULL;
    //  builder.setUserData(userData);
    
    // initialization
    builder.initializeWidget();
    //  [self testGenericQuadTree:geoTileRasterizer];
    
}

- (void) testGenericQuadTree: (GEOTileRasterizer*) geoTileRasterizer{
    
    
    NSString *geoJSONFilePath = [[NSBundle mainBundle] pathForResource: @"geojson/populated_places"
                                                                ofType: @"geojson"];
    
    if (geoJSONFilePath) {
        NSString *nsGEOJSON = [NSString stringWithContentsOfFile: geoJSONFilePath
                                                        encoding: NSUTF8StringEncoding
                                                           error: nil];
        
        if (nsGEOJSON) {
            std::string geoJSON = [nsGEOJSON UTF8String];
            
            GEOObject* geoObject = GEOJSONParser::parseJSON(geoJSON);
            
            GEOFeatureCollection* fc = (GEOFeatureCollection*) geoObject;
            
            for (double areaProportion = 0.1; areaProportion < 0.9; areaProportion += 0.1) {
                
                GenericQuadTree tree(1,12,areaProportion);
                
                std::string* x = new std::string("OK");
                
                for (int i = 0; i < fc->size(); i++) {
                    GEO2DPointGeometry* p = (GEO2DPointGeometry*) fc->get(i)->getGeometry();
                    p->getPosition();
                    
                    Geodetic2D geo = p->getPosition();
                    //        printf("POINT: %s\n", geo.description().c_str());
                    
                    tree.add(p->getPosition(), x);
                }
                
                //      double areaProportion = 0.5;
                printf("TREE WITH CHILD_ARE_PROPORTION %f\n--------------------\n", areaProportion);
                GenericQuadTree_TESTER::run(tree, geoTileRasterizer);
                
                delete x;
            }
            
            delete fc;
            
        }
        
    } else{
        GenericQuadTree_TESTER::run(10000, geoTileRasterizer);
    }
    
    ////////////////////////////////////////////////////
    /*
     {
     
     NSString *geoJSONFilePath = [[NSBundle mainBundle] pathForResource: @"geojson/countries-50m"
     ofType: @"geojson"];
     
     if (geoJSONFilePath) {
     NSString *nsGEOJSON = [NSString stringWithContentsOfFile: geoJSONFilePath
     encoding: NSUTF8StringEncoding
     error: nil];
     
     if (nsGEOJSON) {
     std::string geoJSON = [nsGEOJSON UTF8String];
     
     GEOObject* geoObject = GEOJSONParser::parse(geoJSON);
     
     GEOFeatureCollection* fc = (GEOFeatureCollection*) geoObject;
     
     for (double areaProportion = 0.1; areaProportion < 0.9; areaProportion += 0.1) {
     
     GenericQuadTree tree(1,12,areaProportion);
     
     std::string* x = new std::string("OK");
     
     for (int i = 0; i < fc->size(); i++) {
     GEO2DPolygonGeometry* p = (GEO2DPolygonGeometry*) fc->get(i)->getGeometry();
     
     const std::vector<Geodetic2D*>* ps = p->getCoordinates();
     Sector *s = new Sector(*ps->at(0), *ps->at(0));
     for (unsigned int j = 0; j < ps->size(); j++) {
     if (ps->at(j) != NULL) {
     Geodetic2D g = *ps->at(j);
     Sector x(g,g);
     Sector *s2 = new Sector( s->mergedWith(x));
     delete s;
     s = s2;
     }
     }
     
     //            Geodetic2D geo = p->getPosition();
     printf("SEC: %s\n", s->description().c_str());
     
     tree.add(*s, x);
     delete s;
     }
     
     //      double areaProportion = 0.5;
     printf("TREE WITH CHILD_ARE_PROPORTION %f\n--------------------\n", areaProportion);
     GenericQuadTree_TESTER::run(tree, geoTileRasterizer);
     
     delete x;
     }
     }
     } else{
     GenericQuadTree_TESTER::run(10000, geoTileRasterizer);
     }
     
     }
     */
}

- (void)createInterpolationTest: (MeshRenderer*) meshRenderer
{
    
    const Planet* planet = Planet::createEarth();
    
    Interpolator* interpolator = new BilinearInterpolator();
    
    //  FloatBufferBuilderFromGeodetic vertices(CenterStrategy::firstVertex(),
    //                                          planet,
    //                                          Geodetic2D::zero());
    FloatBufferBuilderFromGeodetic vertices = FloatBufferBuilderFromGeodetic::builderWithFirstVertexAsCenter(planet);
    
    FloatBufferBuilderFromColor colors;
    
    
    //  FloatBufferBuilderFromCartesian3D vertices(CenterStrategy::firstVertex(),
    //                                             Vector3D::zero);
    //  FloatBufferBuilderFromColor colors;
    
    const Sector sector = Sector::fromDegrees(-34, -58,
                                              -32, -57);
    
    const double a = 2;
    //  const double valueSW = 45000 * a;
    //  const double valueSE = 45000 * a;
    //  const double valueNE = 45000 * a;
    //  const double valueNW = 45000 * a;
    const double heightSW = 10000 * a;
    const double heightSE = 20000 * a;
    const double heightNE = 5000 * a;
    const double heightNW = 45000 * a;
    const double minHeight = heightNE;
    const double maxHeight = heightNW;
    const double deltaHeight = maxHeight - minHeight;
    
    
    vertices.add(sector.getSW(), heightSW);  colors.add(1, 0, 0, 1);
    vertices.add(sector.getSE(), heightSE);  colors.add(1, 0, 0, 1);
    vertices.add(sector.getNE(), heightNE);  colors.add(1, 0, 0, 1);
    vertices.add(sector.getNW(), heightNW);  colors.add(1, 0, 0, 1);
    
    for (double lat = sector._lower._latitude._degrees;
         lat <= sector._upper._latitude._degrees;
         lat += 0.025) {
        const Angle latitude(Angle::fromDegrees(lat));
        for (double lon = sector._lower._longitude._degrees;
             lon <= sector._upper._longitude._degrees;
             lon += 0.025) {
            
            const Angle longitude(Angle::fromDegrees(lon));
            //      const Geodetic2D position(latitude,
            //                                longitude);
            
            const double height = interpolator->interpolation(sector._lower,
                                                              sector._upper,
                                                              heightSW,
                                                              heightSE,
                                                              heightNE,
                                                              heightNW,
                                                              latitude,
                                                              longitude);
            
            const float alpha = (deltaHeight == 0) ? 1 : (float) ((height - minHeight) / deltaHeight);
            
            vertices.add(latitude, longitude, height);
            
            colors.add(alpha, alpha, alpha, 1);
        }
    }
    
    
    const float lineWidth = 2;
    const float pointSize = 3;
    Color* flatColor = NULL;
    Mesh* mesh = new DirectMesh(GLPrimitive::points(),
                                //GLPrimitive::lineStrip(),
                                true,
                                vertices.getCenter(),
                                vertices.create(),
                                lineWidth,
                                pointSize,
                                flatColor,
                                colors.create());
    
    meshRenderer->addMesh( mesh );
    
    
    delete planet;
}


- (Mesh*) createPointsMesh: (const Planet*)planet
{
    //  FloatBufferBuilderFromGeodetic vertices(CenterStrategy::firstVertex(),
    //                                          planet,
    //                                          Geodetic2D::zero());
    FloatBufferBuilderFromGeodetic vertices = FloatBufferBuilderFromGeodetic::builderWithFirstVertexAsCenter(planet);
    FloatBufferBuilderFromColor colors;
    
    const Angle centerLat = Angle::fromDegreesMinutesSeconds(38, 53, 42);
    const Angle centerLon = Angle::fromDegreesMinutesSeconds(-77, 02, 11);
    
    const Angle deltaLat = Angle::fromDegrees(1).div(16);
    const Angle deltaLon = Angle::fromDegrees(1).div(16);
    
    const int steps = 128;
    const int halfSteps = steps/2;
    for (int i = -halfSteps; i < halfSteps; i++) {
        Angle lat = centerLat.add( deltaLat.times(i) );
        for (int j = -halfSteps; j < halfSteps; j++) {
            Angle lon = centerLon.add( deltaLon.times(j) );
            
            vertices.add( lat, lon, 100000 );
            
            const float red   = (float) (i + halfSteps + 1) / steps;
            const float green = (float) (j + halfSteps + 1) / steps;
            colors.add(Color::fromRGBA(red, green, 0, 1));
        }
    }
    
    const float lineWidth = 1;
    const float pointSize = 2;
    Color* flatColor = NULL;
    return new DirectMesh(GLPrimitive::points(),
                          true,
                          vertices.getCenter(),
                          vertices.create(),
                          lineWidth,
                          pointSize,
                          flatColor,
                          colors.create());
}

- (CameraRenderer*) createCameraRenderer
{
    CameraRenderer* cameraRenderer = new CameraRenderer();
    const bool useInertia = true;
    cameraRenderer->addHandler(new CameraSingleDragHandler(useInertia));
    cameraRenderer->addHandler(new CameraDoubleDragHandler());
    //cameraRenderer->addHandler(new CameraZoomAndRotateHandler(processRotation, processZoom));
    
    cameraRenderer->addHandler(new CameraRotationHandler());
    cameraRenderer->addHandler(new CameraDoubleTapHandler());
    
    return cameraRenderer;
}

- (std::vector <ICameraConstrainer*>) createCameraConstraints
{
    std::vector <ICameraConstrainer*> cameraConstraints;
    SimpleCameraConstrainer* scc = new SimpleCameraConstrainer();
    cameraConstraints.push_back(scc);
    
    return cameraConstraints;
}



- (LayerSet*) createLayerSet2
{
    LayerSet* layerSet = new LayerSet();
    
    const bool useOSM = false;
    if (useOSM) {
        layerSet->addLayer( new OSMLayer(TimeInterval::fromDays(30)) );
    }
    
    //TODO: Check merkator with elevations
    const bool useMapQuestOSM = false;
    if (useMapQuestOSM) {
        layerSet->addLayer( MapQuestLayer::newOSM(TimeInterval::fromDays(30)) );
        //    layerSet->addLayer( MapQuestLayer::newOpenAerial(TimeInterval::fromDays(30)) );
    }
    
    //  const std::string& mapKey,
    //  const TimeInterval& timeToCache,
    //  bool readExpired = true,
    //  int initialLevel = 1,
    //  int maxLevel = 19,
    //  LayerCondition* condition = NULL
    if (false) {
        layerSet->addLayer(new MapBoxLayer("examples.map-9ijuk24y",
                                           TimeInterval::fromDays(30)));
    }
    
    
    const bool useCartoDB = false;
    if (useCartoDB) {
        layerSet->addLayer( new CartoDBLayer("mdelacalle",
                                             "tm_world_borders_simpl_0_3",
                                             TimeInterval::fromDays(30)) );
    }
    const bool useMapQuestOpenAerial = false;
    if (useMapQuestOpenAerial) {
        layerSet->addLayer( MapQuestLayer::newOpenAerial(TimeInterval::fromDays(30)) );
    }
    
    const bool useMapBox = false;
    if (useMapBox) {
        //const std::string mapKey = "dgd.map-v93trj8v";
        //const std::string mapKey = "examples.map-cnkhv76j";
        const std::string mapKey = "examples.map-qogxobv1";
        layerSet->addLayer( new MapBoxLayer(mapKey, TimeInterval::fromDays(30)) );
    }
    
    const bool useHere = false;
    if (useHere) {
        layerSet->addLayer( new HereLayer("zrgCx5FrbnlPZWPHuvMO",
                                          "cdJ14wN488Oh5DH6KwQ9GA",
                                          TimeInterval::fromDays(30)) );
    }
    
    const bool useGoogleMaps = false;
    if (useGoogleMaps) {
        layerSet->addLayer( new GoogleMapsLayer("AIzaSyC9pospBjqsfpb0Y9N3E3uNMD8ELoQVOrc",
                                                TimeInterval::fromDays(30)) );
    }
    
    const bool useBingMaps = false;
    if (useBingMaps) {
        layerSet->addLayer( new BingMapsLayer(//BingMapType::Road(),
                                              //BingMapType::AerialWithLabels(),
                                              BingMapType::Aerial(),
                                              "AnU5uta7s5ql_HTrRZcPLI4_zotvNefEeSxIClF1Jf7eS-mLig1jluUdCoecV7jc",
                                              TimeInterval::fromDays(30)) );
    }
    
    const bool useOSMEditMap = false;
    if (useOSMEditMap) {
        // http://d.tiles.mapbox.com/v3/enf.osm-edit-date/4/4/5.png
        
        std::vector<std::string> subdomains;
        subdomains.push_back("a.");
        subdomains.push_back("b.");
        subdomains.push_back("c.");
        subdomains.push_back("d.");
        
        MercatorTiledLayer* osmEditMapLayer = new MercatorTiledLayer("osm-edit-map",
                                                                     "http://",
                                                                     "tiles.mapbox.com/v3/enf.osm-edit-date",
                                                                     subdomains,
                                                                     "png",
                                                                     TimeInterval::fromDays(30),
                                                                     true,
                                                                     Sector::fullSphere(),
                                                                     2,
                                                                     11,
                                                                     NULL);
        layerSet->addLayer(osmEditMapLayer);
    }
    
    const bool blueMarble = false;
    if (blueMarble) {
        WMSLayer* blueMarble = new WMSLayer("bmng200405",
                                            URL("http://www.nasa.network.com/wms?", false),
                                            WMS_1_1_0,
                                            Sector::fullSphere(),
                                            "image/jpeg",
                                            "EPSG:4326",
                                            "",
                                            false,
                                            new LevelTileCondition(0, 6),
                                            //NULL,
                                            TimeInterval::fromDays(30),
                                            true,
                                            new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                           2, 4,
                                                                           0, 6,
                                                                           LayerTilesRenderParameters::defaultTileTextureResolution(),
                                                                           LayerTilesRenderParameters::defaultTileMeshResolution(),
                                                                           false)
                                            );
        layerSet->addLayer(blueMarble);
        
        WMSLayer* i3Landsat = new WMSLayer("esat",
                                           URL("http://data.worldwind.arc.nasa.gov/wms?", false),
                                           WMS_1_1_0,
                                           Sector::fullSphere(),
                                           "image/jpeg",
                                           "EPSG:4326",
                                           "",
                                           false,
                                           new LevelTileCondition(7, 100),
                                           TimeInterval::fromDays(30),
                                           true,
                                           new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                          2, 4,
                                                                          0, 12,
                                                                          LayerTilesRenderParameters::defaultTileTextureResolution(),
                                                                          LayerTilesRenderParameters::defaultTileMeshResolution(),
                                                                          false));
        layerSet->addLayer(i3Landsat);
    }
    
    const bool useOrtoAyto = false;
    if (useOrtoAyto) {
        WMSLayer* ortoAyto = new WMSLayer("orto_refundida,etiquetas_50k,Numeros%20de%20Gobierno,etiquetas%20inicial,etiquetas%2020k,Nombres%20de%20Via,etiquetas%2015k,etiquetas%202k,etiquetas%2010k",
                                          URL("http://195.57.27.86/wms_etiquetas_con_orto.mapdef?", false),
                                          WMS_1_1_0,
                                          Sector(Geodetic2D(Angle::fromDegrees(39.350228), Angle::fromDegrees(-6.508713)),
                                                 Geodetic2D(Angle::fromDegrees(39.536351), Angle::fromDegrees(-6.25946))),
                                          "image/jpeg",
                                          "EPSG:4326",
                                          "",
                                          false,
                                          new LevelTileCondition(3, 20),
                                          //NULL,
                                          TimeInterval::fromDays(30),
                                          false,
                                          new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                         2, 4,
                                                                         0, 20,
                                                                         LayerTilesRenderParameters::defaultTileTextureResolution(),
                                                                         LayerTilesRenderParameters::defaultTileMeshResolution(),
                                                                         false));
        layerSet->addLayer(ortoAyto);
    }
    
    bool useWMSBing = false;
    if (useWMSBing) {
        WMSLayer* blueMarble = new WMSLayer("bmng200405",
                                            URL("http://www.nasa.network.com/wms?", false),
                                            WMS_1_1_0,
                                            Sector::fullSphere(),
                                            "image/jpeg",
                                            "EPSG:4326",
                                            "",
                                            false,
                                            new LevelTileCondition(0, 5),
                                            TimeInterval::fromDays(30),
                                            true);
        layerSet->addLayer(blueMarble);
        
        
        //    bool enabled = true;
        //    WMSLayer* bing = LayerBuilder::createBingLayer(enabled);
        WMSLayer* bing = new WMSLayer("ve",
                                      URL("http://worldwind27.arc.nasa.gov/wms/virtualearth?", false),
                                      WMS_1_1_0,
                                      Sector::fullSphere(),
                                      "image/jpeg",
                                      "EPSG:4326",
                                      "",
                                      false,
                                      new LevelTileCondition(6, 500),
                                      TimeInterval::fromDays(30),
                                      true);
        layerSet->addLayer(bing);
    }
    
    if (true) {
        WMSLayer* political = new WMSLayer("topp:cia",
                                           URL("http://worldwind22.arc.nasa.gov/geoserver/wms?", false),
                                           WMS_1_1_0,
                                           Sector::fullSphere(),
                                           "image/png",
                                           "EPSG:4326",
                                           "countryboundaries",
                                           true,
                                           NULL,
                                           TimeInterval::fromDays(30),
                                           true);
        layerSet->addLayer(political);
    }
    
    bool useOSM_WMS = false;
    if (useOSM_WMS) {
        WMSLayer *osm = new WMSLayer("osm_auto:all",
                                     URL("http://129.206.228.72/cached/osm", false),
                                     WMS_1_1_0,
                                     //Sector::fromDegrees(-85.05, -180.0, 85.05, 180.0),
                                     Sector::fullSphere(),
                                     "image/jpeg",
                                     "EPSG:4326",
                                     "",
                                     false,
                                     NULL,
                                     TimeInterval::fromDays(30),
                                     true);
        // osm->setEnable(false);
        
        layerSet->addLayer(osm);
    }
    
    
    //  WMSLayer* pressure = new WMSLayer("pressure_cntr", //
    //                                    URL("http://wms.openweathermap.org/service", false), //
    //                                    WMS_1_1_0, //
    //                                    Sector::fromDegrees(-85.05, -180.0, 85.05, 180.0), //
    //                                    "image/png", //
    //                                    "EPSG:4326", //
    //                                    "", //
    //                                    true, //
    //                                    NULL,
    //                                    TimeInterval::zero());
    //  layerSet->addLayer(pressure);
    
    const bool usePnoaLayer = false;
    if (usePnoaLayer) {
        WMSLayer *pnoa = new WMSLayer("PNOA",
                                      URL("http://www.idee.es/wms/PNOA/PNOA", false),
                                      WMS_1_1_0,
                                      Sector::fromDegrees(21, -18, 45, 6),
                                      "image/png",
                                      "EPSG:4326",
                                      "",
                                      true,
                                      NULL,
                                      TimeInterval::fromDays(30),
                                      true);
        layerSet->addLayer(pnoa);
        
        class PNOATerrainTouchEventListener : public LayerTouchEventListener {
        public:
            bool onTerrainTouch(const G3MEventContext* context,
                                const LayerTouchEvent& event) {
                const URL url = event.getLayer()->getFeatureInfoURL(event.getPosition().asGeodetic2D(),
                                                                    event.getSector());
                
                printf ("PNOA touched. Feature info = %s\n", url.getPath().c_str());
                
                return true;
            }
        };
        
        pnoa->addLayerTouchEventListener(new PNOATerrainTouchEventListener());
    }
    
    const bool testURLescape = false;
    if (testURLescape) {
        WMSLayer *ayto = new WMSLayer(URL::escape("Ejes de via"),
                                      URL("http://sig.caceres.es/wms_callejero.mapdef?", false),
                                      WMS_1_1_0,
                                      Sector::fullSphere(),
                                      "image/png",
                                      "EPSG:4326",
                                      "",
                                      true,
                                      NULL,
                                      TimeInterval::fromDays(30),
                                      true);
        layerSet->addLayer(ayto);
        
    }
    
    //  WMSLayer *vias = new WMSLayer("VIAS",
    //                                "http://idecan2.grafcan.es/ServicioWMS/Callejero",
    //                                WMS_1_1_0,
    //                                "image/gif",
    //                                Sector::fromDegrees(22.5,-22.5, 33.75, -11.25),
    //                                "EPSG:4326",
    //                                "",
    //                                true,
    //                                Angle::nan(),
    //                                Angle::nan());
    //  layerSet->addLayer(vias);
    
    //  WMSLayer *osm = new WMSLayer("bing",
    //                               "http://wms.latlon.org/",
    //                               WMS_1_1_0,
    //                               "image/jpeg",
    //                               Sector::fromDegrees(-85.05, -180.0, 85.5, 180.0),
    //                               "EPSG:4326",
    //                               "",
    //                               false,
    //                               Angle::nan(),
    //                               Angle::nan());
    //  layerSet->addLayer(osm);
    
    if (false) {
        WMSLayer* catastro = new WMSLayer("catastro", //
                                          URL("http://ovc.catastro.meh.es/Cartografia/WMS/ServidorWMS.aspx", false), //
                                          WMS_1_1_0, //
                                          Sector::fromDegrees(26.275479, -18.409639, 44.85536, 5.225974),
                                          "image/png", //
                                          "EPSG:4326", //
                                          "", //
                                          true, //
                                          NULL, //
                                          TimeInterval::fromDays(30),
                                          true);
        
        class CatastroTerrainTouchEventListener : public LayerTouchEventListener {
        public:
            bool onTerrainTouch(const G3MEventContext* context,
                                const LayerTouchEvent& event) {
                const URL url = event.getLayer()->getFeatureInfoURL(event.getPosition().asGeodetic2D(),
                                                                    event.getSector());
                
                ILogger::instance()->logInfo("%s", url.getPath().c_str());
                
                return true;
            }
        };
        
        catastro->addLayerTouchEventListener(new CatastroTerrainTouchEventListener());
        
        layerSet->addLayer(catastro);
    }
    
    if (false) {
        WMSLayer* bing = LayerBuilder::createBingLayer(true);
        layerSet->addLayer(bing);
    }
    
    if (true) {
        WMSLayer* temp = new WMSLayer("snow",
                                      URL("http://wms.openweathermap.org/service", false),
                                      WMS_1_1_0,
                                      Sector::fullSphere(),
                                      "image/png",
                                      "EPSG:4326",
                                      "",
                                      true,
                                      NULL,
                                      TimeInterval::zero(),
                                      true);
        layerSet->addLayer(temp);
        
        class TempTerrainTouchEventListener : public LayerTouchEventListener {
        public:
            bool onTerrainTouch(const G3MEventContext* context,
                                const LayerTouchEvent& event) {
                const URL url = event.getLayer()->getFeatureInfoURL(event.getPosition().asGeodetic2D(),
                                                                    event.getSector());
                
                printf ("touched Temperature. Feature info = %s\n", url.getPath().c_str());
                
                return true;
            }
        };
        
        temp->addLayerTouchEventListener(new TempTerrainTouchEventListener());
    }
    
    //Worng TEMP Layer
    if (false) {
        WMSLayer* temp = new WMSLayer("temp",
                                      URL("http://wms.openweathermap.org/service", false),
                                      WMS_1_1_0,
                                      Sector::fullSphere(),
                                      "image/png2",  //WRONG
                                      "EPSG:4326",
                                      "",
                                      true,
                                      NULL,
                                      TimeInterval::zero(),
                                      true);
        layerSet->addLayer(temp);
    }
    
    //  if (true) {
    //    layerSet->addLayer( new URLTemplateLayer() );
    //  }
    
    return layerSet;
}

- (LayerSet*) createLayerSet
{
    LayerSet* layerSet = new LayerSet();
    
    const bool useOSM = false;
    if (useOSM) {
        layerSet->addLayer( new OSMLayer(TimeInterval::fromDays(30)) );
    }
    
    //TODO: Check merkator with elevations
    const bool useMapQuestOSM = false;
    if (useMapQuestOSM) {
        layerSet->addLayer( MapQuestLayer::newOSM(TimeInterval::fromDays(30)) );
        //    layerSet->addLayer( MapQuestLayer::newOpenAerial(TimeInterval::fromDays(30)) );
    }
    
    //  const std::string& mapKey,
    //  const TimeInterval& timeToCache,
    //  bool readExpired = true,
    //  int initialLevel = 1,
    //  int maxLevel = 19,
    //  LayerCondition* condition = NULL
    if (false) {
        layerSet->addLayer(new MapBoxLayer("examples.map-9ijuk24y",
                                           TimeInterval::fromDays(30)));
    }
    
    
    const bool useCartoDB = false;
    if (useCartoDB) {
        layerSet->addLayer( new CartoDBLayer("mdelacalle",
                                             "tm_world_borders_simpl_0_3",
                                             TimeInterval::fromDays(30)) );
    }
    const bool useMapQuestOpenAerial = false;
    if (useMapQuestOpenAerial) {
        layerSet->addLayer( MapQuestLayer::newOpenAerial(TimeInterval::fromDays(30)) );
    }
    
    const bool useMapBox = false;
    if (useMapBox) {
        //const std::string mapKey = "dgd.map-v93trj8v";
        //const std::string mapKey = "examples.map-cnkhv76j";
        const std::string mapKey = "examples.map-qogxobv1";
        layerSet->addLayer( new MapBoxLayer(mapKey, TimeInterval::fromDays(30)) );
    }
    
    const bool useHere = false;
    if (useHere) {
        layerSet->addLayer( new HereLayer("zrgCx5FrbnlPZWPHuvMO",
                                          "cdJ14wN488Oh5DH6KwQ9GA",
                                          TimeInterval::fromDays(30)) );
    }
    
    const bool useGoogleMaps = false;
    if (useGoogleMaps) {
        layerSet->addLayer( new GoogleMapsLayer("AIzaSyC9pospBjqsfpb0Y9N3E3uNMD8ELoQVOrc",
                                                TimeInterval::fromDays(30)) );
    }
    
    const bool useBingMaps = false;
    if (useBingMaps) {
        layerSet->addLayer( new BingMapsLayer(//BingMapType::Road(),
                                              //BingMapType::AerialWithLabels(),
                                              BingMapType::Aerial(),
                                              "AnU5uta7s5ql_HTrRZcPLI4_zotvNefEeSxIClF1Jf7eS-mLig1jluUdCoecV7jc",
                                              TimeInterval::fromDays(30)) );
    }
    
    const bool useOSMEditMap = false;
    if (useOSMEditMap) {
        // http://d.tiles.mapbox.com/v3/enf.osm-edit-date/4/4/5.png
        
        std::vector<std::string> subdomains;
        subdomains.push_back("a.");
        subdomains.push_back("b.");
        subdomains.push_back("c.");
        subdomains.push_back("d.");
        
        MercatorTiledLayer* osmEditMapLayer = new MercatorTiledLayer("osm-edit-map",
                                                                     "http://",
                                                                     "tiles.mapbox.com/v3/enf.osm-edit-date",
                                                                     subdomains,
                                                                     "png",
                                                                     TimeInterval::fromDays(30),
                                                                     true,
                                                                     Sector::fullSphere(),
                                                                     2,
                                                                     11,
                                                                     NULL);
        layerSet->addLayer(osmEditMapLayer);
    }
    
    const bool blueMarble = true;
    if (blueMarble) {
        WMSLayer* blueMarble = new WMSLayer("bmng200405",
                                            URL("http://www.nasa.network.com/wms?", false),
                                            WMS_1_1_0,
                                            Sector::fullSphere(),
                                            "image/jpeg",
                                            "EPSG:4326",
                                            "",
                                            false,
                                            new LevelTileCondition(0, 6),
                                            //NULL,
                                            TimeInterval::fromDays(30),
                                            true,
                                            new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                           2, 4,
                                                                           0, 6,
                                                                           LayerTilesRenderParameters::defaultTileTextureResolution(),
                                                                           LayerTilesRenderParameters::defaultTileMeshResolution(),
                                                                           false)
                                            );
        layerSet->addLayer(blueMarble);
        
        WMSLayer* i3Landsat = new WMSLayer("esat",
                                           URL("http://data.worldwind.arc.nasa.gov/wms?", false),
                                           WMS_1_1_0,
                                           Sector::fullSphere(),
                                           "image/jpeg",
                                           "EPSG:4326",
                                           "",
                                           false,
                                           new LevelTileCondition(7, 100),
                                           TimeInterval::fromDays(30),
                                           true,
                                           new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                          2, 4,
                                                                          0, 12,
                                                                          LayerTilesRenderParameters::defaultTileTextureResolution(),
                                                                          LayerTilesRenderParameters::defaultTileMeshResolution(),
                                                                          false));
        layerSet->addLayer(i3Landsat);
    }
    
    const bool useOrtoAyto = false;
    if (useOrtoAyto) {
        WMSLayer* ortoAyto = new WMSLayer("orto_refundida,etiquetas_50k,Numeros%20de%20Gobierno,etiquetas%20inicial,etiquetas%2020k,Nombres%20de%20Via,etiquetas%2015k,etiquetas%202k,etiquetas%2010k",
                                          URL("http://195.57.27.86/wms_etiquetas_con_orto.mapdef?", false),
                                          WMS_1_1_0,
                                          Sector(Geodetic2D(Angle::fromDegrees(39.350228), Angle::fromDegrees(-6.508713)),
                                                 Geodetic2D(Angle::fromDegrees(39.536351), Angle::fromDegrees(-6.25946))),
                                          "image/jpeg",
                                          "EPSG:4326",
                                          "",
                                          false,
                                          new LevelTileCondition(3, 20),
                                          //NULL,
                                          TimeInterval::fromDays(30),
                                          false,
                                          new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                         2, 4,
                                                                         0, 20,
                                                                         LayerTilesRenderParameters::defaultTileTextureResolution(),
                                                                         LayerTilesRenderParameters::defaultTileMeshResolution(),
                                                                         false));
        layerSet->addLayer(ortoAyto);
    }
    
    bool useWMSBing = false;
    if (useWMSBing) {
        WMSLayer* blueMarble = new WMSLayer("bmng200405",
                                            URL("http://www.nasa.network.com/wms?", false),
                                            WMS_1_1_0,
                                            Sector::fullSphere(),
                                            "image/jpeg",
                                            "EPSG:4326",
                                            "",
                                            false,
                                            new LevelTileCondition(0, 5),
                                            TimeInterval::fromDays(30),
                                            true);
        layerSet->addLayer(blueMarble);
        
        
        //    bool enabled = true;
        //    WMSLayer* bing = LayerBuilder::createBingLayer(enabled);
        WMSLayer* bing = new WMSLayer("ve",
                                      URL("http://worldwind27.arc.nasa.gov/wms/virtualearth?", false),
                                      WMS_1_1_0,
                                      Sector::fullSphere(),
                                      "image/jpeg",
                                      "EPSG:4326",
                                      "",
                                      false,
                                      new LevelTileCondition(6, 500),
                                      TimeInterval::fromDays(30),
                                      true);
        layerSet->addLayer(bing);
    }
    
    if (false) {
        WMSLayer* political = new WMSLayer("topp:cia",
                                           URL("http://worldwind22.arc.nasa.gov/geoserver/wms?", false),
                                           WMS_1_1_0,
                                           Sector::fullSphere(),
                                           "image/png",
                                           "EPSG:4326",
                                           "countryboundaries",
                                           true,
                                           NULL,
                                           TimeInterval::fromDays(30),
                                           true);
        layerSet->addLayer(political);
    }
    
    bool useOSM_WMS = false;
    if (useOSM_WMS) {
        WMSLayer *osm = new WMSLayer("osm_auto:all",
                                     URL("http://129.206.228.72/cached/osm", false),
                                     WMS_1_1_0,
                                     //Sector::fromDegrees(-85.05, -180.0, 85.05, 180.0),
                                     Sector::fullSphere(),
                                     "image/jpeg",
                                     "EPSG:4326",
                                     "",
                                     false,
                                     NULL,
                                     TimeInterval::fromDays(30),
                                     true);
        // osm->setEnable(false);
        
        layerSet->addLayer(osm);
    }
    
    
    //  WMSLayer* pressure = new WMSLayer("pressure_cntr", //
    //                                    URL("http://wms.openweathermap.org/service", false), //
    //                                    WMS_1_1_0, //
    //                                    Sector::fromDegrees(-85.05, -180.0, 85.05, 180.0), //
    //                                    "image/png", //
    //                                    "EPSG:4326", //
    //                                    "", //
    //                                    true, //
    //                                    NULL,
    //                                    TimeInterval::zero());
    //  layerSet->addLayer(pressure);
    
    const bool usePnoaLayer = false;
    if (usePnoaLayer) {
        WMSLayer *pnoa = new WMSLayer("PNOA",
                                      URL("http://www.idee.es/wms/PNOA/PNOA", false),
                                      WMS_1_1_0,
                                      Sector::fromDegrees(21, -18, 45, 6),
                                      "image/png",
                                      "EPSG:4326",
                                      "",
                                      true,
                                      NULL,
                                      TimeInterval::fromDays(30),
                                      true);
        layerSet->addLayer(pnoa);
        
        class PNOATerrainTouchEventListener : public LayerTouchEventListener {
        public:
            bool onTerrainTouch(const G3MEventContext* context,
                                const LayerTouchEvent& event) {
                const URL url = event.getLayer()->getFeatureInfoURL(event.getPosition().asGeodetic2D(),
                                                                    event.getSector());
                
                printf ("PNOA touched. Feature info = %s\n", url.getPath().c_str());
                
                return true;
            }
        };
        
        pnoa->addLayerTouchEventListener(new PNOATerrainTouchEventListener());
    }
    
    const bool testURLescape = false;
    if (testURLescape) {
        WMSLayer *ayto = new WMSLayer(URL::escape("Ejes de via"),
                                      URL("http://sig.caceres.es/wms_callejero.mapdef?", false),
                                      WMS_1_1_0,
                                      Sector::fullSphere(),
                                      "image/png",
                                      "EPSG:4326",
                                      "",
                                      true,
                                      NULL,
                                      TimeInterval::fromDays(30),
                                      true);
        layerSet->addLayer(ayto);
        
    }
    
    //  WMSLayer *vias = new WMSLayer("VIAS",
    //                                "http://idecan2.grafcan.es/ServicioWMS/Callejero",
    //                                WMS_1_1_0,
    //                                "image/gif",
    //                                Sector::fromDegrees(22.5,-22.5, 33.75, -11.25),
    //                                "EPSG:4326",
    //                                "",
    //                                true,
    //                                Angle::nan(),
    //                                Angle::nan());
    //  layerSet->addLayer(vias);
    
    //  WMSLayer *osm = new WMSLayer("bing",
    //                               "http://wms.latlon.org/",
    //                               WMS_1_1_0,
    //                               "image/jpeg",
    //                               Sector::fromDegrees(-85.05, -180.0, 85.5, 180.0),
    //                               "EPSG:4326",
    //                               "",
    //                               false,
    //                               Angle::nan(),
    //                               Angle::nan());
    //  layerSet->addLayer(osm);
    
    if (false) {
        WMSLayer* catastro = new WMSLayer("catastro", //
                                          URL("http://ovc.catastro.meh.es/Cartografia/WMS/ServidorWMS.aspx", false), //
                                          WMS_1_1_0, //
                                          Sector::fromDegrees(26.275479, -18.409639, 44.85536, 5.225974),
                                          "image/png", //
                                          "EPSG:4326", //
                                          "", //
                                          true, //
                                          NULL, //
                                          TimeInterval::fromDays(30),
                                          true);
        
        class CatastroTerrainTouchEventListener : public LayerTouchEventListener {
        public:
            bool onTerrainTouch(const G3MEventContext* context,
                                const LayerTouchEvent& event) {
                const URL url = event.getLayer()->getFeatureInfoURL(event.getPosition().asGeodetic2D(),
                                                                    event.getSector());
                
                ILogger::instance()->logInfo("%s", url.getPath().c_str());
                
                return true;
            }
        };
        
        catastro->addLayerTouchEventListener(new CatastroTerrainTouchEventListener());
        
        layerSet->addLayer(catastro);
    }
    
    if (false) {
        WMSLayer* bing = LayerBuilder::createBingLayer(true);
        layerSet->addLayer(bing);
    }
    
    if (true) {
        WMSLayer* temp = new WMSLayer("snow",
                                      URL("http://wms.openweathermap.org/service", false),
                                      WMS_1_1_0,
                                      Sector::fullSphere(),
                                      "image/png",
                                      "EPSG:4326",
                                      "",
                                      true,
                                      NULL,
                                      TimeInterval::zero(),
                                      true);
        layerSet->addLayer(temp);
        
        class TempTerrainTouchEventListener : public LayerTouchEventListener {
        public:
            bool onTerrainTouch(const G3MEventContext* context,
                                const LayerTouchEvent& event) {
                const URL url = event.getLayer()->getFeatureInfoURL(event.getPosition().asGeodetic2D(),
                                                                    event.getSector());
                
                printf ("touched Temperature. Feature info = %s\n", url.getPath().c_str());
                
                return true;
            }
        };
        
        temp->addLayerTouchEventListener(new TempTerrainTouchEventListener());
    }
    
    //Worng TEMP Layer
    if (false) {
        WMSLayer* temp = new WMSLayer("temp",
                                      URL("http://wms.openweathermap.org/service", false),
                                      WMS_1_1_0,
                                      Sector::fullSphere(),
                                      "image/png2",  //WRONG
                                      "EPSG:4326",
                                      "",
                                      true,
                                      NULL,
                                      TimeInterval::zero(),
                                      true);
        layerSet->addLayer(temp);
    }
    
    //  if (true) {
    //    layerSet->addLayer( new URLTemplateLayer() );
    //  }
    
    return layerSet;
}

- (TilesRenderParameters*) createPlanetRendererParameters
{
    const bool renderDebug = false;
    const bool useTilesSplitBudget = true;
    const bool forceFirstLevelTilesRenderOnStart = true;
    const bool incrementalTileQuality = false;
    const Quality quality = QUALITY_LOW;
    
    return new TilesRenderParameters(renderDebug,
                                     useTilesSplitBudget,
                                     forceFirstLevelTilesRenderOnStart,
                                     incrementalTileQuality,
                                     quality);
}

- (PlanetRenderer*) createPlanetRenderer: (TilesRenderParameters*) parameters
                                layerSet: (LayerSet*) layerSet
{
    PlanetRendererBuilder* trBuilder = new PlanetRendererBuilder();
    trBuilder->setShowStatistics(false);
    trBuilder->setPlanetRendererParameters(parameters);
    trBuilder->setLayerSet(layerSet);
    
    PlanetRenderer* planetRenderer = trBuilder->create();
    
    return planetRenderer;
}

- (MarksRenderer*) createMarksRenderer
{
    
    class TestMarkTouchListener : public MarkTouchListener {
    public:
        bool touchedMark(Mark* mark) {
            NSString* message = [NSString stringWithFormat: @"Touched on mark \"%s\"", mark->getLabel().c_str()];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Glob3 Demo"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            return true;
        }
    };
    
    
    // marks renderer
    const bool readyWhenMarksReady = false;
    MarksRenderer* marksRenderer = new MarksRenderer(readyWhenMarksReady);
    
    marksRenderer->setMarkTouchListener(new TestMarkTouchListener(), true);
    
    Mark* m1 = new Mark("Fuerteventura",
                        URL("http://glob3m.glob3mobile.com/icons/markers/g3m.png", false),
                        Geodetic3D(Angle::fromDegrees(28.05), Angle::fromDegrees(-14.36), 0),
                        RELATIVE_TO_GROUND);
    marksRenderer->addMark(m1);
    
    
    if (true) {
        for (int i = 0; i < 10; i+=2) {
            for (int j = 0; j < 10; j+=2) {
                Geodetic3D g(Angle::fromDegrees(28.05 + i), Angle::fromDegrees(-14.36 + j - 10), (i+j)*10000);
                
                Mark* m1 = new Mark("M", g, RELATIVE_TO_GROUND);
                marksRenderer->addMark(m1);
                
            }
        }
    }
    
    
    Mark* m2 = new Mark(URL("file:///plane.png", false),
                        Geodetic3D(Angle::fromDegrees(28.05), Angle::fromDegrees(-15.36), 0),
                        RELATIVE_TO_GROUND);
    marksRenderer->addMark(m2);
    
    //  Mark* m3 = new Mark("Washington, DC",
    //                      Geodetic3D(Angle::fromDegreesMinutesSeconds(38, 53, 42.24),
    //                                 Angle::fromDegreesMinutesSeconds(-77, 2, 10.92),
    //                                 0),
    //                      0);
    //  marksRenderer->addMark(m3);
    
    if (false) {
        for (int i = 0; i < 2000; i++) {
            const Angle latitude  = Angle::fromDegrees( (int) (arc4random() % 180) - 90 );
            const Angle longitude = Angle::fromDegrees( (int) (arc4random() % 360) - 180 );
            
            marksRenderer->addMark(new Mark("Random",
                                            URL("http://glob3m.glob3mobile.com/icons/markers/g3m.png", false),
                                            Geodetic3D(latitude, longitude, 0), RELATIVE_TO_GROUND));
        }
    }
    
    return marksRenderer;
    
}

- (ShapesRenderer*) createShapesRenderer: (const Planet*) planet
{
    ShapesRenderer* shapesRenderer = new ShapesRenderer();
    Shape* quad1 = new QuadShape(new Geodetic3D(Angle::fromDegrees(37.78333333),
                                                Angle::fromDegrees(-122),
                                                8000),
                                 RELATIVE_TO_GROUND,
                                 URL("file:///g3m-marker.png", false),
                                 50000, 50000,
                                 false);
    shapesRenderer->addShape(quad1);
    
    Shape* quad2 = new QuadShape(new Geodetic3D(Angle::fromDegrees(37.78333333),
                                                Angle::fromDegrees(-123),
                                                8000),
                                 RELATIVE_TO_GROUND,
                                 35000, 75000,
                                 Color::newFromRGBA(1, 0, 1, 0.5),
                                 true);
    shapesRenderer->addShape(quad2);
    
    Shape* circle = new CircleShape(new Geodetic3D(Angle::fromDegrees(38.78333333),
                                                   Angle::fromDegrees(-123),
                                                   8000),
                                    ABSOLUTE,
                                    50000,
                                    Color::fromRGBA(1, 1, 0, 0.5));
    //  circle->setHeading( Angle::fromDegrees(45) );
    //  circle->setPitch( Angle::fromDegrees(45) );
    //  circle->setScale(2.0, 0.5, 1);
    shapesRenderer->addShape(circle);
    
    Shape* box = new BoxShape(new Geodetic3D(Angle::fromDegrees(39.78333333),
                                             Angle::fromDegrees(-122),
                                             45000),
                              ABSOLUTE,
                              Vector3D(20000, 30000, 50000),
                              2,
                              Color::fromRGBA(0,    1, 0, 0.5),
                              Color::newFromRGBA(0, 0.75, 0, 0.75));
    box->setAnimatedScale(1, 1, 20);
    shapesRenderer->addShape(box);
    
    //    const URL textureURL("file:///world.jpg", false);
    //
    //  const double factor = 2e5;
    //  const Vector3D radius1(factor, factor, factor);
    //  const Vector3D radius2(factor*1.5, factor*1.5, factor*1.5);
    //  const Vector3D radiusBox(factor, factor*1.5, factor*2);
    
    
    //  Shape* box1 = new BoxShape(new Geodetic3D(Angle::fromDegrees(0),
    //                                           Angle::fromDegrees(10),
    //                                           radiusBox.z()/2),
    //                            ABSOLUTE,
    //                            radiusBox,
    //                            2,
    //                            Color::fromRGBA(0,    1, 0, 1),
    //                            Color::newFromRGBA(0, 0.75, 0, 1));
    //  //box->setAnimatedScale(1, 1, 20);
    //  shapesRenderer->addShape(box1);
    //
    //
    //    Shape* ellipsoid1 = new EllipsoidShape(new Geodetic3D(Angle::fromDegrees(0),
    //                                                          Angle::fromDegrees(0),
    //                                                          radius1._x),
    //                                           ABSOLUTE,
    //                                           planet,
    //                                           URL("file:///world.jpg", false),
    //                                           radius1,
    //                                           32,
    //                                           0,
    //                                           false,
    //                                           false
    //                                           //Color::newFromRGBA(0,    0.5, 0.8, 0.5),
    //                                           //Color::newFromRGBA(0, 0.75, 0, 0.75)
    //                                           );
    //  //ellipsoid1->setScale(2);
    //    shapesRenderer->addShape(ellipsoid1);
    //
    //  Shape* mercator1 = new EllipsoidShape(new Geodetic3D(Angle::fromDegrees(0),
    //                                                       Angle::fromDegrees(5),
    //                                                       radius2._x),
    //                                          ABSOLUTE,
    //                                          planet,
    //                                          URL("file:///mercator_debug.png", false),
    //                                          radius2,
    //                                          32,
    //                                          0,
    //                                          false,
    //                                          true
    //                                          //Color::newFromRGBA(0.5,    0.0, 0.8, 0.5),
    //                                          //Color::newFromRGBA(0, 0.75, 0, 0.75)
    //                                          );
    //    shapesRenderer->addShape(mercator1);
    
    //  Shape* mercator2 = new EllipsoidShape(new Geodetic3D(Angle::fromDegrees(41),
    //                                                       Angle::fromDegrees(-117),
    //                                                       radius._x * 1.1),
    //                                        URL("file:///mercator.jpg", false),
    //                                        radius,
    //                                        32,
    //                                        0,
    //                                        true,
    //                                        true
    //                                        //Color::newFromRGBA(0.5,    0.0, 0.8, 0.5),
    //                                        //Color::newFromRGBA(0, 0.75, 0, 0.75)
    //                                        );
    //  shapesRenderer->addShape(mercator2);
    
    //  Shape* colored = new EllipsoidShape(new Geodetic3D(Angle::fromDegrees(41),
    //                                                     Angle::fromDegrees(-115),
    //                                                     radius._x * 1.1),
    //                                      radius,
    //                                      16,
    //                                      1,
    //                                      true,
    //                                      Color::newFromRGBA(1, 1, 0, 0.75),
    //                                      Color::newFromRGBA(0, 0, 0, 1)
    //                                      );
    //  shapesRenderer->addShape(colored);
    
    //  // to test layout::splitOverCircle
    //  Geodetic3D* center = new Geodetic3D(Angle::fromDegrees(40.429701),
    //                                      Angle::fromDegrees(-3.703766),
    //                                      0);
    //  double radius = 5e4;
    //  Vector3D radiusVector(radius, radius, radius);
    //  Shape* centralSphere = new EllipsoidShape(center,
    //                                      radiusVector,
    //                                      8,
    //                                      1,
    //                                      false,
    //                                      false,
    //                                      Color::newFromRGBA(0.8, 0, 0, 0.5),
    //                                      Color::newFromRGBA(0, 0, 0, 0.5)
    //                                      );
    //  shapesRenderer->addShape(centralSphere);
    //  int splits = 5;
    //  std::vector<Geodetic3D*> spheres3D = LayoutUtils::splitOverCircle(planet, *center, 1e6, splits);
    //  for (int i=0; i<splits; i++) {
    //    Shape* sphere = new EllipsoidShape(spheres3D[i],
    //                                       radiusVector,
    //                                       8,
    //                                       1,
    //                                       false,
    //                                       false,
    //                                       Color::newFromRGBA(0.0, 0.8, 0, 0.5),
    //                                       Color::newFromRGBA(0, 0, 0, 0.5)
    //                                       );
    //    shapesRenderer->addShape(sphere);
    //  }
    //  std::vector<Geodetic2D*> spheres2D = LayoutUtils::splitOverCircle(planet, center->asGeodetic2D(), 1e6, splits, Angle::fromDegrees(36));
    //  for (int i=0; i<splits; i++) {
    //    Geodetic3D* centerSplit = new Geodetic3D(*spheres2D[i], 0);
    //    delete spheres2D[i];
    //    Shape* sphere = new EllipsoidShape(centerSplit,
    //                                       radiusVector,
    //                                       8,
    //                                       1,
    //                                       false,
    //                                       false,
    //                                       Color::newFromRGBA(0.8, 0.8, 0, 0.5),
    //                                       Color::newFromRGBA(0, 0, 0, 0.5)
    //                                       );
    //    shapesRenderer->addShape(sphere);
    //  }
    
    Image_iOS *image1 = new Image_iOS([[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon-72" ofType:@"png"]], NULL);
    
    Image_iOS *image2 = new Image_iOS([[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Default-Landscape" ofType:@"png"]], NULL);
    
    std::vector<const IImage*> images;
    images.push_back(image2);
    images.push_back(image1);
    
    std::vector<RectangleF *> srcRs;
    srcRs.push_back(new RectangleF(0,0,1024,748));
    srcRs.push_back(new RectangleF(0, 0, 72, 72));
    
    std::vector<RectangleF *> destRs;
    destRs.push_back(new RectangleF(0,0,256,256));
    destRs.push_back(new RectangleF(0, 128, 64, 64));
    
    class QuadListener: public IImageListener {
        ShapesRenderer* _sr;
    public:
        
        QuadListener(ShapesRenderer* sr):_sr(sr) {
            
        }
        
        void imageCreated(const IImage* image) {
            
            Shape* quadImages = new QuadShape(new Geodetic3D(Angle::fromDegrees(28.410728),
                                                             Angle::fromDegrees(-16.339417),
                                                             8000),
                                              RELATIVE_TO_GROUND,
                                              image,
                                              49000, 38000,
                                              false);
            
            _sr->addShape(quadImages);
        }
    };
    
    
    IImageUtils::combine(Vector2I(256,256),
                         images,
                         srcRs,
                         destRs,
                         new QuadListener(shapesRenderer), true);
    
    for (int i = 0; i < 2; i++) {
        delete images[i];
        delete srcRs[i];
        delete destRs[i];
    }
    
    return shapesRenderer;
}


class SampleSymbolizer : public GEOSymbolizer {
private:
    mutable int _colorIndex = 0;
    
    const Planet* _planet;
    
private:
    
    //  GEOLine2DStyle createLineStyle(const GEOGeometry* geometry) const {
    //    const JSONObject* properties = geometry->getFeature()->getProperties();
    //
    //    const std::string type = properties->getAsString("type", "");
    //
    //    if (type.compare("Water Indicator") == 0) {
    //      return GEOLine2DStyle(Color::fromRGBA(1, 1, 1, 1), 2);
    //    }
    //
    //    return GEOLine2DStyle(Color::fromRGBA(1, 1, 0, 1), 2);
    //  }
    
    GEO2DLineRasterStyle createPolygonLineRasterStyle(const GEOGeometry* geometry) const {
        const JSONObject* properties = geometry->getFeature()->getProperties();
        
        
        //    const Color color = Color::fromRGBA(0.85, 0.85, 0.85, 0.6);
        const int colorIndex = (int) properties->getAsNumber("mapcolor7", 0);
        
        const Color color = Color::fromRGBA(0.7, 0, 0, 0.5).wheelStep(7, colorIndex).muchLighter().muchLighter();
        
        
        float dashLengths[] = {};
        int dashCount = 0;
        //    float dashLengths[] = {3, 6};
        //    int dashCount = 2;
        
        return GEO2DLineRasterStyle(color,
                                    2,
                                    CAP_ROUND,
                                    JOIN_ROUND,
                                    1,
                                    dashLengths,
                                    dashCount,
                                    0);
    }
    
    GEO2DSurfaceRasterStyle createPolygonSurfaceRasterStyle(const GEOGeometry* geometry) const {
        const JSONObject* properties = geometry->getFeature()->getProperties();
        
        //    std::string name = properties->getAsString("name", "");
        //    if (name.compare("Russia") == 0) {
        //      int _XXX;
        //      printf("break point on me\n");
        //    }
        //    if (name.compare("Antarctica") == 0) {
        //      int _XXX;
        //      printf("break point on me\n");
        //    }
        
        const int colorIndex = (int) properties->getAsNumber("mapcolor7", 0);
        
        const Color color = Color::fromRGBA(0.7, 0, 0, 0.5).wheelStep(7, colorIndex);
        
        return GEO2DSurfaceRasterStyle( color );
        
        //    return GEO2DSurfaceRasterStyle(Color::transparent());
    }
    
    GEO2DLineRasterStyle createLineRasterStyle(const GEOGeometry* geometry) const {
        const JSONObject* properties = geometry->getFeature()->getProperties();
        
        const std::string type = properties->getAsString("type", "");
        
        float dashLengths[] = {1, 12};
        int dashCount = 2;
        //    float dashLengths[] = {};
        //    int dashCount = 0;
        
        if (type.compare("Water Indicator") == 0) {
            return GEO2DLineRasterStyle(Color::fromRGBA(1, 1, 1, 0.9),
                                        8,
                                        CAP_ROUND,
                                        JOIN_ROUND,
                                        1,
                                        dashLengths,
                                        dashCount,
                                        0);
        }
        
        return GEO2DLineRasterStyle(Color::fromRGBA(1, 1, 0, 0.9),
                                    8,
                                    CAP_ROUND,
                                    JOIN_ROUND,
                                    1,
                                    dashLengths,
                                    dashCount,
                                    0);
    }
    
    CircleShape* createCircleShape(const GEO2DPointGeometry* geometry) const {
        const JSONObject* properties = geometry->getFeature()->getProperties();
        
        const double population = properties->getAsNumber("population", 0);
        
        const IMathUtils* mu = IMathUtils::instance();
        
        const double area = population * 1200;
        const float radius = (float) mu->sqrt( area / PI );
        Color color = Color::fromRGBA(1, 1, 0, 1);
        
        return new CircleShape(new Geodetic3D(geometry->getPosition(), 200),
                               RELATIVE_TO_GROUND,
                               radius,
                               color);
    }
    
    EllipsoidShape* createEllipsoidShape(const GEO2DPointGeometry* geometry,
                                         const Planet* planet) const {
        const JSONObject* properties = geometry->getFeature()->getProperties();
        
        const double population = properties->getAsNumber("population", 0);
        
        double radius = population / 1e2;
        
        const int wheelSize = 7;
        _colorIndex = (_colorIndex + 1) % wheelSize;
        
        return new EllipsoidShape(new Geodetic3D(geometry->getPosition(), 0),
                                  RELATIVE_TO_GROUND,
                                  Vector3D(radius, radius, radius),
                                  10,
                                  0.0,
                                  false,
                                  false,
                                  Color( Color::fromRGBA(1, 1, 0, 1).wheelStep(wheelSize, _colorIndex) ),
                                  Color::newFromRGBA(0.2, 0.2, 0, 1),
                                  true);
    }
    
    BoxShape* createBoxShape(const GEO2DPointGeometry* geometry,
                             const Planet* planet) const {
        const JSONObject* properties = geometry->getFeature()->getProperties();
        
        const double population = properties->getAsNumber("population", 0);
        
        const double boxExtent = 50000;
        const double baseArea = boxExtent*boxExtent;
        const double volume = population * boxExtent * 3500;
        const double height = volume / baseArea;
        
        const int wheelSize = 7;
        _colorIndex = (_colorIndex + 1) % wheelSize;
        
        
        return new BoxShape(new Geodetic3D(geometry->getPosition(), 0),
                            RELATIVE_TO_GROUND,
                            Vector3D(boxExtent, boxExtent, height),
                            1,
                            //Color::newFromRGBA(1, 1, 0, 0.6),
                            Color( Color::fromRGBA(1, 0.5, 0, 1).wheelStep(wheelSize, _colorIndex) ),
                            Color::newFromRGBA(0.2, 0.2, 0, 1));
        
    }
    
    Mark* createMark(const GEO2DPointGeometry* geometry) const {
        const JSONObject* properties = geometry->getFeature()->getProperties();
        
        const std::string label = properties->getAsString("name", "");
        
        if (label.compare("") != 0) {
            double scalerank = properties->getAsNumber("scalerank", 0);
            
            //      const double population = properties->getAsNumber("population", 0);
            //
            //      const double boxExtent = 50000;
            //      const double baseArea = boxExtent*boxExtent;
            //      const double volume = population * boxExtent * 3500;
            //      const double height = (volume / baseArea) / 2 * 1.1;
            
            const double height = 1000;
            
            return new Mark(label,
                            Geodetic3D(geometry->getPosition(), height),
                            RELATIVE_TO_GROUND,
                            0,
                            //25 + (scalerank * -3)
                            22 + (scalerank * -3)
                            );
        }
        
        return NULL;
    }
    
    
public:
    SampleSymbolizer(const Planet* planet) :
    _planet(planet),
    _colorIndex(0) {
        
    }
    
    std::vector<GEOSymbol*>* createSymbols(const GEO2DMultiPolygonGeometry* geometry) const {
        std::vector<GEOSymbol*>* symbols = new std::vector<GEOSymbol*>();
        
        const GEO2DLineRasterStyle    lineStyle    = createPolygonLineRasterStyle(geometry);
        const GEO2DSurfaceRasterStyle surfaceStyle = createPolygonSurfaceRasterStyle(geometry);
        
        const std::vector<GEO2DPolygonData*>* polygonsData = geometry->getPolygonsData();
        const int polygonsDataSize = polygonsData->size();
        
        for (int i = 0; i < polygonsDataSize; i++) {
            GEO2DPolygonData* polygonData = polygonsData->at(i);
            symbols->push_back( new GEORasterPolygonSymbol(polygonData,
                                                           lineStyle,
                                                           surfaceStyle) );
            
        }
        
        return symbols;
    }
    
    
    std::vector<GEOSymbol*>* createSymbols(const GEO2DPolygonGeometry* geometry) const {
        std::vector<GEOSymbol*>* symbols = new std::vector<GEOSymbol*>();
        
        symbols->push_back( new GEORasterPolygonSymbol(geometry->getPolygonData(),
                                                       createPolygonLineRasterStyle(geometry),
                                                       createPolygonSurfaceRasterStyle(geometry)) );
        
        return symbols;
    }
    
    std::vector<GEOSymbol*>* createSymbols(const GEO2DLineStringGeometry* geometry) const {
        std::vector<GEOSymbol*>* symbols = new std::vector<GEOSymbol*>();
        
        //    symbols->push_back( new GEOLine2DMeshSymbol(geometry->getCoordinates(),
        //                                                createLineStyle(geometry),
        //                                                30000) );
        
        symbols->push_back( new GEORasterLineSymbol(geometry->getCoordinates(),
                                                    createLineRasterStyle(geometry)) );
        
        return symbols;
    }
    
    
    std::vector<GEOSymbol*>* createSymbols(const GEO2DMultiLineStringGeometry* geometry) const {
        std::vector<GEOSymbol*>* symbols = new std::vector<GEOSymbol*>();
        
        //    symbols->push_back( new GEOMultiLine2DMeshSymbol(geometry->getCoordinatesArray(),
        //                                                     createLineStyle(geometry)) );
        
        symbols->push_back( new GEOMultiLineRasterSymbol(geometry->getCoordinatesArray(),
                                                         createLineRasterStyle(geometry)) );
        
        return symbols;
    }
    
    std::vector<GEOSymbol*>* createSymbols(const GEO2DPointGeometry* geometry) const {
        std::vector<GEOSymbol*>* symbols = new std::vector<GEOSymbol*>();
        
        //symbols->push_back( new GEOShapeSymbol( createCircleShape(geometry) ) );
        
        const JSONObject* properties = geometry->getFeature()->getProperties();
        
        const double population = properties->getAsNumber("population", 0);
        
        if (population > 2000000) {
            //    if (rand()%2 == 0) {
            //      symbols->push_back( new GEOShapeSymbol( createEllipsoidShape(geometry) ) );
            //    }
            //    else {
            symbols->push_back( new GEOShapeSymbol( createBoxShape(geometry, _planet) ) );
            //    }
            
            Mark* mark = createMark(geometry);
            if (mark != NULL) {
                symbols->push_back( new GEOMarkSymbol(mark) );
            }
        }
        
        return symbols;
    }
    
};


- (GEORenderer*) createGEORendererMeshRenderer: (MeshRenderer*) meshRenderer
                                shapesRenderer: (ShapesRenderer*) shapesRenderer
                                 marksRenderer: (MarksRenderer*) marksRenderer
                             geoTileRasterizer: (GEOTileRasterizer*) geoTileRasterizer
                                        planet: (const Planet*) planet
{
    GEOSymbolizer* symbolizer = new SampleSymbolizer(planet);
    
    
    GEORenderer* geoRenderer = new GEORenderer(symbolizer,
                                               meshRenderer,
                                               shapesRenderer,
                                               marksRenderer,
                                               geoTileRasterizer);
    
    return geoRenderer;
}


//class TestElevationDataListener : public IElevationDataListener {
//public:
//  void onData(const Sector& sector,
//              const Vector2I& extent,
//              ElevationData* elevationData) {
//    if (elevationData != NULL) {
//      ILogger::instance()->logInfo("Elevation data for sector=%s", sector.description().c_str());
//      ILogger::instance()->logInfo("%s", elevationData->description().c_str());
//    }
//
//  }
//
//  void onError(const Sector& sector,
//               const Vector2I& extent) {
//
//  }
//};


class Bil16Parser_IBufferDownloadListener : public IBufferDownloadListener {
private:
    ShapesRenderer* _shapesRenderer;
    MeshRenderer*   _meshRenderer;
    const Vector2I  _extent;
    const Sector    _sector;
    
public:
    Bil16Parser_IBufferDownloadListener(ShapesRenderer* shapesRenderer,
                                        MeshRenderer*   meshRenderer,
                                        const Vector2I& extent,
                                        const Sector& sector) :
    _shapesRenderer(shapesRenderer),
    _meshRenderer(meshRenderer),
    _extent(extent),
    _sector(sector)
    {
        
    }
    
    void onDownload(const URL& url,
                    IByteBuffer* buffer,
                    bool expired) {
        const ShortBufferElevationData* elevationData = BilParser::parseBil16(_sector,
                                                                              _extent,
                                                                              buffer);
        delete buffer;
        
        if (elevationData == NULL) {
            return;
        }
        
        ILogger::instance()->logInfo("Elevation data=%s", elevationData->description(false).c_str());
        
        const Planet* planet = Planet::createEarth();
        
        //    _meshRenderer->addMesh( elevationData->createMesh(planet,
        //                                                      5,
        //                                                      Geodetic3D::fromDegrees(0.02, 0, 0),
        //                                                      2) );
        
        const float verticalExaggeration = 20.0f;
        const float pointSize = 2.0f;
        
        //    const Sector subSector = _sector.shrinkedByPercent(0.2f);
        //    //    const Sector subSector = _sector.shrinkedByPercent(0.9f);
        //    //    const Sector subSector = _sector;
        //    //    const Vector2I subResolution(512, 512);
        //    //    const Vector2I subResolution(251*2, 254*2);
        //    const Vector2I subResolution(251*2, 254*2);
        
        _meshRenderer->addMesh( createSectorMesh(planet,
                                                 32,
                                                 Sector::fromDegrees(-22, -73,
                                                                     -16, -61),
                                                 Color::yellow(),
                                                 2) );
        
        const Sector meshSector = Sector::fromDegrees(-22, -73,
                                                      -16, -61);
        
        const Vector2I meshResolution(512, 256);
        
        
        _meshRenderer->addMesh( elevationData->createMesh(planet,
                                                          verticalExaggeration,
                                                          Geodetic3D::zero(),
                                                          pointSize,
                                                          meshSector,
                                                          meshResolution) );
        
        
        //    const ElevationData* subElevationData = new SubviewElevationData(elevationData,
        //                                                                     meshSector,
        //                                                                     meshResolution,
        //                                                                     false);
        //
        //    _meshRenderer->addMesh( subElevationData->createMesh(planet,
        //                                                         verticalExaggeration,
        //                                                         Geodetic3D::fromDegrees(meshSector._deltaLatitude._degrees + 0.1,
        //                                                                                 0,
        //                                                                                 0),
        //                                                         pointSize) );
        //
        //    delete subElevationData;
        
        
        
        delete planet;
        delete elevationData;
    }
    
    void onError(const URL& url) {
        
    }
    
    void onCancel(const URL& url) {
        
    }
    
    void onCanceledDownload(const URL& url,
                            IByteBuffer* data,
                            bool expired) {
    }
    
};


class RadarParser_BufferDownloadListener : public IBufferDownloadListener {
private:
    ShapesRenderer* _shapesRenderer;
    
public:
    RadarParser_BufferDownloadListener(ShapesRenderer* shapesRenderer) :
    _shapesRenderer(shapesRenderer)
    {
        
    }
    
    void onDownload(const URL& url,
                    IByteBuffer* buffer,
                    bool expired) {
        
        SGShape* radarModel = (SGShape*) SceneJSShapesParser::parseFromBSON(buffer,
                                                                            "http://radar3d.glob3mobile.com/models/",
                                                                            true,
                                                                            new Geodetic3D(Angle::zero(), Angle::zero(), 10000),
                                                                            ABSOLUTE);
        
        if (radarModel != NULL) {
            SGNode* node  = radarModel->getNode();
            
            const int childrenCount = node->getChildrenCount();
            for (int i = 0; i < childrenCount; i++) {
                SGNode* child = node->getChild(i);
                SGMaterialNode* material = (SGMaterialNode*) child;
                material->setBaseColor( NULL );
            }
            
            //    radarModel->setPosition(Geodetic3D::fromDegrees(0, 0, 0));
            //      radarModel->setPosition(new Geodetic3D(Angle::zero(), Angle::zero(), 10000));
            //    radarModel->setPosition(new Geodetic3D(Angle::fromDegreesMinutesSeconds(25, 47, 16),
            //                                           Angle::fromDegreesMinutesSeconds(-80, 13, 27),
            //                                           10000));
            //radarModel->setScale(10);
            
            _shapesRenderer->addShape(radarModel);
        }
        delete buffer;
    }
    
    void onError(const URL& url) {
        printf("Error downloading %s\n", url.getPath().c_str());
    }
    
    void onCancel(const URL& url) {
    }
    
    void onCanceledDownload(const URL& url,
                            IByteBuffer* buffer,
                            bool expired) {
    }
    
};

//class ParseMeshBufferDownloadListener : public IBufferDownloadListener {
//  MeshRenderer* _meshRenderer;
//  const Planet* _planet;
//
//public:
//  ParseMeshBufferDownloadListener(MeshRenderer* meshRenderer,
//                                  const Planet* planet) :
//  _meshRenderer(meshRenderer),
//  _planet(planet)
//  {
//  }
//
//  void onDownload(const URL& url,
//                  IByteBuffer* buffer,
//                  bool expired) {
//    const JSONBaseObject* jsonBaseObject = IJSONParser::instance()->parse(buffer);
//
//    const JSONObject* jsonObject = jsonBaseObject->asObject();
//    if (jsonObject == NULL) {
//      ILogger::instance()->logError("Invalid format for \"%s\"", url.getPath().c_str());
//    }
//    else {
//      const JSONArray* jsonCoordinates = jsonObject->getAsArray("coordinates");
//
//      int __DGD_At_Work;
//
//      FloatBufferBuilderFromGeodetic vertices = FloatBufferBuilderFromGeodetic::builderWithFirstVertexAsCenter(_planet);
//
//      const int coordinatesSize = jsonCoordinates->size();
//      for (int i = 0; i < coordinatesSize; i += 3) {
//        const double latInDegrees = jsonCoordinates->getAsNumber(i    , 0);
//        const double lonInDegrees = jsonCoordinates->getAsNumber(i + 1, 0);
//        const double height       = jsonCoordinates->getAsNumber(i + 2, 0);
//
//        vertices.add(Angle::fromDegrees(latInDegrees),
//                     Angle::fromDegrees(lonInDegrees),
//                     height);
//      }
//
//      const JSONArray* jsonNormals = jsonObject->getAsArray("normals");
//      const int normalsSize = jsonNormals->size();
//      IFloatBuffer* normals = IFactory::instance()->createFloatBuffer(normalsSize);
//      for (int i = 0; i < normalsSize; i++) {
//        normals->put(i, (float) jsonNormals->getAsNumber(i, 0) );
//      }
//
//      const JSONArray* jsonIndices = jsonObject->getAsArray("indices");
//      const int indicesSize = jsonIndices->size();
//      IShortBuffer* indices = IFactory::instance()->createShortBuffer(indicesSize);
//      for (int i = 0; i < indicesSize; i++) {
//        indices->put(i, (short) jsonIndices->getAsNumber(i, 0) );
//      }
//
//      Mesh* mesh = new IndexedMesh(GLPrimitive::triangles(),
//                                   true,
//                                   vertices.getCenter(),
//                                   vertices.create(),
//                                   indices,
//                                   1, // lineWidth
//                                   1, // pointSize
//                                   Color::newFromRGBA(1,0,0,1), // flatColor
//                                   NULL, // colors,
//                                   1, //  colorsIntensity,
//                                   true, // depthTest,
//                                   normals
//                                   );
//      _meshRenderer->addMesh(mesh);
//    }
//
//    delete jsonBaseObject;
//
//    delete buffer;
//  }
//
//  void onError(const URL& url) {
//    ILogger::instance()->logError("Can't download %s", url.getPath().c_str());
//  }
//
//  void onCancel(const URL& url) {
//  }
//
//  void onCanceledDownload(const URL& url,
//                          IByteBuffer* buffer,
//                          bool expired) {
//  }
//
//};

- (GInitializationTask*) createSampleInitializationTask: (ShapesRenderer*) shapesRenderer
                                            geoRenderer: (GEORenderer*) geoRenderer
                                           meshRenderer: (MeshRenderer*) meshRenderer
                                          marksRenderer: (MarksRenderer*) marksRenderer
                                                 planet: (const Planet*) planet
{
    class SampleInitializationTask : public GInitializationTask {
    private:
        G3MWidget_iOS*  _iosWidget;
        ShapesRenderer* _shapesRenderer;
        GEORenderer*    _geoRenderer;
        MeshRenderer*   _meshRenderer;
        MarksRenderer*  _marksRenderer;
        const Planet* _planet;
        
        void testRadarModel(const G3MContext* context) {
            
            context->getDownloader()->requestBuffer(URL("http://radar3d.glob3mobile.com/models/radar.bson", false),
                                                    1000000,
                                                    TimeInterval::fromDays(1),
                                                    true,
                                                    new RadarParser_BufferDownloadListener(_shapesRenderer),
                                                    true);
        }
        
        
    public:
        SampleInitializationTask(G3MWidget_iOS*  iosWidget,
                                 ShapesRenderer* shapesRenderer,
                                 GEORenderer*    geoRenderer,
                                 MeshRenderer*   meshRenderer,
                                 MarksRenderer*  marksRenderer,
                                 const Planet* planet) :
        _iosWidget(iosWidget),
        _shapesRenderer(shapesRenderer),
        _geoRenderer(geoRenderer),
        _meshRenderer(meshRenderer),
        _marksRenderer(marksRenderer),
        _planet(planet)
        {
            
        }
        
        Mesh* createCameraPathMesh(const G3MContext* context,
                                   const Geodetic2D& fromPosition,
                                   double fromHeight,
                                   const Geodetic2D& toPosition,
                                   double toHeight,
                                   Color* color) {
            
            IMathUtils* mu = IMathUtils::instance();
            
            const double deltaLatInDegrees = fromPosition._latitude._degrees  - toPosition._latitude._degrees;
            const double deltaLonInDegrees = fromPosition._longitude._degrees - toPosition._longitude._degrees;
            
            const double distanceInDegrees = mu->sqrt((deltaLatInDegrees * deltaLatInDegrees) +
                                                      (deltaLonInDegrees * deltaLonInDegrees)  );
            
            // const double distanceMaxHeight = mu->sqrt((90.0 * 90) + (180 * 180));
            const double distanceInDegreesMaxHeight = 180;
            
            const double maxHeight = context->getPlanet()->getRadii().axisAverage();
            
            double middleHeight;
            if (distanceInDegrees >= distanceInDegreesMaxHeight) {
                middleHeight = maxHeight;
            }
            else {
                middleHeight = (distanceInDegrees / distanceInDegreesMaxHeight) * maxHeight;
                //        const double averageHeight = (fromHeight + toHeight) / 2;
                //        if (middleHeight < averageHeight) {
                //          middleHeight = averageHeight;
                //        }
            }
            // const double middleHeight = ((averageHeight * distanceInDegrees) > maxHeight) ? maxHeight : (averageHeight * distanceInDegrees);
            
            //      FloatBufferBuilderFromGeodetic vertices(CenterStrategy::noCenter(),
            //                                              context->getPlanet(),
            //                                              Vector3D::zero);
            FloatBufferBuilderFromGeodetic vertices = FloatBufferBuilderFromGeodetic::builderWithoutCenter(context->getPlanet());
            
            for (double alpha = 0; alpha <= 1; alpha += 0.025) {
                const double height = mu->quadraticBezierInterpolation(fromHeight, middleHeight, toHeight, alpha);
                
                vertices.add(Geodetic2D::linearInterpolation(fromPosition, toPosition, alpha),
                             height);
            }
            
            
            return new DirectMesh(GLPrimitive::lineStrip(),
                                  true,
                                  vertices.getCenter(),
                                  vertices.create(),
                                  2,
                                  1,
                                  color);
        }
        
        //    void testMeshLoad(const G3MContext* context) {
        //      context->getDownloader()->requestBuffer(URL("file:///isosurface-mesh.json"),
        //                                              100000, //  priority,
        //                                              TimeInterval::fromDays(30),
        //                                              true,
        //                                              new ParseMeshBufferDownloadListener(_meshRenderer, _planet),
        //                                              true);
        //    }
        
        void testCanvas(const IFactory* factory) {
            
            class MyImageListener : public IImageListener {
            private:
                ShapesRenderer* _shapesRenderer;
                
            public:
                MyImageListener(ShapesRenderer* shapesRenderer) :
                _shapesRenderer(shapesRenderer)
                {
                    
                }
                
                void imageCreated(const IImage* image) {
                    //printf("Created image=%s\n", image->description().c_str());
                    //delete image;
                    
                    Shape* quad = new QuadShape(new Geodetic3D(Angle::fromDegrees(37.78333333),
                                                               Angle::fromDegrees(-121.5),
                                                               8000),
                                                RELATIVE_TO_GROUND,
                                                image,
                                                50000, 50000,
                                                false);
                    _shapesRenderer->addShape(quad);
                }
            };
            
            
            ICanvas* canvas = factory->createCanvas();
            
            
            const std::string text = "Hello World!";
            //const GFont font = GFont::serif();
            //const GFont font = GFont::monospaced();
            const GFont font = GFont::sansSerif();
            
            canvas->setFont(font);
            
            const Vector2F textExtent = canvas->textExtent(text);
            
            
            canvas->initialize(256, 256);
            
            canvas->setFillColor( Color::fromRGBA(1, 1, 1, 0.75) );
            canvas->fillRoundedRectangle(0, 0, 256, 256, 32);
            
            
            canvas->setShadow(Color::black(), 5, 3.5, -3.5);
            canvas->setFillColor( Color::fromRGBA(1, 0, 0, 0.5) );
            canvas->fillRectangle(32, 64, 64, 128);
            canvas->removeShadow();
            
            canvas->setLineColor( Color::fromRGBA(1, 0, 1, 0.9) );
            canvas->setLineWidth(2.5f);
            
            const float margin = 1.25f;
            canvas->strokeRoundedRectangle(0 + margin, 0 + margin,
                                           256 - (margin * 2), 256 - (margin * 2),
                                           32);
            
            canvas->setFillColor( Color::fromRGBA(1, 1, 0, 0.9) );
            canvas->setLineWidth(1.1f);
            canvas->setLineColor( Color::fromRGBA(0, 0, 0, 0.9) );
            canvas->fillAndStrokeRoundedRectangle(128, 16, 64, 64, 8);
            
            canvas->setFillColor( Color::white() );
            canvas->setShadow(Color::black(), 5, 1, -1);
            canvas->fillText(text,
                             128 - textExtent._x/2,
                             128 - textExtent._y/2);
            
            
            canvas->removeShadow();
            canvas->setFillColor(Color::black());
            canvas->fillRectangle(10, 10, 5, 5);
            
            
            canvas->createImage(new MyImageListener(_shapesRenderer),
                                true);
            
            delete canvas;
        }
        
        void run(const G3MContext* context) {
            printf("Running initialization Task\n");
            
            //testWebSocket(context);
            
            //testMeshLoad( context );
            
            testCanvas(context->getFactory());
            
            
            if (false) {
                [_iosWidget widget]->setAnimatedCameraPosition(TimeInterval::fromSeconds(10),
                                                               Geodetic3D(Angle::fromDegrees(-80),Angle::fromDegrees(-150),50000),
                                                               Geodetic3D(Angle::fromDegrees(40.032213257223013159),Angle::fromDegrees(-3.603964137481248553),1139.1668803810473491),
                                                               Angle::fromDegrees(87),
                                                               Angle::fromDegrees(34),
                                                               Angle::fromDegrees(20),
                                                               Angle::fromDegrees(45));
            }
            
            
            if (false) {
                NSString *cc3dFilePath = [[NSBundle mainBundle] pathForResource: @"cc3d4326"
                                                                         ofType: @"json"];
                if (cc3dFilePath) {
                    NSString *nsCC3dJSON = [NSString stringWithContentsOfFile: cc3dFilePath
                                                                     encoding: NSUTF8StringEncoding
                                                                        error: nil];
                    if (nsCC3dJSON) {
                        std::string cc3dJSON = [nsCC3dJSON UTF8String];
                        Shape* cc3d = SceneJSShapesParser::parseFromJSON(cc3dJSON,
                                                                         "file:///",
                                                                         false,
                                                                         new Geodetic3D(Angle::fromDegrees(39.473641),
                                                                                        Angle::fromDegrees(-6.370732),
                                                                                        500),
                                                                         ABSOLUTE);
                        if (cc3d) {
                            cc3d->setPitch(Angle::fromDegrees(-90));
                            
                            _shapesRenderer->addShape(cc3d);
                        }
                    }
                }
            }
            
            
            
            if (false) { //Incomplete world
                
                int time = 15; //SECS
                
                class RenderedSectorTask: public GTask{
                    G3MWidget_iOS* _iosWidget;
                public:
                    RenderedSectorTask(G3MWidget_iOS* iosWidget): _iosWidget(iosWidget) {}
                    
                    static int randomInt(int max) {
                        int i = rand();
                        return i % max;
                    }
                    
                    void run(const G3MContext* context) {
                        
                        double minLat = randomInt(180) -90;
                        double minLon = randomInt(360) - 180;
                        
                        double maxLat = minLat + randomInt(90 - (int)minLat);
                        double maxLon = minLon + randomInt(90 - (int)minLat);
                        
                        Sector sector = Sector::fromDegrees(minLat, minLon, maxLat, maxLon);
                        Geodetic2D center = sector.getCenter();
                        
                        //            [_iosWidget widget]->setCameraPosition(Geodetic3D(center, 1e7)  );
                        [_iosWidget widget]->setShownSector(sector);
                    }
                };
                [_iosWidget widget]->addPeriodicalTask(TimeInterval::fromSeconds(time), new RenderedSectorTask(_iosWidget));
            }
            
            if (false) { //Adding and deleting marks
                
                int time = 1; //SECS
                
                class MarksTask: public GTask{
                    G3MWidget_iOS* _iosWidget;
                    MarksRenderer* _marksRenderer;
                    
                    std::list<Mark*> _marks;
                    
                public:
                    MarksTask(G3MWidget_iOS* iosWidget, MarksRenderer* marksRenderer): _iosWidget(iosWidget), _marksRenderer(marksRenderer)
                    {
                    }
                    
                    static int randomInt(int max) {
                        int i = rand();
                        return i % max;
                    }
                    
                    void run(const G3MContext* context) {
                        
                        double minLat = randomInt(180) - 90;
                        double minLon = randomInt(360) - 180;
                        
                        Mark* m1 = new Mark("RANDOM MARK",
                                            URL("http://glob3m.glob3mobile.com/icons/markers/g3m.png", false),
                                            Geodetic3D(Angle::fromDegrees(minLat), Angle::fromDegrees(minLon), 0),
                                            RELATIVE_TO_GROUND,
                                            1e9);
                        _marksRenderer->addMark(m1);
                        
                        _marks.push_back(m1);
                        if (_marks.size() > 5){
                            while (_marks.size() > 0){
                                Mark* m2 = _marks.front();
                                _marksRenderer->removeMark(m2);
                                _marks.pop_front();
                                delete m2;
                            }
                        }
                        
                        
                    }
                };
                [_iosWidget widget]->addPeriodicalTask(TimeInterval::fromSeconds(time),
                                                       new MarksTask(_iosWidget, _marksRenderer));
            }
            
            class PlaneShapeLoadListener : public ShapeLoadListener {
            public:
                void onBeforeAddShape(SGShape* shape) {
                    const double scale = 200;
                    shape->setScale(scale, scale, scale);
                    shape->setPitch(Angle::fromDegrees(90));
                    //shape->setRoll(Angle::fromDegrees(45));
                }
                
                void onAfterAddShape(SGShape* shape) {
                    shape->setAnimatedPosition(TimeInterval::fromSeconds(26),
                                               Geodetic3D(Angle::fromDegreesMinutesSeconds(38, 53, 42.24),
                                                          Angle::fromDegreesMinutesSeconds(-78, 2, 10.92),
                                                          10000),
                                               true);
                    
                    /*
                     const double fromDistance = 75000;
                     const double toDistance   = 18750;
                     
                     const Angle fromAzimuth = Angle::fromDegrees(-90);
                     const Angle toAzimuth   = Angle::fromDegrees(270);
                     
                     const Angle fromAltitude = Angle::fromDegrees(90);
                     const Angle toAltitude   = Angle::fromDegrees(15);
                     
                     shape->orbitCamera(TimeInterval::fromSeconds(20),
                     fromDistance, toDistance,
                     fromAzimuth,  toAzimuth,
                     fromAltitude, toAltitude);
                     */
                }
            };
            
            _shapesRenderer->loadBSONSceneJS(URL("file:///A320.bson"),
                                             URL::FILE_PROTOCOL + "textures-A320/",
                                             false,
                                             new Geodetic3D(Angle::fromDegreesMinutesSeconds(38, 53, 42.24),
                                                            Angle::fromDegreesMinutesSeconds(-77, 2, 10.92),
                                                            10000),
                                             ABSOLUTE,
                                             new PlaneShapeLoadListener(),
                                             true);
            
            if (false) {
                NSString *planeFilePath = [[NSBundle mainBundle] pathForResource: @"A320"
                                                                          ofType: @"bson"];
                if (planeFilePath) {
                    NSData* data = [NSData dataWithContentsOfFile: planeFilePath];
                    const int length = [data length];
                    unsigned char* bytes = new unsigned char[ length ]; // will be deleted by IByteBuffer's destructor
                    [data getBytes: bytes
                            length: length];
                    IByteBuffer* buffer = new ByteBuffer_iOS(bytes, length);
                    if (buffer) {
                        Shape* plane = SceneJSShapesParser::parseFromBSON(buffer,
                                                                          URL::FILE_PROTOCOL + "textures-A320/",
                                                                          false,
                                                                          new Geodetic3D(Angle::fromDegreesMinutesSeconds(38, 53, 42.24),
                                                                                         Angle::fromDegreesMinutesSeconds(-77, 2, 10.92),
                                                                                         10000),
                                                                          ABSOLUTE);
                        
                        if (plane) {
                            const double scale = 200;
                            plane->setScale(scale, scale, scale);
                            plane->setPitch(Angle::fromDegrees(90));
                            _shapesRenderer->addShape(plane);
                            
                            plane->setAnimatedPosition(TimeInterval::fromSeconds(26),
                                                       Geodetic3D(Angle::fromDegreesMinutesSeconds(38, 53, 42.24),
                                                                  Angle::fromDegreesMinutesSeconds(-78, 2, 10.92),
                                                                  10000),
                                                       true);
                            
                            /**/
                            const double fromDistance = 75000;
                            const double toDistance   = 18750;
                            
                            // const Angle fromAzimuth = Angle::fromDegrees(-90);
                            // const Angle toAzimuth   = Angle::fromDegrees(-90 + 360 + 180);
                            const Angle fromAzimuth = Angle::fromDegrees(-90);
                            const Angle toAzimuth   = Angle::fromDegrees(270);
                            
                            // const Angle fromAltitude = Angle::fromDegrees(65);
                            // const Angle toAltitude   = Angle::fromDegrees(5);
                            // const Angle fromAltitude = Angle::fromDegrees(30);
                            // const Angle toAltitude   = Angle::fromDegrees(15);
                            const Angle fromAltitude = Angle::fromDegrees(90);
                            const Angle toAltitude   = Angle::fromDegrees(15);
                            
                            plane->orbitCamera(TimeInterval::fromSeconds(20),
                                               fromDistance, toDistance,
                                               fromAzimuth,  toAzimuth,
                                               fromAltitude, toAltitude);
                            /**/
                            
                            delete buffer;
                        }
                    }
                }
            }
            
            if (false) {
                //      NSString* geojsonName = @"geojson/countries";
                //        NSString* geojsonName = @"geojson/countries-50m";
                //      NSString* geojsonName = @"geojson/boundary_lines_land";
                NSString* geojsonName = @"geojson/cities";
                //      NSString* geojsonName = @"geojson/test";
                
                NSString *geoJSONFilePath = [[NSBundle mainBundle] pathForResource: geojsonName
                                                                            ofType: @"geojson"];
                
                if (geoJSONFilePath) {
                    NSString *nsGEOJSON = [NSString stringWithContentsOfFile: geoJSONFilePath
                                                                    encoding: NSUTF8StringEncoding
                                                                       error: nil];
                    
                    if (nsGEOJSON) {
                        std::string geoJSON = [nsGEOJSON UTF8String];
                        
                        GEOObject* geoObject = GEOJSONParser::parseJSON(geoJSON);
                        
                        _geoRenderer->addGEOObject(geoObject);
                    }
                }
            }
            
            //  Touched on (Tile level=18, row=161854, column=74976, sector=(Sector (lat=38.888895015761768548d, lon=-77.036132812499985789d) - (lat=38.889963929167578272d, lon=-77.034759521484360789d)))
            //  Camera position=(lat=38.889495390450342427d, lon=-77.035258992009289614d, height=666.01783933913191049) heading=1.074786 pitch=0.180631
            
            const bool loadWashingtonModel = false;
            if (loadWashingtonModel) {
                NSString* washingtonFilePath = [[NSBundle mainBundle] pathForResource: @"washington-memorial"
                                                                               ofType: @"json"];
                if (washingtonFilePath) {
                    NSString *nsWashingtonJSON = [NSString stringWithContentsOfFile: washingtonFilePath
                                                                           encoding: NSUTF8StringEncoding
                                                                              error: nil];
                    if (nsWashingtonJSON) {
                        std::string washingtonJSON = [nsWashingtonJSON UTF8String];
                        
                        Shape* washington = SceneJSShapesParser::parseFromJSON(washingtonJSON,
                                                                               URL::FILE_PROTOCOL + "/images/" ,
                                                                               false,
                                                                               new Geodetic3D(Angle::fromDegrees(38.888895015761768548),
                                                                                              Angle::fromDegrees(-77.036132812499985789),
                                                                                              10000),
                                                                               ABSOLUTE //RELATIVE_TO_GROUND
                                                                               );
                        
                        const double scale = 100;
                        washington->setScale(scale, scale, scale);
                        washington->setPitch(Angle::fromDegrees(90));
                        //            washington->setHeading(Angle::fromDegrees(0));
                        _shapesRenderer->addShape(washington);
                    }
                }
            }
            
            if (false) {
                NSString *planeFilePath = [[NSBundle mainBundle] pathForResource: @"seymour-plane"
                                                                          ofType: @"json"];
                if (planeFilePath) {
                    NSString *nsPlaneJSON = [NSString stringWithContentsOfFile: planeFilePath
                                                                      encoding: NSUTF8StringEncoding
                                                                         error: nil];
                    if (nsPlaneJSON) {
                        std::string planeJSON = [nsPlaneJSON UTF8String];
                        
                        Shape* plane = SceneJSShapesParser::parseFromJSON(planeJSON,
                                                                          URL::FILE_PROTOCOL + "/" ,
                                                                          false,
                                                                          new Geodetic3D(Angle::fromDegrees(28.127222),
                                                                                         Angle::fromDegrees(-15.431389),
                                                                                         10000),
                                                                          ABSOLUTE);
                        
                        // Washington, DC
                        const double scale = 1000;
                        plane->setScale(scale, scale, scale);
                        plane->setPitch(Angle::fromDegrees(90));
                        plane->setHeading(Angle::fromDegrees(0));
                        _shapesRenderer->addShape(plane);
                        
                        
                        plane->setAnimatedPosition(TimeInterval::fromSeconds(60),
                                                   Geodetic3D(Angle::fromDegrees(28.127222),
                                                              Angle::fromDegrees(-15.431389),
                                                              10000),
                                                   Angle::fromDegrees(90),
                                                   Angle::fromDegrees(720),
                                                   Angle::zero());
                        
                    }
                }
            }
            
            if (false) {
                
                Shape* plane = new BoxShape(new Geodetic3D(Angle::fromDegrees(28.127222),
                                                           Angle::fromDegrees(-15.431389),
                                                           1000000),
                                            RELATIVE_TO_GROUND,
                                            Vector3D(100, 100, 100),
                                            1.0,
                                            Color::fromRGBA(1.0, 0.0, 0.0, 1.0),
                                            Color::newFromRGBA(0.0, 1.0, 0.0, 1.0),
                                            true);
                const double scale = 1000;
                plane->setScale(scale, scale, scale);
                plane->setPitch(Angle::fromDegrees(90));
                plane->setHeading(Angle::fromDegrees(0));
                _shapesRenderer->addShape(plane);
                
                
                plane->setAnimatedPosition(TimeInterval::fromSeconds(60),
                                           Geodetic3D(Angle::fromDegrees(28.127222),
                                                      Angle::fromDegrees(-15.431389),
                                                      10000),
                                           Angle::fromDegrees(90),
                                           Angle::fromDegrees(720),
                                           Angle::zero());
            }
            
            
        }
        
        bool isDone(const G3MContext* context) {
            return true;
        }
    };
    
    GInitializationTask* initializationTask = new SampleInitializationTask([self G3MWidget],
                                                                           shapesRenderer,
                                                                           geoRenderer,
                                                                           meshRenderer,
                                                                           marksRenderer,
                                                                           planet);
    
    return initializationTask;
}

- (PeriodicalTask*) createSamplePeriodicalTask: (G3MBuilder_iOS*) builder
{
    TrailsRenderer* trailsRenderer = new TrailsRenderer();
    
    Trail* trail = new Trail(Color::fromRGBA(0, 1, 1, 0.6f),
                             5000,
                             0);
    
    Geodetic3D position(Angle::fromDegrees(37.78333333),
                        Angle::fromDegrees(-122.41666666666667),
                        25000);
    trail->addPosition(position);
    trailsRenderer->addTrail(trail);
    builder->addRenderer(trailsRenderer);
    
    //  renderers.push_back(new GLErrorRenderer());
    
    class TestTrailTask : public GTask {
    private:
        Trail* _trail;
        
        double _lastLatitudeDegrees;
        double _lastLongitudeDegrees;
        double _lastHeight;
        
    public:
        TestTrailTask(Trail* trail,
                      Geodetic3D lastPosition) :
        _trail(trail),
        _lastLatitudeDegrees(lastPosition._latitude._degrees),
        _lastLongitudeDegrees(lastPosition._longitude._degrees),
        _lastHeight(lastPosition._height)
        {
        }
        
        void run(const G3MContext* context) {
            const double latStep = 2.0 / ((arc4random() % 100) + 50);
            const double lonStep = 2.0 / ((arc4random() % 100) + 50);
            
            _lastLatitudeDegrees  -= latStep;
            _lastLongitudeDegrees += lonStep;
            
            _trail->addPosition(Geodetic3D(Angle::fromDegrees(_lastLatitudeDegrees),
                                           Angle::fromDegrees(_lastLongitudeDegrees),
                                           _lastHeight));
        }
    };
    
    PeriodicalTask* periodicalTask = new PeriodicalTask(TimeInterval::fromSeconds(0.25),
                                                        new TestTrailTask(trail, position));
    return periodicalTask;
}

- (void)viewDidUnload
{
    G3MWidget = nil;
    //[G3MWidget release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [G3MWidget stopAnimation];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


@end

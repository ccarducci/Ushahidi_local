//
//  MapBooBuilder.cpp
//  G3MiOSSDK
//
//  Created by Diego Gomez Deck on 5/25/13.
//
//

#include "MapBooBuilder.hpp"

#include "ILogger.hpp"
#include "CompositeRenderer.hpp"
#include "PlanetRenderer.hpp"
#include "PlanetTileTessellator.hpp"
#include "MultiLayerTileTexturizer.hpp"
#include "TilesRenderParameters.hpp"
#include "DownloadPriority.hpp"
#include "G3MWidget.hpp"
//#include "SimpleCameraConstrainer.hpp"
#include "SectorAndHeightCameraConstrainer.hpp"
#include "CameraRenderer.hpp"
#include "CameraSingleDragHandler.hpp"
#include "CameraDoubleDragHandler.hpp"
#include "CameraRotationHandler.hpp"
#include "CameraDoubleTapHandler.hpp"
#include "BusyMeshRenderer.hpp"
#include "GInitializationTask.hpp"
#include "PeriodicalTask.hpp"
#include "IJSONParser.hpp"
#include "JSONObject.hpp"
#include "JSONString.hpp"
#include "JSONArray.hpp"
#include "JSONNumber.hpp"
#include "IThreadUtils.hpp"
#include "OSMLayer.hpp"
#include "MapQuestLayer.hpp"
#include "BingMapsLayer.hpp"
#include "CartoDBLayer.hpp"
#include "MapBoxLayer.hpp"
#include "WMSLayer.hpp"
#include "LayerTilesRenderParameters.hpp"
#include "IWebSocketListener.hpp"
#include "IWebSocket.hpp"
#include "SceneLighting.hpp"
#include "IDownloader.hpp"
#include "IBufferDownloadListener.hpp"
#include "HUDErrorRenderer.hpp"
#include "TerrainTouchListener.hpp"
#include "MarksRenderer.hpp"
#include "Mark.hpp"
#include "URLTemplateLayer.hpp"


const std::string MapBoo_CameraPosition::description() const {
  IStringBuilder* isb = IStringBuilder::newStringBuilder();

  isb->addString("[CameraPosition position=");
  isb->addString(_position.description());

  isb->addString(", heading=");
  isb->addString(_heading.description());

  isb->addString(", pitch=");
  isb->addString(_pitch.description());

  isb->addString(", animated=");
  isb->addBool(_animated);

  isb->addString("]");

  const std::string s = isb->getString();
  delete isb;
  return s;
}

MapBoo_Scene::~MapBoo_Scene() {
  delete _screenshot;
  delete _baseLayer;
  delete _overlayLayer;
  delete _cameraPosition;
  delete _sector;
}

const std::string MapBoo_MultiImage_Level::description() const {
  IStringBuilder* isb = IStringBuilder::newStringBuilder();
  isb->addString("[Level size=");
  isb->addInt(_width);
  isb->addString("x");
  isb->addInt(_height);
  isb->addString(", url=");
  isb->addString(_url.description());
  isb->addString("]");
  const std::string s = isb->getString();
  delete isb;
  return s;
}

const std::string MapBoo_MultiImage::description() const {
  IStringBuilder* isb = IStringBuilder::newStringBuilder();
  isb->addString("[MultiImage averageColor=");
  isb->addString(_averageColor.description());
  isb->addString(", _levels=[");
  const int levelsSize = _levels.size();
  for (int i = 0; i < levelsSize; i++) {
    if (i > 0) {
      isb->addString(", ");
    }
    isb->addString(_levels[i]->description());
  }
  isb->addString("]]");
  const std::string s = isb->getString();
  delete isb;
  return s;
}

MapBoo_MultiImage_Level* MapBoo_MultiImage::getBestLevel(int width) const {
  const int levelsSize = _levels.size();
  if (levelsSize == 0) {
    return NULL;
  }

  for (int i = 0; i < levelsSize; i++) {
    MapBoo_MultiImage_Level* level = _levels[i];
    const int levelWidth = level->getWidth();
    if (levelWidth <= width) {
      if ((levelWidth < width) && (i > 0)) {
        return _levels[i - 1];
      }
      return level;
    }
  }

  // all levels are widther than width, so select the level with the less resolution
  return _levels[levelsSize - 1];
}

const std::string MapBoo_Scene::description() const {
  IStringBuilder* isb = IStringBuilder::newStringBuilder();

  isb->addString("[Scene name=");
  isb->addString(_name);

  isb->addString(", description=");
  isb->addString(_description);

  isb->addString(", screenshot=");
  isb->addString((_screenshot == NULL) ? "null" : _screenshot->description());

  isb->addString(", backgroundColor=");
  isb->addString(_backgroundColor.description());

  isb->addString(", cameraPosition=");
  if (_cameraPosition == NULL) {
    isb->addString("NULL");
  }
  else {
    isb->addString(_cameraPosition->description());
  }

  isb->addString(", baseLayer=");
  if (_baseLayer == NULL) {
    isb->addString("NULL");
  }
  else {
    isb->addString(_baseLayer->description());
  }

  isb->addString(", overlayLayer=");
  if (_overlayLayer == NULL) {
    isb->addString("NULL");
  }
  else {
    isb->addString(_overlayLayer->description());
  }

  isb->addString(", hasWarnings=");
  isb->addBool(_hasWarnings);

  isb->addString("]");

  const std::string s = isb->getString();
  delete isb;
  return s;
}

MapBooBuilder::MapBooBuilder(const URL& serverURL,
                             const URL& tubesURL,
                             const std::string& applicationId,
                             MapBoo_ViewType viewType,
                             MapBooApplicationChangeListener* applicationListener,
                             bool enableNotifications) :
_serverURL(serverURL),
_tubesURL(tubesURL),
_applicationId(applicationId),
_viewType(viewType),
_applicationName(""),
_applicationWebsite(""),
_applicationEMail(""),
_applicationAbout(""),
_applicationTimestamp(-1),
_gl(NULL),
_g3mWidget(NULL),
_storage(NULL),
_threadUtils(NULL),
_layerSet( new LayerSet() ),
_downloader(NULL),
_applicationListener(applicationListener),
_enableNotifications(enableNotifications),
_gpuProgramManager(NULL),
_isApplicationTubeOpen(false),
_applicationCurrentSceneIndex(-1),
_lastApplicationCurrentSceneIndex(-1),
_context(NULL),
_webSocket(NULL),
_marksRenderer(NULL),
_hasParsedApplication(false)
{

}

GPUProgramManager* MapBooBuilder::getGPUProgramManager() {
  if (_gpuProgramManager == NULL) {
    _gpuProgramManager = createGPUProgramManager();
  }
  return _gpuProgramManager;
}

IDownloader* MapBooBuilder::getDownloader() {
  if (_downloader == NULL) {
    _downloader = createDownloader();
  }
  return _downloader;
}

IThreadUtils* MapBooBuilder::getThreadUtils() {
  if (_threadUtils == NULL) {
    _threadUtils = createThreadUtils();
  }
  return _threadUtils;
}

void MapBooBuilder::setGL(GL *gl) {
  if (_gl != NULL) {
    ILogger::instance()->logError("LOGIC ERROR: _gl already initialized");
    return;
  }
  if (gl == NULL) {
    ILogger::instance()->logError("LOGIC ERROR: _gl cannot be NULL");
    return;
  }
  _gl = gl;
}

GL* MapBooBuilder::getGL() {
  if (_gl == NULL) {
    ILogger::instance()->logError("Logic Error: _gl not initialized");
  }
  return _gl;
}


class MapBooBuilder_TerrainTouchListener : public TerrainTouchListener {
private:
  MapBooBuilder* _mapBooBuilder;

public:
  MapBooBuilder_TerrainTouchListener(MapBooBuilder* mapBooBuilder) :
  _mapBooBuilder(mapBooBuilder)
  {
  }

  ~MapBooBuilder_TerrainTouchListener() {

  }

  bool onTerrainTouch(const G3MEventContext* ec,
                      const Vector2I&        pixel,
                      const Camera*          camera,
                      const Geodetic3D&      position,
                      const Tile*            tile) {
    return _mapBooBuilder->onTerrainTouch(ec,
                                          pixel,
                                          camera,
                                          position,
                                          tile);
  }
};

const std::string MapBooBuilder::escapeString(const std::string& str) const {
  const IStringUtils* su = IStringUtils::instance();

  return su->replaceSubstring(str, "\"", "\\\"");
}

const std::string MapBooBuilder::toCameraPositionJSON(const MapBoo_CameraPosition* cameraPosition) const {
  IStringBuilder* isb = IStringBuilder::newStringBuilder();

  isb->addString("{");

  const Geodetic3D position = cameraPosition->getPosition();

  isb->addString("\"latitude\":");
  isb->addDouble(position._latitude._degrees);

  isb->addString(",\"longitude\":");
  isb->addDouble(position._longitude._degrees);

  isb->addString(",\"height\":");
  isb->addDouble( position._height );

  isb->addString(",\"heading\":");
  isb->addDouble( cameraPosition->getHeading()._degrees );

  isb->addString(",\"pitch\":");
  isb->addDouble( cameraPosition->getPitch()._degrees );

  isb->addString(",\"animated\":");
  isb->addBool( true );

  isb->addString("}");

  const std::string s = isb->getString();
  delete isb;
  return s;
}

const std::string MapBooBuilder::toCameraPositionJSON(const Camera* camera) const {
  IStringBuilder* isb = IStringBuilder::newStringBuilder();

  isb->addString("{");

  const Geodetic3D position = camera->getGeodeticPosition();

  isb->addString("\"latitude\":");
  isb->addDouble(position._latitude._degrees);

  isb->addString(",\"longitude\":");
  isb->addDouble(position._longitude._degrees);

  isb->addString(",\"height\":");
  isb->addDouble( position._height );

  isb->addString(",\"heading\":");
  isb->addDouble( camera->getHeading()._degrees );

  isb->addString(",\"pitch\":");
  isb->addDouble( camera->getPitch()._degrees );

  isb->addString(",\"animated\":");
  isb->addBool( true );

  isb->addString("}");

  const std::string s = isb->getString();
  delete isb;
  return s;
}

const std::string MapBooBuilder::getSendNotificationCommand(const Geodetic2D&            position,
                                                            const MapBoo_CameraPosition* cameraPosition,
                                                            const std::string&           message,
                                                            const URL*                   iconURL) const {
  IStringBuilder* isb = IStringBuilder::newStringBuilder();

  isb->addString("notification=");

  isb->addString("{");

  isb->addString("\"latitude\":");
  isb->addDouble(position._latitude._degrees);

  isb->addString(",\"longitude\":");
  isb->addDouble(position._longitude._degrees);

  isb->addString(",\"message\":");
  isb->addString("\"");
  isb->addString( escapeString(message) );
  isb->addString("\"");

  if (iconURL != NULL) {
    isb->addString(",\"iconURL\":");
    isb->addString("\"");
    isb->addString( escapeString(iconURL->getPath()) );
    isb->addString("\"");
  }

  isb->addString(",\"cameraPosition\":");
  isb->addString( toCameraPositionJSON(cameraPosition) );

  isb->addString("}");

  const std::string s = isb->getString();
  delete isb;
  return s;
}

const std::string MapBooBuilder::getSendNotificationCommand(const Geodetic2D&  position,
                                                            const Camera*      camera,
                                                            const std::string& message,
                                                            const URL*         iconURL) const {
  IStringBuilder* isb = IStringBuilder::newStringBuilder();

  isb->addString("notification=");

  isb->addString("{");

  isb->addString("\"latitude\":");
  isb->addDouble(position._latitude._degrees);

  isb->addString(",\"longitude\":");
  isb->addDouble(position._longitude._degrees);

  isb->addString(",\"message\":");
  isb->addString("\"");
  isb->addString( escapeString(message) );
  isb->addString("\"");

  if (iconURL != NULL) {
    isb->addString(",\"iconURL\":");
    isb->addString("\"");
    isb->addString( escapeString(iconURL->getPath()) );
    isb->addString("\"");
  }

  isb->addString(",\"cameraPosition\":");
  isb->addString( toCameraPositionJSON(camera) );

  isb->addString("}");

  const std::string s = isb->getString();
  delete isb;
  return s;
}

void MapBooBuilder::sendNotification(const Geodetic2D&            position,
                                     const MapBoo_CameraPosition* cameraPosition,
                                     const std::string&           message,
                                     const URL*                   iconURL) const {
  if ((_webSocket != NULL) && _isApplicationTubeOpen) {
    _webSocket->send( getSendNotificationCommand(position,
                                                 cameraPosition,
                                                 message,
                                                 iconURL) );
  }
  else {
    ILogger::instance()->logError("Can't send notification, websocket disconnected");
  }
}

void MapBooBuilder::sendNotification(const Geodetic2D&  position,
                                     const Camera*      camera,
                                     const std::string& message,
                                     const URL*         iconURL) const {
  if ((_webSocket != NULL) && _isApplicationTubeOpen) {
    _webSocket->send( getSendNotificationCommand(position,
                                                 camera,
                                                 message,
                                                 iconURL) );
  }
  else {
    ILogger::instance()->logError("Can't send notification, websocket disconnected");
  }
}

bool MapBooBuilder::onTerrainTouch(const G3MEventContext* ec,
                                   const Vector2I&        pixel,
                                   const Camera*          camera,
                                   const Geodetic3D&      position,
                                   const Tile*            tile) {
  if (_applicationListener != NULL) {
    _applicationListener->onTerrainTouch(this,
                                         ec,
                                         pixel,
                                         camera,
                                         position,
                                         tile);
  }

  return true;
}

PlanetRenderer* MapBooBuilder::createPlanetRenderer() {
  TileTessellator* tessellator = new PlanetTileTessellator(true, Sector::fullSphere());

  ElevationDataProvider* elevationDataProvider = NULL;
  const float verticalExaggeration = 1;
  TileTexturizer* texturizer = new MultiLayerTileTexturizer();
  TileRasterizer* tileRasterizer = NULL;

  const bool renderDebug = false;
  const bool useTilesSplitBudget = true;
  const bool forceFirstLevelTilesRenderOnStart = true;
  const bool incrementalTileQuality = false;
  const Quality quality = QUALITY_LOW;

  const TilesRenderParameters* parameters = new TilesRenderParameters(renderDebug,
                                                                      useTilesSplitBudget,
                                                                      forceFirstLevelTilesRenderOnStart,
                                                                      incrementalTileQuality,
                                                                      quality);

  const bool showStatistics = false;
  long long texturePriority = DownloadPriority::HIGHER;

  const Sector renderedSector = Sector::fullSphere();

  PlanetRenderer* result = new PlanetRenderer(tessellator,
                                              elevationDataProvider,
                                              verticalExaggeration,
                                              texturizer,
                                              tileRasterizer,
                                              _layerSet,
                                              parameters,
                                              showStatistics,
                                              texturePriority,
                                              renderedSector);

  if (_enableNotifications) {
    result->addTerrainTouchListener(new MapBooBuilder_TerrainTouchListener(this));
  }

  return result;
}

const Planet* MapBooBuilder::createPlanet() {
  //return Planet::createEarth();
  return Planet::createSphericalEarth();
}

std::vector<ICameraConstrainer*>* MapBooBuilder::createCameraConstraints(const Planet* planet,
                                                                         PlanetRenderer* planetRenderer) {
  std::vector<ICameraConstrainer*>* cameraConstraints = new std::vector<ICameraConstrainer*>;
  //SimpleCameraConstrainer* scc = new SimpleCameraConstrainer();

  const Geodetic3D initialCameraPosition = planet->getDefaultCameraPosition(Sector::fullSphere());

  cameraConstraints->push_back( new RenderedSectorCameraConstrainer(planetRenderer,
                                                                    initialCameraPosition._height * 1.2) );

  return cameraConstraints;
}

CameraRenderer* MapBooBuilder::createCameraRenderer() {
  CameraRenderer* cameraRenderer = new CameraRenderer();
  const bool useInertia = true;
  cameraRenderer->addHandler(new CameraSingleDragHandler(useInertia));
  cameraRenderer->addHandler(new CameraDoubleDragHandler());
  cameraRenderer->addHandler(new CameraRotationHandler());
  cameraRenderer->addHandler(new CameraDoubleTapHandler());

  return cameraRenderer;
}

Renderer* MapBooBuilder::createBusyRenderer() {
  return new BusyMeshRenderer(Color::newFromRGBA(0, 0, 0, 1));
}

ErrorRenderer* MapBooBuilder::createErrorRenderer() {
  return new HUDErrorRenderer();
}

MapQuestLayer* MapBooBuilder::parseMapQuestLayer(const JSONObject* jsonLayer,
                                                 const TimeInterval& timeToCache) const {
  const std::string imagery = jsonLayer->getAsString("imagery", "<imagery not present>");
  if (imagery.compare("OpenAerial") == 0) {
    return MapQuestLayer::newOpenAerial(timeToCache);
  }

  // defaults to OSM
  return MapQuestLayer::newOSM(timeToCache);
}

BingMapsLayer* MapBooBuilder::parseBingMapsLayer(const JSONObject* jsonLayer,
                                                 const TimeInterval& timeToCache) const {
  const std::string key = jsonLayer->getAsString("key", "");
  const std::string imagerySet = jsonLayer->getAsString("imagerySet", "Aerial");

  return new BingMapsLayer(imagerySet, key, timeToCache);
}

CartoDBLayer* MapBooBuilder::parseCartoDBLayer(const JSONObject* jsonLayer,
                                               const TimeInterval& timeToCache) const {
  const std::string userName = jsonLayer->getAsString("userName", "");
  const std::string table    = jsonLayer->getAsString("table",    "");

  return new CartoDBLayer(userName, table, timeToCache);
}

MapBoxLayer* MapBooBuilder::parseMapBoxLayer(const JSONObject* jsonLayer,
                                             const TimeInterval& timeToCache) const {
  const std::string mapKey = jsonLayer->getAsString("mapKey", "");

  return new MapBoxLayer(mapKey, timeToCache);
}

WMSLayer* MapBooBuilder::parseWMSLayer(const JSONObject* jsonLayer) const {

  const std::string mapLayer = jsonLayer->getAsString("layerName", "");
  const URL mapServerURL = URL(jsonLayer->getAsString("server", ""), false);
  const std::string versionStr = jsonLayer->getAsString("version", "");
  WMSServerVersion mapServerVersion = WMS_1_1_0;
  if (versionStr.compare("WMS_1_3_0") == 0) {
    mapServerVersion = WMS_1_3_0;
  }
  const std::string queryLayer = jsonLayer->getAsString("queryLayer", "");
  const std::string style = jsonLayer->getAsString("style", "");
  const URL queryServerURL = URL("", false);
  const WMSServerVersion queryServerVersion = mapServerVersion;
  const double lowerLat = jsonLayer->getAsNumber("lowerLat", -90.0);
  const double lowerLon = jsonLayer->getAsNumber("lowerLon", -180.0);
  const double upperLat = jsonLayer->getAsNumber("upperLat", 90.0);
  const double upperLon = jsonLayer->getAsNumber("upperLon", 180.0);
  const Sector sector = Sector(Geodetic2D(Angle::fromDegrees(lowerLat), Angle::fromDegrees(lowerLon)),
                               Geodetic2D(Angle::fromDegrees(upperLat), Angle::fromDegrees(upperLon)));
  std::string imageFormat = jsonLayer->getAsString("imageFormat", "image/png");
  const std::string srs = jsonLayer->getAsString("projection", "EPSG:4326");
  LayerTilesRenderParameters* layerTilesRenderParameters = NULL;
  if (srs.compare("EPSG:4326") == 0) {
    layerTilesRenderParameters = LayerTilesRenderParameters::createDefaultWGS84(Sector::fullSphere());
  }
  else if (srs.compare("EPSG:3857") == 0) {
    layerTilesRenderParameters = LayerTilesRenderParameters::createDefaultMercator(0, 17);
  }
  const bool isTransparent = jsonLayer->getAsBoolean("transparent", false);
  const double expiration = jsonLayer->getAsNumber("expiration", 0);
  const long long milliseconds = IMathUtils::instance()->round(expiration);
  const TimeInterval timeToCache = TimeInterval::fromMilliseconds(milliseconds);
  const bool readExpired = jsonLayer->getAsBoolean("acceptExpiration", false);

  return new WMSLayer(mapLayer,
                      mapServerURL,
                      mapServerVersion,
                      queryLayer,
                      queryServerURL,
                      queryServerVersion,
                      sector,
                      imageFormat,
                      srs,
                      style,
                      isTransparent,
                      NULL,
                      timeToCache,
                      readExpired,
                      layerTilesRenderParameters);
}

URLTemplateLayer* MapBooBuilder::parseURLTemplateLayer(const JSONObject* jsonLayer) const {
  const std::string urlTemplate = jsonLayer->getAsString("url", "");

  const bool transparent = jsonLayer->getAsBoolean("transparent", true);

  const int firstLevel = (int) jsonLayer->getAsNumber("firstLevel", 1);
  const int maxLevel   = (int) jsonLayer->getAsNumber("maxLevel", 19);

  const std::string projection = jsonLayer->getAsString("projection", "EPSG:3857");
  const bool mercator = (projection == "EPSG:3857");

  const double lowerLat = jsonLayer->getAsNumber("lowerLat", -90.0);
  const double lowerLon = jsonLayer->getAsNumber("lowerLon", -180.0);
  const double upperLat = jsonLayer->getAsNumber("upperLat", 90.0);
  const double upperLon = jsonLayer->getAsNumber("upperLon", 180.0);

  const Sector sector = Sector::fromDegrees(lowerLat, lowerLon,
                                            upperLat, upperLon);

  URLTemplateLayer* result;
  if (mercator) {
    result = URLTemplateLayer::newMercator(urlTemplate,
                                           sector,
                                           transparent,
                                           firstLevel,
                                           maxLevel,
                                           TimeInterval::fromDays(30));
  }
  else {
    result = URLTemplateLayer::newWGS84(urlTemplate,
                                        sector,
                                        transparent,
                                        firstLevel,
                                        maxLevel,
                                        TimeInterval::fromDays(30));
  }
  
  return result;
}

Layer* MapBooBuilder::parseLayer(const JSONBaseObject* jsonBaseObjectLayer) const {
  if (jsonBaseObjectLayer == NULL) {
    return NULL;
  }

  if (jsonBaseObjectLayer->asNull() != NULL) {
    return NULL;
  }

  const TimeInterval defaultTimeToCache = TimeInterval::fromDays(30);

  const JSONObject* jsonLayer = jsonBaseObjectLayer->asObject();
  if (jsonLayer == NULL) {
    ILogger::instance()->logError("Layer is not a json object");
    return NULL;
  }

  const std::string layerType = jsonLayer->getAsString("layer", "<layer not present>");
  if (layerType.compare("OSM") == 0) {
    return new OSMLayer(defaultTimeToCache);
  }
  else if (layerType.compare("MapQuest") == 0) {
    return parseMapQuestLayer(jsonLayer, defaultTimeToCache);
  }
  else if (layerType.compare("BingMaps") == 0) {
    return parseBingMapsLayer(jsonLayer, defaultTimeToCache);
  }
  else if (layerType.compare("CartoDB") == 0) {
    return parseCartoDBLayer(jsonLayer, defaultTimeToCache);
  }
  else if (layerType.compare("MapBox") == 0) {
    return parseMapBoxLayer(jsonLayer, defaultTimeToCache);
  }
  else if (layerType.compare("WMS") == 0) {
    return parseWMSLayer(jsonLayer);
  }
  else if (layerType.compare("URLTemplate") == 0) {
    return parseURLTemplateLayer(jsonLayer);
  }
  else {
    ILogger::instance()->logError("Unsupported layer type \"%s\"", layerType.c_str());
    ILogger::instance()->logError("%s", jsonBaseObjectLayer->description().c_str());
    return NULL;
  }
}

Color MapBooBuilder::parseColor(const JSONString* jsonColor) const {
  if (jsonColor == NULL) {
    return Color::black();
  }

  const Color* color = Color::parse(jsonColor->value());
  if (color == NULL) {
    ILogger::instance()->logError("Invalid format in attribute 'color' (%s)",
                                  jsonColor->value().c_str());
    return Color::black();
  }

  Color result(*color);
  delete color;
  return result;
}

MapBoo_MultiImage_Level* MapBooBuilder::parseMultiImageLevel(const JSONObject* jsonObject) const {
  const JSONString* jsURL = jsonObject->getAsString("url");
  if (jsURL == NULL) {
    return NULL;
  }

  const JSONNumber* jsWidth = jsonObject->getAsNumber("width");
  if (jsWidth == NULL) {
    return NULL;
  }

  const JSONNumber* jsHeight = jsonObject->getAsNumber("height");
  if (jsHeight == NULL) {
    return NULL;
  }

  return new MapBoo_MultiImage_Level(URL(_serverURL, "/images/" + jsURL->value()),
                                     (int) jsWidth->value(),
                                     (int) jsHeight->value());
}

MapBoo_MultiImage* MapBooBuilder::parseMultiImage(const JSONObject* jsonObject) const {
  if (jsonObject == NULL) {
    return NULL;
  }

  Color averageColor = parseColor( jsonObject->getAsString("averageColor") );

  std::vector<MapBoo_MultiImage_Level*> levels;

  const JSONArray* jsLevels = jsonObject->getAsArray("levels");
  if (jsLevels != NULL) {
    const int levelsCount = jsLevels->size();
    for (int i = 0; i < levelsCount; i++) {
      MapBoo_MultiImage_Level* level = parseMultiImageLevel( jsLevels->getAsObject(i) );
      if (level != NULL) {
        levels.push_back(level);
      }
    }
  }

  return new MapBoo_MultiImage(averageColor, levels);
}

const MapBoo_CameraPosition* MapBooBuilder::parseCameraPosition(const JSONObject* jsonObject) const {
  if (jsonObject == NULL) {
    return NULL;
  }

  const double latitudeInDegress  = jsonObject->getAsNumber("latitude", 0);
  const double longitudeInDegress = jsonObject->getAsNumber("longitude", 0);
  const double height             = jsonObject->getAsNumber("height", 0);

  const double headingInDegrees = jsonObject->getAsNumber("heading", 0);
  const double pitchInDegrees   = jsonObject->getAsNumber("pitch", 0);

  const bool animated = jsonObject->getAsBoolean("animated", true);

  return new MapBoo_CameraPosition(Geodetic3D::fromDegrees(latitudeInDegress, longitudeInDegress, height),
                                   Angle::fromDegrees(headingInDegrees),
                                   Angle::fromDegrees(pitchInDegrees),
                                   animated);
}

//const std::string MapBooBuilder::parseSceneId(const JSONObject* jsonObject) const {
//  if (jsonObject == NULL) {
//    ILogger::instance()->logError("Missing Scene ID");
//    return "";
//  }
//
//  return jsonObject->getAsString("$oid", "");
//}

Sector* MapBooBuilder::parseSector(const JSONBaseObject* jsonBaseObjectLayer) const {
  if (jsonBaseObjectLayer == NULL) {
    return NULL;
  }

  if (jsonBaseObjectLayer->asNull() != NULL) {
    return NULL;
  }

  const JSONObject* jsonObject = jsonBaseObjectLayer->asObject();
  if (jsonObject == NULL) {
    return NULL;
  }

  const double lowerLat = jsonObject->getAsNumber("lowerLat",  -90.0);
  const double lowerLon = jsonObject->getAsNumber("lowerLon", -180.0);
  const double upperLat = jsonObject->getAsNumber("upperLat",   90.0);
  const double upperLon = jsonObject->getAsNumber("upperLon",  180.0);

  return new Sector(Geodetic2D::fromDegrees(lowerLat, lowerLon),
                    Geodetic2D::fromDegrees(upperLat, upperLon));
}

MapBoo_Scene* MapBooBuilder::parseScene(const JSONObject* jsonObject) const {
  if (jsonObject == NULL) {
    return NULL;
  }

  const bool hasWarnings = jsonObject->getAsBoolean("hasWarnings", false);

//  if (hasWarnings && (_viewType != VIEW_PRESENTATION)) {
//    return NULL;
//  }

  return new MapBoo_Scene(jsonObject->getAsString("id", ""),
                          jsonObject->getAsString("name", ""),
                          jsonObject->getAsString("description", ""),
                          parseMultiImage( jsonObject->getAsObject("screenshot") ),
                          parseColor( jsonObject->getAsString("backgroundColor") ),
                          parseCameraPosition( jsonObject->getAsObject("cameraPosition") ),
                          parseSector( jsonObject->get("sector") ),
                          parseLayer( jsonObject->get("baseLayer") ),
                          parseLayer( jsonObject->get("overlayLayer") ),
                          hasWarnings);
}

const URL* MapBooBuilder::parseURL(const JSONString* jsonString) const {
  if (jsonString == NULL) {
    return NULL;
  }
  return new URL(jsonString->value());
}

MapBoo_Notification* MapBooBuilder::parseNotification(const JSONObject* jsonObject) const {
  if (jsonObject == NULL) {
    return NULL;
  }

  return new MapBoo_Notification(Geodetic2D::fromDegrees(jsonObject->getAsNumber("latitude",  0),
                                                         jsonObject->getAsNumber("longitude", 0)),
                                 parseCameraPosition( jsonObject->getAsObject("cameraPosition") ),
                                 jsonObject->getAsString("message", ""),
                                 parseURL( jsonObject->getAsString("iconURL") )
                                 );
}

std::vector<MapBoo_Notification*>* MapBooBuilder::parseNotifications(const JSONArray* jsonArray) const {
  std::vector<MapBoo_Notification*>* result = new std::vector<MapBoo_Notification*>();

  if (jsonArray != NULL) {
    const int size = jsonArray->size();
    for (int i = 0; i < size; i++) {
      MapBoo_Notification* notification = parseNotification( jsonArray->getAsObject(i) );
      if (notification != NULL) {
        result->push_back(notification);
      }
    }
  }

  return result;
}

void MapBooBuilder::parseApplicationJSON(const std::string& json,
                                         const URL& url) {
  const JSONBaseObject* jsonBaseObject = IJSONParser::instance()->parse(json, true);

  if (jsonBaseObject == NULL) {
    ILogger::instance()->logError("Can't parse ApplicationJSON from %s",
                                  url.getPath().c_str());
  }
  else {
    const JSONObject* jsonObject = jsonBaseObject->asObject();
    if (jsonObject == NULL) {
      ILogger::instance()->logError("Invalid ApplicationJSON");
    }
    else {
      const JSONString* jsonError = jsonObject->getAsString("error");
      if (jsonError == NULL) {
        const int timestamp = (int) jsonObject->getAsNumber("timestamp", 0);

        if (getApplicationTimestamp() != timestamp) {
          const JSONString* jsonName = jsonObject->getAsString("name");
          if (jsonName != NULL) {
            setApplicationName( jsonName->value() );
          }

          const JSONString* jsonWebsite = jsonObject->getAsString("website");
          if (jsonWebsite != NULL) {
            setApplicationWebsite( jsonWebsite->value() );
          }

          const JSONString* jsonEMail = jsonObject->getAsString("email");
          if (jsonEMail != NULL) {
            setApplicationEMail( jsonEMail->value() );
          }

          const JSONString* jsonAbout = jsonObject->getAsString("about");
          if (jsonAbout != NULL) {
            setApplicationAbout( jsonAbout->value() );
          }

          const JSONArray* jsonScenes = jsonObject->getAsArray("scenes");
          if (jsonScenes != NULL) {
            std::vector<MapBoo_Scene*> scenes;

            const int scenesCount = jsonScenes->size();
            for (int i = 0; i < scenesCount; i++) {
              MapBoo_Scene* scene = parseScene( jsonScenes->getAsObject(i) );
              if (scene != NULL) {
                scenes.push_back(scene);
              }
            }

            setApplicationScenes(scenes);
          }

          setApplicationTimestamp(timestamp);
          saveApplicationData();
          setHasParsedApplication();
        }

        const JSONNumber* jsonCurrentSceneIndex = jsonObject->getAsNumber("currentSceneIndex");
        if (jsonCurrentSceneIndex != NULL) {
          setApplicationCurrentSceneIndex( (int) jsonCurrentSceneIndex->value() );
        }

        if (_enableNotifications) {
          const JSONArray* jsonNotifications = jsonObject->getAsArray("notifications");
          if (jsonNotifications != NULL) {
            addApplicationNotifications( parseNotifications(jsonNotifications) );
          }

          const JSONObject* jsonNotification = jsonObject->getAsObject("notification");
          if (jsonNotification != NULL) {
            addApplicationNotification( parseNotification(jsonNotification) );
          }
        }
      }
      else {
        ILogger::instance()->logError("Server Error: %s",
                                      jsonError->value().c_str());
      }
    }

    delete jsonBaseObject;
  }

}

void MapBooBuilder::addApplicationNotifications(const std::vector<MapBoo_Notification*>* notifications) {
  if (notifications == NULL) {
    return;
  }

  const int size = notifications->size();
  for (int i = 0; i < size; i++) {
    MapBoo_Notification* notification = notifications->at(i);
    if (notification != NULL) {
      addApplicationNotification(notification);
    }
  }

  delete notifications;
}

void MapBooBuilder::addApplicationNotification(MapBoo_Notification* notification) {
  if (_marksRenderer != NULL) {
    const std::string message = notification->getMessage();

    const bool hasMessage = (message.size() > 0);
    const URL* iconURL = notification->getIconURL();

    const Geodetic2D position = notification->getPosition();

    bool newMark = false;

    if (hasMessage) {
      if (iconURL == NULL) {
        _marksRenderer->addMark( new Mark(message,
                                          Geodetic3D(position, 0),
                                          ABSOLUTE,
                                          0) );
      }
      else {
        _marksRenderer->addMark( new Mark(message,
                                          *iconURL,
                                          Geodetic3D(position, 0),
                                          ABSOLUTE,
                                          0) );
      }
      newMark = true;
    }
    else {
      if (iconURL != NULL) {
        _marksRenderer->addMark( new Mark(*iconURL,
                                          Geodetic3D(position, 0),
                                          ABSOLUTE,
                                          0) );
        newMark = true;
      }
    }

    if (newMark) {
      const MapBoo_CameraPosition* cameraPosition = notification->getCameraPosition();
      if (cameraPosition != NULL) {
        _g3mWidget->setAnimatedCameraPosition(TimeInterval::fromSeconds(3),
                                              cameraPosition->getPosition(),
                                              cameraPosition->getHeading(),
                                              cameraPosition->getPitch());
      }
    }
  }

  delete notification;
}

void MapBooBuilder::setApplicationCurrentSceneIndex(int sceneIndex) {
  if (sceneIndex != _applicationCurrentSceneIndex) {
    const bool validSceneIndex = ((sceneIndex >= 0) &&
                                  (sceneIndex < _applicationScenes.size()));

    if (validSceneIndex) {
      _applicationCurrentSceneIndex = sceneIndex;
      changedCurrentScene();
    }
  }
}

LayerSet* MapBoo_Scene::createLayerSet() const {
  LayerSet* layerSet = new LayerSet();
  if (_baseLayer != NULL) {
    layerSet->addLayer(_baseLayer->copy());
  }
  if (_overlayLayer != NULL) {
    layerSet->addLayer(_overlayLayer->copy());
  }
  return layerSet;
}

void MapBooBuilder::recreateLayerSet() {
  const MapBoo_Scene* scene = getApplicationCurrentScene();

  if (scene == NULL) {
    _layerSet->removeAllLayers(true);
  }
  else {
    LayerSet* newLayerSet = scene->createLayerSet();
    if (!newLayerSet->isEquals(_layerSet)) {
      _layerSet->removeAllLayers(true);
      _layerSet->takeLayersFrom(newLayerSet);
    }
    delete newLayerSet;
  }
}

const URL MapBooBuilder::createApplicationTubeURL() const {
  const std::string tubesPath = _tubesURL.getPath();

  std::string view;
  switch (_viewType) {
    case VIEW_PRESENTATION:
      view = "presentation";
      break;
      //    case VIEW_RUNTIME:
      //      view = "runtime";
      //      break;
    default:
      view = "runtime";
  }

  return URL(tubesPath + "/application/" + _applicationId + "/" + view, false);
}


class MapBooBuilder_TubeWatchdogPeriodicalTask : public GTask {
private:
  MapBooBuilder* _builder;
  bool _firstRun;

public:
  MapBooBuilder_TubeWatchdogPeriodicalTask(MapBooBuilder* builder) :
  _builder(builder),
  _firstRun(true)
  {
  }

  void run(const G3MContext* context) {
    if (_firstRun) {
      _firstRun = false;
    }
    else {
      if (!_builder->isApplicationTubeOpen()) {
        _builder->openApplicationTube(context);
      }
    }
  }

};


std::vector<PeriodicalTask*>* MapBooBuilder::createPeriodicalTasks() {
  std::vector<PeriodicalTask*>* periodicalTasks = new std::vector<PeriodicalTask*>();

  periodicalTasks->push_back(new PeriodicalTask(TimeInterval::fromSeconds(5),
                                                new MapBooBuilder_TubeWatchdogPeriodicalTask(this)));

  return periodicalTasks;
}

IStorage* MapBooBuilder::getStorage() {
  if (_storage == NULL) {
    _storage = createStorage();
  }
  return _storage;
}

class MapBooBuilder_ApplicationTubeListener : public IWebSocketListener {
private:
  MapBooBuilder* _builder;

public:
  MapBooBuilder_ApplicationTubeListener(MapBooBuilder* builder) :
  _builder(builder)
  {
  }

  ~MapBooBuilder_ApplicationTubeListener() {
  }

  void onOpen(IWebSocket* ws) {
    ILogger::instance()->logInfo("Tube '%s' opened!",
                                 ws->getURL().getPath().c_str());
    _builder->setApplicationTubeOpened(true);
  }

  void onError(IWebSocket* ws,
               const std::string& error) {
    ILogger::instance()->logError("Error '%s' on Tube '%s'",
                                  error.c_str(),
                                  ws->getURL().getPath().c_str());
    _builder->setApplicationTubeOpened(false);
  }

  void onMesssage(IWebSocket* ws,
                  const std::string& message) {
    //ILogger::instance()->logInfo(message);
    _builder->parseApplicationJSON(message, ws->getURL());
  }

  void onClose(IWebSocket* ws) {
    ILogger::instance()->logError("Tube '%s' closed!",
                                  ws->getURL().getPath().c_str());
    _builder->setApplicationTubeOpened(false);
  }
};

class MapBooBuilder_ApplicationTubeConnector : public GInitializationTask {
private:
  MapBooBuilder* _builder;

public:
  MapBooBuilder_ApplicationTubeConnector(MapBooBuilder* builder) :
  _builder(builder)
  {
  }

  void run(const G3MContext* context) {
    _builder->setContext(context);
    _builder->openApplicationTube(context);
  }

  bool isDone(const G3MContext* context) {
    return _builder->isApplicationTubeOpen() && _builder->hasParsedApplication();
    //return true;
  }
};

void MapBooBuilder::setContext(const G3MContext* context) {
  _context = context;
}

MapBooBuilder::~MapBooBuilder() {

}

class MapBooBuilder_RestJSON : public IBufferDownloadListener {
private:
  MapBooBuilder* _builder;

public:
  MapBooBuilder_RestJSON(MapBooBuilder* builder) :
  _builder(builder)
  {
  }

  void onDownload(const URL& url,
                  IByteBuffer* buffer,
                  bool expired) {
    _builder->parseApplicationJSON(buffer->getAsString(), url);
    delete buffer;
  }

  void onError(const URL& url) {
    ILogger::instance()->logError("Can't download %s", url.getPath().c_str());
  }

  void onCancel(const URL& url) {
    // do nothing
  }

  void onCanceledDownload(const URL& url,
                          IByteBuffer* buffer,
                          bool expired) {
    // do nothing
  }
};

const URL MapBooBuilder::createApplicationRestURL() const {
  IStringBuilder* isb = IStringBuilder::newStringBuilder();
  isb->addString(_serverURL.getPath());
  isb->addString("/applications/");
  isb->addString(_applicationId);
  isb->addString("?view=runtime&lastTs=");
  isb->addInt(_applicationTimestamp);
  const std::string path = isb->getString();
  delete isb;

  return URL(path, false);
}

void MapBooBuilder::openApplicationTube(const G3MContext* context) {

//  IDownloader* downloader = context->getDownloader();
//  downloader->requestBuffer(createApplicationRestURL(),
//                            DownloadPriority::HIGHEST,
//                            TimeInterval::zero(),
//                            false, // readExpired
//                            new MapBooBuilder_RestJSON(this),
//                            true);

  const IFactory* factory = context->getFactory();
  _webSocket = factory->createWebSocket(createApplicationTubeURL(),
                                        new MapBooBuilder_ApplicationTubeListener(this),
                                        true /* autodeleteListener  */,
                                        true /* autodeleteWebSocket */);
}

const int MapBooBuilder::getApplicationCurrentSceneIndex() {
  if (_applicationCurrentSceneIndex < 0) {
    _applicationCurrentSceneIndex = 0;
  }
  return _applicationCurrentSceneIndex;
}

const MapBoo_Scene* MapBooBuilder::getApplicationCurrentScene() {
  const int sceneIndex = getApplicationCurrentSceneIndex();

  const bool validSceneIndex = ((sceneIndex >= 0) &&
                                (sceneIndex < _applicationScenes.size()));

  return validSceneIndex ? _applicationScenes[sceneIndex] : NULL;
}

Color MapBooBuilder::getCurrentBackgroundColor() {
  const MapBoo_Scene* scene = getApplicationCurrentScene();
  return (scene == NULL) ? Color::black() : scene->getBackgroundColor();
}

MarksRenderer* MapBooBuilder::getMarksRenderer() {
  if (_marksRenderer == NULL) {
    _marksRenderer = new MarksRenderer(false);
  }
  return _marksRenderer;
}

G3MWidget* MapBooBuilder::create() {
  if (_g3mWidget != NULL) {
    ILogger::instance()->logError("The G3MWidget was already created, can't be created more than once");
    return NULL;
  }


  CompositeRenderer* mainRenderer = new CompositeRenderer();
  const Planet* planet = createPlanet();

  PlanetRenderer* planetRenderer = createPlanetRenderer();
  mainRenderer->addRenderer(planetRenderer);

  mainRenderer->addRenderer(getMarksRenderer());

  std::vector<ICameraConstrainer*>* cameraConstraints = createCameraConstraints(planet, planetRenderer);

  GInitializationTask* initializationTask = new MapBooBuilder_ApplicationTubeConnector(this);

  std::vector<PeriodicalTask*>* periodicalTasks = createPeriodicalTasks();

  ICameraActivityListener* cameraActivityListener = NULL;


  InitialCameraPositionProvider* icpp = new SimpleInitialCameraPositionProvider();

  _g3mWidget = G3MWidget::create(getGL(),
                                 getStorage(),
                                 getDownloader(),
                                 getThreadUtils(),
                                 cameraActivityListener,
                                 planet,
                                 *cameraConstraints,
                                 createCameraRenderer(),
                                 mainRenderer,
                                 createBusyRenderer(),
                                 createErrorRenderer(),
                                 Color::black(),
                                 false,      // logFPS
                                 false,      // logDownloaderStatistics
                                 initializationTask,
                                 true,       // autoDeleteInitializationTask
                                 *periodicalTasks,
                                 getGPUProgramManager(),
                                 createSceneLighting(),
                                 icpp);
  delete cameraConstraints;
  delete periodicalTasks;

  return _g3mWidget;
}

int MapBooBuilder::getApplicationTimestamp() const {
  return _applicationTimestamp;
}

void MapBooBuilder::saveApplicationData() const {
  //  std::string                _applicationId;
  //  std::string                _applicationName;
  //  std::string                _applicationWebsite;
  //  std::string                _applicationEMail;
  //  std::string                _applicationAbout;
  //  int                        _applicationTimestamp;
  //  std::vector<MapBoo_Scene*> _applicationScenes;
  //  int                        _applicationCurrentSceneIndex;
  //  int                        _lastApplicationCurrentSceneIndex;
  int __DGD_at_work;
}

void MapBooBuilder::setHasParsedApplication() {
  _hasParsedApplication = true;
}

bool MapBooBuilder::hasParsedApplication() const {
  return _hasParsedApplication;
}

void MapBooBuilder::setApplicationTimestamp(const int timestamp) {
  _applicationTimestamp = timestamp;
}

void MapBooBuilder::setApplicationName(const std::string& name) {
  if (_applicationName.compare(name) != 0) {
    _applicationName = name;

    if (_applicationListener != NULL) {
      _applicationListener->onNameChanged(_context, _applicationName);
    }
  }
}

void MapBooBuilder::setApplicationWebsite(const std::string& website) {
  if (_applicationWebsite.compare(website) != 0) {
    _applicationWebsite = website;

    if (_applicationListener != NULL) {
      _applicationListener->onWebsiteChanged(_context, _applicationWebsite);
    }
  }
}

void MapBooBuilder::setApplicationEMail(const std::string& eMail) {
  if (_applicationEMail.compare(eMail) != 0) {
    _applicationEMail = eMail;

    if (_applicationListener != NULL) {
      _applicationListener->onEMailChanged(_context, _applicationEMail);
    }
  }
}

void MapBooBuilder::setApplicationAbout(const std::string& about) {
  if (_applicationAbout.compare(about) != 0) {
    _applicationAbout = about;

    if (_applicationListener != NULL) {
      _applicationListener->onAboutChanged(_context, _applicationAbout);
    }
  }
}


class MapBooBuilder_ChangeSceneTask : public GTask {
private:
  MapBooBuilder* _builder;
  const int      _sceneIndex;

public:
  MapBooBuilder_ChangeSceneTask(MapBooBuilder* builder,
                                int sceneIndex) :
  _builder(builder),
  _sceneIndex(sceneIndex)
  {
  }

  void run(const G3MContext* context) {
    _builder->rawChangeScene(_sceneIndex);
  }
};

void MapBooBuilder::rawChangeScene(int sceneIndex) {
  _applicationCurrentSceneIndex = sceneIndex;

  changedCurrentScene();
}

void MapBooBuilder::changeScene(int sceneIndex) {
  const int currentSceneIndex = getApplicationCurrentSceneIndex();
  if (currentSceneIndex != sceneIndex) {
    const bool validSceneIndex = ((sceneIndex >= 0) &&
                                  (sceneIndex < _applicationScenes.size()));

    if (validSceneIndex) {
      getThreadUtils()->invokeInRendererThread(new MapBooBuilder_ChangeSceneTask(this, sceneIndex),
                                               true);
    }
  }
}

void MapBooBuilder::changeScene(const MapBoo_Scene* scene) {
  const int size = _applicationScenes.size();
  for (int i = 0; i < size; i++) {
    if (_applicationScenes[i] == scene) {
      changeScene(i);
      break;
    }
  }
}

void MapBooBuilder::changedCurrentScene() {
  recreateLayerSet();

  const MapBoo_Scene* currentScene = getApplicationCurrentScene();

  if (_g3mWidget != NULL) {
    _g3mWidget->setBackgroundColor(getCurrentBackgroundColor());

    // force immediate execution of PeriodicalTasks
    _g3mWidget->resetPeriodicalTasksTimeouts();

    if (currentScene != NULL) {
      const Sector* sector = currentScene->getSector();
      if (sector == NULL) {
        _g3mWidget->setShownSector( Sector::fullSphere() );
      }
      else {
        _g3mWidget->setShownSector( *sector );
      }

      const MapBoo_CameraPosition* cameraPosition = currentScene->getCameraPosition();
      if (cameraPosition != NULL) {
        if (cameraPosition->isAnimated()) {
          _g3mWidget->setAnimatedCameraPosition(TimeInterval::fromSeconds(3),
                                                cameraPosition->getPosition(),
                                                cameraPosition->getHeading(),
                                                cameraPosition->getPitch());
        }
        else {
          _g3mWidget->setCameraPosition( cameraPosition->getPosition() );
          _g3mWidget->setCameraHeading( cameraPosition->getHeading() );
          _g3mWidget->setCameraPitch( cameraPosition->getPitch() );
        }
      }
    }
  }

  if (_applicationListener != NULL) {
    _applicationListener->onSceneChanged(_context,
                                         getApplicationCurrentSceneIndex(),
                                         currentScene);
  }

  if (_viewType == VIEW_PRESENTATION) {
    if ((_webSocket != NULL) && _isApplicationTubeOpen) {
      if (_applicationCurrentSceneIndex != _lastApplicationCurrentSceneIndex) {
        if (_lastApplicationCurrentSceneIndex >= 0) {
          _webSocket->send( getApplicationCurrentSceneCommand() );
        }
        _lastApplicationCurrentSceneIndex = _applicationCurrentSceneIndex;
      }
    }
    else {
      ILogger::instance()->logError("VIEW_PRESENTATION: can't fire the event of changed scene");
    }
  }
}

const std::string MapBooBuilder::getApplicationCurrentSceneCommand() const {
  IStringBuilder* isb = IStringBuilder::newStringBuilder();
  isb->addString("currentSceneIndex=");
  isb->addInt(_applicationCurrentSceneIndex);
  const std::string s = isb->getString();
  delete isb;
  return s;
}

void MapBooBuilder::setApplicationScenes(const std::vector<MapBoo_Scene*>& applicationScenes) {
  const int currentScenesCount = _applicationScenes.size();
  for (int i = 0; i < currentScenesCount; i++) {
    MapBoo_Scene* scene = _applicationScenes[i];
    delete scene;
  }

  _applicationScenes.clear();

#ifdef C_CODE
  _applicationScenes = applicationScenes;
#endif
#ifdef JAVA_CODE
  _applicationScenes = new java.util.ArrayList<MapBoo_Scene>(applicationScenes);
#endif

  if (_applicationListener != NULL) {
#ifdef C_CODE
    _applicationListener->onScenesChanged(_context, _applicationScenes);
#endif
#ifdef JAVA_CODE
    _applicationListener.onScenesChanged(_context,
                                         new java.util.ArrayList<MapBoo_Scene>(_applicationScenes));
#endif
  }

  changedCurrentScene();
}

SceneLighting* MapBooBuilder::createSceneLighting() {
  return new CameraFocusSceneLighting();
}

void MapBooBuilder::setApplicationTubeOpened(bool open) {
  if (_isApplicationTubeOpen != open) {
    _isApplicationTubeOpen = open;
    if (!_isApplicationTubeOpen) {
      _webSocket = NULL;
    }

    if (_isApplicationTubeOpen) {
      if (_applicationListener != NULL) {
        _applicationListener->onWebSocketOpen(_context);
      }
    }
    else {
      if (_applicationListener != NULL) {
        _applicationListener->onWebSocketClose(_context);
      }
    }
  }
}

const MapBoo_Notification* MapBooBuilder::createNotification(const Geodetic2D&  position,
                                                             const Camera*      camera,
                                                             const std::string& message,
                                                             const URL*         iconURL) const {
  MapBoo_CameraPosition* cameraPosition = new MapBoo_CameraPosition(camera->getGeodeticPosition(),
                                                                    camera->getHeading(),
                                                                    camera->getPitch(),
                                                                    true /* animated */);
  return new MapBoo_Notification(position, cameraPosition, message, iconURL);
}

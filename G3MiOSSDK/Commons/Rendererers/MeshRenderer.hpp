//
//  MeshRenderer.hpp
//  G3MiOSSDK
//
//  Created by Diego Gomez Deck on 12/22/12.
//
//

#ifndef __G3MiOSSDK__MeshRenderer__
#define __G3MiOSSDK__MeshRenderer__

#include "LeafRenderer.hpp"
#include <vector>
#include "GLState.hpp"
#include "DownloadPriority.hpp"
#include "TimeInterval.hpp"
#include "URL.hpp"

class Mesh;


class MeshLoadListener {
public:
#ifdef C_CODE
  virtual ~MeshLoadListener() { }
#endif
#ifdef JAVA_CODE
  void dispose();
#endif

  virtual void onBeforeAddMesh(Mesh* mesh) = 0;
  virtual void onAfterAddMesh(Mesh* mesh) = 0;
};

enum MeshType {
  POINT_CLOUD,
  MESH
};

class MeshRenderer : public LeafRenderer {
private:


  class LoadQueueItem {
  public:
#ifdef C_CODE
    const URL          _url;
    const TimeInterval _timeToCache;
#endif
#ifdef JAVA_CODE
    public final URL          _url;
    public final TimeInterval _timeToCache;
#endif
    const long long    _priority;
    const bool         _readExpired;
    const float        _pointSize;
    const double       _deltaHeight;
    const Color*       _color;
    MeshLoadListener*  _listener;
    const bool         _deleteListener;
    const bool         _isBSON;
    const MeshType     _meshType;

    LoadQueueItem(const URL&          url,
                  long long           priority,
                  const TimeInterval& timeToCache,
                  bool                readExpired,
                  float               pointSize,
                  double              deltaHeight,
                  const Color*        color,
                  MeshLoadListener*   listener,
                  bool                deleteListener,
                  bool                isBSON,
                  const MeshType      meshType) :
    _url(url),
    _priority(priority),
    _timeToCache(timeToCache),
    _readExpired(readExpired),
    _pointSize(pointSize),
    _deltaHeight(deltaHeight),
    _color(color),
    _listener(listener),
    _deleteListener(deleteListener),
    _isBSON(isBSON),
    _meshType(meshType)
    {

    }

    ~LoadQueueItem() {
    }
  };
  
  

  std::vector<Mesh*> _meshes;
  
  GLState* _glState;
  void updateGLState(const G3MRenderContext* rc);

#ifdef C_CODE
  const G3MContext* _context;
#endif
#ifdef JAVA_CODE
  private G3MContext _context;
#endif

  std::vector<LoadQueueItem*> _loadQueue;

  void drainLoadQueue();

  void requestMeshBuffer(const URL&          url,
                         long long           priority,
                         const TimeInterval& timeToCache,
                         bool                readExpired,
                         float               pointSize,
                         double              deltaHeight,
                         const Color*        color,
                         MeshLoadListener*   listener,
                         bool                deleteListener,
                         bool                isBSON,
                         const MeshType      meshType);


public:

  MeshRenderer():
  _glState(new GLState()),
  _context(NULL)
  {
  }
  
  ~MeshRenderer();

  void addMesh(Mesh* mesh) {
    _meshes.push_back(mesh);
  }

  void clearMeshes();

  void enableAll();

  void disableAll();

  void onResume(const G3MContext* context) {

  }

  void onPause(const G3MContext* context) {

  }

  void onDestroy(const G3MContext* context) {

  }

  void initialize(const G3MContext* context);

  RenderState getRenderState(const G3MRenderContext* rc) {
    return RenderState::ready();
  }

  void render(const G3MRenderContext* rc, GLState* glState);

  bool onTouchEvent(const G3MEventContext* ec,
                    const TouchEvent* touchEvent) {
    return false;
  }

  void onResizeViewportEvent(const G3MEventContext* ec,
                             int width, int height) {

  }

  void start(const G3MRenderContext* rc) {

  }
  
  void stop(const G3MRenderContext* rc) {
    
  }

  void loadJSONPointCloud(const URL&          url,
                          long long           priority,
                          const TimeInterval& timeToCache,
                          bool                readExpired,
                          float               pointSize,
                          double              deltaHeight=0,
                          MeshLoadListener*   listener=NULL,
                          bool                deleteListener=true);

  void loadJSONPointCloud(const URL&        url,
                          float             pointSize,
                          double            deltaHeight=0,
                          MeshLoadListener* listener=NULL,
                          bool              deleteListener=true) {
    loadJSONPointCloud(url,
                       DownloadPriority::MEDIUM,
                       TimeInterval::fromDays(30),
                       true,
                       pointSize,
                       deltaHeight,
                       listener,
                       deleteListener);
  }

  void loadBSONPointCloud(const URL&          url,
                          long long           priority,
                          const TimeInterval& timeToCache,
                          bool                readExpired,
                          float               pointSize,
                          double              deltaHeight=0,
                          MeshLoadListener*   listener=NULL,
                          bool                deleteListener=true);

  void loadBSONPointCloud(const URL&        url,
                          float             pointSize,
                          double            deltaHeight=0,
                          MeshLoadListener* listener=NULL,
                          bool              deleteListener=true) {
    loadBSONPointCloud(url,
                       DownloadPriority::MEDIUM,
                       TimeInterval::fromDays(30),
                       true,
                       pointSize,
                       deltaHeight,
                       listener,
                       deleteListener);
  }

  void loadJSONMesh(const URL&          url,
                    const Color*        color,
                    long long           priority,
                    const TimeInterval& timeToCache,
                    bool                readExpired,
                    MeshLoadListener*   listener=NULL,
                    bool                deleteListener=true);

  void loadJSONMesh(const URL&        url,
                    const Color*      color,
                    MeshLoadListener* listener=NULL,
                    bool              deleteListener=true) {
    loadJSONMesh(url,
                 color,
                 DownloadPriority::MEDIUM,
                 TimeInterval::fromDays(30),
                 true,
                 listener,
                 deleteListener);
  }

  void loadBSONMesh(const URL&          url,
                    const Color*        color,
                    long long           priority,
                    const TimeInterval& timeToCache,
                    bool                readExpired,
                    MeshLoadListener*   listener=NULL,
                    bool                deleteListener=true);

  void loadBSONMesh(const URL&        url,
                    const Color*      color,
                    MeshLoadListener* listener=NULL,
                    bool              deleteListener=true) {
    loadBSONMesh(url,
                 color,
                 DownloadPriority::MEDIUM,
                 TimeInterval::fromDays(30),
                 true,
                 listener,
                 deleteListener);
  }


};

#endif

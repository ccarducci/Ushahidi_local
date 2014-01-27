//
//  GLState.cpp
//  G3MiOSSDK
//
//  Created by Jose Miguel SN on 17/05/13.
//
//

#include "GLState.hpp"
#include "GLFeature.hpp"

GLState::~GLState() {
  delete _accumulatedFeatures;

  delete _valuesSet;
  delete _globalState;

  if (_parentGLState != NULL) {
    _parentGLState->_release();
  }
}

void GLState::hasChangedStructure() const {
  _timeStamp++;
  delete _valuesSet;
  _valuesSet = NULL;
  delete _globalState;
  _globalState = NULL;
  _lastGPUProgramUsed = NULL;

  delete _accumulatedFeatures;
  _accumulatedFeatures = NULL;
}

GLFeatureSet* GLState::getAccumulatedFeatures() const{
  if (_accumulatedFeatures == NULL) {

    _accumulatedFeatures = new GLFeatureSet();

    if (_parentGLState != NULL) {
      GLFeatureSet* parents = _parentGLState->getAccumulatedFeatures();
      if (parents != NULL) {
        _accumulatedFeatures->add(parents);
      }
    }
    _accumulatedFeatures->add(&_features);

  }
  return _accumulatedFeatures;
}

void GLState::addGLFeature(GLFeature* f, bool mustRetain) {
  _features.add(f);

  if (!mustRetain) {
    f->_release();
  }

  hasChangedStructure();
}

void GLState::setParent(const GLState* parent) const{

  if (parent == NULL) {
    if (parent != _parentGLState) {
      _parentGLState    = NULL;
      _parentsTimeStamp = -1;
      hasChangedStructure();
    }
  }
  else {
    const int parentsTimeStamp = parent->getTimeStamp();
    if ((parent != _parentGLState) ||
        (_parentsTimeStamp != parentsTimeStamp)) {

      if (_parentGLState != parent) {
        if (_parentGLState != NULL) {
          _parentGLState->_release();
        }
        _parentGLState    = parent;
        _parentGLState->_retain();
      }

      _parentsTimeStamp = parentsTimeStamp;
      hasChangedStructure();
    }
  }
}

void GLState::applyOnGPU(GL* gl, GPUProgramManager& progManager) const{


  if (_valuesSet == NULL && _globalState == NULL) {

    _valuesSet   = new GPUVariableValueSet();
    _globalState = new GLGlobalState();

    GLFeatureSet* accumulatedFeatures = getAccumulatedFeatures();

    //    for (int i = 0; i < N_GLFEATURES_GROUPS; i++) {
    //      GLFeatureGroupName groupName = GLFeatureGroup::getGroupName(i);
    //      GLFeatureGroup* group = GLFeatureGroup::createGroup(groupName);
    //
    ////      for (int j = 0; j < accumulatedFeatures->size(); j++) {
    ////        const GLFeature* f = accumulatedFeatures->get(j);
    ////        if (f->getGroup() == groupName) {
    ////          group->add(f);
    ////        }
    ////      }
    ////      group->addToGPUVariableSet(_valuesSet);
    ////      group->applyOnGlobalGLState(_globalState);
    //
    //      group->apply(*accumulatedFeatures, *_valuesSet, *_globalState);
    //
    //      delete group;
    //    }

    GLFeatureGroup::applyToAllGroups(*accumulatedFeatures, *_valuesSet, *_globalState);

    const int uniformsCode   = _valuesSet->getUniformsCode();
    const int attributesCode = _valuesSet->getAttributesCode();

    _lastGPUProgramUsed = progManager.getProgram(gl, uniformsCode, attributesCode);
  }

  if (_valuesSet == NULL || _globalState == NULL) {
    ILogger::instance()->logError("GLState logic error.");
    return;
  }

  if (_lastGPUProgramUsed != NULL) {
    gl->useProgram(_lastGPUProgramUsed);

    _valuesSet->applyValuesToProgram(_lastGPUProgramUsed);
    _globalState->applyChanges(gl, *gl->getCurrentGLGlobalState());

    _lastGPUProgramUsed->applyChanges(gl);

    //prog->onUnused(); //Uncomment to check that all GPUProgramStates are complete
  }
  else {
    ILogger::instance()->logError("No GPUProgram found.");
  }

}

void GLState::clearGLFeatureGroup(GLFeatureGroupName g) {
  _features.clearFeatures(g);
  hasChangedStructure();
}

void GLState::clearAllGLFeatures() {
  _features.clearFeatures();
  hasChangedStructure();
}

int GLState::getNumberOfGLFeatures() const{
  return _features.size();
}

GLFeature* GLState::getGLFeature(GLFeatureID id) const{
  const int size = _features.size();
  for (int i = 0; i < size; i++) {
    GLFeature* f = _features.get(i);
    if (f->_id == id) {
      return f;
    }
  }

  return NULL;
}

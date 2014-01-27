//
//  IndexedMesh.hpp
//  G3MiOSSDK
//
//  Created by José Miguel S N on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef G3MiOSSDK_IndexedMesh_h
#define G3MiOSSDK_IndexedMesh_h

#include "AbstractMesh.hpp"

class IShortBuffer;

class IndexedMesh : public AbstractMesh {
private:
  IShortBuffer*       _indices;
protected:
  void rawRender(const G3MRenderContext* rc) const;

public:
  IndexedMesh(const int primitive,
              bool owner,
              const Vector3D& center,
              IFloatBuffer* vertices,
              IShortBuffer* indices,
              float lineWidth,
              float pointSize = 1,
              const Color* flatColor = NULL,
              IFloatBuffer* colors = NULL,
              const float colorsIntensity = 0.0f,
              bool depthTest = true,
              IFloatBuffer* normals = NULL);

  ~IndexedMesh();
};

#endif

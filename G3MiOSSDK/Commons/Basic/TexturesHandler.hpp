//
//  TexturesHandler.hpp
//  G3MiOSSDK
//
//  Created by Diego Gomez Deck on 19/06/12.
//  Copyright (c) 2012 IGO Software SL. All rights reserved.
//

#ifndef G3MiOSSDK_TexturesHandler_hpp
#define G3MiOSSDK_TexturesHandler_hpp

#include <string>
#include <vector>

#include "INativeGL.hpp"

class IImage;
class G3MRenderContext;
class TextureHolder;
class GL;
class IFactory;
class IGLTextureId;


class TextureSpec {
private:
  const std::string _id;

  const int         _width;
  const int         _height;
  const bool        _isMipmap;

  TextureSpec& operator=(const TextureSpec& that);

public:
  TextureSpec(const std::string& id,
              const int          width,
              const int          height,
              const bool         isMipmap):
  _id(id),
  _width(width),
  _height(height),
  _isMipmap(isMipmap)
  {

  }

  TextureSpec():_id(""), _width(0),_height(0), _isMipmap(false) {}

  TextureSpec(const TextureSpec& that):
  _id(that._id),
  _width(that._width),
  _height(that._height),
  _isMipmap(that._isMipmap)
  {

  }

  bool isMipmap() const {
    return _isMipmap;
  }

  int getWidth() const {
    return _width;
  }

  int getHeight() const {
    return _height;
  }

  bool equalsTo(const TextureSpec& that) const {
    return ((_id.compare(that._id) == 0) &&
            (_width  == that._width) &&
            (_height == that._height));
  }

  bool lowerThan(const TextureSpec& that) const {
    if (_id < that._id) {
      return true;
    }
    else if (_id > that._id) {
      return false;
    }

    if (_width < that._width) {
      return true;
    }
    else if (_width > that._width) {
      return false;
    }

    return (_height < that._height);
  }

  const std::string description() const;

#ifdef C_CODE
  bool operator<(const TextureSpec& that) const {
    return lowerThan(that);
  }
#endif

#ifdef JAVA_CODE
  @Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + _height;
		result = prime * result + ((_id == null) ? 0 : _id.hashCode());
		result = prime * result + _width;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		TextureSpec other = (TextureSpec) obj;
		if (_height != other._height)
			return false;
		if (_id == null) {
			if (other._id != null)
				return false;
		} else if (!_id.equals(other._id))
			return false;
		if (_width != other._width)
			return false;
		return true;
	}
#endif
};

class TexturesHandler;

class TextureIDReference{
private:
  const IGLTextureId* _id;
  TexturesHandler* _texHandler;
public:

  TextureIDReference(const IGLTextureId* id,
                     TexturesHandler* texHandler):
  _texHandler(texHandler), _id(id){}

  virtual ~TextureIDReference();

  TextureIDReference* createCopy() const;

  const IGLTextureId* getID() const{
    return _id;
  }

};

class TexturesHandler {
private:
  std::vector<TextureHolder*> _textureHolders;

  GL* const _gl;
  const bool _verbose;
  //void showHolders(const std::string& message) const;

  const IGLTextureId* getGLTextureIdIfAvailable(const TextureSpec& textureSpec);

public:

  TexturesHandler(GL* const  gl,
                  bool verbose):
  _gl(gl),
  _verbose(verbose)
  {
  }

  ~TexturesHandler();

  const TextureIDReference* getTextureIDReference(const IImage* image,
                                     int format,
                                     const std::string& name,
                                     bool hasMipMap);


  //This two methods are supposed to be accessed only by TextureIDReference class
  void releaseGLTextureId(const IGLTextureId* glTextureId);
  void retainGLTextureId(const IGLTextureId* glTextureId);
};

#endif

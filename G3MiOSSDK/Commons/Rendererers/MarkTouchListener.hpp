//
//  MarkTouchListener.hpp
//  G3MiOSSDK
//
//  Created by Eduardo de la Montaña on 05/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef G3MiOSSDK_MarkTouchListener_hpp
#define G3MiOSSDK_MarkTouchListener_hpp

class Mark;

class MarkTouchListener {
public:
  virtual ~MarkTouchListener() {
  }

  virtual bool touchedMark(Mark* mark) = 0;
};

#endif

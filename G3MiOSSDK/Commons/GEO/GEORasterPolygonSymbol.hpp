//
//  GEORasterPolygonSymbol.hpp
//  G3MiOSSDK
//
//  Created by Diego Gomez Deck on 7/23/13.
//
//

#ifndef __G3MiOSSDK__GEORasterPolygonSymbol__
#define __G3MiOSSDK__GEORasterPolygonSymbol__

#include "GEORasterSymbol.hpp"

#include "GEO2DLineRasterStyle.hpp"
#include "GEO2DSurfaceRasterStyle.hpp"

class GEO2DPolygonData;


class GEORasterPolygonSymbol : public GEORasterSymbol {
private:
#ifdef C_CODE
  const std::vector<Geodetic2D*>* _coordinates;
  const GEO2DLineRasterStyle      _lineStyle;
  const GEO2DSurfaceRasterStyle   _surfaceStyle;
#endif
#ifdef JAVA_CODE
  private java.util.ArrayList<Geodetic2D> _coordinates;
  private final GEO2DLineRasterStyle      _lineStyle;
  private final GEO2DSurfaceRasterStyle   _surfaceStyle;
#endif

  const std::vector<std::vector<Geodetic2D*>*>* _holesCoordinatesArray;

public:

  GEORasterPolygonSymbol(const GEO2DPolygonData*        polygonData,
                         const GEO2DLineRasterStyle&    lineStyle,
                         const GEO2DSurfaceRasterStyle& surfaceStyle,
                         const int minTileLevel = -1,
                         const int maxTileLevel = -1);

  ~GEORasterPolygonSymbol();

  void rawRasterize(ICanvas*                   canvas,
                    const GEORasterProjection* projection) const;

};

#endif

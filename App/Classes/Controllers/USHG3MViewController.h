//
//  USHG3MViewController.h
//  App
//
//  Created by Cristiano Carducci on 22/11/13.
//  Copyright (c) 2013 Ushahidi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <G3MiOSSDK/G3MWidget_iOS.h>
#import <G3MBuilder_iOS.hpp>

class MapBooBuilder_iOS;

class Sector;
class Mesh;


Mesh* createSectorMesh(const Planet* planet,
                       const int resolution,
                       const Sector& sector,
                       const Color& color,
                       const int lineWidth);


@interface USHG3MViewController : UIViewController{
    
    
    IBOutlet G3MWidget_iOS *G3MWidget;
    MapBooBuilder_iOS* _g3mcBuilder;
}
@property (retain, nonatomic) G3MWidget_iOS* G3MWidget;

@end

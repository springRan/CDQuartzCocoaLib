//
//  AbstractConnectorShape.h
//  CDQuartzGraph
//
//  Created by Chris Davey on 14/08/10.
//  Copyright 2010 none. All rights reserved.
//

#import "CDQuartzGraphHeader.h"
#import "AbstractGraphShape.h"
#import "ShapeDelegate.h"
#import "AbstractPortShape.h"
#import "CirclePortShape.h"
#import "CurvedRectanglePort.h"

@interface AbstractConnectorShape : AbstractGraphShape {
	/**
	 A shape that is drawn at the start of the connection.
	 **/
	AbstractGraphShape *startDecoration;
	/**
	 A shape that is drawn at the end of the connection.
	 **/
	AbstractGraphShape *endDecoration;
	
	/**
	 A reference to the start port.
	 **/
	AbstractPortShape *startPort;
	
	/**
	A reference to the end port.
	 **/
	AbstractPortShape *endPort;
}

/**
 A shape that is drawn at the start of the connection.
 **/
@property(retain) AbstractGraphShape *startDecoration;
/**
 A shape that is drawn at the end of the connection.
 **/
@property(retain) AbstractGraphShape *endDecoration;

/**
 A reference to the start port.
 **/
@property(retain) AbstractPortShape *startPort;

/**
 A reference to the end port.
 **/
@property(retain) AbstractPortShape *endPort;



/**
 Default initialisation.
 **/
-(id)init;

/**
 Default initialisation.
 **/
-(id)initWithLabel:(NSString *)l;

/**
 Initialise with bounds.
 **/
-(id)initWithBounds:(QRectangle *)b;

/**
 Initialise with bounds and label.
 **/
-(id)initWithBounds:(QRectangle *)b AndLabel:(NSString *)l;

-(void)dealloc;

/**
 Initialise the line with default bounds.
 Use the diagonal of the bounds to set the key points.
 **/
-(void)initialiseRect:(QRectangle *)b;

/**
 Update Connections.
 **/
-(void)updateConnections;

/**
 Connect the start line to supplied port.
 **/
-(void)connectStartTo:(AbstractPortShape *)port;

/**
 Connect the end line to supplied port.
 **/
-(void)connectEndTo:(AbstractPortShape *)port;


/**
 Move start point by relative amount.
 **/
-(void)moveStartBy:(QPoint *)p;

/**
 Move end point by relative amount.
 **/
-(void)moveEndBy:(QPoint *)p;

/**
 Move start point to absolute point.
 **/
-(void)moveStartTo:(QPoint *)p;

/**
 Move end point to absolute point.
 **/
-(void)moveEndTo:(QPoint *)p;


/**
 Update the context.
 **/
-(void)update:(QContext *)context;

#pragma mark Encoder and Decoder.
/**
 Read data from an nscoder.
 **/
-(id)initWithCoder:(NSCoder *)aDecoder;
/**
 Write data to an nscoder.
 **/
-(void)encodeWithCoder:(NSCoder *)aCoder;

@end

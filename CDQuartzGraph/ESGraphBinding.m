//
//  EcmascriptGraphBinding.m
//  CDQuartzGraph
//
//  Created by Chris Davey on 6/02/11.
//  Copyright 2011 cd. All rights reserved.
//

#import "ESGraphBinding.h"


@implementation ESGraphBinding

@synthesize webView;
@synthesize scriptObject;
@synthesize state;
@synthesize graphView;
@synthesize textView;
@synthesize scriptData;

-(id)init {
	self = [super init];
	
	return self;
}

/**
 Initialisation of the graph binding.
 **/
-(id)initWithWebView:(WebView *) webView AndState:(CDGraphViewState *)st  {
	self = [super init];
	if (self.webView != nil)
	{
		self.scriptObject = [self.webView windowScriptObject];
		[self.scriptObject setValue:self forKey:@"Graph"];
		
		// load the web resource web.htm the web view.
		NSString *path = [[NSBundle bundleForClass:[ESGraphBinding class]] pathForResource:@"scriptpage" ofType:@"htm"];
		[[self.webView mainFrame] loadRequest:
		 [NSURLRequest requestWithURL:
		  [NSURL URLWithString:path]]];
	}
	self.state = st;
	return self;
}

-(void)awakeFromNib {
	if (self.webView != nil)
	{
		self.scriptObject = [self.webView windowScriptObject];
		[self.scriptObject setValue:self forKey:@"Graph"];
		
		// load the web resource web.htm the web view.
		NSString *path = [[NSBundle bundleForClass:[ESGraphBinding class]] pathForResource:@"scriptpage" ofType:@"htm"];
		[[self.webView mainFrame] loadRequest:
		 [NSURLRequest requestWithURL:
		  [NSURL URLWithString:path]]];
	}
	if (self.graphView != nil) {
		self.state = self.graphView.state;	
	}
	// assign self as the text view delegate
	if (self.textView != nil)
	{
		[self.textView setDelegate:self];	
	}
}

/**
 Deallocate the script object.
 **/
-(void)dealloc {
	// assign nil with autorelease called in property.
	self.webView = nil;
	self.scriptObject = nil;  
	self.state = nil;
	self.graphView = nil;
	self.textView = nil;
	self.scriptData = nil;
	[super dealloc];
}

/**
 Find a node for a given name.
 This method is not exported for ecmascript.
 **/
-(CDQuartzNode*) findNode:(NSString *)name
{
	CDNode *node = [self.state.graph findWith:^(CDNode *node) {
		if ([node.data compare:name options:NSCaseInsensitiveSearch] == NSOrderedSame)
			return YES;
		else 
			return NO;
	}];
	if (node == nil) return nil;
	return (CDQuartzNode*)node;
}



/**
 Add a node with supplied name.
 The name should be unique.
 If the node exists the node will not be created.
 **/
-(void)addNodeWithName:(NSString *)name
{
	[self.state.graph add:name];
}


/**
 Connect two nodes by name.
 
 **/
-(void)connectNode:(NSString *)name ToTarget:(NSString *)target
{
	CDNode *node = [self.state.graph findWith:^(CDNode *search) {
		if ([search.data compare:name options:NSCaseInsensitiveSearch] == NSOrderedSame)
			return YES;
		else 
			return NO;
	}];
	if (node == nil) return;
	CDNode *targetNode = [self.state.graph findWith:^(CDNode *search) {
		if ([search.data compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame)
			return YES;
		else 
			return NO;
	}];
	if (target == nil) return;
	[self.state.graph connect:node to:targetNode];
}

/**
 Create a shape description that can be used with the graph.
 **/
-(ESShapeDescription *)makeShapeInstance
{
	ESShapeDescription *shape = [[[ESShapeDescription alloc] init] autorelease];
	return shape;
}

-(void)setShape: (ESShapeDescription *)shape ForName:(NSString *)name
{
	CDQuartzNode *node = [self findNode:name];
	if (node == nil) return;
	// select the appropriate shape by name.
	AbstractNodeShape* nodeShape = [shape createShape];
	node.shapeDelegate = nodeShape;
}



-(void)setColor: (NSString*)c ForShape:(ESShapeDescription*) s { s.color = c; }
-(NSString*)getColorForShape:(ESShapeDescription *)s { return s.color; }
-(void)setOutlineColor:(NSString*)c ForShape:(ESShapeDescription *)s { s.outlineColor = c; }
-(NSString*)getOutlineColorForShape:(ESShapeDescription *)s { return s.outlineColor; }
-(void)setOutlineWidth:(float)w ForShape:(ESShapeDescription *)s { s.outlineWidth= w; }
-(float)getOutlineWidthForShape:(ESShapeDescription *)s { return s.outlineWidth; }
-(void)setTypeName:(NSString*)n ForShape:(ESShapeDescription *)s { s.shapeType = n; }
-(NSString*)getTypeNameForShape:(ESShapeDescription *)s { return s.shapeType; }
-(void)setLabelText:(NSString*)n ForShape:(ESShapeDescription *)s { s.labelText = n; }
-(NSString*)getLabelTextForShape:(ESShapeDescription *)s { return s.labelText; }
-(void)setAlpha:(float)a ForShape:(ESShapeDescription *)s { s.alpha= a; }
-(float)getAlphaForShape:(ESShapeDescription *)s { return s.alpha; }

-(void)setX:(float)x ForShape:(ESShapeDescription *)s { s.bounds.x = x; }
-(float)getXForShape:(ESShapeDescription *)s { return s.bounds.x; }

-(void)setY:(float)y ForShape:(ESShapeDescription *)s { s.bounds.y = y; }
-(float)getYForShape:(ESShapeDescription *)s { return s.bounds.y; }


-(void)setWidth:(float)w ForShape:(ESShapeDescription *)s { s.bounds.width = w; }
-(float)getWidthForShape:(ESShapeDescription *)s { return s.bounds.width; }

-(void)setHeight:(float)h ForShape:(ESShapeDescription *)s { s.bounds.height = h; }
-(float)getHeightForShape:(ESShapeDescription *)s { return s.bounds.height; }



+ (NSString *)webScriptNameForSelector:(SEL)sel
{
    // change the javascript name from 'forward_' to 'forward' ...
	if (sel == @selector(addNodeWithName:))
		return @"addNodeWithName";
	if (sel == @selector(makeShapeInstance))
		return @"makeShapeInstance";
	if (sel == @selector(setShape:ForName:))
		return @"setShapeForName";
	if (sel == @selector(connectNode:ToTarget:))
		return @"connectNodeToTarget";
	if (sel == @selector(setColor:ForShape:))
		return @"setColorForShape";
	if (sel == @selector(getColorForShape:))
		return @"getColorForShape";
	if (sel == @selector(setOutlineColor:ForShape:))
		return @"setOutlineColorForShape";
	if (sel == @selector(getOutlineColorForShape:))
		return @"getOutlineColorForShape";
	if (sel == @selector(setTypeName:ForShape:))
		return @"setTypeNameForShape";
	if (sel == @selector(getTypeNameForShape:))
		return @"getTypeNameForShape";
	if (sel == @selector(setLabelText:ForShape:))
		return @"setLabelTextForShape";
	if (sel == @selector(getLabelTextForShape:))
		return @"getLabelTextForShape";
	if (sel == @selector(setAlpha:ForShape:))
		return @"setAlphaForShape";
	if (sel == @selector(getAlphaForShape:))
		return @"getAlphaForShape";
	if (sel == @selector(setX:ForShape:))
		return @"setXForShape";
	if (sel == @selector(getXForShape:))
		return @"getXForShape";
	if (sel == @selector(setY:ForShape:))
		return @"setYForShape";
	if (sel == @selector(getYForShape:))
		return @"getYForShape";
	if (sel == @selector(setWidth:ForShape:))
		return @"setWidthForShape";
	if (sel == @selector(getWidthForShape:))
		return @"getWidthForShape";
	if (sel == @selector(setHeight:ForShape:))
		return @"setHeightForShape";
	if (sel == @selector(getHeightForShape:))
		return @"getHeightForShape";
	
	return nil;
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)sel { 
	if (sel == @selector(setState:)) return YES;
	if (sel == @selector(setScriptObject:)) return YES;
	if (sel == @selector(findNodeFor:)) return YES;
	return NO;
	
}
+ (BOOL)isKeyExcludedFromWebScript:(const char *)name { 
	return NO;	
}

/**
 Parse and display the graph.
 **/
-(IBAction)parseDisplayGraph:(id)sender
{
	if (self.textView == nil)
		return;
	// read the graph and get the ecmascript.
	NSString* string = [self ecmascriptForGraph];
	self.scriptData = string;
	[self.textView setString:string];
}

/**
 Apply the changes from the view to the graph.
 **/
-(IBAction)applyChanges:(id)sender
{
	if (self.webView == nil)
		return;
	if (self.textView == nil)
		return;
	if (self.scriptData == nil)
		return;
	if ([self.scriptData isEqualToString:@""])
		return;
	// try and call the ecmascript.
	NSArray *args = [NSArray arrayWithObjects:
					 self.scriptData,
					 nil];
	self.scriptObject = [self.webView windowScriptObject];
	[self.scriptObject callWebScriptMethod:@"parseFromJSON"
						withArguments:args];
}

/**
 Receive notification of the text view changes.
 **/
- (void) textDidChange: (NSNotification *) notification
{
	self.scriptData = [NSString stringWithString:[[self.textView textStorage] string]]; 	
}


/**
 Process the supplied graph.
 **/
-(NSString *)ecmascriptForGraph {
	
	if ((self.state == nil) || (self.state.graph == nil) )
		return @"";
	
	ESGraphParser* parser = [[ESGraphParser alloc] initWithGraph:self.state.graph];
	self.scriptData = [parser parse];
	[parser autorelease];
	return self.scriptData;
}

@end

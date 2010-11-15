//
//  EdgeDelete.m
//  CDQuartzGraph
//
//  Created by Chris Davey on 9/10/10.
/**
 Copyright (c) 2010, Chris Davey
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

#import "EdgeDelete.h"


@implementation EdgeDelete


-(id)init {
	self = [super init];
	return self;
}


/**
 Does the operation apply to the current state.
 **/
-(BOOL)appliesTo:(CDGraphViewState *)state
{
	if (!state.shouldDelete || state.isCancelled) 
		return NO;
	return	(state.shouldDelete) && 
			(!state.isCancelled) && 
			([state.selectEdges count] > 0) &&
			(state.isEditing);
}

/**
 Update the state. 
 **/
-(void)update:(CDGraphViewState *)state
{
	int i = 0;
	for(QPoint *p in state.hoverPoints)
	{
		TrackedEdge *t = [state findTrackedEdge:i];
		if (t.edge != nil)
		{
			// disconnect the items.
			[state.graph disconnect:t.edge.source to:t.edge.target]; 
			// remove it from detached edges if it exists.
			t.edge.source = nil;
			t.edge.target = nil;
			[state.detachedEdges removeObject:(id)t.edge];
			[state.selectEdges removeObjectAtIndex:t.index];
		}
	}
	state.shouldDelete = NO;
	state.redraw = YES;
}


@end

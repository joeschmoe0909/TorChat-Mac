/*
<<<<<<< HEAD
 *  TCBuddiesController.m
 *
 *  Copyright 2014 Avérous Julien-Pierre
=======
 *  TCBuddiesWindowController.m
 *
 *  Copyright 2016 Avérous Julien-Pierre
>>>>>>> javerous/master
 *
 *  This file is part of TorChat.
 *
 *  TorChat is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  TorChat is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with TorChat.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

<<<<<<< HEAD

=======
>>>>>>> javerous/master
#import "TCBuddiesWindowController.h"

// -- Core --
#import "TCCoreManager.h"
#import "TCConfig.h"
#import "TCBuddy.h"
#import "TCImage.h"

// > Tools
#import "TCDebugLog.h"

// -- Interface --
// > Controllers
<<<<<<< HEAD
#import "TCBuddyInfoWindowController.h"
=======
#import "TCBuddyInfoWindowsController.h"
>>>>>>> javerous/master
#import "TCChatWindowController.h"
#import "TCFilesWindowController.h"

// > Cells
#import "TCBuddyCellView.h"

// > Views
#import "TCButton.h"
#import "TCDropButton.h"
#import "TCThreePartImageView.h"

// > Managers
#import "TCLogsManager.h"
#import "TCTorManager.h"

// > Components
#import "TCFilesCommon.h"

// > Categories
#import "TCInfo+Render.h"


<<<<<<< HEAD

=======
>>>>>>> javerous/master
/*
** TCBuddiesController - Private
*/
#pragma mark - TCBuddiesController - Private

<<<<<<< HEAD
@interface TCBuddiesWindowController () <TCCoreManagerDelegate, TCDropButtonDelegate, TCBuddyDelegate, TCChatWindowControllerDelegate>
=======
@interface TCBuddiesWindowController () <TCCoreManagerObserver, TCBuddyObserver, TCDropButtonDelegate, TCChatWindowControllerDelegate>
>>>>>>> javerous/master
{
	id <TCConfigInterface>	_configuration;
	TCCoreManager		*_control;
	
	dispatch_queue_t	_localQueue;
	dispatch_queue_t	_noticeQueue;

	NSMutableArray		*_buddies;
	id					_lastSelected;
	
	BOOL				_running;
	
	NSDictionary		*_infos;
<<<<<<< HEAD
=======
	
	TCBuddyInfoWindowsController *_infoWindowsController;
>>>>>>> javerous/master
}

// -- Properties --
@property (strong, nonatomic) IBOutlet NSProgressIndicator	*indicator;
@property (strong, nonatomic) IBOutlet NSTableView			*tableView;
@property (strong, nonatomic) IBOutlet NSPopUpButton		*imTitle;
@property (strong, nonatomic) IBOutlet NSButton				*imRemove;
@property (strong, nonatomic) IBOutlet NSPopUpButton		*imStatus;
@property (strong, nonatomic) IBOutlet NSImageView			*imStatusImage;
@property (strong, nonatomic) IBOutlet TCDropButton			*imAvatar;
@property (strong, nonatomic) IBOutlet TCThreePartImageView *barView;

@property (strong, nonatomic) IBOutlet NSWindow				*addWindow;
@property (strong, nonatomic) IBOutlet NSTextField			*addNameField;
@property (strong, nonatomic) IBOutlet NSTextField			*addAddressField;
@property (strong, nonatomic) IBOutlet NSTextView			*addNotesField;

@property (strong, nonatomic) IBOutlet NSWindow				*profileWindow;
@property (strong, nonatomic) IBOutlet NSTextField			*profileName;
@property (strong, nonatomic) IBOutlet NSTextView			*profileText;

// -- IBAction --
- (IBAction)doStatus:(id)sender;
- (IBAction)doAvatar:(id)sender;
- (IBAction)doTitle:(id)sender;


- (IBAction)doAddOk:(id)sender;
- (IBAction)doAddCancel:(id)sender;

- (IBAction)doProfileOk:(id)sender;
- (IBAction)doProfileCancel:(id)sender;

// -- Helpers --
- (void)updateStatusUI:(int)status;
- (void)updateTitleUI;

@end



/*
** TCBuddiesController
*/
#pragma mark - TCBuddiesController

@implementation TCBuddiesWindowController


/*
** TCBuddiesController - Constructor & Destuctor
*/
#pragma mark - TCBuddiesController - Constructor & Destuctor

+ (TCBuddiesWindowController *)sharedController
{
	static dispatch_once_t		pred;
	static TCBuddiesWindowController	*instance = nil;
		
	dispatch_once(&pred, ^{
		instance = [[TCBuddiesWindowController alloc] init];
	});
	
	return instance;
}

- (id)init
{
	self = [super initWithWindowNibName:@"BuddiesWindow"];
	
	if (self)
	{
		// Build an event dispatch queue
<<<<<<< HEAD
		_localQueue = dispatch_queue_create("com.torchat.cocoa.buddies.local", DISPATCH_QUEUE_SERIAL);
		_noticeQueue = dispatch_queue_create("com.torchat.cocoa.buddies.notice", DISPATCH_QUEUE_SERIAL);
=======
		_localQueue = dispatch_queue_create("com.torchat.app.buddies.local", DISPATCH_QUEUE_SERIAL);
		_noticeQueue = dispatch_queue_create("com.torchat.app.buddies.notice", DISPATCH_QUEUE_SERIAL);
>>>>>>> javerous/master

		// Build array of cocoa buddy
		_buddies = [[NSMutableArray alloc] init];
		
		// Observe file events
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileCancel:) name:TCFileCancelNotification object:nil];
	}
	
	return self;
}

- (void)dealloc
{
<<<<<<< HEAD
	TCDebugLog("TCBuddieController dealloc");
=======
	TCDebugLog(@"TCBuddieController dealloc");
>>>>>>> javerous/master
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidLoad
{
	// Place Window.
	[self.window center];
	[self.window setFrameAutosaveName:@"BuddiesWindow"];
	
	// Configure table view.
	[_tableView setTarget:self];
	[_tableView setDoubleAction:@selector(tableViewDoubleClick:)];
	
	// Configura bar.
	_barView.startCap = [NSImage imageNamed:@"bar"];
	_barView.centerFill = [NSImage imageNamed:@"bar"];
	_barView.endCap = [NSImage imageNamed:@"bar"];
}



/*
** TCBuddiesController - Running
*/
#pragma mark - TCBuddiesController - Running

<<<<<<< HEAD
- (void)startWithConfiguration:(id <TCConfigInterface>)configuration
{
	NSImage *avatar;
	
	if (!configuration)
=======
- (void)startWithConfiguration:(id <TCConfigInterface>)configuration coreManager:(TCCoreManager *)coreMananager
{
	if (!configuration || !coreMananager)
>>>>>>> javerous/master
	{
		NSBeep();
		[NSApp terminate:self];
		return;
	}
	
<<<<<<< HEAD
	if (_running)
		return;
	
	_running = YES;
	
	// Load window.
	[self window];
	
	// Hold the config
	_configuration = configuration;
	
	// Build controller
	_control = [[TCCoreManager alloc] initWithConfiguration:_configuration];
	
	// -- Init window content --
	// > Show load indicator
	[_indicator startAnimation:self];

	// > Init title
	[self updateTitleUI];
	
	// > Init status
	[self updateStatusUI:[_control status]];
	
	// > Init avatar
	avatar = [[_control profileAvatar] imageRepresentation];
	
	if ([[avatar representations] count] > 0)
		[_imAvatar setImage:avatar];
	else
	{
		NSImage *img = [NSImage imageNamed:NSImageNameUser];
		
		[img setSize:NSMakeSize(64, 64)];
		 
		[_imAvatar setImage:img];
	}
		
	// > Init table file drag
	[_tableView registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
	[_tableView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
	
	// > Redirect avatar drop
	[_imAvatar setDelegate:self];

	// Show the window
	[self showWindow:nil];
	
	// Init delegate
	_control.delegate = self;
	
	// Start the controller
	[_control start];
=======
	dispatch_async(dispatch_get_main_queue(), ^{
		
		if (_running)
			return;
		
		_running = YES;
		
		// Load window.
		[self window];
		
		// Hold the config & core.
		_configuration = configuration;
		_control = coreMananager;
		
		// -- Init window content --
		// > Show load indicator.
		[_indicator startAnimation:self];
		
		// > Init title.
		[self updateTitleUI];
		
		// > Init status
		[self updateStatusUI:[_control status]];
		
		// > Init avatar.
		NSImage *avatar = [[_control profileAvatar] imageRepresentation];
		
		if ([[avatar representations] count] > 0)
			[_imAvatar setImage:avatar];
		else
		{
			NSImage *img = [NSImage imageNamed:NSImageNameUser];
			
			[img setSize:NSMakeSize(64, 64)];
		 
			[_imAvatar setImage:img];
		}
		
		// > Init table file drag.
		[_tableView registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
		[_tableView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
		
		// > Redirect avatar drop.
		[_imAvatar setDelegate:self];
		
		// Create windows info controller.
		_infoWindowsController = [[TCBuddyInfoWindowsController alloc] initWithCoreManager:coreMananager];
		
		// Show the window.
		[self showWindow:nil];
		
		// Add ourself as observer.
		[_control addObserver:self];
		
		// Start the controller.
		[_control start];
	});
>>>>>>> javerous/master
}

- (void)stop
{
<<<<<<< HEAD
	if (!_running)
		return;
	
	// Clean buddies
	for (TCBuddy *buddy in _buddies)
	{
		buddy.delegate = nil;
		
		// Inform the info controller that we un-hold this buddy.
		dispatch_async(_noticeQueue, ^{
			[[NSNotificationCenter defaultCenter] postNotificationName:TCBuddiesWindowControllerRemovedBuddy object:self userInfo:@{ @"buddy" : buddy }];
		});
	}
	
	[_buddies removeAllObjects];
	[_tableView reloadData];
	
	// Clean controller
	if (_control)
	{
		_control.delegate = nil;
		
		[_control stop];
		
		_control = nil;
	}
	
	// Set status to offline
	[_imStatus selectItemWithTag:0];
	[self updateTitleUI];
	
	// Update status
	_running = NO;
}



/*
** TCBuddiesController - Blocked Buddies
*/
#pragma mark - TCBuddiesController - Blocked Buddies

- (BOOL)addBlockedBuddy:(NSString *)address
{
	// Add
	return [_control addBlockedBuddy:address];
}

- (BOOL)removeBlockedBuddy:(NSString *)address
{
	// Remove
	return [_control removeBlockedBuddy:address];
=======
	dispatch_async(dispatch_get_main_queue(), ^{
		
		if (!_running)
			return;
		
		// Clean buddies.
		for (TCBuddy *buddy in _buddies)
		{
			[buddy removeObserver:self];
			[_infoWindowsController closeInfoForBuddy:buddy];
		}
		
		[_buddies removeAllObjects];
		[_tableView reloadData];
		
		// Clean controller.
		if (_control)
		{
			[_control removeObserver:self];
			_control = nil;
		}
		
		// Set status to offline.
		[_imStatus selectItemWithTag:0];
		[self updateTitleUI];
		
		// Update status.
		_running = NO;
	});
>>>>>>> javerous/master
}



/*
** TCBuddiesController - TableView
*/
#pragma mark - TCBuddiesController - TableView

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return (NSInteger)[_buddies count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
	TCBuddyCellView	*cellView = nil;
	TCBuddy			*buddy = [_buddies objectAtIndex:(NSUInteger)rowIndex];
	NSString		*name = [buddy finalName];
	
	if ([name length] > 0)
		cellView = [tableView makeViewWithIdentifier:@"buddy_name" owner:self];
	else
		cellView = [tableView makeViewWithIdentifier:@"buddy_address" owner:self];
	
	[cellView setBuddy:buddy];
	
	return cellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	NSInteger	row = [_tableView selectedRow];
	
	[_imRemove setEnabled:(row >= 0)];

	// Hold current selection (not perfect).
	if (row >= 0 && row < [_buddies count])
		_lastSelected = [_buddies objectAtIndex:(NSUInteger)row];
	else
		_lastSelected = nil;
	
	// Notify.
	id obj = (row >= 0 ? [_buddies objectAtIndex:(NSUInteger)row] : [NSNull null]);
	
	dispatch_async(_noticeQueue, ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:TCBuddiesWindowControllerSelectChanged object:self userInfo:@{ TCBuddiesWindowControllerBuddyKey : obj }];
	});
}

- (void)tableViewDoubleClick:(id)sender
{
	NSInteger	row = [_tableView clickedRow];
	TCBuddy		*buddy;

	// Get the double-clicked button
	if (row < 0 || row >= [_buddies count])
		return;
	
	buddy = [_buddies objectAtIndex:(NSUInteger)row];
	
	// Open a chat window.
	[self startChatForBuddy:buddy select:YES];
}


- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{	
	if (operation == NSTableViewDropOn)
		return NSDragOperationMove;
	else
		return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
	if (row < 0 || row >= [_buddies count])
		return NO;
	
	TCBuddy			*buddy = [_buddies objectAtIndex:(NSUInteger)row];
	NSPasteboard	*pboard = [info draggingPasteboard];
	NSArray			*types = [pboard types];
	
	if ([types containsObject:NSFilenamesPboardType])
	{
		NSFileManager	*mng = [NSFileManager defaultManager];
		NSArray			*fileList = [pboard propertyListForType:NSFilenamesPboardType];

		for (NSString *fileName in fileList)
		{
			BOOL isDirectory = NO;
			
			if ([mng fileExistsAtPath:fileName isDirectory:&isDirectory])
			{
				if (isDirectory)
					continue;
				
				[buddy sendFile:fileName];
			}
		}
		
		return YES;
	}
	
	return NO;
}



/*
** TCBuddiesController - TCCoreManagerDelegate
*/
<<<<<<< HEAD
#pragma mark - TCBuddiesController - TCCoreManagerDelegate
=======
#pragma mark - TCBuddiesController - TCCoreManagerObserver
>>>>>>> javerous/master

- (void)torchatManager:(TCCoreManager *)manager information:(TCInfo *)info
{
	// Log the item
<<<<<<< HEAD
	[[TCLogsManager sharedManager] addGlobalLogEntry:[info render]];
=======
	[[TCLogsManager sharedManager] addGlobalLogWithInfo:info];
>>>>>>> javerous/master
	
	// Action information
	if (info.kind == TCInfoInfo)
	{
		switch ((TCCoreEvent)info.code)
		{
			case TCCoreEventStarted:
			{
				dispatch_async(dispatch_get_main_queue(), ^{
					[_indicator stopAnimation:self];
				});
				
				break;
			}
				
			case TCCoreEventStopped:
			{
				dispatch_async(dispatch_get_main_queue(), ^{
					[self updateStatusUI:-2];
				});
				
				break;
			}
				
			case TCCoreEventStatus:
			{
<<<<<<< HEAD
				TCStatus	status = (TCStatus)[(NSNumber *)info.context intValue];
=======
				TCStatus status = (TCStatus)[(NSNumber *)info.context intValue];
>>>>>>> javerous/master
				
				dispatch_async(dispatch_get_main_queue(), ^{
					[self updateStatusUI:status];
				});
				
				break;
			}
				
			case TCCoreEventProfileAvatar:
			{
				TCImage	*tcFinal = (TCImage *)info.context;
				NSImage	*final = [tcFinal imageRepresentation];
				
				if (!final)
					final = [NSImage imageNamed:NSImageNameUser];
				
				// Change image.
				dispatch_async(dispatch_get_main_queue(), ^{
					[_imAvatar setImage:final];
				});
				
				// Set the new avatar to the chat window.
				[[TCChatWindowController sharedController] setLocalAvatar:final forIdentifier:[_configuration selfAddress]];
				
<<<<<<< HEAD
				// Notify the change.
				dispatch_async(_noticeQueue, ^{
					[[NSNotificationCenter defaultCenter] postNotificationName:TCBuddiesWindowControllerAvatarChanged object:manager userInfo:@{ @"avatar" : final }];
				});
				
=======
>>>>>>> javerous/master
				break;
			}
				
			case TCCoreEventProfileName:
			{
<<<<<<< HEAD
				dispatch_async(dispatch_get_main_queue(), ^{
					// Update Title
=======
				// Update Title.
				dispatch_async(dispatch_get_main_queue(), ^{
>>>>>>> javerous/master
					[self updateTitleUI];
				});
				
				break;
			}
				
			case TCCoreEventProfileText:
				break;
				
			case TCCoreEventBuddyNew:
			{
				TCBuddy *buddy = (TCBuddy *)info.context;
				
<<<<<<< HEAD
				buddy.delegate = self;
=======
				[buddy addObserver:self];
>>>>>>> javerous/master
				
				dispatch_async(dispatch_get_main_queue(), ^{
					
					[_buddies addObject:buddy];
					
					[[TCChatWindowController sharedController] setLocalAvatar:[_imAvatar image] forIdentifier:[buddy address]];
					
<<<<<<< HEAD
					[self reloadBuddy:nil];
=======
					[self _reloadBuddy:nil];
>>>>>>> javerous/master
				});
				
				break;
			}
				
<<<<<<< HEAD
			case TCCoreEventClientStarted:
				break;
				
			case TCCoreEventClientStopped:
=======
			case TCCoreEventBuddyRemove:
			{
				TCBuddy *buddy = info.context;
				
				[buddy removeObserver:self];
				
				dispatch_async(dispatch_get_main_queue(), ^{
					[_buddies removeObjectIdenticalTo:buddy];
					[_tableView reloadData];
				});

				break;
			}
				
			case TCCoreEventBuddyBlocked:
			case TCCoreEventBuddyUnblocked:
			{
				TCBuddy *buddy = info.context;
				
				// Reload table.
				dispatch_async(dispatch_get_main_queue(), ^{
					[self _reloadBuddy:buddy];
				});
				
				break;
			}
				
			case TCCoreEventClientStarted:
			case TCCoreEventClientStopped:
			
>>>>>>> javerous/master
				break;
		}
	}
}



/*
<<<<<<< HEAD
** TCBuddiesController - TCBuddyDelegate
*/
#pragma mark - TCBuddiesController - TCBuddyDelegate

- (void)buddy:(TCBuddy *)aBuddy event:(const TCInfo *)info
{
	// Add the error in the error manager
	[[TCLogsManager sharedManager] addBuddyLogEntryFromAddress:[aBuddy address] name:[aBuddy finalName] andText:[info render]];
	
=======
** TCBuddiesController - TCBuddyObserver
*/
#pragma mark - TCBuddiesController - TCBuddyObserver

- (void)buddy:(TCBuddy *)aBuddy information:(TCInfo *)info
{
	// Add the info in the log manager.
	[[TCLogsManager sharedManager] addBuddyLogWithAddress:[aBuddy address] name:[aBuddy finalName] info:info];
	
	// Handle info.
>>>>>>> javerous/master
	dispatch_async(_localQueue, ^{
		
		if (info.kind == TCInfoInfo)
		{
			// Actions
			switch ((TCBuddyEvent)info.code)
			{
				case TCBuddyEventConnectedTor:
					break;
					
				case TCBuddyEventConnectedBuddy:
					break;
					
				case TCBuddyEventDisconnected:
				{
					// Rebuid buddy list.
					[self buddyStatusChanged];
					
					// Reload buddies table.
					dispatch_async(dispatch_get_main_queue(), ^{
<<<<<<< HEAD
						[self reloadBuddy:aBuddy];
					});
					
					// Notify.
					dispatch_async(_noticeQueue, ^{
						[[NSNotificationCenter defaultCenter] postNotificationName:TCCocoaBuddyChangedStatusNotification object:aBuddy userInfo:@{ @"status" : @(TCStatusOffline) }];
=======
						[self _reloadBuddy:aBuddy];
>>>>>>> javerous/master
					});
					
					break;
				}
					
				case TCBuddyEventIdentified:
					break;
					
				case TCBuddyEventStatus:
				{
<<<<<<< HEAD
					TCStatus  status = (TCStatus)[(NSNumber *)info.context intValue];
					NSString		*statusStr = @"";
=======
					TCStatus	status = (TCStatus)[(NSNumber *)info.context intValue];
					NSString	*statusStr = @"";
>>>>>>> javerous/master
					
					// Send status to chat window.
					switch (status)
					{
						case TCStatusOffline:
							statusStr = NSLocalizedString(@"bd_status_offline", @"");
							break;
							
						case TCStatusAvailable:
							statusStr = NSLocalizedString(@"bd_status_available", @"");
							break;
							
						case TCStatusAway:
							statusStr = NSLocalizedString(@"bd_status_away", @"");
							break;
							
						case TCStatusXA:
							statusStr = NSLocalizedString(@"bd_status_xa", @"");
							break;
					}
					
					[[TCChatWindowController sharedController] receiveStatus:statusStr forIdentifier:[aBuddy address]];
					
					// Reload buddies table.
					dispatch_async(dispatch_get_main_queue(), ^{
<<<<<<< HEAD
						[self reloadBuddy:aBuddy];
					});
					
					// Notify.
					dispatch_async(_noticeQueue, ^{
						[[NSNotificationCenter defaultCenter] postNotificationName:TCCocoaBuddyChangedStatusNotification object:aBuddy userInfo:@{ @"status" : info.context }];
					});
					
=======
						[self _reloadBuddy:aBuddy];
					});

>>>>>>> javerous/master
					break;
				}
					
				case TCBuddyEventProfileAvatar:
				{
					TCImage *tcAvatar = (TCImage *)info.context;
					NSImage *avatar = [tcAvatar imageRepresentation];
					
					if (!avatar)
						return;
					
					// Reload table.
					dispatch_async(dispatch_get_main_queue(), ^{
<<<<<<< HEAD
						[self reloadBuddy:aBuddy];
=======
						[self _reloadBuddy:aBuddy];
>>>>>>> javerous/master
					});
					
					// Set the new avatar to the chat window.
					[[TCChatWindowController sharedController] setRemoteAvatar:avatar forIdentifier:[aBuddy address]];
<<<<<<< HEAD
					
					// Notify of the new avatar.
					dispatch_async(_noticeQueue, ^{
						[[NSNotificationCenter defaultCenter] postNotificationName:TCCocoaBuddyChangedAvatarNotification object:aBuddy userInfo:@{ @"avatar" : avatar }];
					});
					
=======

>>>>>>> javerous/master
					break;
				}
					
				case TCBuddyEventProfileText:
<<<<<<< HEAD
				{
					NSString *text = info.context;
					
					if (!text)
						return;
					
					// Notify.
					dispatch_async(_noticeQueue, ^{
						[[NSNotificationCenter defaultCenter] postNotificationName:TCCocoaBuddyChangedTextNotification object:aBuddy userInfo:@{ @"text" : text }];
					});
					
					break;
				}
=======
					break;
>>>>>>> javerous/master
					
				case TCBuddyEventProfileName:
				{
					NSString *name = info.context;
					
					if (!name)
						return;
					
					// Reload table.
					dispatch_async(dispatch_get_main_queue(), ^{
<<<<<<< HEAD
						[self reloadBuddy:aBuddy];
					});
					
					// Notify.
					dispatch_async(_noticeQueue, ^{
						[[NSNotificationCenter defaultCenter] postNotificationName:TCCocoaBuddyChangedNameNotification object:aBuddy userInfo:@{ @"name" : name }];
=======
						[self _reloadBuddy:aBuddy];
>>>>>>> javerous/master
					});
					
					break;
				}
					
				case TCBuddyEventMessage:
				{
					TCChatWindowController *chatController = [TCChatWindowController sharedController];
					
					// Start a chat UI.
					[self startChatForBuddy:aBuddy select:NO];
					
					// Add the message.
					[chatController receiveMessage:info.context forIdentifier:[aBuddy address]];
					
					break;
				}
					
				case TCBuddyEventAlias:
				{
					NSString *alias =info.context;
					
					if (!alias)
						return;
					
					// Reload table.
					dispatch_async(dispatch_get_main_queue(), ^{
<<<<<<< HEAD
						[self reloadBuddy:aBuddy];
					});
					
					// Notify.
					dispatch_async(_noticeQueue, ^{
						[[NSNotificationCenter defaultCenter] postNotificationName:TCCocoaBuddyChangedAliasNotification object:aBuddy userInfo:@{ @"alias" : alias }];
=======
						[self _reloadBuddy:aBuddy];
>>>>>>> javerous/master
					});
					
					break;
				}
					
				case TCBuddyEventNotes:
					break;
					
<<<<<<< HEAD
				case TCBuddyEventBlocked:
				{
					NSNumber *blocked = info.context;
					
					if (!blocked)
						return;
					
					// Reload table.
					dispatch_async(dispatch_get_main_queue(), ^{
						[self reloadBuddy:aBuddy];
					});
					
					// Notify.
					dispatch_async(_noticeQueue, ^{
						[[NSNotificationCenter defaultCenter] postNotificationName:TCCocoaBuddyChangedBlockedNotification object:aBuddy userInfo:@{ @"blocked" : blocked }];
					});
					
					break;
				}
					
				case TCBuddyEventVersion:
				{
					NSString *version = info.context;
					
					if (!version)
						return;
					
					// Notify.
					dispatch_async(_noticeQueue, ^{
						[[NSNotificationCenter defaultCenter] postNotificationName:TCCocoaBuddyChangedPeerVersionNotification object:aBuddy userInfo:@{ @"version" : version }];
					});
					
					break;
				}
					
				case TCBuddyEventClient:
				{
					NSString *client = info.context;
					
					if (!client)
						return;
					
					// Notify.
					dispatch_async(_noticeQueue, ^{
						[[NSNotificationCenter defaultCenter] postNotificationName:TCCocoaBuddyChangedPeerClientNotification object:self userInfo:@{ @"client" : client }];
					});
					
					break;
				}
=======
				case TCBuddyEventVersion:
					break;
					
				case TCBuddyEventClient:
					break;
>>>>>>> javerous/master
					
				case TCBuddyEventFileSendStart:
				{
					TCFileInfo *finfo = (TCFileInfo *)info.context;
					
					if (!finfo)
						return;
					
					// Add the file transfert to the controller
					[[TCFilesWindowController sharedController] startFileTransfert:[finfo uuid] withFilePath:[finfo filePath] buddyAddress:[aBuddy address] buddyName:[aBuddy finalName] transfertWay:tcfile_upload fileSize:[finfo fileSizeTotal]];
					
					break;
				}
					
				case TCBuddyEventFileSendRunning:
				{
					TCFileInfo *finfo = (TCFileInfo *)info.context;
					
					if (!finfo)
						return;
					
					// Update bytes received
					[[TCFilesWindowController sharedController] setCompleted:[finfo fileSizeCompleted] forFileTransfert:[finfo uuid] withWay:tcfile_upload];
					
					break;
				}
					
				case TCBuddyEventFileSendFinish:
				{
					TCFileInfo *finfo = (TCFileInfo *)info.context;
					
					if (!finfo)
						return;
					
					// Update status
					[[TCFilesWindowController sharedController] setStatus:tcfile_status_finish andTextStatus:NSLocalizedString(@"file_upload_done", @"") forFileTransfert:[finfo uuid] withWay:tcfile_upload];
					
					break;
				}
					
				case TCBuddyEventFileSendStopped:
				{
					TCFileInfo *finfo = (TCFileInfo *)info.context;
					
					if (!finfo)
						return;
					
					// Update status
					[[TCFilesWindowController sharedController] setStatus:tcfile_status_stopped andTextStatus:NSLocalizedString(@"file_upload_stopped", @"") forFileTransfert:[finfo uuid] withWay:tcfile_upload];
					
					break;
				}
					
				case TCBuddyEventFileReceiveStart:
				{
					TCFileInfo *finfo = (TCFileInfo *)info.context;
					
					if (!finfo)
						return;
					
					// Add the file transfert to the controller
					[[TCFilesWindowController sharedController] startFileTransfert:[finfo uuid] withFilePath:[finfo filePath] buddyAddress:[aBuddy address] buddyName:[aBuddy finalName] transfertWay:tcfile_download fileSize:[finfo fileSizeTotal]];
					
					break;
				}
					
				case TCBuddyEventFileReceiveRunning:
				{
					TCFileInfo *finfo = (TCFileInfo *)info.context;
					
					if (!finfo)
						return;
					
					// Update bytes received
					[[TCFilesWindowController sharedController] setCompleted:[finfo fileSizeCompleted] forFileTransfert:[finfo uuid] withWay:tcfile_download];
					
					break;
				}
					
				case TCBuddyEventFileReceiveFinish:
				{
					TCFileInfo *finfo = (TCFileInfo *)info.context;
					
					if (!finfo)
						return;
					
					// Update status
					[[TCFilesWindowController sharedController] setStatus:tcfile_status_finish andTextStatus:NSLocalizedString(@"file_download_done", @"") forFileTransfert:[finfo uuid] withWay:tcfile_download];
					
					break;
				}
					
				case TCBuddyEventFileReceiveStopped:
				{
					TCFileInfo *finfo = (TCFileInfo *)info.context;
					
					if (!finfo)
						return;
					
					// Update status
					[[TCFilesWindowController sharedController] setStatus:tcfile_status_stopped andTextStatus:NSLocalizedString(@"file_download_stopped", @"") forFileTransfert:[finfo uuid] withWay:tcfile_download];
					
					break;
				}
			}
		}
		else if (info.kind == TCInfoError)
		{
			switch ((TCBuddyError)info.code)
			{
					
				case TCBuddyErrorResolveTor:
					break;
					
				case TCBuddyErrorConnectTor:
					break;
					
				case TCBuddyErrorSocket:
					break;
					
				case TCBuddyErrorSocks:
				case TCBuddyErrorSocksRequest:
					break;
					
				case TCBuddyErrorMessageOffline:
				{
					NSString	*key = NSLocalizedString(@"bd_error_offline", "");
					NSString	*message = info.context;
					NSString	*full;
					
					if (message)
						full = [[NSString alloc] initWithFormat:key, message];
					else
						full = [[NSString alloc] initWithFormat:key, @"-"];
					
					// Add the error
					[[TCChatWindowController sharedController] receiveError:full forIdentifier:[aBuddy address]];
					
					break;
				}
					
				case TCBuddyErrorMessageBlocked:
				{
					NSString	*key = NSLocalizedString(@"bd_error_blocked", "");
					NSString	*message = (NSString *)info.context;
					NSString	*full;
					
					if (message)
						full = [[NSString alloc] initWithFormat:key, message];
					else
						full = [[NSString alloc] initWithFormat:key, @"-"];
					
					// Add the error
					[[TCChatWindowController sharedController] receiveError:full forIdentifier:[aBuddy address]];
					
					break;
				}
					
				case TCBuddyErrorSendFile:
					break;
					
				case TCBuddyErrorReceiveFile:
					break;
					
				case TCBuddyErrorFileOffline:
					break;
					
				case TCBuddyErrorFileBlocked:
					break;
					
				case TCBuddyErrorParse:
					break;
			}
		}
	});
}



/*
** TCBuddiesController - TCDropButtonDelegate
*/
#pragma mark - TCBuddiesController - TCDropButtonDelegate

- (void)dropButton:(TCDropButton *)button doppedImage:(NSImage *)avatar
{
	if (!avatar)
		return;
	
	TCImage *image = [[TCImage alloc] initWithImage:avatar];
	
	[_control setProfileAvatar:image];
}



/*
** TCBuddiesController - TCDropButtonDelegate
*/
#pragma mark - TCBuddiesController - TCDropButtonDelegate

- (void)chatSendMessage:(NSString *)message identifier:(NSString *)identifier context:(id)context
{
	TCBuddy *buddy = context;
	
	if (!buddy || !message)
		return;
	
	[buddy sendMessage:message];
}



/*
** TCBuddiesController - Notifications
*/
#pragma mark - TCBuddiesController - Notifications

- (void)fileCancel:(NSNotification *)notice
{
	NSDictionary	*info = [notice userInfo];
	NSString		*uuid = [info objectForKey:@"uuid"];
	NSString		*address = [info objectForKey:@"address"];
	tcfile_way		way = (tcfile_way)[[info objectForKey:@"way"] intValue];
	
	// Search the buddy associated with this transfert
	for (TCBuddy *buddy in _buddies)
	{
		if ([[buddy address] isEqualToString:address])
		{
			// Change the file status
			[[TCFilesWindowController sharedController] setStatus:tcfile_status_cancel andTextStatus:NSLocalizedString(@"file_canceling", @"") forFileTransfert:uuid withWay:way];
			
			// Canceling the transfert
			if (way == tcfile_upload)
				[buddy fileCancelOfUUID:uuid way:TCBuddyFileSend];
			else if (way == tcfile_download)
				[buddy fileCancelOfUUID:uuid way:TCBuddyFileReceive];
			
			return;
		}
	}
}



/*
** TCBuddiesController - IBAction
*/
#pragma mark - TCBuddiesController - IBAction

- (IBAction)doStatus:(id)sender
{
	// Change status
	switch ([_imStatus selectedTag])
	{
		case 0:
			[_control stop];
			[self updateStatusUI:-2];
			break;
			
		case 1:
			[_control setStatus:TCStatusAvailable];
			break;
			
		case 2:
			[_control setStatus:TCStatusAway];
			break;
			
		case 3:
			[_control setStatus:TCStatusXA];
			break;
	}
}

- (IBAction)doAvatar:(id)sender
{
	// Show dialog to select files to send
	NSOpenPanel	*openDlg = [NSOpenPanel openPanel];
	
	// Ask for a file
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg setCanCreateDirectories:NO];
	[openDlg setAllowsMultipleSelection:NO];
	[openDlg setAllowedFileTypes:[NSImage imageFileTypes]];
	
	if ([openDlg runModal] == NSOKButton)
	{
		NSArray	*urls = [openDlg URLs];
		NSImage *avatar = [[NSImage alloc] initWithContentsOfURL:[urls objectAtIndex:0]];

		[self dropButton:nil doppedImage:avatar];
	}
}

- (IBAction)doTitle:(id)sender
{
	NSMenuItem	*selected = [_imTitle selectedItem];
	NSInteger	tag = [selected tag];
	
	if (!selected)
	{
		NSBeep();
		return;
	}
	
	switch (tag)
	{
		case 0:
			[_configuration setModeTitle:TCConfigTitleName];
			break;
			
		case 1:
			[_configuration setModeTitle:TCConfigTitleAddress];
			break;
			
		case 3:
			[self doEditProfile:sender];			
			break;
	}
	
	[self updateTitleUI];
}

<<<<<<< HEAD
=======
- (IBAction)doShowInfo:(id)sender
{
	// Get selected buddy.
	TCBuddy *buddy = [self selectedBuddy];
	
	if (!buddy)
	{
		NSBeep();
		return;
	}
	
	// Show.
	[_infoWindowsController showInfoForBuddy:buddy];
}

>>>>>>> javerous/master
- (IBAction)doRemove:(id)sender
{
	NSInteger	row = [_tableView selectedRow];
	TCBuddy		*buddy;
	NSString	*address;
	
	if (row < 0 || row >= [_buddies count])
		return;
	
<<<<<<< HEAD
	// Get the buddy address
	buddy = [_buddies objectAtIndex:(NSUInteger)row];
	address = [buddy address];
	
	// Inform the info controller that we are removing this buddy
	dispatch_async(_noticeQueue, ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:TCBuddiesWindowControllerRemovedBuddy object:self userInfo:@{ @"buddy" : buddy }];
	});
	
	// Remove the buddy from interface side
	buddy.delegate = nil;
	[_buddies removeObjectAtIndex:(NSUInteger)row];
	[_tableView reloadData];
	
	// Remove the buddy from the controller
=======
	// Get the buddy address.
	buddy = [_buddies objectAtIndex:(NSUInteger)row];
	address = [buddy address];

	// Remove the buddy from the controller.
>>>>>>> javerous/master
	[_control removeBuddy:address];
}

- (IBAction)doAdd:(id)sender
{
	[_addNameField setStringValue:@""];
	[_addAddressField setStringValue:@""];
	[[[_addNotesField textStorage] mutableString] setString:@""];
	
	[_addNameField becomeFirstResponder];
	
	[_addWindow center];
	[_addWindow makeKeyAndOrderFront:sender];
}

- (IBAction)doChat:(id)sender
{
	NSInteger	row = [_tableView selectedRow];
	TCBuddy		*buddy;
	
	if (row < 0 || row >= [_buddies count])
		return;

	buddy = [_buddies objectAtIndex:(NSUInteger)row];
	
	[self startChatForBuddy:buddy select:YES];
}

- (IBAction)doSendFile:(id)sender
{
	NSInteger	row = [_tableView selectedRow];
	TCBuddy		*buddy;
	
	if (row < 0 || row >= [_buddies count])
		return;
	
	buddy = [_buddies objectAtIndex:(NSUInteger)row];
	
	// Show dialog to select files to send
	NSOpenPanel	*openDlg = [NSOpenPanel openPanel];
	
	// Ask for a file
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg setCanCreateDirectories:NO];
	[openDlg setAllowsMultipleSelection:YES];
	
	if ([openDlg runModal] == NSOKButton)
	{
		NSArray *urls = [openDlg URLs];

		for (NSURL *url in urls)
			[buddy sendFile:[url path]];
	}
}

- (IBAction)doToggleBlock:(id)sender
{
	NSInteger	row = [_tableView selectedRow];
	TCBuddy		*buddy;
	
	if (row < 0 || row >= [_buddies count])
		return;
	
	buddy = [_buddies objectAtIndex:(NSUInteger)row];
		
	if ([buddy blocked])
		[_control removeBlockedBuddy:[buddy address]];
	else
		[_control addBlockedBuddy:[buddy address]];
}

- (IBAction)doEditProfile:(id)sender
{
	NSString *tname = [_control profileName];
	NSString *ttext = [_control profileText];
	
	[_profileName setStringValue:tname];
	[[[_profileText textStorage] mutableString] setString:ttext];
	
	[NSApp beginSheet:_profileWindow modalForWindow:self.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
}

- (IBAction)doAddOk:(id)sender
{
	NSString *notes = [[_addNotesField textStorage] mutableString];

	// Add the buddy to the controller. Notification will add it on our interface.
	[_control addBuddy:[_addNameField stringValue] address:[_addAddressField stringValue] comment:notes];
	
	[_addWindow orderOut:self];
}

- (IBAction)doAddCancel:(id)sender
{
	[_addWindow orderOut:self];
}

- (IBAction)doProfileOk:(id)sender
{
	[NSApp endSheet:_profileWindow];
	[_profileWindow orderOut:self];
	
	// -- Hold name --
	NSString *name = [_profileName stringValue];
	
	[_control setProfileName:name];
	
<<<<<<< HEAD
	dispatch_async(_noticeQueue, ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:TCBuddiesWindowControllerNameChanged object:self userInfo:@{ @"name" : name }];
	});
	
=======
>>>>>>> javerous/master
	// -- Hold text --
	NSString *text = [[_profileText textStorage] mutableString];
	
	[_control setProfileText:text];
<<<<<<< HEAD
	
	dispatch_async(_noticeQueue, ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:TCBuddiesWindowControllerTextChanged object:self userInfo:@{ @"text" : text }];
	});
=======
>>>>>>> javerous/master
}

- (IBAction)doProfileCancel:(id)sender
{
	[NSApp endSheet:_profileWindow];
	[_profileWindow orderOut:self];
}



/*
** TCBuddiesController - Tools
*/
#pragma mark - TCBuddiesController - Tools

- (void)buddyStatusChanged
{
	dispatch_async(dispatch_get_main_queue(), ^{

		// Sort buddies by status
		NSUInteger		i, cnt = [_buddies count];
		NSMutableArray	*temp_off = [[NSMutableArray alloc] initWithCapacity:cnt];
		NSMutableArray	*temp_av = [[NSMutableArray alloc] initWithCapacity:cnt];
		NSMutableArray	*temp_aw = [[NSMutableArray alloc] initWithCapacity:cnt];
		NSMutableArray	*temp_xa = [[NSMutableArray alloc] initWithCapacity:cnt];
		
		for (i = 0; i < cnt; i++)
		{
			TCBuddy *buddy = [_buddies objectAtIndex:i];
			
			switch ([buddy status])
			{
				case TCStatusOffline:
					[temp_off addObject:buddy];
					break;
					
				case TCStatusAvailable:
					[temp_av addObject:buddy];
					break;
					
				case TCStatusAway:
					[temp_aw addObject:buddy];
					break;
					
				case TCStatusXA:
					[temp_xa addObject:buddy];
					break;
			}
		}
		
		[_buddies removeAllObjects];
		
		[_buddies addObjectsFromArray:temp_av];
		[_buddies addObjectsFromArray:temp_aw];
		[_buddies addObjectsFromArray:temp_xa];
		[_buddies addObjectsFromArray:temp_off];
		
		// Reload table
<<<<<<< HEAD
		[self reloadBuddy:nil];
=======
		[self _reloadBuddy:nil];
>>>>>>> javerous/master
	});
}

- (void)startChatForBuddy:(TCBuddy *)buddy select:(BOOL)select
{
	if (!buddy)
		return;
	
	TCChatWindowController	*chatCtrl = [TCChatWindowController sharedController];
<<<<<<< HEAD
	NSString				*identifier;
	
	identifier = [buddy address];
=======
	NSString				*address = [buddy address];
>>>>>>> javerous/master
	
	// Start chat.
	TCImage *tcImage = [buddy profileAvatar];
	NSImage	*image = [tcImage imageRepresentation];
	
	if (!image)
		image = [NSImage imageNamed:NSImageNameUser];
	
<<<<<<< HEAD
	[chatCtrl startChatWithIdentifier:identifier name:[buddy finalName] localAvatar:[_imAvatar image] remoteAvatar:image context:buddy delegate:self];
		
	// Select it.
	if (select)
		[chatCtrl selectChatWithIdentifier:identifier];
=======
	[chatCtrl startChatWithIdentifier:address name:[buddy finalName] localAvatar:[_imAvatar image] remoteAvatar:image context:buddy delegate:self];
		
	// Select it.
	if (select)
		[chatCtrl selectChatWithIdentifier:address];
>>>>>>> javerous/master
}

- (TCBuddy *)selectedBuddy
{
	NSInteger row = [_tableView selectedRow];
	
	if (row < 0 || row >= [_buddies count])
		return nil;
	
	return [_buddies objectAtIndex:(NSUInteger)row];
}

- (void)updateStatusUI:(int)status
{
	// Unselect old item
	for (NSMenuItem *item in [_imStatus itemArray])
		[item setState:NSOffState];
	
	// Select the new item
	NSInteger index = [_imStatus indexOfItemWithTag:status];
	
	if (index > -1)
	{
		NSMenuItem *select = [_imStatus itemAtIndex:index];
		NSMenuItem *title = [_imStatus itemAtIndex:0];
		
		[title setTitle:[select title]];
		[select setState:NSOnState];
		
		[_imStatusImage setImage:[select image]];
	}
}

- (void)updateTitleUI
{	
	NSString *content = @"-";
	
	if (_configuration)
	{
		// Check the title to show
		switch ([_configuration modeTitle])
		{
			case TCConfigTitleAddress:
			{
				content = [_configuration selfAddress];
				
				[[_imTitle itemAtIndex:[_imTitle indexOfItemWithTag:0]] setState:NSOffState];
				[[_imTitle itemAtIndex:[_imTitle indexOfItemWithTag:1]] setState:NSOnState];
				break;
			}
				
			case TCConfigTitleName:
			{
				content = [_control profileName];
				
				if ([content length] == 0)
					content = @"-";
								
				[[_imTitle itemAtIndex:[_imTitle indexOfItemWithTag:0]] setState:NSOnState];
				[[_imTitle itemAtIndex:[_imTitle indexOfItemWithTag:1]] setState:NSOffState];
				break;
			}
		}
	}
	else
	{
		[[_imTitle itemAtIndex:[_imTitle indexOfItemWithTag:0]] setState:NSOffState];
		[[_imTitle itemAtIndex:[_imTitle indexOfItemWithTag:1]] setState:NSOffState];
	}
	
	// Update popup-title
	[[_imTitle itemAtIndex:0] setTitle:content];
}

<<<<<<< HEAD
- (void)reloadBuddy:(TCBuddy *)buddy
{
=======
- (void)_reloadBuddy:(TCBuddy *)buddy
{
	// > main queue <
	
>>>>>>> javerous/master
	if (buddy)
	{
		NSUInteger index = [_buddies indexOfObjectIdenticalTo:buddy];
		
		if (index != NSNotFound)
			[_tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
		else
<<<<<<< HEAD
			[self reloadBuddy:nil];
=======
			[self _reloadBuddy:nil];
>>>>>>> javerous/master
	}
	else
	{
		NSInteger index = [_tableView selectedRow];
		
		[_tableView reloadData];
		
		if (index != NSNotFound)
			[_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:(NSUInteger)index] byExtendingSelection:NO];
	}
}

@end
/*
 * OpenClonk, http://www.openclonk.org
 *
 * Portions might be copyrighted by other authors who have contributed
 * to OpenClonk.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * See isc_license.txt for full license and disclaimer.
 *
 * "Clonk" is a registered trademark of Matthes Bender.
 * See clonk_trademark_license.txt for full license.
 */
 
#include <C4Include.h>
#include <C4DrawGL.h>
#include <C4Window.h>
#include <C4Version.h>
#include <C4Application.h>
#include <C4Rect.h>
#include <C4FullScreen.h>

#import <Appkit/AppKit.h>
#import <C4WindowController.h>
#import <C4DrawGLMac.h>

#ifdef USE_COCOA

#define ctrler (this->objectiveCObject<C4WindowController>())

C4Window::C4Window ():
	Active(false),
	pSurface(0)
{}

C4Window::~C4Window () {}

static NSString* windowXibNameForWindowKind(C4Window::WindowKind kind)
{
	switch (kind)
	{
	case C4Window::W_GuiWindow:
	case C4Window::W_Console:
		return @"EditorGUIWindow";
	case C4Window::W_Fullscreen:
		return @"FullScreen";
	case C4Window::W_Viewport:
		return @"EditorViewport";
	default:
		return nil;
	}
}

C4Window * C4Window::Init(C4Window::WindowKind windowKind, C4AbstractApp * pApp, const char * Title, const C4Rect * size)
{
	Active = true;

	// Create window
	C4WindowController* controller = [C4WindowController new];
	setObjectiveCObject(controller);
	[NSBundle loadNibNamed:windowXibNameForWindowKind(windowKind) owner:controller];
	[controller setStdWindow:this];
	if (windowKind != W_GuiWindow && windowKind != W_Console)
	{
		if (lionAndBeyond())
			[controller.window setCollectionBehavior:[controller.window collectionBehavior] | NSWindowCollectionBehaviorFullScreenPrimary];
	}
	SetTitle(Title);
	return this;
}

void C4Window::Clear()
{
	// Destroy window
	C4WindowController* controller = ctrler;
	if (controller)
	{
		[controller.openGLView setNeedsDisplay:NO];
		[controller.openGLView removeFromSuperview];
		[controller setStdWindow:NULL];
		[controller close];
		setObjectiveCObject(nil);
	}
}

bool C4Window::StorePosition(const char *szWindowName, const char *szSubKey, bool fStoreSize)
{
	[ctrler setWindowFrameAutosaveName:[NSString stringWithFormat:@"%s_%s", szWindowName, szSubKey]];
	return true;
}

bool C4Window::RestorePosition(const char *szWindowName, const char *szSubKey, bool fHidden)
{
	StorePosition(szWindowName, szSubKey, true);
	if (fHidden)
		[ctrler.window orderOut:ctrler];
	else
		[ctrler.window orderFront:ctrler];
	return true;
}

void C4Window::SetTitle(const char *szToTitle)
{
	C4WindowController* controller;
	if ((controller = ctrler) && controller.window)
		[controller.window setTitle:[NSString stringWithUTF8String:szToTitle ? szToTitle : ""]];
}

bool C4Window::GetSize(C4Rect * pRect)
{
	if (this == &::FullScreen)
	{
		pRect->x = 0;
		pRect->y = 0;
		pRect->Wdt = ActualFullscreenX;
		pRect->Hgt = ActualFullscreenY;
	}
	else
	{
		C4WindowController* controller = ctrler;
		NSView* view = controller.openGLView ? controller.openGLView : controller.window.contentView;
		NSRect r = [view frame];
		pRect->x = 0;
		pRect->y = 0;
		pRect->Wdt = r.size.width;
		pRect->Hgt = r.size.height;
	}
	return true;
}

void C4Window::SetSize(unsigned int cx, unsigned int cy)
{
	C4WindowController* controller = ctrler;
	[controller setContentSize:NSMakeSize(cx, cy)];
}

void C4Window::RequestUpdate()
{
	[ctrler.openGLView display];
}

bool C4Window::ReInit(C4AbstractApp* pApp)
{
	return true;
}

C4KeyCode K_SHIFT_L = 56 + CocoaKeycodeOffset;
C4KeyCode K_SHIFT_R = 60 + CocoaKeycodeOffset;
C4KeyCode K_ALT_L = 58 + CocoaKeycodeOffset;
C4KeyCode K_ALT_R = 61 + CocoaKeycodeOffset;
C4KeyCode K_F1 = 122 + CocoaKeycodeOffset;
C4KeyCode K_F2 = 120 + CocoaKeycodeOffset;
C4KeyCode K_F3 = 99 + CocoaKeycodeOffset;
C4KeyCode K_F4 = 118 + CocoaKeycodeOffset;
C4KeyCode K_F5 = 96 + CocoaKeycodeOffset;
C4KeyCode K_F6 = 97 + CocoaKeycodeOffset;
C4KeyCode K_F7 = 98 + CocoaKeycodeOffset;
C4KeyCode K_F8 = 100 + CocoaKeycodeOffset;
C4KeyCode K_F9 = 101 + CocoaKeycodeOffset;
C4KeyCode K_F10 = 109 + CocoaKeycodeOffset;
C4KeyCode K_F11 = 103 + CocoaKeycodeOffset;
C4KeyCode K_F12 = 111 + CocoaKeycodeOffset;
C4KeyCode K_ADD = 69 + CocoaKeycodeOffset;
C4KeyCode K_SUBTRACT = 78 + CocoaKeycodeOffset;
C4KeyCode K_MULTIPLY = 67 + CocoaKeycodeOffset;
C4KeyCode K_ESCAPE = 53 + CocoaKeycodeOffset;
C4KeyCode K_PAUSE = NSPauseFunctionKey + CocoaKeycodeOffset;
C4KeyCode K_TAB = 48 + CocoaKeycodeOffset;
C4KeyCode K_RETURN = 36 + CocoaKeycodeOffset;
C4KeyCode K_DELETE = 117 + CocoaKeycodeOffset;
C4KeyCode K_INSERT = 125125125 + CocoaKeycodeOffset;
C4KeyCode K_BACK = 51 + CocoaKeycodeOffset;
C4KeyCode K_SPACE = 49 + CocoaKeycodeOffset;
C4KeyCode K_UP = 126 + CocoaKeycodeOffset;
C4KeyCode K_DOWN = 125 + CocoaKeycodeOffset;
C4KeyCode K_LEFT = 123 + CocoaKeycodeOffset;
C4KeyCode K_RIGHT = 124 + CocoaKeycodeOffset;
C4KeyCode K_HOME = 115 + CocoaKeycodeOffset;
C4KeyCode K_END = 119 + CocoaKeycodeOffset;
C4KeyCode K_SCROLL = 1000 + CocoaKeycodeOffset;
C4KeyCode K_MENU = 1000 + CocoaKeycodeOffset;
C4KeyCode K_PAGEUP = 116 + CocoaKeycodeOffset;
C4KeyCode K_PAGEDOWN = 121 + CocoaKeycodeOffset;
C4KeyCode K_M = 46 + CocoaKeycodeOffset;
C4KeyCode K_T = 17 + CocoaKeycodeOffset;
C4KeyCode K_W = 13 + CocoaKeycodeOffset;
C4KeyCode K_I = 34 + CocoaKeycodeOffset;
C4KeyCode K_C = 8 + CocoaKeycodeOffset;
C4KeyCode K_V = 9 + CocoaKeycodeOffset;
C4KeyCode K_X = 7 + CocoaKeycodeOffset;
C4KeyCode K_A = 0 + CocoaKeycodeOffset;
int MK_SHIFT = NSShiftKeyMask;
int MK_CONTROL = NSControlKeyMask;
int MK_ALT = NSAlternateKeyMask;

#endif
//
// XPCOM native widget Cocoa implementation class
//
// $Id: XPCNativeWidgetCocoa.cpp,v 1.14 2010/12/07 14:14:31 rishitani Exp $
//

#define TESTING_XXX

#ifndef TESTING_XXX
#include <common.h>
#endif

#include "XPCNativeWidgetCocoa.hpp"

#include <prlog.h>
#include <nsDebug.h>

#include <nsCOMPtr.h>
#include <nsIRunnable.h>
#include <nsThreadUtils.h>

#import <AppKit/AppKit.h>
#import <OpenGL/gl.h>
#import <OpenGL/glext.h>
#import <OpenGL/glu.h>

#ifndef TESTING_XXX
#include <sysdep/CglView.hpp>
#include <sysdep/CglDisplayContext.hpp>
#include <qsys/InDevEvent.hpp>
#endif

#include "NSOglMolView.hpp"

// using gfx::DisplayContext;
// using sysdep::CglDisplayContext;

XPCNativeWidgetCocoa::XPCNativeWidgetCocoa()
{
  m_bRealTimeDrag = false;
  m_bScrollEndPending = false;
  m_bValidSizeSet = false;

  mParentView=NULL;
  mView=NULL;
  // m_pCglView = NULL;
  printf("XPCNativeWidgetCocoa ctor called.\n");
}

XPCNativeWidgetCocoa::~XPCNativeWidgetCocoa()
{
  printf("XPCNativeWidgetCocoa dtor called.\n");
}

//////////

nsresult XPCNativeWidgetCocoa::setupImpl(nativeWindow widget)
{
  //mParentView = (void *)(widget->GetNativeData(NS_NATIVE_WIDGET));
  mParentView = widget;
  NS_ENSURE_TRUE(mParentView != NULL, NS_ERROR_FAILURE);

  NSView *parView = (NSView *) mParentView;
  printf("XPCNativeWidgetCocoa::setupImpl ParentView: %p\n", parView);
  printf("ParentView.subviews count: %d\n", parView.subviews.count);
  //id sibling = [[parView subviews] objectAtInde: 0]
    
  int width = getWidth(), height=getHeight();
  if (width<0) width = 100;
  if (height<0) height = 100;
  NSRect rect = NSMakeRect(0,0,width,height);

  // Create NSOglMolView object (defined in NSOglMolView.hpp)
  NSOglMolView *view = [NSOglMolView alloc];
  [view initWithFrameAndOwner: rect owner: this];

  // NSView *view = [NSButton alloc];
  // [view initWithFrame: rect];
  
  printf("NSView created: %p (%d, %d)\n", view, width, height);
  
  [parView addSubview: view];

  [view setParentView: parView];

  // [view setAcceptsTouchEvents: YES];
  // printf(" superview: %p\n", [view superview]);
  // printf(" nextresponder: %p\n", [view nextResponder]);
  
  mView = view;
  
  return NS_OK;
}

nsresult XPCNativeWidgetCocoa::attachImpl()
{
  return NS_OK;
}

NS_IMETHODIMP XPCNativeWidgetCocoa::Unload()
{
  XPCNativeWidget::Unload();

  if (mView) {
    NSView *view = (NSView *) mView;
    [view removeFromSuperviewWithoutNeedingDisplay];
    mView=NULL;
  }

  mParentView = NULL;
  //MB_DPRINT("!! XPCNativeWidgetCocoa::Unload called.\n");

  return NS_OK;
}

NS_IMETHODIMP XPCNativeWidgetCocoa::Resize(PRInt32 x, PRInt32 y, PRInt32 width, PRInt32 height)
{
  NS_ENSURE_TRUE(mView, NS_ERROR_FAILURE);
  printf("XPCNativeWidgetCocoa> resize W,H= %d,%d\n", width, height);

  NSView *view = (NSView *) mView;
  NSView *parView = [view superview];

  int ph = [parView frame].size.height;
  printf("XPCNativeWidgetCocoa> parent Height= %d\n", ph);
  int y2 =  ph - (y+height);
  printf("XPCNativeWidgetCocoa> flipped y: %d\n", y2);

  NSRect rect = NSMakeRect(x,y2,width,height);
  [view setFrame: rect];
  m_bValidSizeSet = true;

  setSize(width, height);

  printf("superview: %p\n", parView);
  printf("parView: %p\n", mParentView);
  printf("view: %p\n", mView);
  printf("view.frame.size.width: %f\n", view.frame.size.width);
  printf("view.frame.size.height: %f\n", view.frame.size.height);
  printf("--> ParentView.subviews count: %d\n", parView.subviews.count);
  for (int i=0; i<parView.subviews.count; ++i) {
    NSView *pv = parView.subviews[i];
    printf("  %d: %p\n", i, pv);
  }
  return NS_OK;
}

/* void show (); */
NS_IMETHODIMP XPCNativeWidgetCocoa::Show()
{
  printf(">>> XPCNativeWindowCocoa::Show() called\n");

  NS_ENSURE_TRUE(mView, NS_ERROR_FAILURE);
  NSView *view = (NSView *) mView;
  if (!m_bValidSizeSet) {
    printf(">>> XPCNativeWindowCocoa::Show() called but valid size not set %d,%d\n", getWidth(), getHeight());
    return NS_OK;
  }
  [view setHidden: NO];

  printf(">>> XPCNativeWindowCocoa::Show() OK\n");
  return NS_OK;
}

/* void hide (); */
NS_IMETHODIMP XPCNativeWidgetCocoa::Hide()
{
  //NS_ENSURE_TRUE(mView, NS_ERROR_FAILURE);
  if (mView==NULL) return NS_OK;
  
  NSView *view = (NSView *) mView;
  [view setHidden: YES];
  // MB_DPRINTLN(">>> XPCNativeWindowCocoa::Hide() called");
  printf(">>> XPCNativeWindowCocoa::Hide() called\n");
  return NS_OK;
}

/* boolean reload (); */
NS_IMETHODIMP XPCNativeWidgetCocoa::Reload(bool *_retval )
{
  // LOG_DPRINT("XPCNativeWidgetCocoa::Reload NOT IMPLEMENTED!!");
  printf("XPCNativeWidgetCocoa::Reload NOT IMPLEMENTED!!\n");
  *_retval = PR_TRUE;
  return NS_OK;
}


//////////

void XPCNativeWidgetCocoa::checkScrollEndPending()
{
}

//////////

void XPCNativeWidgetCocoa::doRedrawGL()
{
}

void XPCNativeWidgetCocoa::scrollGesture(float deltaX, float deltaY)
{
}

void XPCNativeWidgetCocoa::pinchGesture(float deltaZ)
{
}

void XPCNativeWidgetCocoa::rotateGesture(float rot)
{
}

void XPCNativeWidgetCocoa::swipeGesture(float deltaX, float deltaY)
{
}


/* attribute boolean useRbtnEmul; */
NS_IMETHODIMP XPCNativeWidgetCocoa::GetUseRbtnEmul(bool *aUseRbtnEmul)
{
  return NS_OK;
}

NS_IMETHODIMP XPCNativeWidgetCocoa::SetUseRbtnEmul(bool aUseRbtnEmul)
{
  return NS_OK;
}

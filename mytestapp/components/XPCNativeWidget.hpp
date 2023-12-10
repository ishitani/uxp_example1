//
// XPCOM native window/widget super class
//
// $Id: XPCNativeWidget.hpp,v 1.5 2010/10/20 15:29:46 rishitani Exp $
//

#ifndef XPC_NATIVE_WIDGET_HPP
#define XPC_NATIVE_WIDGET_HPP

#include "xpcom.hpp"

#include <nsCOMPtr.h>
#include <nsITimer.h>
#include <nsIDOMEventListener.h>
#include <nsIBaseWindow.h>
#include "qINativeWidget.h"

#ifndef TESTING_XXX
#include <qsys/View.hpp>
#include <sysdep/MouseEventHandler.hpp>
#endif

#ifndef TESTING_XXX
namespace qsys { class InDevEvent; }
#endif

namespace xpcom {

  class XPCNativeWidget : public qINativeWidget
  {
  private:

  protected:
    virtual ~XPCNativeWidget();

  public:
    XPCNativeWidget();

  public:
    NS_DECL_ISUPPORTS;

     NS_IMETHOD Setup(nsIDocShell *docShell, nsIBaseWindow *arg);
     NS_IMETHOD Load(PRInt32 scid, PRInt32 vwid);
     NS_IMETHOD Unload(void);
     NS_IMETHOD Reload(bool *_retval );

     NS_IMETHOD GetUseGlShader(bool *);
     NS_IMETHOD SetUseGlShader(bool);

     NS_IMETHOD GetUseMultiPad(bool *aUseMultiPad);
     NS_IMETHOD SetUseMultiPad(bool aUseMultiPad);

     NS_IMETHOD GetUseRbtnEmul(bool *aUseRbtnEmul);
     NS_IMETHOD SetUseRbtnEmul(bool aUseRbtnEmul);

    /* attribute boolean useHiDPI; */
     NS_IMETHOD GetUseHiDPI(bool *aUseHiDPI);
     NS_IMETHOD SetUseHiDPI(bool aUseHiDPI);

     NS_IMETHOD GetSceneID(PRInt32 *aSceneID);
     NS_IMETHOD SetSceneID(PRInt32 aSceneID);
     NS_IMETHOD GetViewID(PRInt32 *aViewID);
     NS_IMETHOD SetViewID(PRInt32 aViewID);

     NS_IMETHOD HandleEvent(nsIDOMEvent* aEvent);
    
  public:
    virtual nsresult setupImpl(nativeWindow widget) =0;
    virtual nsresult attachImpl() =0;

    static const int DBCLK_TIMER = 500;
    
    enum {
      DME_MOUSE_DOWN = 0,
      DME_MOUSE_MOVE = 1,
      DME_MOUSE_UP = 2,
      DME_WHEEL = 3,
      DME_DBCHK_TIMEUP = 4
    };

#ifndef TESTING_XXX
    virtual void dispatchMouseEvent(int nType, qsys::InDevEvent &ev);
    qsys::ViewPtr getQmView() const { return m_rQmView; }
#endif

    void setSize(int w, int h) { mWidth = w; mHeight = h;}
    int getWidth() const { return mWidth; }
    int getHeight() const { return mHeight; }

    void resetCursor();

    bool useMultiTouchPad() const { return m_bUseMultiPad; }

    static void timerCallbackFunc(nsITimer *aTimer, void *aClosure);
    

  protected:
    nsCOMPtr<nsIBaseWindow> mBaseWin;
    nsCOMPtr<nsIDocShell> mDocShell;

    int mWidth, mHeight;
    int mPosX, mPosY;

    int m_nSceneID, m_nViewID;

#ifndef TESTING_XXX
    qsys::ViewPtr m_rQmView;
    sysdep::MouseEventHandler m_meh;
    void setupFromDOMEvent(nsIDOMEvent* aEvent, bool bMouseBtn, qsys::InDevEvent &ev);
#endif
    
    bool m_bUseGlShader;
    bool m_bUseMultiPad;
    bool m_bUseHiDPI;

  };

}

#endif


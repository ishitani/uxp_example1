//
// $Id: XPCCueMol.hpp,v 1.8 2011/03/10 13:11:55 rishitani Exp $
//

#ifndef XPC_CUEMOL_HPP__
#define XPC_CUEMOL_HPP__

#include <nsCOMPtr.h>
#include <nsIObserver.h>
#include "qICueMol.h"

#ifndef TESTING_XXX
#include <qlib/qlib.hpp>
#include <qlib/LString.hpp>
#endif

namespace xpcom {

#ifndef TESTING_XXX
  using qlib::LString;
  class XPCObjWrapper;
#endif

  class XPCCueMol : public qICueMol, public nsIObserver
  {
  private:

#ifndef TESTING_XXX
    struct Cell
    {
      Cell() : ptr(NULL) {}
      XPCObjWrapper *ptr;
#ifdef MB_DEBUG
      LString dbgmsg;
#endif
    };
    
    std::vector<Cell> m_pool;
    std::list<int> m_freeind;

    void *m_pTR;

    // Recently occured error message
    LString m_errMsg;

    // setup text rendering
    bool initTextRender();
    void finiTextRender();
#endif

    bool m_bInit;


  protected:
    virtual ~XPCCueMol();

  public:
    XPCCueMol();

    NS_DECL_ISUPPORTS;

    NS_DECL_QICUEMOL;

    NS_DECL_NSIOBSERVER;

#ifndef TESTING_XXX
    /// Create new object wrapper
    XPCObjWrapper *createWrapper();
#endif

    /// Notify the destruction of wrapper (to clear the wrapper pool entry)
    void notifyDestr(int nind);

    /// Set debug info to wrapper pool entry (debug version)
    void setWrapperDbgMsg(int nind, const char *dbgmsg);

    /// Dump wrapper pool info
    void dumpWrappers() const;

    /// Cleanup unreleased wrapper objects
    void cleanupWrappers();

#ifndef TESTING_XXX
    void setErrMsg(const LString &msg)
    {
      m_errMsg = msg;
    }
#endif

    static XPCCueMol *getInstance();
  };

}

/// Class ID for XPCCueMol service
#define XPCCueMol_CID					\
  { 0x16ab26f1, 0xe579, 0x4aa6,				\
      { 0xa9, 0x46, 0xde, 0x71, 0x2e, 0x17, 0x26, 0xc4}}

/// Contract ID for XPCCueMol service
#define XPCCueMol_CONTRACTID "@cuemol.org/XPCCueMol"

#endif

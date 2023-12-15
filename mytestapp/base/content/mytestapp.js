/* -*- Mode: Java; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
 
dump("===== mytestup.js ===== \n");
// const {Cc,Ci,Cr} = require("chrome");
const Cc = Components.classes;
const Ci = Components.interfaces;
const Cu = Components.utils;
const Cr = Components.results;

Cu.import("resource://gre/modules/appboots.js");

let dd = function (str) {dump (str + "\n");}

function setupScriptResize(aFrm)
{
  var boxObj = aFrm.boxObject;
  var natwin = aFrm.native_window;
  dd("boxObj: "+boxObj);
  
  //var target = aFrm.contentWindow;
  dd("aFrm.contentWindow = "+aFrm.contentWindow);

  function onResize(aEvent)
  {
    try {
      //var boxObj = aFrm.boxObject;
      //dd("onResize aFrm: "+aFrm);
      //dd("onResize boxObj: "+boxObj);
      // cuemol.putLogMsg("onResize "+boxObj.x+", "+boxObj.y+", "+boxObj.width+", "+boxObj.height);
      dd("onResize "+boxObj.x+", "+boxObj.y+", "+boxObj.width+", "+boxObj.height);
      natwin.resize(boxObj.x, boxObj.y, boxObj.width, boxObj.height);
      natwin.show();
    }
    catch (e) {
      debug_util.exception(e);
    }
  }
  aFrm.contentWindow.addEventListener("resize", onResize, false);

  //////////
  // LOAD

  function onLoad(aEvent) {
    dd("NativeWidget: load");
    dd("SIZE "+boxObj.x+", "+boxObj.y+", "+boxObj.width+", "+boxObj.height);
    natwin.resize(boxObj.x, boxObj.y, boxObj.width, boxObj.height);
    natwin.show();
  }
  aFrm.contentWindow.addEventListener("load", onLoad, false);

  //////////
  // MOUSE WHEEL

  function onMouseWheel(aEvent) {
    //dd("NativeWidget: onMouseWheel");
    natwin.handleEvent(aEvent);
  }
  aFrm.contentWindow.addEventListener("DOMMouseScroll", onMouseWheel, false);

  //////////
  // UNLOAD

  function onUnload(aEvent)
  {
    dd("NativeWidget: remove native window lisnters.");
    aFrm.contentWindow.removeEventListener("resize", onResize, false);
    aFrm.contentWindow.removeEventListener("DOMMouseScroll", onMouseWheel, false);
    natwin.unload();
  }
  aFrm.addEventListener("unload", onUnload, false);

  //natwin.resize(boxObj.x, boxObj.y, boxObj.width, boxObj.height);
};

let setup = function (window, aFrm, aScID, aVwID, cuemol)
{

  try {
    //var natwin = Cc[NATWIN_CID].createInstance(Ci.qINativeWindow);
    var natwin = cuemol.createNativeWidget();
    if (!natwin) {
      dd("FATAL ERROR: cannot create native widget.");
      window.alert("FATAL ERROR: cannot create native widget.");
      return;
    }

    // Get base window object
    var treeOwner = window.QueryInterface(Ci.nsIInterfaceRequestor)
      .getInterface(Ci.nsIWebNavigation)
        .QueryInterface(Ci.nsIDocShellTreeItem)
          .treeOwner;
    var docShell = treeOwner.QueryInterface(Ci.nsIInterfaceRequestor)
      .getInterface(Ci.nsIXULWindow)
        .docShell;

    var baseWindow = docShell.QueryInterface(Ci.nsIBaseWindow);
    var baseWindow2 = treeOwner.QueryInterface(Ci.nsIInterfaceRequestor)
      .QueryInterface(Ci.nsIBaseWindow);

    dd("**** Parent Native Window = " + baseWindow.parentNativeWindow);
    dd("**** Native Handle = " + baseWindow2.nativeHandle);

    natwin.setup(docShell, baseWindow);
    aFrm.native_window = natwin;

    // dd("Native widget overlay target elem: "+aFrm);

    // set preferences from gecko-prefs
    // setPrefs(natwin);

    // setup OpenGL, etc
    natwin.load(aScID, aVwID);

    setupScriptResize(aFrm);
    //setupNativeResize(aFrm);

    // var key = makeTabKey(natwin);
    // mNatwinTab[key] = natwin;

    return natwin;
  }
  catch (e) {
    // debug_util.exception(e);
    dd("exception: " + e);
  }
};

function Startup() {
  // Startup code here
  dump("XXXX Startup called!!\n\n");
  const CueMol = new Components.Constructor("@cuemol.org/XPCCueMol", "qICueMol");
  var qm = new CueMol;
  dump("CueMol="+qm+"\n");
  qm.init("path");

  let aFrm = document.getElementById("view-1");
  dd("iframe: "+aFrm);

  let natwin = setup(window, aFrm, 1, 1, qm);
  dd("natwin: "+natwin);
  window.natwin = natwin;
}

function Shutdown() {
  // Shutdown code here
}

function WindowIsClosing() {
  // Window is closing code here
  window.natwin = null;
}

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

function Startup() {
  // Startup code here
  dump("XXXX Startup called!!\n\n");
  const CueMol = new Components.Constructor("@cuemol.org/XPCCueMol", "qICueMol");
  var qm = new CueMol;
  dump("CueMol="+qm+"\n");
  qm.init("path");

  var natwin = qm.createNativeWidget();
  dump("natwin="+natwin+"\n");

  if (!natwin) {
    dump("FATAL ERROR: cannot create native widget.\n");
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
  
  //dd("**** Parent Native Window = " + baseWindow.parentNativeWindow);
  dump("**** Native Handle = " + baseWindow2.nativeHandle + "\n");
  natwin.setup(docShell, baseWindow);

  window.natwin = natwin;
}

function Shutdown() {
  // Shutdown code here
}

function WindowIsClosing() {
  // Window is closing code here
  window.natwin = null;
}

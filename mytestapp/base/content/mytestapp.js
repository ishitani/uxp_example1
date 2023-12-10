/* -*- Mode: Java; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
 
dump("===== mytestup.js ===== \n");

function Startup() {
  // Startup code here
  dump("XXXX Startup called!!\n\n");
  const CueMol = new Components.Constructor("@cuemol.org/XPCCueMol", "qICueMol");
  var qm = new CueMol;
  dump("CueMol="+qm+"\n");
  qm.init("path");

}

function Shutdown() {
  // Shutdown code here
}

function WindowIsClosing() {
  // Window is closing code here
}

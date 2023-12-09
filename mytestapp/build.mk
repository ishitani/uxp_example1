# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

installer:
	@$(MAKE) -C mytestapp/installer installer

package:
	@$(MAKE) -C mytestapp/installer make-archive

l10n-package:
	@$(MAKE) -C mytestapp/installer make-langpack

mozpackage:
	@$(MAKE) -C mytestapp/installer

package-compare:
	@$(MAKE) -C mytestapp/installer package-compare

stage-package:
	@$(MAKE) -C mytestapp/installer stage-package make-buildinfo-file

install::
	@$(MAKE) -C mytestapp/installer install

clean::
	@$(MAKE) -C mytestapp/installer clean

distclean::
	@$(MAKE) -C mytestapp/installer distclean

source-package::
	@$(MAKE) -C mytestapp/installer source-package

upload::
	@$(MAKE) -C mytestapp/installer upload

source-upload::
	@$(MAKE) -C mytestapp/installer source-upload

hg-bundle::
	@$(MAKE) -C mytestapp/installer hg-bundle

l10n-check::
	@$(MAKE) -C mytestapp/locales l10n-check

ifdef ENABLE_TESTS
# Implemented in testing/testsuite-targets.mk

mochitest-browser-chrome:
	$(RUN_MOCHITEST) --browser-chrome
	$(CHECK_TEST_ERROR)

mochitest:: mochitest-browser-chrome

.PHONY: mochitest-browser-chrome

mochitest-metro-chrome:
	$(RUN_MOCHITEST) --metro-immersive --browser-chrome
	$(CHECK_TEST_ERROR)


endif

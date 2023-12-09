# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

installer:
	@$(MAKE) -C example/installer installer

package:
	@$(MAKE) -C example/installer make-archive

l10n-package:
	@$(MAKE) -C example/installer make-langpack

mozpackage:
	@$(MAKE) -C example/installer

package-compare:
	@$(MAKE) -C example/installer package-compare

stage-package:
	@$(MAKE) -C example/installer stage-package make-buildinfo-file

install::
	@$(MAKE) -C example/installer install

clean::
	@$(MAKE) -C example/installer clean

distclean::
	@$(MAKE) -C example/installer distclean

source-package::
	@$(MAKE) -C example/installer source-package

upload::
	@$(MAKE) -C example/installer upload

source-upload::
	@$(MAKE) -C example/installer source-upload

hg-bundle::
	@$(MAKE) -C example/installer hg-bundle

l10n-check::
	@$(MAKE) -C example/locales l10n-check

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

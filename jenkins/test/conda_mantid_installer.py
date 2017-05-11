#

import os

from mantidinstaller import MantidInstaller, run

class CondaInstaller(MantidInstaller):

    python_args = "" # not mantidpython. just normal python

    def __init__(self, package_dir, do_install=True):
        filepattern = "mantid-framework*.tar.bz2"
        MantidInstaller.__init__(self, package_dir, filepattern, do_install)
        package = os.path.basename(self.mantidInstaller)
        self.conda_prefix = os.path.expanduser('~/opt/miniconda2')
        install_prefix = os.path.join(self.conda_prefix, 'envs', 'mantid')
        self.mantidPlotPath = "Unknown"
        self.python_cmd = install_prefix + '/bin/python'

    def do_install(self):
        """Uses gdebi to run the install
        """
        thisdir = os.path.dirname(__file__)
        script = os.path.join(thisdir, 'install_conda_mantid.sh')
        run('%s %s' % (script, self.mantidInstaller))

    def do_uninstall(self):
        """Removes the debian package
        """
        # run('rm -rf %s' % self.conda_prefix)


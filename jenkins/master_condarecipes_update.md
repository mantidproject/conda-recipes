## master_condarecipes_update
* Update mantid-framework conda recipe by running "conda_update_recipe.py".
* git push to mantidproject/conda-recipes

### Configuration
* General
  * Discard old builds
    * Startegy: Log Rotation
      * Days to keep builds: 14
* Job Notification
  * Restrict where this project can be run
    * Label Expression: master
* Source Code Management
  * Git
    * Repositories
      * URL: git@github.com-mantid-builder:mantidproject/conda-recipes.git
* Build Environment
  * Delete workspace before build starts
  * Add timestamps to the Console Output
* Build
  * Copy artifacts from another project
    * name: master_clean-rhel7
    * Artifacts to copy: */*/*.py
    * Target directory: build
    * Flatten directories
    * Fingerprint Artifacts
  * Execute Python script
    ```
    import sys, os, subprocess as sp, shlex
    sys.path.insert(0, os.path.abspath("build"))
    import conda_update_recipe as cur
    repo = os.path.abspath(".")

    pkgs = ['framework', 'workbench']
    updated = False
    for pkg in pkgs:
      updated = updated or cur.update_meta_yaml(repo, pkg)
    if updated:
      cmd = 'git -c user.name="jenkins" -c user.email="mantid-buildserver@mantidproject.org" commit -m "update version and git_rev" .'
      sp.check_call(shlex.split(cmd), cwd=repo)
    ```
* Post-build Actions
  * Git Publisher
    * Push Only If Build Succeeds
    * Branches: branch:master; target remote: origin
  * Build other projects
    * master_create_conda_linux_pkg


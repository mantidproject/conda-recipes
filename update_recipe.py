# -*- Python -*-

"""methods to update recipes with new version and git tag
"""

import subprocess as sp, shlex, os

def checkout(repo_path):
    # checkout recipe
    if not os.path.exists(repo_path):
        cmd = 'git clone git@github.com:mantidproject/conda-recipes'
        sp.check_call(cmd.split())
    else:
        cmd = 'git pull'
        sp.check_call(cmd.split(), cwd=repo_path)
    return


def update_meta_yaml(repo_path, version, git_rev, recipe_path=None):
    """update meta.yaml file with new version and git_rev

    Example: update_meta_yaml(".", "5.5", "release-5.5", "framework")

    return: True if updated
    """
    recipe_path = recipe_path or 'framework'
    if not os.path.isabs(recipe_path):
        recipe_path = os.path.join(repo_path, recipe_path)
    # change framework meta.yaml
    path = os.path.join(recipe_path, 'meta.yaml')
    header = []
    header.append('{% set version = "' + '%s' % version + '" %}')
    header.append('{% set git_rev = "' + '%s' % git_rev + '" %}')
    content = open(path, 'rt').read().split('\n')
    old_header = content[:2]
    body = content[2:]
    # if nothing changed just exit
    if header == old_header:
        print("Nothing changed. Skipping.")
        return False
    open(path, 'wt').write('\n'.join(header+body))
    return True


def commit(repo_path):
    # git commit
    cmd = 'git commit -m "update version and git_rev" .'
    sp.check_call(shlex.split(cmd), cwd=repo_path)
    return


def push(repo_path):
    # git push
    cmd = 'git push'
    sp.check_call(cmd.split(), cwd=repo_path)
    return

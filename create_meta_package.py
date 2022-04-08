# This script generates the developer package

import os

current_script_dir = os.path.dirname(os.path.abspath(__file__))
recipes_dir = os.path.join(current_script_dir, 'recipes')
meta_folder_path = os.path.join(recipes_dir, 'mantiddeveloper')
# If meta-package doesn't exist make the folder
if not os.path.exists(meta_folder_path):
    os.mkdir(meta_folder_path)

meta_recipe_file = os.path.join(meta_folder_path, 'meta.yaml')
mantid_recipe_file = os.path.join(recipes_dir, 'mantid', 'meta.yaml')
mantidqt_recipe_file = os.path.join(recipes_dir, 'mantidqt', 'meta.yaml')
mantidworkbench_recipe_file = os.path.join(recipes_dir, 'mantidworkbench', 'meta.yaml')
extras_file = os.path.join(current_script_dir, 'dev-only-packages.txt')


def load_dependencies(recipe_file):
    dependencies_found = False
    dependencies = set()
    with open(recipe_file) as open_recipe_file:
        for line in open_recipe_file.readlines():
            if "test:" in line or "about:" in line:
                break
            if "build:" in line or "host:" in line or "run:" in line:
                dependencies_found = True
            if "-" in line and dependencies_found:
                # Ignore compilers
                if "compiler(" in line:
                    pass
                # Ignore pin_compatibles
                elif "pin_compatible" in line:
                    pass
                # Ignore pin_subpackage
                elif "pin_subpackage" in line:
                    pass
                # Ignore workbench = workbench.app.main:main
                elif "workbench = workbench.app.main:main" in line:
                    pass
                # Add dependency to set
                else:
                    dependencies.add(line)

    return dependencies


def load_extras(extras_file):
    dependencies = set()
    with open(extras_file) as open_extras_file:
        for line in open_extras_file.readlines():
            dependencies.add(line)
    return dependencies


mantid_dependencies = load_dependencies(mantid_recipe_file)
mantidqt_dependencies = load_dependencies(mantidqt_recipe_file)
mantidworkbench_dependencies = load_dependencies(mantidworkbench_recipe_file)
extra_dev_dependencies = load_extras(extras_file)
recipe_dependencies = set.union(mantid_dependencies, mantidqt_dependencies, mantidworkbench_dependencies, extra_dev_dependencies)


def write_meta_yaml(meta_file_path):
    if os.path.exists(meta_file_path):
        # Find the current version and increment by 1 on minor version
pass

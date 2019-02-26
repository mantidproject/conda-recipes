"""
run this script at baldrick.ornl.gov to obtain a comparison
of versions of dependencies between redhat and conda
"""
import subprocess as sp, shlex, yaml

# get info of installed pkgs
cmd = 'yum list installed > ~/installed.txt'
args = shlex.split(cmd)
sp.check_output(args)

# compare to pkg version in spec
d = yaml.load(open('./conda_build_config.yaml'))
for k in d:
    if k == 'python': continue
    cmd = 'grep %s /home/lj7/installed.txt' % k
    args = shlex.split(cmd)
    text = sp.check_output(args)
    if not text: continue
    tokens = text[0].split()
    print '%10s%40s%20s' % (k, tokens[1], d[k][0])

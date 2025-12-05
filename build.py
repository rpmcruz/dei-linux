#!/usr/bin/env python3

# requires: nix-shell -p jdk python313Packages.pyyaml

import yaml, re, os, stat, shutil
from contextlib import chdir

if os.path.exists('demos'): shutil.rmtree('demos')
if os.path.exists('desktop'): shutil.rmtree('desktop')

for demo in yaml.safe_load(open('demos.yaml')):
    github = re.sub(r'^https://github\.com/(.+)$', r'git@github.com:\1.git', demo['link'])
    path = f'demos/{demo["course"]}/{demo["title"]}'
    os.system(f'git clone --depth 1 --single-branch --no-tags {github} "{path}"')
    if 'compile' in demo:
        with chdir(path):
            os.system(demo['compile'])
    os.makedirs(f'desktop/{demo["course"]}', exist_ok=True)
    filename = f'desktop/{demo["course"]}/{demo["title"].replace(" ", "_")}.desktop'
    with open(filename, 'w') as f:
        print('[Desktop Entry]', file=f)
        print(f'Name={demo["title"]}', file=f)
        print(f'Path=/demos/{demo["course"]}/{demo["title"]}', file=f)
        print(f'Exec={demo["run"]}', file=f)
        print('Type=Application', file=f)
    os.chmod(filename, os.stat(filename).st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)

print("build the ISO...")
ok = os.system("nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix")

print("test...")
if ok == 0:
    os.system('qemu-system-x86_64 -enable-kvm -m 4096 -cpu host -smp 2 -boot d -cdrom ./result/iso/nixos-*.iso -device virtio-vga')

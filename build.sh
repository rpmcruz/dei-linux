#!/bin/sh


nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=/home/rpcruz/Documentos/dei-linux/nixos-live/configuration.nix -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-25.11.tar.gz
exit

# test
qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -cpu host \
  -smp 2 \
  -boot d \
  -cdrom ./result/iso/nixos.iso \
  -drive if=virtio,file=disk.img,format=qcow2 \
  -device virtio-vga



sudo rm -rf desktop /demos
sudo mkdir desktop /demos
sudo chmod a+rwX desktop /demos

#!/bin/bash

# Iterate over YAML items
yq e '.[]' projects.yaml -o=json | jq -c '.[]' | while read -r item; do
    title=$(echo "$item" | jq -r '.title')
    student=$(echo "$item" | jq -r '.student')
    run=$(echo "$item" | jq -r '.run // ""') # handle missing key
    compile=$(echo "$item" | jq -r '.compile // ""')

    echo "Title: $title"
    echo "Student: $student"
    echo "Compile: $compile"
    echo "Run: $run"
    echo "----------------"
done



while IFS=',' read -r course title author url execute ; do
    [ -z "$url" ] && continue  # skip empty lines
    git_url=$(echo "$url" | sed -E 's#https://github.com/(.+)#git@github.com:\1.git#')
    git clone $git_url "/demos/$title"
    filename=desktop/$(echo "$title" | tr ' ' '_').desktop
    # create the .desktop file
    cat > $filename << EOF
[Desktop Entry]
Name=$title
Path=/demos/$title
Exec=$execute
Type=Application
EOF
    chmod +x $filename
done < fpro.csv

#for fname in ~/Secretária/*.desktop; do
#    gio set $fname "metadata::trusted" true
#done

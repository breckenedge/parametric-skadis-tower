#!/bin/sh
# Re-render every image in images/ from the current skadis_tower.scad, so the
# README always shows the model as it is now. Run it after any change to the
# geometry, and commit the images with the change:
#
#   ./render-images.sh
#
# Uses OpenSCAD's fast preview renderer (the F5 view), so the whole set takes
# seconds rather than the minutes a full render of the towers would. Set
# OPENSCAD to point at the binary if it isn't on PATH.

set -e
cd "$(dirname "$0")"

if [ -z "$OPENSCAD" ]; then
    if command -v openscad >/dev/null 2>&1; then
        OPENSCAD=openscad
    elif [ -x "/c/Program Files/OpenSCAD/openscad.com" ]; then
        OPENSCAD="/c/Program Files/OpenSCAD/openscad.com"
    elif [ -x /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD ]; then
        OPENSCAD=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
    else
        echo "OpenSCAD not found; set OPENSCAD=/path/to/openscad" >&2
        exit 1
    fi
fi

# render NAME WIDTHxHEIGHT CAMERA [-D overrides...]
# CAMERA is OpenSCAD's translate_x,y,z,rot_x,y,z,distance form.
render() {
    name=$1 size=$2 camera=$3
    shift 3
    echo "images/$name.png"
    "$OPENSCAD" -o "images/$name.png" --imgsize="${size%x*},${size#*x}" \
        --camera="$camera" --colorscheme=Cornfield "$@" skadis_tower.scad 2>&1 \
        | grep -E "WARNING|ERROR" || true
}

# The full stack, assembled: a base with the power inlet, two segments, a cap.
# Seen from the back-right corner, so the inlet shows.
render stack 700x1150 0,0,195,62,0,155,1450 \
    -D make_base=true -D towers=2 -D make_cap=true -D 'layout="assembled"' \
    -D base_inlet=true -D base_height=45

# The same run as it goes to the slicer.
render print 1200x450 0,0,60,62,0,15,780 \
    -D make_base=true -D towers=2 -D make_cap=true -D 'layout="print"' \
    -D base_inlet=true -D base_height=45

# Each piece on its own, at the defaults.
render tower      700x1000 0,0,80,62,0,25,620
render cap        800x560  0,0,8,55,0,25,300   -D towers=0 -D make_cap=true
render base       800x560  0,0,10,55,0,25,380  -D towers=0 -D make_base=true
render base-inlet 800x560  0,0,22,60,0,200,400 -D towers=0 -D make_base=true \
    -D base_inlet=true -D base_height=45

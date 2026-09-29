// ============================================================================
// Parametric Skadis Tower
// ----------------------------------------------------------------------------
// A four-sided hollow tower whose walls carry the IKEA Skadis peg pattern, so
// standard Skadis accessories hook onto every face. The pattern auto-fills each
// face: you set the outside dimensions, the slots lay themselves out.
//
// Slot openings are filleted (a concave blend into the face, not a straight
// chamfer) on both the inside and the outside.
//
// Segments stack on locating tabs: tabs stand proud of the top face and drop
// into matching pockets in the underside of the segment above. A tab is
// `tab_thickness` of the wall measured from the cavity, so the outer skin of
// the upper segment covers the joint and the seam is invisible from outside.
// Tabs are domed and the pockets arch to match, so the pocket roof
// self-supports and needs no print supports.
//
// The pattern is laid out to survive that joint: rows sit half a pitch from
// each end face, so a stack reads as one continuous Skadis panel. That puts the
// bottom row alongside the tabs, so tabs are snapped onto the half-pitch line
// midway between two slot columns, where they clear the slots.
//
// Orientation: width = X, depth = Y, height = Z. Print standing up as modeled.
//
// All dimensions are millimeters.
// ============================================================================

/* [Part] */

// Which piece to render. Both parts read the same shared dimensions below, so
// the cap's pockets always line up with the tower's tabs. That is the reason
// the cap lives in this file instead of a separate copy that could drift out of
// sync the first time you change a tab setting.
part = "tower";  // [tower, cap]

/* [Tower size] */

// Outside width (X), mm
width = 80;         // [25:1:400]
// Outside depth (Y), mm
depth = 80;         // [25:1:400]
// Outside height (Z) of one segment, mm. Keep this a whole multiple of the
// grid pitch (20 mm) so stacked segments hold Skadis spacing across the joint.
height = 160;       // [20:20:400]

/* [Corners] */

// Outside corner radius, mm. 0 = sharp corners.
corner_radius = 6;  // [0:0.5:50]

/* [Wall] */

// Wall thickness, mm. An IKEA Skadis board is 5 mm; slightly under that gives
// hooks some slop, which makes them easier to fit and pull off a panel this
// stiff. See the note at the bottom of this file.
wall = 4.5;         // [3:0.1:10]

/* [Stacking] */

// Tabs on top, for a segment to stack on. Turn this off for the topmost
// segment to get a clean flat top. The pockets underneath are cut either way,
// so the piece still seats on the segment below it.
stackable = true;
// Tabs along each wall
tabs_per_wall = 2;    // [1:1:4]
// Length of each tab along the wall, mm. Also sets the dome radius (half this).
tab_width = 8;        // [4:0.5:40]
// How far each tab stands proud of the top face, mm
tab_height = 8;       // [4:0.5:20]
// How thick a tab is through the wall, mm. Independent of `wall` so that
// thinning the wall for hook feel does not also weaken the stacking joint.
// The remaining `wall - tab_thickness` is the outer skin that hides the seam.
tab_thickness = 2.5;  // [1.5:0.1:6]
// Clearance on the tabs, mm. Raise for a looser fit.
tab_clearance = 0.25; // [0:0.05:0.8]

/* [Skadis pattern] */

// Slot width, mm (IKEA Skadis = 5)
slot_width = 5;     // [3:0.1:8]
// Slot height, mm (IKEA Skadis = 15)
slot_height = 15;   // [10:0.5:25]
// Printing allowance added to the slot WIDTH only, mm. FDM holes come out
// undersize in the wall plane -- extrusion overlap on the inside of the curve
// eats a tenth or two -- so a nominal 5 mm slot often measures 4.8 and hooks
// bind. This compensates so the printed slot measures `slot_width`; it is not
// meant to make the slot bigger than the IKEA standard. Measure a printed slot
// and tune. Height is left alone: Z lands where it is told, and the slot roof
// is an arch, so there is nothing to compensate there.
slot_fit = 0.2;     // [0:0.05:0.6]
// Pattern grid pitch, mm (IKEA Skadis = 20)
grid = 20;          // [10:1:40]
// Fillet radius around each slot opening, mm. Applied inside and out.
slot_fillet = 0.8;  // [0:0.1:2]
// Run the left/right faces out of phase with the front/back, so the gap to the
// shared corner alternates long/short up the edge instead of matching.
alternate_corners = true;
// Minimum solid material between a slot opening and a rounded corner, mm.
// Horizontal only: the vertical spacing is fixed by the stacking rule below.
edge_margin = 4;    // [2:0.5:20]

/* [Cap] */

// A solid lid with no slots, for closing off the top of a stack.
//
// Tilt of the cap's top face, degrees from horizontal. 10 aims a desktop
// speaker up toward seated ear height. 0 gives a plain flat lid.
cap_tilt = 10;      // [0:0.5:30]
// Which edge of the cap is the high one. On a square tower this is only a print
// orientation and you can just spin the finished part; it starts to matter once
// width and depth differ. For a desk speaker, put the high edge toward your
// listening position, so the speaker tips back and fires up at you.
cap_tilt_dir = 0;   // [0:high edge at back (+Y), 90:high edge at left (-X), 180:high edge at front (-Y), 270:high edge at right (+X)]
// Solid material over the tab pockets at the LOW edge, mm. This is what sets
// the cap's overall thickness: a pocket is as deep as a tab is tall, so the low
// edge works out to tab_height + tab_clearance + this.
cap_roof = 4;       // [2:0.5:15]

/* [Hidden] */

$fn = 48;
eps = 0.01;
// Slices used to approximate each fillet. More = smoother, slower.
fillet_steps = 6;

// ----------------------------------------------------------------------------
// Derived values
// ----------------------------------------------------------------------------

inner_w = width - 2 * wall;
inner_d = depth - 2 * wall;
inner_r = max(corner_radius - wall, 0);

// Flat run of each face, excluding the rounded corners and the edge margin.
// This bounds the pattern horizontally; vertically the grid rule below rules.
flat_x = width - 2 * (corner_radius + edge_margin);
flat_y = depth - 2 * (corner_radius + edge_margin);

// The fillet widens the opening, so the footprint that has to fit inside the
// margins is the slot plus its fillet on every side.
// Slot width as actually cut, including the printing allowance.
cut_w = slot_width + slot_fit;

open_w = cut_w + 2 * slot_fillet;
open_h = slot_height + 2 * slot_fillet;

// Material left above and below a slot at the very ends of a segment. Fixed by
// the stacking rule, not a free choice: rows sit half a pitch from each face.
end_material = (grid - open_h) / 2;

// Smallest sizes that still fit one slot with its margins.
min_face   = 2 * (corner_radius + edge_margin) + open_w;
min_height = max(grid, tab_height + tab_clearance + open_h / 2 + 1);

// Cap geometry. The cap uses the same pockets the tower's tabs drop into, so it
// has to be thick enough to swallow a tab plus its clearance before any roof.
// The tilt then adds `cap_rise` across the span it tilts along.
cap_base = tab_height + tab_clearance + cap_roof;
cap_span = (cap_tilt_dir == 90 || cap_tilt_dir == 270) ? width : depth;
cap_rise = cap_span * tan(cap_tilt);

// Dome radius of a tab: a full semicircle across the tab, so the matching
// pocket roof is a self-supporting arch.
tab_r = tab_width / 2;

// ----------------------------------------------------------------------------
// Sanity checks: stop the render with a readable message rather than silently
// producing a tower with no slots or no walls.
// ----------------------------------------------------------------------------

assert(width >= min_face,
    str("width must be at least ", min_face,
        " mm for this corner radius and margin (got ", width, ")"));

assert(depth >= min_face,
    str("depth must be at least ", min_face,
        " mm for this corner radius and margin (got ", depth, ")"));

assert(height >= min_height,
    str("height must be at least ", min_height,
        " mm to fit a row of slots clear of the stacking joint (got ", height, ")"));

assert(open_h <= grid,
    str("a slot opening (", open_h, " mm with the fillet) cannot exceed the grid "
        , "pitch (", grid, " mm), or rows would run into each other across the joint"));

assert(corner_radius <= min(width, depth) / 2,
    str("corner_radius cannot exceed half the smaller of width/depth (max ",
        min(width, depth) / 2, ")"));

assert(wall >= 3,
    "wall must be at least 3 mm; Skadis accessories expect a 5 mm board");

assert(2 * wall < min(width, depth),
    "wall is too thick for this width/depth: there is no cavity left");

assert(slot_fillet < wall / 3,
    str("slot_fillet must stay under a third of the wall (max ", wall / 3, ")"));

assert(tab_thickness <= wall - 1.5,
    str("tab_thickness must leave at least 1.5 mm of outer skin to hide the joint (max ",
        wall - 1.5, " mm at this wall thickness)"));

assert(tab_clearance < tab_thickness / 4,
    "tab_clearance is too large for this tab thickness");

assert(tab_height > tab_r,
    str("tab_height must exceed the dome radius (", tab_r,
        " mm) so the tab has a straight section below the dome"));

assert(tab_width <= min(flat_x, flat_y) / tabs_per_wall,
    str(tabs_per_wall, " tabs of ", tab_width,
        " mm do not fit the shortest wall: either drop tab_width to ",
        min(flat_x, flat_y) / tabs_per_wall, " mm, or set tabs_per_wall to ",
        max(floor(min(flat_x, flat_y) / tab_width), 1)));

// A tab sits on the half-pitch line between two columns, and the lowest row of
// slots runs alongside it, so the two must not meet.
assert(tab_width / 2 + open_w / 2 < grid / 2,
    str("tab_width must stay under ", grid - open_w,
        " mm, or a tab would run into the slot column beside it"));

assert(min(tab_gap(flat_x, cols_x), tab_gap(flat_y, cols_y)) >= tab_width,
    str("tabs collide after snapping to the half-pitch line; reduce tabs_per_wall ",
        "or tab_width"));

assert(part == "tower" || part == "cap",
    str("part must be \"tower\" or \"cap\" (got \"", part, "\")"));

assert(cap_tilt >= 0 && cap_tilt < 45,
    str("cap_tilt must be between 0 and 45 degrees (got ", cap_tilt, ")"));

assert(cap_tilt_dir == 0 || cap_tilt_dir == 90 || cap_tilt_dir == 180
       || cap_tilt_dir == 270,
    str("cap_tilt_dir must be 0, 90, 180 or 270 (got ", cap_tilt_dir, ")"));

// ----------------------------------------------------------------------------
// Pattern layout
//
// The Skadis pattern is a checkerboard on a square grid: a slot sits at every
// grid intersection where (column + row) is even. That gives the familiar 40 mm
// spacing along each row, with alternate rows offset by half a pitch.
// ----------------------------------------------------------------------------

function slot_count(span, opening) =
    max(floor((span - opening) / grid) + 1, 1);

cols_x = slot_count(flat_x, open_w);   // faces normal to Y (the width faces)
cols_y = slot_count(flat_y, open_w);   // faces normal to X (the depth faces)

// Rows are NOT centered in the height. The first row sits half a pitch up from
// the bottom face and they march up at the full pitch, so a stacked segment
// carries on at the same spacing across the joint: the last row of one segment
// and the first of the next end up exactly `grid` apart. That only works out
// if `height` is a whole number of pitches, which the echo below checks.
rows = max(floor(height / grid), 1);

function row_z(j) = grid / 2 + j * grid;

// Column centers across a face, centered on the face.
function col_x(i, cols) = (i - (cols - 1) / 2) * grid;

// Tab centers along a wall. A tab shares the bottom of the tower with the
// lowest row of slots, so it cannot sit on a column: snap the evenly spread
// position onto the half-pitch line midway between two columns.
function tab_pos(i, flat, cols) =
    let (ideal = (i - (tabs_per_wall - 1) / 2) * (flat / tabs_per_wall),
         base  = col_x(0, cols) + grid / 2)
    base + round((ideal - base) / grid) * grid;

// Closest approach between neighbouring tabs on a wall, used by the checks.
function tab_gap(flat, cols) =
    tabs_per_wall < 2 ? 1e9
    : min([for (i = [1 : tabs_per_wall - 1])
              tab_pos(i, flat, cols) - tab_pos(i - 1, flat, cols)]);

// How far the fillet has grown the opening at depth `z` below the face, for a
// fillet circle of radius f tangent to both the face and the slot wall.
function fillet_grow(z, f) = f - sqrt(max(f * f - pow(z - f, 2), 0));

// ----------------------------------------------------------------------------
// Primitives
// ----------------------------------------------------------------------------

// 2D rounded rectangle, centered on the origin.
module rrect(w, d, r) {
    if (r > eps) offset(r = r) square([w - 2 * r, d - 2 * r], center = true);
    else         square([w, d], center = true);
}

// The rounded-slot outline, optionally grown by `grow`.
module slot_profile(grow = 0) {
    offset(r = grow)
        hull()
            for (s = [-1, 1])
                translate([0, s * (slot_height - cut_w) / 2])
                    circle(d = cut_w);
}

// The filleted flare at one slot opening: widest at z = 0 (the face) and
// blending tangentially into the slot wall at z = f. Built as a stack of
// hulled slices following the fillet arc.
module slot_flare(f) {
    for (k = [0 : fillet_steps - 1]) {
        z0 = f * k / fillet_steps;
        z1 = f * (k + 1) / fillet_steps;
        hull() {
            translate([0, 0, z0])
                linear_extrude(eps) slot_profile(fillet_grow(z0, f));
            translate([0, 0, z1])
                linear_extrude(eps) slot_profile(fillet_grow(z1, f));
        }
    }
}

// A slot cutter in its own frame: extruded along +Z, with z = 0 at the inner
// (cavity) surface of the wall and z = thick at the outer surface.
//
// render() collapses the fillet's slice stack into a single cached mesh. Every
// cutter in the model is geometrically identical, so this is evaluated once and
// reused; without it the preview CSG tree runs to six figures and F5 gives up.
module slot_cutter(thick) {
    f = slot_fillet;
    render() union() {
        // Straight through-cut, run past both faces so the difference is clean.
        translate([0, 0, -1]) linear_extrude(thick + 2) slot_profile();

        if (f > eps) {
            // Inner face: flare opens downward, so build upward from z = 0.
            slot_flare(f);
            translate([0, 0, -1]) linear_extrude(1) slot_profile(f);

            // Outer face: the same flare mirrored about z = thick.
            translate([0, 0, thick]) mirror([0, 0, 1]) slot_flare(f);
            translate([0, 0, thick]) linear_extrude(1) slot_profile(f);
        }
    }
}

// ----------------------------------------------------------------------------
// Stacking tabs
//
// Seen face-on, a tab is a rectangle capped by a semicircular dome. The pocket
// is the same outline grown by the clearance — concentric, so the gap is even
// all round — which makes the pocket roof an arch that prints without support.
// A tab occupies the inner half of the wall; the pocket leaves the outer half
// intact so the joint is hidden from outside.
// ----------------------------------------------------------------------------

// 2D tab outline in the (along-wall, vertical) plane, base centered on origin.
module tab_profile(w, h) {
    r = w / 2;
    hull() {
        translate([-w / 2, 0]) square([w, eps]);
        translate([0, h - r]) circle(r = r);
    }
}

// Extrude a tab outline through the wall, from y0 out to y1.
module tab_extrude(y0, y1, w, h) {
    translate([0, y1, height])
        rotate([90, 0, 0])
            linear_extrude(y1 - y0)
                tab_profile(w, h);
}

// One tab, centered on the origin in X, on a wall whose outer surface is y = face_off.
module tab(face_off) {
    c = tab_clearance;
    tab_extrude(face_off - wall,                        // cavity side; opens inward
                face_off - wall + tab_thickness - c,    // clear of the pocket wall
                tab_width - 2 * c,
                tab_height);
}

// The matching pocket, cut up into the underside of the segment above.
module tab_pocket(face_off) {
    translate([0, 0, -height])                  // tab_extrude builds at z = height
        tab_extrude(face_off - wall - eps,      // break through into the cavity
                    face_off - wall + tab_thickness,  // leave the outer skin intact
                    tab_width,
                    tab_height + tab_clearance);
}

// Tabs (or pockets) along one wall.
module wall_joint(flat, cols, face_off, spin, pocket = false) {
    rotate([0, 0, spin])
        for (i = [0 : tabs_per_wall - 1])
            translate([tab_pos(i, flat, cols), 0, 0])
                if (pocket) tab_pocket(face_off);
                else        tab(face_off);
}

module all_joints(pocket = false) {
    wall_joint(flat_x, cols_x, depth / 2,   0, pocket);
    wall_joint(flat_x, cols_x, depth / 2, 180, pocket);
    wall_joint(flat_y, cols_y, width / 2,  90, pocket);
    wall_joint(flat_y, cols_y, width / 2, -90, pocket);
}

// ----------------------------------------------------------------------------
// Assembly
// ----------------------------------------------------------------------------

module shell() {
    difference() {
        linear_extrude(height) rrect(width, depth, corner_radius);
        translate([0, 0, -eps])
            linear_extrude(height + 2 * eps) rrect(inner_w, inner_d, inner_r);
    }
}

module skadis_tower() {
    difference() {
        union() {
            shell();
            if (stackable) all_joints(pocket = false);
        }
        // Width faces (normal to Y), then depth faces (normal to X). The depth
        // faces take the opposite parity so the corners stagger.
        p = alternate_corners ? 1 : 0;
        face_pattern(cols_x, depth / 2,   0, 0);
        face_pattern(cols_x, depth / 2, 180, 0);
        face_pattern(cols_y, width / 2,  90, p);
        face_pattern(cols_y, width / 2, -90, p);

        // Pockets are cut unconditionally: even a segment with no tabs of its
        // own has to drop onto the one below.
        all_joints(pocket = true);
    }
}

// ----------------------------------------------------------------------------
// Cap
//
// A solid lid that drops onto a tower's tabs and presents a tilted top face.
// It reuses `all_joints(pocket = true)` unchanged, so its pockets are the same
// geometry as the ones in a stacking segment and land in the same places.
//
// Left solid in the model on purpose. Under a speaker you want mass and
// rigidity, not a thin-walled box that can drum, and leaving it solid hands the
// weight/stiffness trade to the slicer's infill setting where it belongs.
//
// Prints as modeled with no supports: the large flat bottom goes on the plate,
// the tilted face is an upward-facing surface, and the only overhangs are the
// tab pockets, which are self-supporting arches by design.
// ----------------------------------------------------------------------------

module skadis_cap() {
    difference() {
        intersection() {
            // Tall enough to be trimmed by the tilted face at every point.
            linear_extrude(cap_base + cap_rise + 1)
                rrect(width, depth, corner_radius);
            cap_tilt_cut();
        }
        all_joints(pocket = true);
    }
}

// The half-space whose top plane becomes the tilted face: `cap_base` above the
// low edge, rising at `cap_tilt` toward the high edge.
//
// A plane rotated by `a` about X is z = y*tan(a), which sits at -span/2*tan(a)
// over the low edge, so lifting it by cap_base + cap_rise/2 puts the low edge
// at exactly cap_base and the high edge at cap_base + cap_rise.
module cap_tilt_cut() {
    big = 4 * (width + depth + cap_base + cap_rise);
    rotate([0, 0, cap_tilt_dir])
        translate([0, 0, cap_base + cap_rise / 2])
            rotate([cap_tilt, 0, 0])
                translate([0, 0, -big / 2])
                    cube(big, center = true);
}

// The slot pattern for one face.
//   cols     - how many grid columns fit across this face
//   face_off - distance from the tower axis out to the outer surface
//   spin     - rotation about Z that aims this face at +Y
//   parity   - which half of the checkerboard this face uses. Flipping it on
//              the adjacent faces is what staggers the pattern at the corners.
module face_pattern(cols, face_off, spin, parity = 0) {
    rotate([0, 0, spin])
        for (i = [0 : cols - 1], j = [0 : rows - 1])
            if ((i + j) % 2 == parity)
                translate([col_x(i, cols),
                           face_off - wall,
                           row_z(j)])
                    rotate([-90, 0, 0])
                        slot_cutter(wall);
}

if (part == "cap") skadis_cap();
else               skadis_tower();

if (part == "cap") {
    echo(str("Skadis cap: ", width, " x ", depth, " mm, ", cap_tilt,
             " deg tilt, high edge at ", cap_tilt_dir, " deg"));
    echo(str("  thickness: ", cap_base, " mm at the low edge, ",
             cap_base + cap_rise, " mm at the high edge"));
    echo(str("  rise: ", cap_rise, " mm across the ", cap_span, " mm span"));
    echo(str("  pockets: ", tabs_per_wall * 4, " x ", tab_width, " mm wide, ",
             tab_height + tab_clearance, " mm deep, ", cap_roof,
             " mm of material above"));
    echo("  solid in the model on purpose - set infill in the slicer");
} else {
echo(str("Skadis tower: ", width, " x ", depth, " x ", height, " mm"));
echo(str("  width faces: ", cols_x, " cols x ", rows, " rows (checkerboard)"));
echo(str("  depth faces: ", cols_y, " cols x ", rows, " rows (checkerboard)"));
echo(str("  stacking: ", tabs_per_wall * 4, " pockets underneath, ",
         stackable ? str(tabs_per_wall * 4, " tabs on top")
                   : "no tabs on top (flat top, use this as the last segment)",
         " - ", tab_width, " x ", tab_height, " mm, dome r=", tab_r));
echo(str("  minimum width/depth at these settings: ", min_face, " mm"));
echo(str("  minimum height at these settings: ", min_height, " mm"));
echo(str("  material above/below the end rows: ", end_material, " mm"));

// Continuous spacing across a stacked joint needs a whole number of pitches.
stack_ok = abs(height - round(height / grid) * grid) < 0.001;
echo(stack_ok
    ? str("  stacking: OK, height is ", height / grid, " x the ", grid, " mm pitch")
    : str("  *** height ", height, " is not a multiple of the ", grid,
          " mm pitch, so stacked segments will NOT keep Skadis spacing across the",
          " joint. Nearest good heights: ", floor(height / grid) * grid, " or ",
          ceil(height / grid) * grid, " mm"));
}

// ============================================================================
// Note on wall thickness
// ----------------------------------------------------------------------------
// An IKEA Skadis board is 5 mm, and hooks are moulded to snap over exactly
// that. Matching it here is the obvious choice but not the best one, for two
// reasons that are specific to a tower.
//
// 1. Stiffness. A Skadis board is a wide, unsupported panel that flexes a
//    little as you work a hook on or off. A tower wall is a short span tied
//    into two corners at each end, so it is far stiffer than the board the
//    hook was designed against. None of that give is available, and a hook
//    that is merely snug on a real board binds here.
//
// 2. Tolerance stacks the wrong way. A nominal 5 mm printed wall usually
//    measures a little over, so the fit goes from snug to tight rather than
//    from snug to loose.
//
// Hence the 4.5 mm default: a few tenths of slop, which a hook takes up by
// tilting slightly. Going much below about 4 mm starts to let accessories rock
// noticeably. `tab_thickness` is deliberately independent of `wall`, so tuning
// this for hook feel does not quietly weaken the stacking tabs.
// ============================================================================

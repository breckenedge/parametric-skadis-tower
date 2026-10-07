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

/* [Parts] */

// Which pieces to render. Turn on several to get a whole stack in one run.
// Every part reads the same shared dimensions below, so the cap's pockets and
// the base's tabs always line up with the tower. That is the reason they live
// in this file instead of separate copies that could drift out of sync the
// first time you change a tab setting.
//
// A base for the bottom of the stack.
make_base = false;
// How many tower segments. 0 leaves the tower out.
towers = 1;         // [0:1:10]
// A tilted cap for the top of the stack.
make_cap = false;
// How to arrange the pieces.
//   print     - side by side on the bed, each standing as it prints. Export this
//               to print the pieces separately and stack them.
//   fused     - stacked and joined into one solid, to print the whole tower in
//               one go. The joints between pieces are left out; the bottom of
//               the run keeps its pockets and the top keeps its tabs, so a fused
//               run still stacks onto separate pieces.
//   assembled - stacked as they go together, to see the whole thing. The tabs
//               sit loose in their pockets, so don't print from this layout.
layout = "print";   // [print, fused, assembled]
// Space between pieces in the print layout, mm.
layout_gap = 10;    // [2:1:50]

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

// Tabs on top of the topmost segment, for another segment to stack on. Turn
// this off to get a clean flat top. Lower segments in a run always get tabs,
// and so does the top one when the cap is on. The pockets underneath are cut
// either way, so every segment seats on whatever is below it.
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
// Which faces carry the Skadis pattern. Turn a face off to leave it plain, such
// as the back of a tower that stands against a wall. Front is -Y (the side the
// base's power inlet is on), back +Y, left -X, right +X.
slots_front = true;
slots_back = true;
slots_left = true;
slots_right = true;
// Minimum solid material between a slot opening and a rounded corner, mm.
// Horizontal only: the vertical spacing is fixed by the stacking rule below.
edge_margin = 4;    // [2:0.5:20]

/* [Cap] */

// A lid with no slots, for closing off the top of a stack: solid, or an open
// collar with `cap_open`.
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
// Open the cap's middle, leaving a collar: the tower's walls cut off at the
// tilt, so the speaker sits on a slanted rim and cables come straight up the
// core. Off gives a solid lid.
cap_open = false;

/* [Base] */

// A footing for the bottom of a stack. Tabs on its top drop into the pockets
// under the lowest tower segment, the same way one segment seats on another.
//
// The base's footprint follows the tower: it is the tower's outline grown by a
// flange on every side, so it can never come out narrower than the tower. The
// flange resists tipping and carries the outside screw holes.
//
// Flange on each side in X (left and right), mm. The footprint at the floor is
// `width` plus twice this.
base_offset_width = 20; // [0:0.5:250]
// Flange on each side in Y (front and back), mm. The footprint at the floor is
// `depth` plus twice this.
base_offset_depth = 20; // [0:0.5:250]
// Height of the base (Z), mm, not counting the tabs on top.
base_height = 20;   // [3:0.5:100]
// Corner radius of the footprint at the floor, mm.
base_corner_radius = 12; // [0:0.5:100]
// Slope the sides in from the footprint at the floor to the tower's own outline
// at the top, so the base flows into the tower. Off gives a straight-sided block.
base_taper = true;
// Straight, vertical section at the bottom before the taper starts, mm. Keeps
// the outer edge from thinning to a knife edge that would curl off the bed.
base_foot = 4;      // [0:0.5:50]
// Hollow the base out into a closed box that opens up into the tower's core, so
// wires can run up the middle. Off gives a solid base: more weight down low,
// with the slicer's infill as the knob.
base_hollow = true;
// Wall thickness of a hollow base, mm. The walls thicken toward the top, where
// they meet the tower wall.
base_wall = 3;      // [1.2:0.1:10]
// Floor thickness of a hollow base, mm. 0 leaves the bottom open, so the base
// is just walls: lighter, faster to print, and wires can also come in from
// below. Screws get solid pads or columns either way.
base_floor = 0;     // [0:0.5:20]

/* [Base power inlet] */

// A snap-in IEC C14 power inlet (the common fused, switched 3-in-1 module) in
// the front (-Y) of a hollow base, so mains comes in at the base and the wires
// run up the tower's core. The inlet is recessed into an alcove so its face is
// flush with the tower's front face rather than the base's outer edge, keeping
// the plug from standing out. Needs base_hollow and a base of about 40 mm or
// more; the console gives the exact minimum.
base_inlet = false;
// Panel cutout, width x height, mm. 47.5 x 28.5 fits the usual generic module
// (datasheets give 47.1-47.2 x 28.1-28.3). Measure yours.
base_inlet_w = 47.5;     // [10:0.1:100]
base_inlet_h = 28.5;     // [10:0.1:100]
// The flange on the front of the module, mm. It must sit on a flat face.
base_inlet_flange_w = 50.5; // [10:0.1:110]
base_inlet_flange_h = 31.5; // [10:0.1:110]
// How far the module reaches behind the panel, terminals included, mm.
base_inlet_depth = 35;   // [10:0.5:80]
// Wall thickness around the cutout, mm. Snap-in clips are made for thin sheet
// panels, so the wall is thinned to this from inside around the opening.
base_inlet_panel = 2;    // [0.8:0.1:5]
// Clearance around the cutout behind the panel for the snap clips to spring
// open, mm.
base_inlet_clip_room = 4; // [1:0.5:10]
// Space between the flange and each side of the alcove, mm.
base_inlet_alcove_gap = 2; // [0:0.5:20]

/* [Base screw holes] */

// Screw holes for fixing the base down to a desk or shelf.
base_screws = 4;    // [0:none, 2:2 (diagonal corners), 4:4 (all corners)]
// Where the holes go.
//   outside - in the flange around the tower, reachable with the tower in place.
//             Needs a base wider than the tower.
//   inside  - under the tower's hollow core, hidden once the tower is on. Screw
//             the base down first, then drop the tower onto it.
base_screw_position = "outside"; // [outside, inside]
// Shank clearance hole, mm. 4.5 suits a #8 / 4 mm wood screw.
base_screw_d = 4.5;      // [2:0.1:10]
// Head shape. Countersunk is a 90 degree cone for flat-head wood screws;
// counterbore is a flat-bottomed recess for pan-head or cap screws.
base_screw_head = "countersunk"; // [countersunk, counterbore]
// Head diameter, plus a little clearance, mm.
base_screw_head_d = 9;   // [4:0.1:20]
// Height above the floor where the head seats, mm: the top of a countersunk head,
// or the underside of a counterbored one. This is the material the screw
// clamps; the recess above it runs clear to the top surface.
base_screw_seat = 4;     // [1:0.5:50]

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

// Base geometry. The footprint at the floor: the tower grown by the flange.
base_width = width + 2 * base_offset_width;
base_depth = depth + 2 * base_offset_depth;

// Depth of a 90 degree countersink: the cone narrows from the head to the
// shank at 45 degrees.
base_sink_h = (base_screw_head_d - base_screw_d) / 2;
base_head_r = base_screw_head_d / 2;

// Cross-section of the base at height z, as [w, d, r]. The tapered base is a
// hull of the floor footprint and the tower outline, and a hull of two convex
// outlines slices to a straight blend of the two, so every term interpolates.
function base_section(z) =
    let (t = (!base_taper || z <= base_foot) ? 0
             : min((z - base_foot) / (base_height - base_foot), 1))
    [base_width         + t * (width - base_width),
     base_depth         + t * (depth - base_depth),
     base_corner_radius + t * (corner_radius - base_corner_radius)];

// Signed distance from point p to a centered rounded rectangle: negative inside.
function rrect_sd(p, w, d, r) =
    let (qx = abs(p[0]) - (w / 2 - r),
         qy = abs(p[1]) - (d / 2 - r))
    norm([max(qx, 0), max(qy, 0)]) + min(max(qx, qy), 0) - r;

// One screw position per quadrant, mirrored into the others. Outside holes sit
// midway across the flange; inside holes tuck into the cavity's corners, clear
// of its rounded corner and of the tabs, which stay within the wall.
base_screw_inset = base_head_r + inner_r + 1;
base_screw_xy = base_screw_position == "inside"
    ? [inner_w / 2 - base_screw_inset, inner_d / 2 - base_screw_inset]
    : [(width + base_width) / 4, (depth + base_depth) / 4];

base_screw_signs = base_screws == 4 ? [[1, 1], [-1, 1], [-1, -1], [1, -1]]
                 : base_screws == 2 ? [[1, 1], [-1, -1]]
                 : [];

// In a hollow base, outside screws pass through a solid column from the floor
// to the top surface, so the head is reachable from above. Inside screws stand
// on a solid pad as tall as the seat, so they work with no floor at all.
base_column_r = base_head_r + base_wall;

// Where the cavity starts: on the floor, or just below the bottom face when
// there is no floor, so the cut opens cleanly through it.
base_cavity_z0 = base_floor > 0 ? base_floor : -1;

// Power inlet. The panel is in the plane of the tower's front face, at the back
// of a straight-sided alcove cut down through the base. The bay behind the
// panel leaves clip room all round the cutout.
base_front = -depth / 2;
base_alcove_w = base_inlet_flange_w + 2 * base_inlet_alcove_gap;
base_inlet_bay_w = base_inlet_w + 2 * base_inlet_clip_room;
// Cutout centre: high enough for the flange to clear the desk and for the clip
// room under the cutout to clear the floor.
base_inlet_z = max(base_inlet_flange_h / 2 + 1,
                   base_floor + base_inlet_h / 2 + base_inlet_clip_room);
base_inlet_bay_top = base_inlet_z + base_inlet_h / 2 + base_inlet_clip_room;
base_inlet_min_height = max(base_inlet_bay_top + base_wall,
                            base_inlet_z + base_inlet_flange_h / 2);
// Any flat bay ceiling between the panel's wall and where the cavity's 45
// degree roof passes that height. Usually none: with the panel in the tower's
// plane, the roof reaches out past it.
base_inlet_bridge = max(0, (depth / 2 - base_wall)
                         - (inner_d / 2 + base_height - base_inlet_bay_top));

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

assert(make_base || towers > 0 || make_cap,
    "nothing to render: turn on make_base or make_cap, or set towers above 0");

assert(towers == round(towers) && towers >= 0,
    str("towers must be a whole number, 0 or more (got ", towers, ")"));

assert(layout == "print" || layout == "fused" || layout == "assembled",
    str("layout must be \"print\", \"fused\" or \"assembled\" (got \"", layout, "\")"));

assert(cap_tilt >= 0 && cap_tilt < 45,
    str("cap_tilt must be between 0 and 45 degrees (got ", cap_tilt, ")"));

assert(cap_tilt_dir == 0 || cap_tilt_dir == 90 || cap_tilt_dir == 180
       || cap_tilt_dir == 270,
    str("cap_tilt_dir must be 0, 90, 180 or 270 (got ", cap_tilt_dir, ")"));

// Base checks only apply when rendering the base, so an awkward base setting
// never blocks rendering a tower or a cap.
if (make_base) {
    assert(base_offset_width >= 0 && base_offset_depth >= 0,
        "base_offset_width/base_offset_depth cannot be negative, or the tower overhangs its own base");

    assert(base_corner_radius <= min(base_width, base_depth) / 2,
        str("base_corner_radius cannot exceed half the smaller of base_width/base_depth (max ",
            min(base_width, base_depth) / 2, ")"));

    assert(!base_taper || base_foot < base_height,
        str("base_foot must be less than base_height (", base_height,
            ") or there is no room left for the taper"));

    assert(base_screws == 0 || base_screws == 2 || base_screws == 4,
        str("base_screws must be 0, 2 or 4 (got ", base_screws, ")"));

    assert(base_screw_position == "outside" || base_screw_position == "inside",
        str("base_screw_position must be \"outside\" or \"inside\" (got \"",
            base_screw_position, "\")"));

    assert(base_screw_head == "countersunk" || base_screw_head == "counterbore",
        str("base_screw_head must be \"countersunk\" or \"counterbore\" (got \"",
            base_screw_head, "\")"));

    if (base_screws > 0) {
        assert(base_screw_head_d > base_screw_d + 1,
            "base_screw_head_d must be at least 1 mm larger than base_screw_d");

        assert(base_screw_seat < base_height,
            str("base_screw_seat must be below the top of the base (", base_height, " mm)"));

        assert(base_screw_head == "counterbore" || base_screw_seat >= base_sink_h + 1,
            str("base_screw_seat must be at least ", base_sink_h + 1,
                " mm for a countersink this size, or the cone breaks through the bottom"));

        if (base_screw_position == "inside") {
            assert(rrect_sd(base_screw_xy, inner_w, inner_d, inner_r) <= -base_head_r,
                str("the tower's cavity is too small for inside screw holes with a ",
                    base_screw_head_d, " mm head; use smaller screws or put them outside"));
        } else {
            // The recess has to clear the tower above it, and the head has to
            // land on solid base at the seat height, not hang off the taper.
            assert(rrect_sd(base_screw_xy, width, depth, corner_radius) >= base_head_r + 0.5,
                str("base is too small for outside screw holes: the heads would run under ",
                    "the tower. Grow base_offset_width/base_offset_depth, or use base_screw_position = inside"));

            s = base_section(base_screw_seat);
            assert(rrect_sd(base_screw_xy, s[0], s[1], s[2]) <= -(base_head_r + 1),
                str("outside screw heads hang off the edge of the base at the seat height. ",
                    "Grow base_offset_width/base_offset_depth, raise base_foot, or lower base_screw_seat"));
        }
    }

    if (base_hollow) {
        assert(base_floor < base_height - 1,
            str("base_floor must be well below base_height (", base_height, " mm)"));
        assert(base_wall < min(base_width, base_depth) / 4,
            "base_wall is too thick for this base; thin it or widen the base");
    }

    if (base_inlet) {
        assert(base_hollow, "base_inlet needs base_hollow = true: the module sits in the cavity");

        assert(base_height >= base_inlet_min_height,
            str("base_height must be at least ", base_inlet_min_height,
                " mm to fit the power inlet (cutout centre ", base_inlet_z,
                " mm up, clip room above and below, and a ", base_wall, " mm roof)"));

        assert(base_alcove_w <= width - 2 * corner_radius,
            str("the inlet alcove (", base_alcove_w, " mm) is wider than the flat of the tower's ",
                "front face (", width - 2 * corner_radius, " mm); widen the tower, reduce ",
                "corner_radius, or narrow base_inlet_alcove_gap"));

        assert(base_inlet_flange_w > base_inlet_w && base_inlet_flange_h > base_inlet_h,
            "base_inlet_flange_w/h must be larger than the cutout, or the module falls through");

        assert(base_inlet_panel <= base_wall,
            str("base_inlet_panel cannot be thicker than base_wall (", base_wall, " mm)"));

        assert(base_inlet_panel + base_inlet_depth <= depth / 2 + inner_d / 2,
            str("the inlet module is deeper than the tower's core reaches; depth must be at least ",
                base_inlet_panel + base_inlet_depth + wall, " mm"));

        assert(base_screws == 0 || base_screw_position == "inside"
               || base_screw_xy[0] - base_column_r >= max(base_inlet_bay_w, base_alcove_w) / 2,
            "the front outside screw columns run into the inlet alcove; grow base_offset_width or put the screws inside");
    }
}

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

module skadis_tower(tabs = stackable, pockets = true) {
    difference() {
        union() {
            shell();
            if (tabs) all_joints(pocket = false);
        }
        // Width faces (normal to Y), then depth faces (normal to X). The depth
        // faces take the opposite parity so the corners stagger.
        p = alternate_corners ? 1 : 0;
        if (slots_back)  face_pattern(cols_x, depth / 2,   0, 0);
        if (slots_front) face_pattern(cols_x, depth / 2, 180, 0);
        if (slots_left)  face_pattern(cols_y, width / 2,  90, p);
        if (slots_right) face_pattern(cols_y, width / 2, -90, p);

        // Pockets don't depend on `tabs`: even a segment with no tabs of its
        // own has to drop onto the one below. They are left out only when the
        // piece below is fused on.
        if (pockets) all_joints(pocket = true);
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

module skadis_cap(pockets = true) {
    difference() {
        intersection() {
            // Tall enough to be trimmed by the tilted face at every point.
            linear_extrude(cap_base + cap_rise + 1)
                rrect(width, depth, corner_radius);
            cap_tilt_cut();
        }
        if (pockets) all_joints(pocket = true);
        // The collar: the tower's core carried up through the top.
        if (cap_open)
            translate([0, 0, -1])
                linear_extrude(cap_base + cap_rise + 2)
                    rrect(inner_w, inner_d, inner_r);
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

// ----------------------------------------------------------------------------
// Base
//
// A footing that the bottom tower segment drops onto. It carries the same tabs
// as the top of a segment, from the same `all_joints()`, so it seats in the
// pockets every segment already has underneath. The top face is exactly the
// tower's outline, so with the taper on the sides run straight into the tower.
//
// Hollow by default: just walls, open at the bottom and at the top into the
// tower's core so wires can run up the middle. The cavity's roof is held to 45
// degrees by intersecting it with a pyramid grown down from the core opening,
// so it prints without supports. Solid is still an option, for a base that is
// all ballast.
//
// The optional power inlet is recessed: a straight-sided alcove is cut down
// through the front of the base to the plane of the tower's front face, and the
// inlet sits in that plane, flush with the tower above it. The alcove is open
// to the sky, so it has no roof to support, and the cavity's 45 degree roof
// reaches out over the bay behind the panel.
//
// Prints as modeled: flat bottom on the plate, the taper slopes inward going
// up, the tabs are free-standing, and the screw recesses all open upward.
// ----------------------------------------------------------------------------

module skadis_base(tabs = true) {
    union() {
        difference() {
            base_body();
            if (base_hollow) base_cavity();
            for (s = base_screw_signs)
                translate([s[0] * base_screw_xy[0], s[1] * base_screw_xy[1], 0])
                    base_screw_hole();
            if (base_inlet) {
                base_alcove();
                translate([-base_inlet_w / 2, base_front - 1, base_inlet_z - base_inlet_h / 2])
                    cube([base_inlet_w, base_inlet_panel + 2, base_inlet_h]);
            }
        }
        // all_joints() builds tabs standing on z = height; move them down onto
        // the top of the base. Added after the cavity is cut: their inner faces
        // sit exactly on the core opening.
        if (tabs) translate([0, 0, base_height - height]) all_joints(pocket = false);
    }
}

module base_body() {
    if (base_taper) {
        hull() {
            linear_extrude(max(base_foot, eps))
                rrect(base_width, base_depth, base_corner_radius);
            translate([0, 0, base_height - eps])
                linear_extrude(eps) rrect(width, depth, corner_radius);
        }
    } else {
        linear_extrude(base_height)
            rrect(base_width, base_depth, base_corner_radius);
    }
}

// Everything in front of the tower's front face across the alcove's width,
// grown by `grow` at the sides and back.
module base_alcove(grow = 0) {
    translate([-base_alcove_w / 2 - grow, -base_depth / 2 - 1, -1])
        cube([base_alcove_w + 2 * grow, (base_depth - depth) / 2 + 1 + grow,
              base_height + 2]);
}

module base_cavity() {
    difference() {
        intersection() {
            base_cavity_limit();
            union() {
                base_cavity_roof();
                if (base_inlet)
                    translate([-base_inlet_bay_w / 2, base_front + base_inlet_panel, base_cavity_z0])
                        cube([base_inlet_bay_w, base_inlet_depth + 1,
                              base_inlet_bay_top - base_cavity_z0]);
            }
        }
        // Solid columns carry outside screws up through the cavity.
        if (base_screw_position == "outside")
            for (s = base_screw_signs)
                translate([s[0] * base_screw_xy[0], s[1] * base_screw_xy[1], 0])
                    cylinder(r = base_column_r, h = base_height + 1);
        // Solid pads under inside screw heads, each webbed out to its corner of
        // the wall so it isn't a loose island when there is no floor.
        if (base_screw_position == "inside")
            for (s = base_screw_signs)
                hull() {
                    translate([s[0] * base_screw_xy[0], s[1] * base_screw_xy[1], -1])
                        cylinder(r = base_column_r, h = base_screw_seat + 1);
                    translate([s[0] * base_width / 2, s[1] * base_depth / 2, -1])
                        cylinder(r = base_column_r, h = base_screw_seat + 1);
                }
        // Walls around the inlet alcove.
        if (base_inlet) base_alcove(grow = base_wall);
    }
    // Thin the front wall around the cutout to panel thickness, so the clips
    // can catch behind it.
    if (base_inlet)
        translate([-base_inlet_bay_w / 2, base_front + base_inlet_panel,
                   base_inlet_z - base_inlet_h / 2 - base_inlet_clip_room])
            cube([base_inlet_bay_w, base_wall - base_inlet_panel + 1,
                  base_inlet_h + 2 * base_inlet_clip_room]);
}

// The body shrunk by base_wall (horizontally), sitting on the floor or, with no
// floor, running out through the bottom. At the
// top it narrows to the tower's core, so where the base meets the tower its wall
// is the tower's wall and the tabs stand on solid material.
module base_cavity_limit() {
    low = base_taper ? max(base_floor, base_foot) : base_floor;
    s = base_section(low);
    hull() {
        translate([0, 0, base_cavity_z0])
            linear_extrude(max(low - base_cavity_z0, eps))
                rrect(s[0] - 2 * base_wall, s[1] - 2 * base_wall, max(s[2] - base_wall, 0));
        translate([0, 0, base_height])
            linear_extrude(1)
                if (base_taper) rrect(inner_w, inner_d, inner_r);
                else rrect(base_width - 2 * base_wall, base_depth - 2 * base_wall,
                           max(base_corner_radius - base_wall, 0));
    }
}

// The tower's core opening, grown outward 1 mm for every 1 mm down: anything
// inside it has a roof no flatter than 45 degrees.
module base_cavity_roof() {
    g = base_height - base_cavity_z0;
    hull() {
        translate([0, 0, base_height])
            linear_extrude(1) rrect(inner_w, inner_d, inner_r);
        translate([0, 0, base_cavity_z0])
            linear_extrude(eps) rrect(inner_w + 2 * g, inner_d + 2 * g, inner_r + g);
    }
}

// One screw hole, at the origin: a shank clearance hole straight through, and a
// recess for the head from the seat up through the top surface, so a driver can
// reach it whatever the surface does above.
module base_screw_hole() {
    clear = base_height + 1;
    translate([0, 0, -1]) cylinder(d = base_screw_d, h = clear + 1);
    if (base_screw_head == "countersunk")
        translate([0, 0, base_screw_seat - base_sink_h])
            cylinder(d1 = base_screw_d, d2 = base_screw_head_d, h = base_sink_h + eps);
    translate([0, 0, base_screw_seat])
        cylinder(d = base_screw_head_d, h = clear);
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

// ----------------------------------------------------------------------------
// Layout
//
// Every piece in the run, bottom of the stack to top, as [kind, index]:
// kind 0 is the base, 1 a tower segment, 2 the cap.
// ----------------------------------------------------------------------------

pieces = concat(make_base ? [[0, 0]] : [],
                [for (i = [0 : 1 : towers - 1]) [1, i]],
                make_cap ? [[2, 0]] : []);

// Every segment below the top one carries tabs for the next. The top one does
// when the cap goes on it, or when `stackable` asks for them.
top_tabs = make_cap || stackable;

function piece_w(p) = p[0] == 0 ? base_width : width;

// Print layout: centres along X, left to right in stack order, layout_gap apart.
function piece_x(n) = n <= 0 ? 0
    : piece_x(n - 1) + (piece_w(pieces[n - 1]) + piece_w(pieces[n])) / 2 + layout_gap;
row_len = len(pieces) > 0 ? piece_x(len(pieces) - 1) : 0;

// Fused and assembled layouts: the height each piece's bottom sits at.
tower_z0 = make_base ? base_height : 0;
function piece_z(p) = p[0] == 0 ? 0 : tower_z0 + (p[0] == 1 ? p[1] : towers) * height;
stack_h = tower_z0 + towers * height + (make_cap ? cap_base + cap_rise : 0);

// In the fused layout a piece drops the joint on any side that another piece
// in the run is fused to; the ends of the run keep theirs. The pieces then
// meet face to face and union into one solid.
fused = layout == "fused";

module piece(n) {
    p = pieces[n];
    below = fused && n > 0;
    above = fused && n < len(pieces) - 1;
    if      (p[0] == 0) skadis_base(tabs = !above);
    else if (p[0] == 1) skadis_tower(tabs = !above && (p[1] < towers - 1 || top_tabs),
                                     pockets = !below);
    else                skadis_cap(pockets = !below);
}

for (n = [0 : 1 : len(pieces) - 1])
    if (layout == "print")
        translate([piece_x(n) - row_len / 2, 0, 0]) piece(n);
    else
        translate([0, 0, piece_z(pieces[n])]) piece(n);

echo(str("Run: ", make_base ? "base, " : "", towers, " tower segment", towers == 1 ? "" : "s",
         make_cap ? ", cap" : "", " - ", layout, " layout",
         layout == "print" ? str(", ", len(pieces) > 0 ? row_len + piece_w(pieces[0]) / 2
                                         + piece_w(pieces[len(pieces) - 1]) / 2 : 0,
                                 " mm long row")
                           : str(", ", stack_h, " mm tall to the top surface",
                                 fused ? " as one solid" : "")));
if (fused && make_cap && towers > 0 && !cap_open)
    echo(str("  the cap's underside spans the tower's core: a ", min(inner_w, inner_d),
             " mm bridge"));

if (make_base) {
    echo(str("Skadis base: ", base_width, " x ", base_depth, " mm footprint, ",
             base_height, " mm tall, ",
             base_taper ? str("tapering to the ", width, " x ", depth, " mm tower above a ",
                              base_foot, " mm foot")
                        : "straight sides"));
    echo(str("  tabs: ", tabs_per_wall * 4, " on top, for the lowest tower segment"));
    echo(base_screws == 0 ? "  screw holes: none"
        : str("  screw holes: ", base_screws, " ", base_screw_position, ", ",
              base_screw_d, " mm shank, ", base_screw_head_d, " mm ", base_screw_head,
              " head seated ", base_screw_seat, " mm above the floor, at (+/-",
              base_screw_xy[0], ", +/-", base_screw_xy[1], ")"));
    if (base_screws > 0 && base_screw_position == "inside")
        echo("  inside holes are covered by the tower: screw the base down first");
    echo(base_hollow
        ? str("  hollow: ", base_wall, " mm walls, ",
              base_floor > 0 ? str(base_floor, " mm floor") : "open bottom",
              ", open into the tower's core for wiring")
        : "  solid in the model on purpose - set infill in the slicer");
    if (base_inlet) {
        echo(str("  power inlet: ", base_inlet_w, " x ", base_inlet_h,
                 " mm cutout flush with the tower's front (-Y) face, centred ", base_inlet_z,
                 " mm up, in a ", base_inlet_panel, " mm panel"));
        echo(str("  alcove: ", base_alcove_w, " mm wide, ", (base_depth - depth) / 2,
                 " mm deep, open at the top"));
        echo(str("  inlet needs base_height >= ", base_inlet_min_height, " mm; ",
                 base_inlet_bridge > 0 ? str("the bay ceiling is a ", base_inlet_bridge, " mm bridge")
                                       : "no bridges"));
    }
}

if (towers > 0) {
echo(str("Skadis tower: ", towers, " x ", width, " x ", depth, " x ", height, " mm"));
echo(str("  width faces: ", cols_x, " cols x ", rows, " rows (checkerboard)"));
echo(str("  depth faces: ", cols_y, " cols x ", rows, " rows (checkerboard)"));
if (!(slots_front && slots_back && slots_left && slots_right))
echo(str("  plain faces (no slots):", slots_front ? "" : " front", slots_back ? "" : " back",
         slots_left ? "" : " left", slots_right ? "" : " right"));
if (fused)
echo(str("  fused: one solid, ", make_base ? "joined to the base, " : str(tabs_per_wall * 4,
         " pockets underneath, "), make_cap ? "joined to the cap" : top_tabs
         ? str(tabs_per_wall * 4, " tabs on top") : "flat top"));
else
echo(str("  stacking: ", tabs_per_wall * 4, " pockets underneath each segment, ",
         towers > 1 ? str(tabs_per_wall * 4, " tabs on top of all but the top one, which has ")
                    : "",
         top_tabs ? str(tabs_per_wall * 4, " tabs on top", make_cap ? " for the cap" : "")
                  : "no tabs on top (flat top, the last segment)",
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

if (make_cap) {
    echo(str("Skadis cap: ", width, " x ", depth, " mm, ", cap_tilt,
             " deg tilt, high edge at ", cap_tilt_dir, " deg"));
    echo(str("  thickness: ", cap_base, " mm at the low edge, ",
             cap_base + cap_rise, " mm at the high edge"));
    echo(str("  rise: ", cap_rise, " mm across the ", cap_span, " mm span"));
    echo(str("  pockets: ", tabs_per_wall * 4, " x ", tab_width, " mm wide, ",
             tab_height + tab_clearance, " mm deep, ", cap_roof,
             " mm of material above"));
    echo(cap_open ? str("  open collar: ", wall, " mm rim around a ", inner_w, " x ", inner_d,
                        " mm opening")
                  : "  solid in the model on purpose - set infill in the slicer");
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

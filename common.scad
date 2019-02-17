/**
 * KEY ELEMENTS DESCRIPTION:
 * -------------------------
 *
 * ARC
 * ---
 * 2d figure in form of arc, which will be base for stairs:
 *
 * +-------+  v
 * |   _   |  |
 * |  / \  |  ^
 * |_|   |_|  |
 *            this is arc_gap
 *
 * >-<---- this is arc_base_thickness
 *
 * arc base will overlap with central pillar and outer walls
 *
 */

use <../BOSL/paths.scad>

// slowdown render
details_multiplier = 6;
particles_details_multiplier = max(1, details_multiplier / 2);

// number of segments in arc
arc_details = 4 * details_multiplier;
// $fn for extrude_2dpath_along_spiral
spiral_details = 40 * details_multiplier;
// $fn for bricks rounding
brick_rounding_details = 4 * particles_details_multiplier;
// $fn for central pillar
pillar_details = 8 * details_multiplier;
// $fn for external bricks
round_brick_details = spiral_details;
// $fn for stair front rounding
step_rounding_details = 6 * particles_details_multiplier;

// Bricks should have rounded corners
brick_rounding_r = 2;

// tower radius including central pillar and walls
tower_radius = 50;
// tower wall tickness
wall_thickness = 4;
// see ARC description
arc_base_thickness = 1;
tower_inner_radius = tower_radius - wall_thickness - arc_base_thickness;
arc_offset = wall_thickness + arc_base_thickness;
// ARC circles radius
arc_radius = tower_radius - arc_offset * 2;
arc_width = tower_radius - wall_thickness * 2;
// ARC height
arc_height = 40;
// see ARC description
arc_gap = arc_height - arc_radius * sqrt(3) / 2;
// min thickness for all steps
min_step_thickness = 1;

bottom_thickness = 5;

// each step height is calculated so thinnest part will be min_step_thickness
step_height = arc_gap - min_step_thickness;
// set step angle to 15 degrees, so steps will be small enough
step_angle = 15;
// last step should be a bit longer
step_extra_angle = 1;
// front rounding radius
step_rounding_r = 1.5;
// in order to avoid supports, shift rounding towards stair, so no horizontal
// areas will be generated
step_rounding_offset = 0.5;
step_rounding_extra = 1;

turn_angle = 60;
twists = 1.5;
steps_count = twists * 360 / step_angle;
turn_steps_count = turn_angle / step_angle;

outer_wall_height = (steps_count + 2) * step_height + arc_height;

// Arc is made of two halfes and rounding rectangle
left_arc = [for (i = [0 : 60 / arc_details : 59])[arc_radius * (1 - cos(i)) + arc_base_thickness, arc_radius * sin(i)]];
right_arc = [for (i = [60 : -60 / arc_details : 0])[arc_radius * cos(i) + arc_base_thickness, arc_radius * sin(i)]];
arc = concat(left_arc, right_arc, [[arc_width, 0], [arc_width, arc_height], [0, arc_height], [0, 0]]);

inner_arc_extra_height = 20;
inner_arc_radius = arc_radius - brick_rounding_r * 2;
left_inner_arc = [for (i = [0 : 60 / arc_details : 59])[inner_arc_radius * (1 - cos(i)), inner_arc_radius * sin(i) + inner_arc_extra_height]];
right_inner_arc = [for (i = [60 : -60 / arc_details : 0])[inner_arc_radius * cos(i), inner_arc_radius * sin(i) + inner_arc_extra_height]];
inner_arc = concat(left_inner_arc, right_inner_arc, [[inner_arc_radius, 0], [0, 0]]);

gate_wear_width = 5;
wear_arc_radius = arc_radius + gate_wear_width;
left_wear_arc =  [for (i = [0 : 60 / arc_details : 59])[wear_arc_radius * (1 - cos(i)), wear_arc_radius * sin(i) + inner_arc_extra_height]];
right_wear_arc = [for (i = [60 : -60 / arc_details : 0])[wear_arc_radius * cos(i), wear_arc_radius * sin(i) + inner_arc_extra_height]];
wear_arc = concat(left_wear_arc, right_wear_arc, [[wear_arc_radius, 0], [0, 0]]);


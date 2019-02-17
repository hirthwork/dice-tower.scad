include <common.scad>

// Bricks! Let's define their parameters
// Some tower walls are flat, so we need to define straigh bricks parameters
straight_brick_width = 10;
straight_brick_depth = 5;
straight_brick_height = 5;
straight_brick_horizontal_interval = straight_brick_width + brick_rounding_r;
straight_brick_vertical_interval = straight_brick_height + brick_rounding_r;
// bricks should intersect by ⅓
brick_intersection = 3;

pi = 3.14159265358;

// central pillar bricks will have same height
pillar_brick_r = wall_thickness + arc_base_thickness;
pillar_circumference = pillar_brick_r * 2 * pi;
pillar_brick_height = straight_brick_height;
pillar_brick_count = round(pillar_circumference / straight_brick_width);
pillar_brick_angle = 360 / pillar_brick_count;
pillar_layer_height = pillar_brick_height + brick_rounding_r;

// outer walls bricks
wall_circumference = tower_radius * 2 * pi;
wall_brick_height = straight_brick_height;
wall_brick_count = round(wall_circumference / straight_brick_width);
wall_layer_height = wall_brick_height + brick_rounding_r;

top_wall_radius = tower_radius + 5;

// roof will have brick face
roof_wall_height = arc_height - step_height;
roof_wall_bricks_horizontal_count = floor(tower_radius / straight_brick_horizontal_interval) + 1;
roof_wall_bricks_vertical_count = floor(roof_wall_height / straight_brick_vertical_interval) + 1;

roof_plank_width = 10;
roof_plank_length = 50;
roof_plank_gap_width = 0.3;
roof_plank_gap_depth = 0.3;

roof_barrier_width = brick_rounding_r;
roof_barrier_height = 7;
roof_barrier_offset = brick_rounding_r * 2;

module roof_arc() {
    difference() {
        intersection() {
            rotate([0, 0, -45]) translate([brick_rounding_r, 0, 0]) union() {
                rotate([0, 0, 90])
                    minkowski() {
                        for (i = [0:roof_wall_bricks_horizontal_count])
                            for (j = [0:roof_wall_bricks_vertical_count])
                                translate([
                                    straight_brick_horizontal_interval * (i - (j % brick_intersection) / brick_intersection),
                                    -straight_brick_depth,
                                    straight_brick_vertical_interval * j])
                                    cube([straight_brick_width, straight_brick_depth, straight_brick_height]);
                        sphere(r = brick_rounding_r, $fn = brick_rounding_details);
                    }
                translate([0, -tower_radius, 0])
                    cube([tower_radius, tower_radius * 2, arc_height]);
                translate([-tower_radius - brick_rounding_r, -tower_radius, 0])
                    cube([tower_radius + brick_rounding_r, tower_radius, arc_height]);
            }
            rotate([0, 0, 195]) rotate_extrude(angle = 210, convexity = 3, $fn = spiral_details) translate([wall_thickness, 0, 0]) intersection() {
                polygon(arc);
                square([arc_width, arc_height - step_height]);
            }
        }
        for (i = [-tower_radius:roof_plank_width:tower_radius]) {
            translate([i, -tower_radius, arc_height - step_height - roof_plank_gap_depth])
                cube([roof_plank_gap_width, tower_radius * 2, roof_plank_gap_depth]);
            for (j = [-tower_radius:roof_plank_length:tower_radius])
                translate([i, j + (floor(i / roof_plank_width) % 2) * roof_plank_length / 2, arc_height - step_height - roof_plank_gap_depth])
                    cube([roof_plank_width, roof_plank_gap_width, roof_plank_gap_depth]);
        }
    }
    rotate([0, 0, 45]) translate([0, -roof_barrier_offset, arc_height - step_height]) cube([tower_radius, roof_barrier_width, roof_barrier_height]);
    minkowski() {
        rotate([0, 0, 45]) translate([0, -roof_barrier_offset + roof_barrier_width / 4, arc_height - step_height + roof_barrier_height]) cube([tower_radius, roof_barrier_width / 2, 0.01]);
        sphere(r = brick_rounding_r, $fn = step_rounding_details);
    }
}

module pillar(height) {
    layers = ceil(height / pillar_brick_height);
    minkowski() {
        difference() {
            cylinder(r = pillar_brick_r, h = height, $fn = pillar_details);
            for (i = [0:layers - 1])
                for (j = [1:pillar_brick_count])
                    rotate([0, 0, pillar_brick_angle * (j + (i % brick_intersection) / brick_intersection)])
                        translate([-brick_rounding_r / 2, 0, i * pillar_layer_height])
                            cube([brick_rounding_r, wall_thickness * 2, pillar_layer_height]);
            for (i = [0:layers])
                translate([0, 0, i * pillar_layer_height])
                    cube([wall_thickness * 3, wall_thickness * 3, brick_rounding_r], true);
        }
        sphere(r = brick_rounding_r, $fn = brick_rounding_details);
    }
}

module wall(height, bricks_gap = brick_rounding_r, outer_radius = tower_radius, outer_top_radius = undef, brick_count = wall_brick_count) {
    top_radius = (outer_top_radius == undef) ? outer_radius : outer_top_radius;
    layers = ceil(height / wall_layer_height);
    brick_angle = 360 / brick_count;
    minkowski() {
        difference() {
            cylinder(r1 = outer_radius, r2 = top_radius, h = height, $fn = spiral_details);
            cylinder(r = tower_inner_radius, h = height, $fn = spiral_details);
            for (i = [0:layers - 1])
                for (j = [1:brick_count])
                    rotate([0, 0, brick_angle * (j + (i % brick_intersection) / brick_intersection)])
                        translate([-bricks_gap / 2, 0, i * wall_layer_height])
                            cube([bricks_gap, tower_radius * 2, wall_layer_height]);
            for (i = [0:layers])
                translate([0, 0, i * wall_layer_height])
                    cube([tower_radius * 3, tower_radius * 3, brick_rounding_r], true);
        }
        sphere(r = brick_rounding_r, $fn = brick_rounding_details);
    }
}


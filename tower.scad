include <steps.scad>
include <bricks.scad>
include <rocks.scad>

top_wall_layer_gap = 10;
top_wall_brick_count = round(wall_circumference / (straight_brick_width + top_wall_layer_gap));
top_wall_conjunction_height = wall_layer_height * 2;
steps_per_window = 2;
windows_angle = step_angle * steps_per_window;
windows_count = (twists * 360 / windows_angle) - 5;
window_step_offset = 10;
outer_bottom_radius = tower_radius + outer_rock_offset;
outer_bottom_deeping = 0.3;
outer_bottom_deeping_step = 10;

intersection() {
    union() {
        steps(-turn_steps_count, steps_count + 1);
        translate([cos(turn_angle) * tower_radius, -sin(turn_angle) * tower_radius, 0]) rotate([0, 0, turn_angle]) mirror([0, 1, 0]) {
            steps(-turn_steps_count * 2, -turn_steps_count);
            rotate([0, 0, -turn_angle * 2.5]) intersection() {
                wall(360 / step_angle * step_height - step_height);
                cube([tower_radius * 2, tower_radius * 2, arc_height + 360 * step_height / step_angle]);
                rotate([0, 0, 90 - turn_angle]) cube([tower_radius * 2, tower_radius * 2, arc_height + 360 * step_height / step_angle]);
            }
        }
        pillar(outer_wall_height);

        difference() {
            union() {
                difference() {
                    union() {
                        translate([0, 0, (steps_count + 1) * step_height]) roof_arc();
                        wall(outer_wall_height - top_wall_conjunction_height);
                    }
                    for (i = [-1:windows_count - 1])
                        rotate([0, 0, 90 + i * windows_angle]) translate([-inner_arc_radius / 8, -tower_radius + wall_thickness * 4, arc_height + window_step_offset + i * step_height * steps_per_window]) scale([0.3, 0.5, 0.5]) rotate([90, 0, 0]) linear_extrude(wall_thickness * 16) polygon(inner_arc);
                }
                for (i = [-1:windows_count - 1])
                    rotate([0, 0, 90 + i * windows_angle])
                        translate([-inner_arc_radius / 8, -tower_radius + wall_thickness + arc_base_thickness, arc_height + window_step_offset + i * step_height * steps_per_window]) minkowski() {
                            difference() {
                                hull() minkowski() {
                                    scale([0.3, 0.5, 0.5]) rotate([90, 0, 0]) linear_extrude((wall_thickness + arc_base_thickness) * 2) polygon(inner_arc);
                                    sphere(r = wear_arc_radius / 2, $fn = pillar_details, true);
                                }
                                scale([0.3, 0.5, 0.5]) translate([0, wall_thickness, 0]) rotate([90, 0, 0]) linear_extrude(wall_thickness * 12) polygon(inner_arc);
                            }
                            sphere(r = brick_rounding_r, $fn = brick_rounding_details);
                        }
                difference() {
                    translate([-wear_arc_radius / 2, -tower_radius + wall_thickness * 2, 0]) rotate([90, 0, 0]) linear_extrude(wall_thickness * 3) polygon(wear_arc);
                    cylinder(r = tower_inner_radius, h = wear_arc_radius + inner_arc_extra_height, $fn = spiral_details);
                }
            }
            translate([-inner_arc_radius / 2, -tower_radius + wall_thickness * 4, -brick_rounding_r]) rotate([90, 0, 0]) linear_extrude(wall_thickness * 8) polygon(inner_arc);
        }
        translate([0, 0, outer_wall_height - top_wall_conjunction_height]) wall(top_wall_conjunction_height, outer_top_radius = top_wall_radius);
        translate([0, 0, outer_wall_height]) wall(wall_layer_height, bricks_gap = top_wall_layer_gap, outer_radius = top_wall_radius, brick_count = top_wall_brick_count);

        difference() {
            union() {
                for (i = [4:rocks_count-1])
                    rotate([0, 0, i * rock_angle - 90]) translate([tower_radius + rock_offset, 0, 0]) rock(i);
                scale([1, 1, 0.95]) rotate([0, 0, 3 * rock_angle - 90]) translate([tower_radius + rock_offset, 0, 0]) rock(3);
                scale([1, 1, 0.95]) rotate([0, 0, rocks_count * rock_angle - 90]) translate([tower_radius + rock_offset, 0, 0]) rock(rocks_count);
                scale([1, 1, 0.9]) rotate([0, 0, 2 * rock_angle - 90]) translate([tower_radius + rock_offset, 0, 0]) rock(2);
                scale([1, 1, 0.9]) rotate([0, 0, (rocks_count + 1) * rock_angle - 90]) translate([tower_radius + rock_offset, 0, 0]) rock(rocks_count + 1);
                translate([0, -tower_radius * 2, 0]) mirror([0, 1, 0]) {
                    for (i = [5:outer_rocks_count - 2])
                        scale([1, 1, 0.7]) rotate([0, 0, i * outer_rock_angle - 90]) translate([tower_radius + outer_rock_offset, 0, 0]) rock(i * 2);
                    scale([1, 1, 0.75]) rotate([0, 0, 4 * outer_rock_angle - 90]) translate([tower_radius + outer_rock_offset, 0, 0]) rock(4 * 2);
                    scale([1, 1, 0.75]) rotate([0, 0, (outer_rocks_count - 1) * outer_rock_angle - 90]) translate([tower_radius + outer_rock_offset, 0, 0]) rock((outer_rocks_count - 1) * 2);
                    scale([1, 1, 0.8]) rotate([0, 0, 3 * outer_rock_angle - 90]) translate([tower_radius + outer_rock_offset, 0, 0]) rock(2);
                    scale([1, 1, 0.8]) rotate([0, 0, outer_rocks_count * outer_rock_angle - 90]) translate([tower_radius + outer_rock_offset, 0, 0]) rock((outer_rocks_count + 1) * 2);
                    scale([1, 1, 0.85]) rotate([0, 0, 2 * outer_rock_angle - 90]) translate([tower_radius + outer_rock_offset, 0, 0]) rock(6);
                    scale([1, 1, 0.85]) rotate([0, 0, (outer_rocks_count + 1) * outer_rock_angle - 90]) translate([tower_radius + outer_rock_offset, 0, 0]) rock(outer_rocks_count * 2);
                }
            }
            cylinder(r = tower_radius, h = outer_wall_height, $fn = spiral_details);
        }

        translate([0, 0, -bottom_thickness]) cylinder(r = tower_radius + rock_offset, h = bottom_thickness, $fn = spiral_details);
        difference() {
            translate([0, -tower_radius * 2, -bottom_thickness]) cylinder(r = outer_bottom_radius, h = bottom_thickness, $fn = spiral_details);
            for (i = [-outer_bottom_radius:outer_bottom_deeping_step:outer_bottom_radius]) {
                translate([-outer_bottom_radius, -tower_radius * 2 + i, -outer_bottom_deeping]) cube([outer_bottom_radius * 2, outer_bottom_deeping, outer_bottom_deeping]);
                translate([i, -tower_radius * 2 - outer_bottom_radius, -outer_bottom_deeping]) rotate([0, 0, 90]) cube([outer_bottom_radius * 2, outer_bottom_deeping, outer_bottom_deeping]);
            }
        }
    }
    translate([-500, -500, -bottom_thickness]) cube([1000, 1000, 1000]);
}

